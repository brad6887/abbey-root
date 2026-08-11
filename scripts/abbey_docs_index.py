#!/usr/bin/env python3
"""Generate a deterministic index of durable Abbey project documentation."""

from __future__ import annotations

import argparse
import re
from collections import defaultdict
from pathlib import Path
from urllib.parse import quote


EXCLUDED_DIRECTORIES = {"research", "session-updates"}
PREFERRED_CATEGORIES = (
    "guide",
    "planning",
    "framework",
    "architecture",
    "reference",
    "runbooks",
    "issues",
    "reviews",
    "generated",
)
INDEX_PATH = Path("docs/generated/DOCUMENTATION_INDEX.md")


def document_title(path: Path) -> str:
    try:
        text = path.read_text(encoding="utf-8")
    except OSError:
        text = ""
    match = re.search(r"^#\s+(.+?)\s*$", text, re.MULTILINE)
    if match:
        return match.group(1).strip()
    return path.stem.replace("_", " ").replace("-", " ").title()


def category_title(category: str) -> str:
    if category == "root":
        return "Documentation Root"
    return category.replace("_", " ").replace("-", " ").title()


def category_order(category: str):
    if category == "root":
        return (0, 0, category)
    try:
        return (1, PREFERRED_CATEGORIES.index(category), category)
    except ValueError:
        return (2, 0, category)


def markdown_link(path: Path) -> str:
    relative = Path("..") / path.relative_to("docs")
    return quote(relative.as_posix(), safe="/._-")


def generate_index(project_root: Path, output: Path, overlays: dict[Path, Path]) -> None:
    docs_root = project_root / "docs"
    documents: dict[Path, Path] = {}

    if docs_root.is_dir():
        for source in docs_root.rglob("*.md"):
            relative = source.relative_to(project_root)
            if relative == INDEX_PATH:
                continue
            if any(part in EXCLUDED_DIRECTORIES for part in relative.parts[1:-1]):
                continue
            documents[relative] = source

    for relative, source in overlays.items():
        documents[relative] = source

    grouped = defaultdict(list)
    for relative, source in documents.items():
        category = relative.parts[1] if len(relative.parts) > 2 else "root"
        grouped[category].append((document_title(source), relative))

    lines = [
        "# Documentation Index",
        "",
        "*Generated automatically by `abbey docs generate`. Do not edit directly.*",
        "",
        "This index covers durable Markdown documentation under `docs/`. Session",
        "updates and research artifacts are excluded because they are historical or",
        "domain-specific collections with dedicated discovery workflows.",
        "",
    ]

    for category in sorted(grouped, key=category_order):
        lines.extend([f"## {category_title(category)}", ""])
        for title, relative in sorted(
            grouped[category], key=lambda item: (item[0].casefold(), item[1].as_posix())
        ):
            escaped_title = title.replace("[", "\\[").replace("]", "\\]")
            lines.append(f"- [{escaped_title}]({markdown_link(relative)})")
        lines.append("")

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text("\n".join(lines), encoding="utf-8")
    print(f"Generated {output}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--project-root", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--overlay", action="append", default=[])
    args = parser.parse_args()

    overlays = {}
    for value in args.overlay:
        relative_text, separator, source_text = value.partition("=")
        if not separator:
            parser.error("--overlay must use RELATIVE_PATH=SOURCE_FILE")
        relative = Path(relative_text)
        if relative.is_absolute() or relative.parts[:1] != ("docs",):
            parser.error("--overlay paths must be relative paths below docs/")
        overlays[relative] = Path(source_text)

    generate_index(args.project_root.resolve(), args.output, overlays)


if __name__ == "__main__":
    main()
