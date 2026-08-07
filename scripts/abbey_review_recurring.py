#!/usr/bin/env python3
"""Discover Abbey recurring review definitions, occurrences, due state, and review implementations."""

import argparse
import calendar
from datetime import date, timedelta
import os
from pathlib import Path
import subprocess
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


def relative_path(path: Path, root: Path) -> str:
    """Return a repository-relative path when possible."""

    try:
        return str(path.relative_to(root))
    except ValueError:
        return str(path)


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


def unreviewed_session_updates(root: Path) -> list[Path]:
    """Return session updates whose reviewed metadata is false."""

    session_dir = root / "docs" / "session-updates"

    if not session_dir.exists():
        return []

    updates = []

    for path in sorted(session_dir.glob("*.md")):
        metadata = read_frontmatter(path)

        if metadata is not None and metadata.get("reviewed") is False:
            updates.append(path)

    return updates


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


def run_documentation_audit(root: Path) -> int:
    """Run the Documentation Audit recurring review."""

    print("========================================")
    print(" Documentation Audit")
    print("========================================")
    print()
    print(f"Repo: {root}")

    findings = 0

    print()
    print("Generated Documentation")
    print("-----------------------")

    docs_command = (
        Path(__file__).resolve().parents[1]
        / "tools"
        / "bin"
        / "abbey-docs"
    )

    result = subprocess.run(
        [str(docs_command), "check"],
        cwd=root,
        env={
            **os.environ,
            "ABBEY_ROOT": str(root),
        },
        text=True,
    )

    if result.returncode != 0:
        findings += 1

    print()
    print("Architecture")
    print("------------")

    architecture_dir = root / "docs" / "architecture"
    architecture_files = sorted(architecture_dir.glob("*.md"))

    if architecture_files:
        print(f"INFO Architecture documents: {len(architecture_files)}")
    else:
        print("WARN No architecture documents found")
        findings += 1

    print()
    print("Planning")
    print("--------")

    planning_files = [
        "docs/planning/PROJECT_STATUS.md",
        "docs/planning/NEXT.md",
        "docs/planning/BACKLOG.md",
    ]

    for relative_file in planning_files:
        path = root / relative_file

        if path.is_file():
            print(f"OK   {relative_file}")
        else:
            print(f"WARN Missing planning document: {relative_file}")
            findings += 1

    print()
    print("Session Documentation")
    print("---------------------")

    updates = unreviewed_session_updates(root)

    if updates:
        print(f"INFO Unreviewed session updates: {len(updates)}")
        print(
            "INFO Oldest unreviewed: "
            f"{relative_path(updates[0], root)}"
        )
    else:
        print("OK   Unreviewed session updates: none")

    print()
    print("Result")
    print("------")
    print("OK   Documentation audit completed")
    print(f"INFO Findings: {findings}")

    return 0


def run_review(root: Path, review_name: str) -> int:
    """Run a supported recurring review implementation."""

    review_path = (
        root
        / "docs"
        / "reviews"
        / "recurring"
        / f"{review_name}.md"
    )

    if not review_path.is_file():
        print(f"ERROR Recurring review not found: {review_name}")
        return 1

    metadata = read_frontmatter(review_path)

    if metadata is None:
        print(f"ERROR Invalid recurring review definition: {review_path.name}")
        return 1

    errors = validate_definition(review_path, metadata)

    if errors:
        print(f"ERROR Invalid recurring review definition: {review_path.name}")
        for error in errors:
            print(f"      {error}")
        return 1

    if metadata["status"] != "active":
        print(f"ERROR Recurring review is not active: {review_name}")
        return 1

    if review_name == "documentation-audit":
        return run_documentation_audit(root)

    print(f"ERROR No implementation available for recurring review: {review_name}")
    return 1


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Discover and run Abbey recurring reviews."
    )

    parser.add_argument(
        "command",
        nargs="?",
        choices=["run"],
        help="Recurring review action.",
    )

    parser.add_argument(
        "review",
        nargs="?",
        help="Recurring review name.",
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

    if args.command == "run":
        if not args.review:
            print("ERROR A recurring review name is required.")
            return 1

        return run_review(root, args.review)

    if args.review:
        print("ERROR A review name requires the run command.")
        return 1

    if args.due:
        return show_due_reviews(root)

    return discover_reviews(root)


if __name__ == "__main__":
    sys.exit(main())
