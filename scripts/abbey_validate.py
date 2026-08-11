#!/usr/bin/env python3
"""Deterministic consistency validation for Abbey projects and the toolkit."""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

import yaml


class Reporter:
    def __init__(self) -> None:
        self.failures = 0

    def ok(self, message: str) -> None:
        print(f"OK   {message}")

    def fail(self, message: str) -> None:
        print(f"FAIL {message}")
        self.failures += 1


def load_metadata(path: Path, reporter: Reporter) -> dict:
    if not path.is_file():
        reporter.fail(f"Missing project metadata: {path}")
        return {}
    try:
        data = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    except (OSError, yaml.YAMLError) as exc:
        reporter.fail(f"Invalid project metadata: {path} ({exc})")
        return {}
    if not isinstance(data, dict):
        reporter.fail(f"Project metadata must be a mapping: {path}")
        return {}
    reporter.ok("Project metadata is valid YAML")
    return data


def nested(data: dict, *keys: str):
    value = data
    for key in keys:
        if not isinstance(value, dict) or key not in value:
            return None
        value = value[key]
    return value


def validate_relative_path(root: Path, label: str, value, reporter: Reporter) -> Path | None:
    if not isinstance(value, str) or not value.strip():
        reporter.fail(f"Missing configured path: {label}")
        return None
    candidate = (root / value).resolve()
    try:
        candidate.relative_to(root)
    except ValueError:
        reporter.fail(f"Configured path escapes the active project: {label}={value}")
        return None
    if not candidate.is_dir():
        reporter.fail(f"Configured directory does not exist: {value}")
        return None
    reporter.ok(f"Configured directory exists: {value}")
    return candidate


def validate_next(path: Path, reporter: Reporter) -> None:
    if not path.is_file():
        reporter.fail(f"Missing planning document: {path.name}")
        return
    headings = set(re.findall(r"^#{1,6}\s+(.+?)\s*$", path.read_text(encoding="utf-8"), re.MULTILINE))
    required = (
        "Current Theme",
        "Primary Objective",
        "Current Priorities",
        "Success Criteria",
        "Future Direction",
        "Guiding Principle",
    )
    missing = [heading for heading in required if heading not in headings]
    if missing:
        reporter.fail(f"NEXT.md is missing required sections: {', '.join(missing)}")
    else:
        reporter.ok("NEXT.md satisfies the canonical six-section contract")


def run_check(command: list[str], cwd: Path, success: str, failure: str, reporter: Reporter) -> None:
    result = subprocess.run(command, cwd=cwd, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    if result.returncode == 0:
        reporter.ok(success)
    else:
        reporter.fail(failure)
        for line in result.stdout.rstrip().splitlines():
            print(f"     {line}")


def validate_toolkit(toolkit: Path, reporter: Reporter) -> None:
    registry_path = toolkit / "config/cli/cli.yml"
    dispatcher_path = toolkit / "tools/bin/abbey"
    try:
        registry = yaml.safe_load(registry_path.read_text(encoding="utf-8")) or {}
        dispatcher = dispatcher_path.read_text(encoding="utf-8")
    except (OSError, yaml.YAMLError) as exc:
        reporter.fail(f"Unable to read toolkit command sources: {exc}")
        return

    commands = registry.get("commands", {})
    if not isinstance(commands, dict):
        reporter.fail("CLI registry commands must be a mapping")
        return

    missing_dispatch = []
    missing_implementation = []
    for name in commands:
        dispatcher_pattern = rf"^\s*{re.escape(name)}(?:\|[^)]*)?\)\s*$"
        if not re.search(dispatcher_pattern, dispatcher, re.MULTILINE):
            missing_dispatch.append(name)
        if name != "help" and not (toolkit / "tools/bin" / f"abbey-{name}").is_file():
            missing_implementation.append(name)

    if missing_dispatch:
        reporter.fail(f"Registered commands missing from dispatcher: {', '.join(missing_dispatch)}")
    else:
        reporter.ok("Every registered command is dispatched")
    if missing_implementation:
        reporter.fail(f"Registered commands missing implementations: {', '.join(missing_implementation)}")
    else:
        reporter.ok("Every registered command has an implementation")

    run_check(
        [str(toolkit / "tools/bin/abbey-docs"), "check"],
        toolkit,
        "Generated command documentation is current",
        "Generated command documentation is stale",
        reporter,
    )


def main() -> int:
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--toolkit-root", required=True, type=Path)
    parser.add_argument("--project-root", required=True, type=Path)
    args = parser.parse_args()
    toolkit = args.toolkit_root.resolve()
    project = args.project_root.resolve()
    reporter = Reporter()

    print("Abbey Project Validation")
    print("========================")
    print(f"Project: {project}")
    print()

    metadata = load_metadata(project / ".abbey/project.yml", reporter)
    for label, value in (("project.name", nested(metadata, "project", "name")), ("project.slug", nested(metadata, "project", "slug"))):
        if isinstance(value, str) and value.strip():
            reporter.ok(f"Required metadata is set: {label}")
        else:
            reporter.fail(f"Missing required metadata: {label}")

    if (project / ".git").exists():
        reporter.ok("Git repository detected")
        run_check(["git", "diff", "--check"], project, "Git whitespace check passed", "Git whitespace errors detected", reporter)
    else:
        reporter.fail("Active project is not a Git repository")

    planning = validate_relative_path(project, "paths.planning", nested(metadata, "paths", "planning"), reporter)
    validate_relative_path(project, "paths.session_updates", nested(metadata, "paths", "session_updates"), reporter)
    journal = nested(metadata, "paths", "journal")
    if isinstance(journal, str) and journal.strip():
        validate_relative_path(project, "paths.journal", journal, reporter)

    if planning:
        status = planning / "PROJECT_STATUS.md"
        if status.is_file():
            reporter.ok("PROJECT_STATUS.md exists")
        else:
            reporter.fail("Missing planning document: PROJECT_STATUS.md")
        validate_next(planning / "NEXT.md", reporter)

    if project == toolkit:
        validate_toolkit(toolkit, reporter)

    print()
    if reporter.failures:
        print(f"FAIL Validation completed with {reporter.failures} failure(s).")
        return 1
    print("PASS Repository consistency checks passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
