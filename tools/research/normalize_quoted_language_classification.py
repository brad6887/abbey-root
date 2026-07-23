#!/usr/bin/env python3

"""Normalize and validate a quoted-language classification batch."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any


CATEGORIES = {"SD", "IR", "DQ", "RS", "TP", "PC", "MN", "OT"}
RELEVANCE = {"S", "C", "X", "R"}
ALLOWED_CODES = {
    f"{category}-{relevance}"
    for category in CATEGORIES
    for relevance in RELEVANCE
}
SOURCE_ID = re.compile(r"^FB-\d{6}$")


def load_json(path: Path) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except OSError as exc:
        raise ValueError(f"unable to read {path}: {exc}") from exc
    except json.JSONDecodeError as exc:
        raise ValueError(f"invalid JSON in {path}: {exc}") from exc


def load_model_json(path: Path) -> Any:
    try:
        content = path.read_text(encoding="utf-8").strip()
    except OSError as exc:
        raise ValueError(f"unable to read {path}: {exc}") from exc
    content = re.sub(
        r"^```(?:json)?\s*|\s*```$",
        "",
        content,
        flags=re.DOTALL,
    )
    try:
        return json.loads(content)
    except json.JSONDecodeError as exc:
        raise ValueError(f"invalid model JSON in {path}: {exc}") from exc


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Normalize a quoted-language classification batch."
    )
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--raw-result", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    try:
        batch = load_json(args.input)
        result = load_model_json(args.raw_result)
    except ValueError as exc:
        raise SystemExit(str(exc)) from exc

    candidates = batch.get("candidates") if isinstance(batch, dict) else None
    if not isinstance(candidates, list) or not candidates:
        raise SystemExit("input candidates must be a non-empty array")

    expected: list[str] = []
    for index, candidate in enumerate(candidates):
        source_id = (
            candidate.get("source_id")
            if isinstance(candidate, dict)
            else None
        )
        if not isinstance(source_id, str) or not SOURCE_ID.fullmatch(source_id):
            raise SystemExit(
                f"input candidates[{index}].source_id is invalid"
            )
        expected.append(source_id)
    if len(expected) != len(set(expected)):
        raise SystemExit("input contains duplicate source identifiers")

    if not isinstance(result, dict):
        raise SystemExit("model result root must be an object")
    if result.get("schema_version") != 1:
        raise SystemExit("model result schema_version must equal 1")
    if result.get("review_type") != "quoted_language_classification":
        raise SystemExit(
            "model result review_type must equal "
            "quoted_language_classification"
        )
    items = result.get("items")
    if not isinstance(items, dict):
        raise SystemExit("model result items must be an object")

    expected_set = set(expected)
    actual_set = set(items)
    missing = sorted(expected_set - actual_set)
    extra = sorted(actual_set - expected_set)
    if missing:
        raise SystemExit(
            "model result is missing source identifiers: "
            + ", ".join(missing)
        )
    if extra:
        raise SystemExit(
            "model result contains unexpected source identifiers: "
            + ", ".join(extra)
        )

    invalid_codes = [
        f"{source_id}={items[source_id]!r}"
        for source_id in expected
        if items[source_id] not in ALLOWED_CODES
    ]
    if invalid_codes:
        raise SystemExit(
            "model result contains invalid codes: "
            + ", ".join(invalid_codes)
        )

    normalized = {
        "schema_version": 1,
        "review_type": "quoted_language_classification",
        "batch_id": batch.get("batch_id"),
        "candidate_count": len(expected),
        "items": {
            source_id: items[source_id]
            for source_id in expected
        },
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(normalized, indent=2) + "\n",
        encoding="utf-8",
    )

    print(f"PASS batch:      {normalized['batch_id']}")
    print(f"PASS candidates: {len(expected)}")
    print(f"Output:          {args.output}")


if __name__ == "__main__":
    main()
