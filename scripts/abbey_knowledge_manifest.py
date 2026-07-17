#!/usr/bin/env python3
"""Build and compare Abbey knowledge repository manifests."""

from __future__ import annotations

import argparse
import fnmatch
import hashlib
import json
import socket
import subprocess
import sys
from datetime import datetime
from pathlib import Path
from typing import Any

SCHEMA_VERSION = 1
MAX_LISTING_DEPTH = 3

CONTENT_SOURCES = (
    "ansible/inventory/hosts.yml",
    "docs/planning/PROJECT_STATUS.md",
    "docs/planning/NEXT.md",
    "docs/planning/ROADMAP.md",
    "docs/planning/BACKLOG.md",
    "docs/guides/abbey-cli.md",
    "tools/bin/abbey-knowledge",
    "tools/lib/config.sh",
    "config/abbey.conf",
)

LISTING_SOURCES = (
    ("ansible/playbooks", "*.yml"),
    ("ansible/roles", "*"),
    ("tools/bin", "*"),
    ("docs/planning", "*.md"),
    ("docs/generated", "*.md"),
    ("docs/runbooks", "*.md"),
    ("docs/guides", "*.md"),
    ("content/journal", "*.md"),
)


def git_value(root: Path, *arguments: str) -> str | None:
    try:
        return subprocess.check_output(
            ["git", "-C", str(root), *arguments],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
    except (OSError, subprocess.CalledProcessError):
        return None


def build_manifest(root: Path) -> dict[str, Any]:
    records: list[str] = []
    content_count = 0
    listed_count = 0

    for relative_name in CONTENT_SOURCES:
        path = root / relative_name

        if path.is_file():
            digest = hashlib.sha256(path.read_bytes()).hexdigest()
            records.append(f"CONTENT\t{relative_name}\t{digest}")
            content_count += 1
        else:
            records.append(f"MISSING\t{relative_name}")

    for relative_dir, pattern in LISTING_SOURCES:
        base = root / relative_dir

        if not base.is_dir():
            records.append(f"MISSING_DIR\t{relative_dir}")
            continue

        matched_paths: list[str] = []

        for path in base.rglob("*"):
            if not path.is_file():
                continue

            relative_to_base = path.relative_to(base)

            if len(relative_to_base.parts) > MAX_LISTING_DEPTH:
                continue

            if not fnmatch.fnmatch(path.name, pattern):
                continue

            matched_paths.append(path.relative_to(root).as_posix())

        for relative_name in sorted(matched_paths):
            records.append(f"LIST\t{relative_name}")
            listed_count += 1

    records.sort()

    manifest_text = "\n".join(records) + "\n"
    repository_hash = hashlib.sha256(
        manifest_text.encode("utf-8")
    ).hexdigest()

    return {
        "repository_hash": repository_hash,
        "content_source_count": content_count,
        "listed_path_count": listed_count,
    }


def build_metadata(root: Path) -> dict[str, Any]:
    manifest = build_manifest(root)

    return {
        "schema_version": SCHEMA_VERSION,
        "generated_at": datetime.now().astimezone().isoformat(
            timespec="seconds"
        ),
        **manifest,
        "git_commit": git_value(root, "rev-parse", "--short", "HEAD"),
        "git_branch": git_value(root, "branch", "--show-current"),
        "host": socket.gethostname(),
    }


def write_metadata(root: Path, output_file: Path) -> int:
    output_file.write_text(
        json.dumps(build_metadata(root), indent=2) + "\n",
        encoding="utf-8",
    )
    return 0


def determine_state(
    root: Path,
    snapshot: Path,
    metadata_file: Path,
) -> tuple[str, int]:
    if not snapshot.is_file() or not metadata_file.is_file():
        return "MISSING", 2

    try:
        metadata = json.loads(
            metadata_file.read_text(encoding="utf-8")
        )
    except (OSError, json.JSONDecodeError):
        return "INVALID", 2

    if (
        metadata.get("schema_version") != SCHEMA_VERSION
        or not isinstance(metadata.get("repository_hash"), str)
        or not metadata["repository_hash"]
    ):
        return "INVALID", 2

    current = build_manifest(root)

    if current["repository_hash"] == metadata["repository_hash"]:
        return "FRESH", 0

    return "STALE", 1


def show_state(
    root: Path,
    snapshot: Path,
    metadata_file: Path,
) -> int:
    state, return_code = determine_state(
        root,
        snapshot,
        metadata_file,
    )
    print(state)
    return return_code


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build and compare Abbey knowledge manifests."
    )

    subparsers = parser.add_subparsers(dest="command", required=True)

    metadata_parser = subparsers.add_parser("write-metadata")
    metadata_parser.add_argument("root", type=Path)
    metadata_parser.add_argument("output_file", type=Path)

    state_parser = subparsers.add_parser("state")
    state_parser.add_argument("root", type=Path)
    state_parser.add_argument("snapshot", type=Path)
    state_parser.add_argument("metadata_file", type=Path)

    return parser.parse_args()


def main() -> int:
    arguments = parse_arguments()

    if arguments.command == "write-metadata":
        return write_metadata(
            arguments.root,
            arguments.output_file,
        )

    if arguments.command == "state":
        return show_state(
            arguments.root,
            arguments.snapshot,
            arguments.metadata_file,
        )

    raise RuntimeError(f"Unhandled command: {arguments.command}")


if __name__ == "__main__":
    sys.exit(main())
