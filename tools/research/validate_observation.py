#!/usr/bin/env python3

from __future__ import annotations

import argparse
import re
import sys
import unicodedata
from pathlib import Path


REQUIRED_HEADINGS = [
    "## Question",
    "## Corpus",
    "## Method",
    "## Findings",
    "## Interpretation",
    "## Questions Raised",
    "## Status",
]

SOURCE_ID = re.compile(r"\bFB-[0-9]{6}\b")
SOURCE_LIKE = re.compile(r"\bFB.[0-9]{6}\b")


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Validate an Abbey voice-analysis observation.",
    )
    parser.add_argument("observation", type=Path)
    parser.add_argument(
        "--corpus-sample",
        type=Path,
        required=True,
        help="Sample containing the allowed source identifiers.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_arguments()

    observation = args.observation.read_text(encoding="utf-8")
    sample = args.corpus_sample.read_text(encoding="utf-8")

    failures = 0

    print("Observation Validation")
    print("=" * 72)

    lines = observation.splitlines()

    for heading in REQUIRED_HEADINGS:
        if heading in lines:
            print(f"PASS required heading: {heading}")
        else:
            print(f"FAIL required heading: {heading}")
            failures += 1

    trailing_heading_spaces = [
        line
        for line in lines
        if line.startswith("#") and line != line.rstrip()
    ]

    if trailing_heading_spaces:
        print("FAIL headings contain trailing whitespace")
        failures += 1
    else:
        print("PASS headings contain no trailing whitespace")

    normalized = unicodedata.normalize("NFKC", observation)

    if normalized != observation:
        print("FAIL observation contains compatibility Unicode characters")
        failures += 1
    else:
        print("PASS no compatibility Unicode normalization changes")

    source_like = set(SOURCE_LIKE.findall(observation))
    valid_format = set(SOURCE_ID.findall(observation))

    malformed = sorted(source_like - valid_format)

    if malformed:
        print("FAIL malformed source identifiers:")
        for value in malformed:
            print(f"  {value!r}")
        failures += 1
    else:
        print("PASS source identifier format")

    allowed_ids = set(SOURCE_ID.findall(sample))
    cited_ids = set(SOURCE_ID.findall(observation))
    invalid_ids = sorted(cited_ids - allowed_ids)

    print(f"INFO cited source identifiers: {len(cited_ids)}")

    if not cited_ids:
        print("FAIL observation contains no source citations")
        failures += 1
    else:
        print("PASS observation contains source citations")

    if invalid_ids:
        print("FAIL citations absent from supplied sample:")
        for source_id in invalid_ids:
            print(f"  {source_id}")
        failures += 1
    else:
        print("PASS all citations occur in supplied sample")

    prohibited_patterns = {
        "weighted score": re.compile(r"\bweighted score\b", re.I),
        "evidence score": re.compile(r"\bevidence score\b", re.I),
        "score distribution": re.compile(r"\bscore distribution\b", re.I),
        "conclusively established": re.compile(
            r"\bconclusively established\b",
            re.I,
        ),
        "unavailable evidence": re.compile(
            r"\b(?:not shown|analogous|outside the sample)\b",
            re.I,
        ),
    }

    for name, pattern in prohibited_patterns.items():
        if pattern.search(observation):
            print(f"FAIL prohibited language: {name}")
            failures += 1
        else:
            print(f"PASS prohibited language absent: {name}")

    print()
    print(f"Failures: {failures}")

    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
