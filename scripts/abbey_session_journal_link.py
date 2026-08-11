#!/usr/bin/env python3
"""Validate and maintain reciprocal session-update and journal metadata links."""

from __future__ import annotations

import argparse
import os
import re
import tempfile
from pathlib import Path


def frontmatter_bounds(lines: list[str], path: Path) -> tuple[int, int]:
    if not lines or lines[0].strip() != "---":
        raise ValueError(f"Missing YAML frontmatter: {path}")
    for index, line in enumerate(lines[1:], start=1):
        if line.strip() == "---":
            return 1, index
    raise ValueError(f"Unterminated YAML frontmatter: {path}")


def scalar_value(value: str) -> str:
    value = value.strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", '"'}:
        return value[1:-1]
    return value


def linked_text(path: Path, key: str, value: str, after_key: str) -> str:
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    start, end = frontmatter_bounds(lines, path)
    matches = []
    anchor = None

    for index in range(start, end):
        match = re.match(r"^([A-Za-z0-9_-]+):(?:[ \t]*(.*))?$", lines[index])
        if not match:
            continue
        if match.group(1) == key:
            matches.append((index, scalar_value(match.group(2) or "")))
        if match.group(1) == after_key:
            anchor = index

    if len(matches) > 1:
        raise ValueError(f"Duplicate {key} metadata in {path}")
    if matches:
        existing = matches[0][1]
        if existing != value:
            raise ValueError(
                f"Conflicting {key} metadata in {path}: "
                f"expected {value}, found {existing or '<empty>'}"
            )
        return text
    if anchor is None:
        raise ValueError(f"Cannot add {key}; missing {after_key} metadata in {path}")

    lines.insert(anchor + 1, f'{key}: "{value}"')
    return "\n".join(lines) + ("\n" if text.endswith("\n") else "")


def replace_file(path: Path, text: str) -> None:
    current = path.read_text(encoding="utf-8")
    if current == text:
        return
    mode = path.stat().st_mode
    with tempfile.NamedTemporaryFile(
        mode="w", encoding="utf-8", dir=path.parent, delete=False
    ) as handle:
        handle.write(text)
        temporary = Path(handle.name)
    os.chmod(temporary, mode)
    os.replace(temporary, path)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--session", required=True, type=Path)
    parser.add_argument("--journal", required=True, type=Path)
    parser.add_argument("--session-relative", required=True)
    parser.add_argument("--journal-relative", required=True)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    try:
        session_text = linked_text(
            args.session, "journal", args.journal_relative, "session"
        )
        journal_text = None
        if args.journal.exists():
            journal_text = linked_text(
                args.journal,
                "session_update",
                args.session_relative,
                "date",
            )
        elif not args.check:
            raise ValueError(f"Journal entry does not exist: {args.journal}")

        if args.check:
            return 0

        replace_file(args.session, session_text)
        replace_file(args.journal, journal_text or "")
    except (OSError, ValueError) as exc:
        print(f"ERROR {exc}")
        return 1

    print("Associated session update and journal entry:")
    print(f"  Session: {args.session_relative}")
    print(f"  Journal: {args.journal_relative}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
