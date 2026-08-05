#!/usr/bin/env python3
"""Discover Abbey recurring review definitions."""

from pathlib import Path
import sys
from typing import Any

import yaml


REQUIRED_FIELDS = [
    "title",
    "category",
    "frequency",
    "status",
]


def read_frontmatter(path: Path) -> dict[str, Any] | None:
    """Read YAML frontmatter from a Markdown file."""

    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()

    if not lines or lines[0].strip() != "---":
        return None

    try:
        end_index = lines[1:].index("---") + 1
    except ValueError:
        return None

    frontmatter_text = "\n".join(lines[1:end_index])

    try:
        data = yaml.safe_load(frontmatter_text)
    except yaml.YAMLError:
        return None

    if not isinstance(data, dict):
        return None

    return data


def validate_definition(path: Path, metadata: dict[str, Any]) -> list[str]:
    """Validate required recurring review metadata."""

    errors = []

    for field in REQUIRED_FIELDS:
        if field not in metadata or metadata[field] in (None, ""):
            errors.append(f"missing required field: {field}")

    return errors


def discover_reviews(root: Path) -> int:
    """Discover and display recurring review definitions."""

    review_dir = root / "docs" / "reviews" / "recurring"

    print("========================================")
    print(" Recurring Reviews")
    print("========================================")
    print()
    print(f"Source:")
    print(f"  {review_dir}")
    print()

    if not review_dir.exists():
        print("No recurring review directory found.")
        return 0

    files = sorted(review_dir.glob("*.md"))

    if not files:
        print("No recurring reviews found.")
        return 0

    print("Reviews Found:")
    print("--------------")

    status = 0

    for path in files:
        metadata = read_frontmatter(path)

        print()
        print(path.stem)

        if metadata is None:
            print("  ERROR Invalid or missing YAML frontmatter")
            status = 1
            continue

        errors = validate_definition(path, metadata)

        if errors:
            for error in errors:
                print(f"  ERROR {error}")
            status = 1
            continue

        print(f"  Title:      {metadata['title']}")
        print(f"  Category:   {metadata['category']}")
        print(f"  Frequency:  {metadata['frequency']}")
        print(f"  Status:     {metadata['status']}")
        print(f"  File:       {path}")

    return status


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    return discover_reviews(root)


if __name__ == "__main__":
    sys.exit(main())
