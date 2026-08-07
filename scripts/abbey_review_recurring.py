#!/usr/bin/env python3
"""Discover Abbey recurring review definitions, occurrences, and due state."""

import argparse
import calendar
from datetime import date, timedelta
import os
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

SUPPORTED_FREQUENCIES = {
    "daily",
    "weekly",
    "monthly",
    "quarterly",
    "yearly",
}


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

    frequency = metadata.get("frequency")

    if frequency and frequency not in SUPPORTED_FREQUENCIES:
        errors.append(f"unsupported frequency: {frequency}")

    return errors


def normalize_date(value: Any) -> date | None:
    """Normalize YAML date values to datetime.date."""

    if isinstance(value, date):
        return value

    if isinstance(value, str):
        try:
            return date.fromisoformat(value)
        except ValueError:
            return None

    return None


def add_months(value: date, months: int) -> date:
    """Add calendar months while preserving a valid day of month."""

    month_index = value.month - 1 + months
    year = value.year + month_index // 12
    month = month_index % 12 + 1
    day = min(value.day, calendar.monthrange(year, month)[1])

    return date(year, month, day)


def next_due_date(last_date: date, frequency: str) -> date:
    """Calculate the next due date for a recurring review."""

    if frequency == "daily":
        return last_date + timedelta(days=1)

    if frequency == "weekly":
        return last_date + timedelta(weeks=1)

    if frequency == "monthly":
        return add_months(last_date, 1)

    if frequency == "quarterly":
        return add_months(last_date, 3)

    if frequency == "yearly":
        return add_months(last_date, 12)

    raise ValueError(f"unsupported frequency: {frequency}")


def discover_occurrences(root: Path) -> dict[str, dict[str, Any]]:
    """Discover latest completed recurring review occurrences."""

    occurrence_dir = root / "docs" / "reviews" / "occurrences"
    occurrences: dict[str, dict[str, Any]] = {}

    if not occurrence_dir.exists():
        return occurrences

    for path in sorted(occurrence_dir.glob("*.md")):
        metadata = read_frontmatter(path)

        if metadata is None:
            continue

        review = metadata.get("review")
        occurrence_date = normalize_date(metadata.get("date"))

        if not review or occurrence_date is None:
            continue

        current = occurrences.get(review)

        if current is None or occurrence_date > current["date"]:
            occurrences[review] = {
                "file": path,
                "date": occurrence_date,
                "status": metadata.get("status", ""),
            }

    return occurrences


def discover_reviews(root: Path) -> int:
    """Discover and display recurring review definitions."""

    review_dir = root / "docs" / "reviews" / "recurring"

    print("========================================")
    print(" Recurring Reviews")
    print("========================================")
    print()
    print("Source:")
    print(f"  {review_dir}")
    print()

    if not review_dir.exists():
        print("No recurring review directory found.")
        return 0

    files = sorted(review_dir.glob("*.md"))
    occurrences = discover_occurrences(root)

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

        occurrence = occurrences.get(path.stem)

        if occurrence:
            print("  Last Occurrence:")
            print(f"    File:     {occurrence['file'].name}")
            print(f"    Date:     {occurrence['date'].isoformat()}")
            print(f"    Status:   {occurrence['status']}")

    return status


def show_due_reviews(root: Path) -> int:
    """Display active recurring reviews that are currently due."""

    review_dir = root / "docs" / "reviews" / "recurring"

    if not review_dir.exists():
        print("OK   Recurring reviews due: none")
        return 0

    occurrences = discover_occurrences(root)
    today = date.today()
    due_reviews = []
    status = 0

    for path in sorted(review_dir.glob("*.md")):
        metadata = read_frontmatter(path)

        if metadata is None:
            print(f"WARN Invalid recurring review definition: {path.name}")
            status = 1
            continue

        errors = validate_definition(path, metadata)

        if errors:
            print(f"WARN Invalid recurring review definition: {path.name}")
            for error in errors:
                print(f"     {error}")
            status = 1
            continue

        if metadata["status"] != "active":
            continue

        occurrence = occurrences.get(path.stem)

        if occurrence is None:
            due_reviews.append(
                {
                    "title": metadata["title"],
                    "frequency": metadata["frequency"],
                    "last": None,
                    "due": None,
                }
            )
            continue

        last_date = occurrence["date"]
        due_date = next_due_date(last_date, metadata["frequency"])

        if today >= due_date:
            due_reviews.append(
                {
                    "title": metadata["title"],
                    "frequency": metadata["frequency"],
                    "last": last_date,
                    "due": due_date,
                }
            )

    if due_reviews:
        print(f"WARN Recurring reviews due: {len(due_reviews)}")

        for review in due_reviews:
            print(f"     {review['title']}")

            if review["last"] is None:
                print("       Last completed: never")
                print(f"       Frequency:      {review['frequency']}")
                print("       Due:            now")
            else:
                print(f"       Last completed: {review['last'].isoformat()}")
                print(f"       Frequency:      {review['frequency']}")
                print(f"       Due:            {review['due'].isoformat()}")
    else:
        print("OK   Recurring reviews due: none")

    return status


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Discover Abbey recurring reviews."
    )
    parser.add_argument(
        "--root",
        type=Path,
        help="Abbey project root.",
    )
    parser.add_argument(
        "--due",
        action="store_true",
        help="Display only recurring reviews that are currently due.",
    )

    return parser.parse_args()


def main() -> int:
    args = parse_args()

    if args.root:
        root = args.root.resolve()
    elif os.environ.get("ABBEY_ROOT"):
        root = Path(os.environ["ABBEY_ROOT"]).resolve()
    else:
        root = Path(__file__).resolve().parents[1]

    if args.due:
        return show_due_reviews(root)

    return discover_reviews(root)


if __name__ == "__main__":
    sys.exit(main())
