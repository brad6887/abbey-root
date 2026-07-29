#!/usr/bin/env python3

import argparse
import re
import shutil
import subprocess
import sys
from datetime import date
from pathlib import Path

import yaml


def slugify(value):
    return re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")


def default_name(path):
    return " ".join(word.capitalize() for word in path.name.replace("_", "-").split("-"))


def parse_args():
    parser = argparse.ArgumentParser(
        prog="abbey init",
        description="Create a new project from the default Abbey template.",
    )
    parser.add_argument("path", type=Path)
    parser.add_argument("--name")
    parser.add_argument("--description")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--yes", action="store_true")
    parser.add_argument("--no-git", action="store_true")
    parser.add_argument(
        "--journal-policy",
        choices=("required", "event-driven", "optional"),
        default="event-driven",
        help="control when session capture creates a journal entry",
    )
    return parser.parse_args()


def project_files(name, slug, description, journal_policy):
    today = date.today().isoformat()
    metadata = {
        "schema_version": 1,
        "project": {
            "name": name,
            "slug": slug,
            "description": description,
        },
        "framework": {"name": "Abbey", "schema_version": 1},
        "capabilities": {"infrastructure": False},
        "workflow": {"journal": {"policy": journal_policy}},
        "validation": {"commands": ["git diff --check"]},
        "paths": {
            "planning": "docs/planning",
            "session_updates": "docs/session-updates",
            "journal": "content/journal",
        },
    }
    return {
        ".abbey/project.yml": yaml.safe_dump(metadata, sort_keys=False),
        ".abbey/session-guidance.md": f"""# {name} Session Guidance

Follow the Abbey Session Workflow:

1. Review
2. Define
3. Build
4. Validate
5. Document
6. Capture
7. Commit
8. Review

Keep each session focused on one objective with a clear Definition of Done.
Prefer Abbey commands and one authoritative source over duplicate manual work.
Validate changes and capture a session update before committing.
""",
        "docs/planning/PROJECT_STATUS.md": f"""# {name} Project Status

Last Updated: {today}

## Project Snapshot

{description}

## Current Session

No active session has been defined.

## Suggested Next Step

Review `docs/planning/NEXT.md` and define the first focused session.
""",
        "docs/planning/NEXT.md": f"""# {name} Next

Last Reviewed: {today}

## Current Theme

Project Foundation

## Primary Objective

Define the first usable {name} project workflow.

## Definition of Done

- The first project workflow is documented.
- One real example validates the workflow.
- The result can be reviewed without relying on chat history.
- The project remains simple to maintain manually.

## Tasks

- [ ] Define and validate the first useful project workflow.
""",
        "docs/planning/BACKLOG.md": f"""# {name} Backlog

No backlog items have been defined.
""",
        "docs/planning/ROADMAP.md": f"""# {name} Roadmap

## Foundation

- Define and validate the first useful project workflow.
""",
        "docs/session-updates/.gitkeep": "",
        "content/journal/.gitkeep": "",
        "working/session-context/.gitkeep": "",
        ".gitignore": """# Abbey generated working files
working/session-context/*
!working/session-context/.gitkeep

# Generated Abbey runtime state
.abbey/ai/
.abbey/context/
.abbey/knowledge/

# Local Abbey configuration
.abbey/config.conf
""",
        "README.md": f"""# {name}

{description}

This repository follows the Abbey Session Workflow. Start with:

```text
abbey doctor
abbey session
```
""",
    }


def validate_destination(destination):
    if destination.exists() and not destination.is_dir():
        raise ValueError(f"destination is not a directory: {destination}")
    if destination.exists() and any(destination.iterdir()):
        raise ValueError(f"destination is not empty: {destination}")


def validate_result(destination, files, expect_git):
    missing = [relative for relative in files if not (destination / relative).is_file()]
    if missing:
        raise RuntimeError(f"generated files are missing: {', '.join(missing)}")
    metadata = yaml.safe_load(
        (destination / ".abbey/project.yml").read_text(encoding="utf-8")
    )
    if metadata.get("schema_version") != 1 or not metadata.get("project", {}).get("name"):
        raise RuntimeError("generated project metadata is invalid")
    if expect_git:
        subprocess.run(
            ["git", "-C", str(destination), "rev-parse", "--is-inside-work-tree"],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )


def main():
    args = parse_args()
    destination = args.path.expanduser().resolve()
    name = args.name or default_name(destination)
    slug = slugify(destination.name)
    description = args.description or f"{name} is an Abbey project."

    if not slug:
        print("ERROR: Project path must produce a non-empty slug.", file=sys.stderr)
        return 1

    try:
        validate_destination(destination)
    except ValueError as error:
        print(f"ERROR: Unsafe destination: {error}", file=sys.stderr)
        return 1

    files = project_files(name, slug, description, args.journal_policy)
    git_enabled = not args.no_git

    print("Abbey Project Initialization")
    print()
    print(f"Project: {name}")
    print(f"Path:    {destination}")
    print(f"Git:     {'initialize on main' if git_enabled else 'disabled'}")
    print(f"Journal: {args.journal_policy}")
    print()

    if args.dry_run:
        print("Dry Run — no changes will be made")
        print()
        for relative in files:
            print(f"CREATE {relative}")
        if git_enabled:
            print("RUN    git init --initial-branch=main")
        return 0

    if not args.yes and sys.stdin.isatty():
        answer = input("Proceed? [Y/n]: ").strip().lower()
        if answer not in ("", "y", "yes"):
            print("Initialization cancelled.")
            return 1

    destination_created = not destination.exists()
    created_files = []
    try:
        destination.mkdir(parents=True, exist_ok=True)
        for relative, content in files.items():
            path = destination / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content, encoding="utf-8")
            created_files.append(path)

        if git_enabled:
            subprocess.run(
                ["git", "init", "--initial-branch=main", str(destination)],
                check=True,
                stdout=subprocess.DEVNULL,
            )

        validate_result(destination, files, git_enabled)
    except Exception as error:
        if destination_created:
            shutil.rmtree(destination, ignore_errors=True)
        else:
            for path in reversed(created_files):
                path.unlink(missing_ok=True)
            for path in sorted(destination.rglob("*"), reverse=True):
                if path.is_dir():
                    try:
                        path.rmdir()
                    except OSError:
                        pass
        print(f"ERROR: Initialization failed: {error}", file=sys.stderr)
        return 1

    print("Created Files")
    print("-------------")
    for relative in files:
        print(f"CREATE {relative}")
    print()
    print("Validation")
    print("----------")
    print("OK   Project metadata valid")
    print("OK   Required planning documents present")
    print("OK   Session update directory present")
    print("OK   Journal directory present")
    print(f"OK   Git repository {'detected' if git_enabled else 'not requested'}")
    print()
    print("No commit or remote was created.")
    print()
    print("Suggested Next Step")
    print("-------------------")
    print(f"cd {destination}")
    print("abbey doctor")
    print("abbey session")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
