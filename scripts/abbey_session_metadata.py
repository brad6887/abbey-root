#!/usr/bin/env python3
"""Validate Abbey session-update frontmatter without blocking on historical debt."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

REQUIRED_FIELDS = (
    "title",
    "description",
    "date",
    "status",
    "reviewed",
    "session",
    "tags",
)

SCALAR_FIELDS = (
    "title",
    "description",
    "date",
    "status",
    "reviewed",
    "session",
)


def strip_scalar(value: str) -> str:
    value = value.strip()

    if (
        len(value) >= 2
        and value[0] == value[-1]
        and value[0] in {'"', "'"}
    ):
        return value[1:-1].strip()

    return value


def inspect_session_update(path: Path) -> list[str]:
    try:
        text = path.read_text(encoding="utf-8")
    except OSError as exc:
        return [f"unable to read file: {exc}"]

    lines = text.splitlines()

    if not lines or lines[0].strip() != "---":
        return ["missing YAML frontmatter"]

    try:
        end_index = next(
            index
            for index, line in enumerate(lines[1:], start=1)
            if line.strip() == "---"
        )
    except StopIteration:
        return ["unterminated YAML frontmatter"]

    frontmatter = lines[1:end_index]
    values: dict[str, str] = {}
    tag_items: list[str] = []
    current_key: str | None = None
    duplicates: set[str] = set()

    for line in frontmatter:
        top_level = re.match(r"^([A-Za-z0-9_-]+):(?:[ \t]*(.*))?$", line)

        if top_level:
            key = top_level.group(1)
            value = strip_scalar(top_level.group(2) or "")

            if key in values:
                duplicates.add(key)

            values[key] = value
            current_key = key
            continue

        if current_key == "tags":
            tag_match = re.match(r"^[ \t]+-[ \t]+(.+?)\s*$", line)

            if tag_match:
                tag_items.append(strip_scalar(tag_match.group(1)))

    problems: list[str] = []

    for key in REQUIRED_FIELDS:
        if key not in values:
            problems.append(f"missing required field: {key}")

    for key in SCALAR_FIELDS:
        if key in values and not values[key]:
            problems.append(f"empty required field: {key}")

    for key in sorted(duplicates):
        problems.append(f"duplicate field: {key}")

    for key in ("title", "description"):
        value = values.get(key, "")

        if value.upper().startswith("TODO"):
            problems.append(f"incomplete required field: {key}")

    date_value = values.get("date", "")

    if date_value and not re.fullmatch(r"\d{4}-\d{2}-\d{2}", date_value):
        problems.append("date must use YYYY-MM-DD")

    reviewed_value = values.get("reviewed", "").lower()

    if reviewed_value and reviewed_value not in {"true", "false"}:
        problems.append("reviewed must be true or false")

    if "tags" in values and not tag_items:
        problems.append("tags must contain at least one value")

    return problems


def normalize_changed_path(root: Path, value: str) -> str:
    path = Path(value)

    if path.is_absolute():
        try:
            path = path.resolve().relative_to(root)
        except ValueError:
            return path.as_posix()

    return path.as_posix()


def print_problem(path: str, problems: list[str], prefix: str) -> None:
    print(f"{prefix} {path}")

    for problem in problems:
        print(f"     - {problem}")


def main() -> int:
    parser = argparse.ArgumentParser(
        description=(
            "Validate changed Abbey session updates and report unrelated "
            "historical metadata debt."
        )
    )
    parser.add_argument(
        "--root",
        default=".",
        help="Abbey repository root",
    )
    parser.add_argument(
        "--changed",
        action="append",
        default=[],
        metavar="FILE",
        help="Changed session-update path; may be supplied more than once",
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="List every invalid session update and fail when any are invalid",
    )
    args = parser.parse_args()

    root = Path(args.root).resolve()
    session_dir = root / "docs/session-updates"

    if not session_dir.is_dir():
        print(f"FAIL Session update directory not found: {session_dir}")
        return 1

    changed = {
        normalize_changed_path(root, value)
        for value in args.changed
    }

    inspected: dict[str, list[str]] = {}

    for path in sorted(session_dir.glob("*.md")):
        relative = path.relative_to(root).as_posix()
        inspected[relative] = inspect_session_update(path)

    invalid = {
        path: problems
        for path, problems in inspected.items()
        if problems
    }

    if args.all:
        if not invalid:
            print("OK   All session updates contain valid required metadata")
            return 0

        for path, problems in invalid.items():
            print_problem(path, problems, "FAIL")

        print()
        print(f"Invalid session updates: {len(invalid)}")
        return 1

    changed_existing = {
        path
        for path in changed
        if path in inspected
    }

    changed_invalid = {
        path: invalid[path]
        for path in sorted(changed_existing)
        if path in invalid
    }

    historical_invalid = {
        path: problems
        for path, problems in invalid.items()
        if path not in changed_existing
    }

    if not changed_existing:
        print("INFO No changed session updates require metadata validation")
    elif changed_invalid:
        for path, problems in changed_invalid.items():
            print_problem(path, problems, "FAIL")
    else:
        print(
            "OK   Changed session update metadata is valid: "
            f"{len(changed_existing)} file(s)"
        )

    if historical_invalid:
        print(
            "WARN Pre-existing historical session metadata debt: "
            f"{len(historical_invalid)} file(s)"
        )

        preview = list(historical_invalid.items())[:5]

        for path, problems in preview:
            summary = "; ".join(problems)
            print(f"     {path}: {summary}")

        remaining = len(historical_invalid) - len(preview)

        if remaining:
            print(f"     ...and {remaining} more")

        print(
            "     Run: python3 scripts/abbey_session_metadata.py "
            "--root . --all"
        )
    else:
        print("OK   No historical session metadata debt detected")

    return 1 if changed_invalid else 0


if __name__ == "__main__":
    sys.exit(main())
