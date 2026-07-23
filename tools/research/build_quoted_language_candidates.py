#!/usr/bin/env python3

"""Build a deterministic quoted-language candidate set from a corpus CSV."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import re
from pathlib import Path


PAIRED_ASCII_SINGLE = re.compile(
    r"(?:^|[^A-Za-z0-9])'[^'\n]+'(?:[^A-Za-z0-9]|$)"
)
PAIRED_CURLY_SINGLE = re.compile(r"‘[^‘’\n]+’")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def signals(text: str) -> list[str]:
    found: list[str] = []
    if '"' in text:
        found.append("ascii_double_quote")
    if any(character in text for character in "“”"):
        found.append("curly_double_quote")
    if PAIRED_ASCII_SINGLE.search(text):
        found.append("paired_ascii_single_quote")
    if PAIRED_CURLY_SINGLE.search(text):
        found.append("paired_curly_single_quote")
    return found


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Build a quoted-language review candidate set."
    )
    parser.add_argument("--corpus", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    with args.corpus.open(encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames is None:
            raise SystemExit(f"Corpus has no CSV header: {args.corpus}")
        required = {
            "source_id",
            "datetime",
            "text",
            "research_status",
            "platform_context",
        }
        missing = required.difference(reader.fieldnames)
        if missing:
            raise SystemExit(
                "Corpus is missing required fields: "
                + ", ".join(sorted(missing))
            )
        source_rows = list(reader)

    rows = [
        row
        for row in source_rows
        if row["research_status"] == "eligible"
        and not row["platform_context"]
    ]

    candidates = []
    signal_counts: dict[str, int] = {}
    for row in rows:
        detected = signals(row["text"])
        if not detected:
            continue
        for signal in detected:
            signal_counts[signal] = signal_counts.get(signal, 0) + 1
        candidates.append(
            {
                "source_id": f"FB-{int(row['source_id']):06d}",
                "datetime": row["datetime"],
                "text": row["text"],
                "signals": detected,
                "review": {
                    "category": "pending",
                    "voice_relevance": "pending",
                    "note": "",
                },
            }
        )

    artifact = {
        "schema_version": 1,
        "artifact_type": "quoted_language_candidate_set",
        "status": "human_review_required",
        "corpus": {
            "path": str(args.corpus),
            "sha256": sha256(args.corpus),
            "source_row_count": len(source_rows),
            "eligible_row_count": len(rows),
        },
        "method": {
            "ascii_double_quote": "contains an ASCII double quote",
            "curly_double_quote": "contains a curly double quote",
            "paired_ascii_single_quote": (
                "contains a non-contraction pair of ASCII single quotes"
            ),
            "paired_curly_single_quote": (
                "contains an opening-and-closing curly single-quote pair"
            ),
        },
        "candidate_count": len(candidates),
        "signal_counts": dict(sorted(signal_counts.items())),
        "candidates": candidates,
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(artifact, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )

    print("Quoted-Language Candidate Set")
    print(f"Source rows:   {len(source_rows)}")
    print(f"Eligible rows: {len(rows)}")
    print(f"Candidates:    {len(candidates)}")
    for name, count in sorted(signal_counts.items()):
        print(f"{name}: {count}")
    print(f"Output:        {args.output}")


if __name__ == "__main__":
    main()
