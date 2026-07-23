#!/usr/bin/env python3

"""Create deterministic chronological batches from a voice-eligible corpus."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from pathlib import Path
from typing import Any


def positive_integer(value: str) -> int:
    try:
        number = int(value)
    except ValueError as exc:
        raise argparse.ArgumentTypeError(
            f"expected an integer, received {value!r}"
        ) from exc
    if number < 1:
        raise argparse.ArgumentTypeError("value must be at least 1")
    return number


def load_rows(
    path: Path,
    include_platform_context: bool,
) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames is None:
            raise ValueError(f"corpus has no CSV header: {path}")

        required = {
            "source_id",
            "datetime",
            "text",
            "research_status",
            "platform_context",
        }
        missing = required.difference(reader.fieldnames)
        if missing:
            fields = ", ".join(sorted(missing))
            raise ValueError(f"corpus is missing required fields: {fields}")

        rows = [
            row
            for row in reader
            if row["research_status"] == "eligible"
            and (
                include_platform_context
                or not row["platform_context"].strip()
            )
        ]

    rows.sort(key=lambda row: (row["datetime"], int(row["source_id"])))
    return rows


def render_batch(
    rows: list[dict[str, str]],
    batch_number: int,
    total_batches: int,
) -> str:
    lines = [
        "# Voice-Eligible Chronological Batch",
        "",
        f"Batch: {batch_number} of {total_batches}",
        f"Posts: {len(rows)}",
        "",
    ]
    for index, row in enumerate(rows, start=1):
        source_id = f"FB-{int(row['source_id']):06d}"
        lines.extend(
            [
                f"{index}. [{source_id}] {row['datetime']}",
                "",
                row["text"].strip(),
                "",
            ]
        )
    return "\n".join(lines).rstrip() + "\n"


def create_batches(
    corpus: Path,
    output_dir: Path,
    batch_size: int,
    include_platform_context: bool,
) -> dict[str, Any]:
    rows = load_rows(corpus, include_platform_context)
    batches = [
        rows[index : index + batch_size]
        for index in range(0, len(rows), batch_size)
    ]

    output_dir.mkdir(parents=True, exist_ok=True)
    batch_records = []
    for index, batch_rows in enumerate(batches, start=1):
        filename = f"batch-{index:03d}.md"
        content = render_batch(batch_rows, index, len(batches))
        path = output_dir / filename
        path.write_text(content, encoding="utf-8")
        batch_records.append(
            {
                "batch": index,
                "path": filename,
                "posts": len(batch_rows),
                "first_source_id": (
                    f"FB-{int(batch_rows[0]['source_id']):06d}"
                    if batch_rows
                    else None
                ),
                "last_source_id": (
                    f"FB-{int(batch_rows[-1]['source_id']):06d}"
                    if batch_rows
                    else None
                ),
                "first_datetime": (
                    batch_rows[0]["datetime"] if batch_rows else None
                ),
                "last_datetime": (
                    batch_rows[-1]["datetime"] if batch_rows else None
                ),
                "sha256": hashlib.sha256(
                    content.encode("utf-8")
                ).hexdigest(),
            }
        )

    manifest = {
        "method": "chronological-voice-eligible-batches",
        "source_corpus": str(corpus),
        "source_sha256": hashlib.sha256(corpus.read_bytes()).hexdigest(),
        "include_platform_context": include_platform_context,
        "batch_size": batch_size,
        "eligible_posts": len(rows),
        "batch_count": len(batches),
        "batches": batch_records,
    }
    (output_dir / "manifest.json").write_text(
        json.dumps(manifest, indent=2) + "\n",
        encoding="utf-8",
    )
    return manifest


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "Create deterministic chronological Markdown batches from a "
            "voice-eligible corpus."
        ),
    )
    parser.add_argument("--corpus", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument(
        "--batch-size",
        type=positive_integer,
        default=125,
    )
    parser.add_argument(
        "--include-platform-context",
        action="store_true",
    )
    args = parser.parse_args()

    manifest = create_batches(
        corpus=args.corpus,
        output_dir=args.output_dir,
        batch_size=args.batch_size,
        include_platform_context=args.include_platform_context,
    )
    print("Voice Research Batches")
    print("======================")
    print(f"Eligible posts: {manifest['eligible_posts']}")
    print(f"Batch size:     {manifest['batch_size']}")
    print(f"Batches:        {manifest['batch_count']}")
    print(f"Output:         {args.output_dir}")


if __name__ == "__main__":
    main()

