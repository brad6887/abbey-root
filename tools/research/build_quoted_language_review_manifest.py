#!/usr/bin/env python3

"""Build a complete exact-citation review manifest for OBS-004."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from pathlib import Path
from typing import Any


SUPPORTING_RETAIN = {"SD-S", "IR-S"}
SUPPORTING_PROVISIONAL = {"DQ-S", "RS-S"}
COMPARISON_RETAIN = {
    f"{category}-C"
    for category in ("SD", "IR", "DQ", "RS", "TP", "PC", "MN", "OT")
}
EXCLUDED = {
    f"{category}-X"
    for category in ("SD", "IR", "DQ", "RS", "TP", "PC", "MN", "OT")
}
AMBIGUOUS = {
    f"{category}-R"
    for category in ("SD", "IR", "DQ", "RS", "TP", "PC", "MN", "OT")
}
ALLOWED = (
    SUPPORTING_RETAIN
    | SUPPORTING_PROVISIONAL
    | COMPARISON_RETAIN
    | EXCLUDED
    | AMBIGUOUS
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def load_corpus(path: Path) -> dict[str, str]:
    with path.open(encoding="utf-8", newline="") as handle:
        return {
            f"FB-{int(row['source_id']):06d}": row["text"]
            for row in csv.DictReader(handle)
        }


def decision_for(code: str) -> tuple[str, str, str]:
    if code in SUPPORTING_RETAIN:
        return (
            "supporting",
            "retain",
            "Human review retained the worker classification as direct "
            "support for distancing or comic renaming.",
        )
    if code in SUPPORTING_PROVISIONAL:
        return (
            "supporting",
            "provisional",
            "Worker marked the quotation as supporting, but direct quotation "
            "or reported speech requires case-specific framing review.",
        )
    if code in COMPARISON_RETAIN:
        return (
            "comparison",
            "retain",
            "Retained as an ordinary or non-supporting quotation comparison.",
        )
    if code in EXCLUDED:
        return (
            "comparison",
            "reject",
            "Rejected because the match is copied, platform-derived, "
            "malformed, or unsuitable for voice inference.",
        )
    if code in AMBIGUOUS:
        return (
            "comparison",
            "provisional",
            "Retained for human review because the worker marked the "
            "quotation function as ambiguous.",
        )
    raise ValueError(f"unsupported classification code: {code}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Build the complete OBS-004 review manifest."
    )
    parser.add_argument("--candidate-set", type=Path, required=True)
    parser.add_argument("--results-dir", type=Path, required=True)
    parser.add_argument("--corpus", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    candidate_data = load_json(args.candidate_set)
    candidates = candidate_data.get("candidates")
    if not isinstance(candidates, list) or not candidates:
        raise SystemExit("candidate set must contain candidates")

    classifications: dict[str, str] = {}
    for path in sorted(args.results_dir.glob("batch-*.json")):
        data = load_json(path)
        items = data.get("items")
        if not isinstance(items, dict):
            raise SystemExit(f"classification items missing: {path}")
        overlap = set(classifications).intersection(items)
        if overlap:
            raise SystemExit(
                "duplicate classified source IDs: "
                + ", ".join(sorted(overlap))
            )
        classifications.update(items)

    expected = [candidate["source_id"] for candidate in candidates]
    missing = sorted(set(expected) - set(classifications))
    extra = sorted(set(classifications) - set(expected))
    if missing or extra:
        raise SystemExit(
            f"classification coverage mismatch; missing={missing}, extra={extra}"
        )
    invalid = {
        source_id: code
        for source_id, code in classifications.items()
        if code not in ALLOWED
    }
    if invalid:
        raise SystemExit(f"invalid classification codes: {invalid}")

    corpus = load_corpus(args.corpus)
    items = []
    for index, candidate in enumerate(candidates, 1):
        source_id = candidate["source_id"]
        code = classifications[source_id]
        evidence_role, decision, note = decision_for(code)
        items.append(
            {
                "review_item_id": f"QUOTE-{index:03d}",
                "evidence_role": evidence_role,
                "decision": decision,
                "note": f"{note} Classification: {code}.",
                "citations": [
                    {
                        "source_id": source_id,
                        "text": corpus[source_id],
                    }
                ],
            }
        )

    manifest = {
        "schema_version": 1,
        "review_id": "REVIEW-004",
        "evidence_artifact": "EVID-004",
        "review_scope": "complete_candidate_review",
        "corpus": {
            "artifact_id": "CORPUS-001",
            "path": str(args.corpus),
            "sha256": sha256(args.corpus),
        },
        "method": {
            "model": "gpt-oss:20b",
            "prompt": (
                "docs/research/voice-analysis/prompts/"
                "quoted-language-classification.md"
            ),
            "reviewer": "Brad Cooke",
            "review_date": "2026-07-23",
        },
        "items": items,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )

    counts: dict[tuple[str, str], int] = {}
    for item in items:
        key = (item["evidence_role"], item["decision"])
        counts[key] = counts.get(key, 0) + 1
    print(f"Candidates: {len(candidates)}")
    for key, count in sorted(counts.items()):
        print(f"{key[0]} / {key[1]}: {count}")
    print(f"Output: {args.output}")


if __name__ == "__main__":
    main()
