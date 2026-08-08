#!/usr/bin/env python3

import argparse
import sys
from pathlib import Path
from typing import Any, Dict, Optional

import yaml


class ProjectError(Exception):
    pass


def discover_project(start: Path, explicit: Optional[Path] = None) -> Path:
    if explicit is not None:
        root = explicit.expanduser().resolve()
        if not root.is_dir():
            raise ProjectError(f"project path is not a directory: {explicit}")
        if not (root / ".abbey/project.yml").is_file():
            raise ProjectError(f"no .abbey/project.yml exists under {root}")
        return root

    current = start.expanduser().resolve()
    if not current.is_dir():
        raise ProjectError(f"start path is not a directory: {start}")
    for candidate in (current, *current.parents):
        if (candidate / ".abbey/project.yml").is_file():
            return candidate
    raise ProjectError(f"no Abbey project found from {current}")


def load_metadata(root: Path) -> Dict[str, Any]:
    metadata_path = root / ".abbey/project.yml"
    try:
        data = yaml.safe_load(metadata_path.read_text(encoding="utf-8"))
    except (OSError, yaml.YAMLError) as error:
        raise ProjectError(f"cannot load {metadata_path}: {error}") from error

    if not isinstance(data, dict):
        raise ProjectError(f"{metadata_path} must contain a YAML mapping")
    if data.get("schema_version") != 1:
        raise ProjectError(f"{metadata_path} must declare schema_version: 1")
    project = data.get("project")
    if not isinstance(project, dict) or not str(project.get("name", "")).strip():
        raise ProjectError(f"{metadata_path} must declare project.name")
    return data


def resolve_project_path(root: Path, configured_path: str) -> Path:
    candidate = (root / configured_path).resolve()
    try:
        candidate.relative_to(root)
    except ValueError as error:
        raise ProjectError(
            f"configured path escapes the active project: {configured_path}"
        ) from error
    return candidate


def toolkit_defaults_enabled(metadata: Dict[str, Any]) -> bool:
    configuration = metadata.get("configuration", {})
    return isinstance(configuration, dict) and configuration.get(
        "allow_toolkit_defaults"
    ) is True


def command_show(args: argparse.Namespace) -> int:
    root = discover_project(Path.cwd(), args.project)
    metadata = load_metadata(root)
    project = metadata["project"]

    print("Abbey Project Context")
    print()
    print(f"Active project:       {project['name']}")
    print(f"Project root:         {root}")
    print(f"Toolkit root:         {args.toolkit_root}")
    print(f"Project configuration: {root / '.abbey/project.yml'}")
    state = "enabled" if toolkit_defaults_enabled(metadata) else "disabled"
    print(f"Toolkit defaults:     {state}")
    if args.config:
        config_path = resolve_project_path(root, args.config)
        print(f"Resolved configuration: {config_path}")
        print(
            "Configuration status: "
            + ("present" if config_path.is_file() else "missing")
        )
    return 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(prog="abbey project")
    parser.add_argument("--toolkit-root", type=Path, required=True, help=argparse.SUPPRESS)
    subparsers = parser.add_subparsers(dest="command", required=True)

    show = subparsers.add_parser("show", help="show the resolved Abbey project context")
    show.add_argument("--project", type=Path, help="use an explicit Abbey project root")
    show.add_argument(
        "--config",
        help="resolve and report a project-relative command configuration path",
    )
    show.set_defaults(func=command_show)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    args.toolkit_root = args.toolkit_root.expanduser().resolve()
    try:
        return args.func(args)
    except ProjectError as error:
        print(f"ERROR: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
