#!/usr/bin/env python3

"""Promote a reviewed fact-lock proposal without rewriting its contents."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any


def load_json(path: Path) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"unable to load {path}: {exc}") from exc


def canonical_hash(value: Any) -> str:
    encoded = json.dumps(
        value, sort_keys=True, separators=(",", ":"), ensure_ascii=False
    ).encode("utf-8")
    return hashlib.sha256(encoded).hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser(description="Approve a reviewed voice fact lock.")
    parser.add_argument("--proposal", type=Path, required=True)
    parser.add_argument("--review", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    failures: list[str] = []
    try:
        proposal = load_json(args.proposal)
        review = load_json(args.review)
        if args.output.exists():
            failures.append(f"output already exists: {args.output}")
        if review.get("schema_version") != 1:
            failures.append("review schema_version must equal 1")
        if review.get("proposal_sha256") != canonical_hash(proposal):
            failures.append("review proposal_sha256 mismatch")
        if review.get("decision") != "approve":
            failures.append("review decision must equal approve")
        expected = [
            item.get("scenario_id") for item in proposal.get("requests", [])
        ]
        items = review.get("items")
        actual = [
            item.get("scenario_id") for item in items
            if isinstance(item, dict)
        ] if isinstance(items, list) else []
        if actual != expected:
            failures.append("review scenario coverage or order mismatch")
        for item in items if isinstance(items, list) else []:
            if item.get("facts") != "approve":
                failures.append(f"{item.get('scenario_id')}: facts not approved")
            if item.get("constraints") != "approve":
                failures.append(f"{item.get('scenario_id')}: constraints not approved")
            if not isinstance(item.get("note"), str) or not item["note"].strip():
                failures.append(f"{item.get('scenario_id')}: review note required")
        if not failures:
            approved = dict(proposal)
            approved["fact_lock_id"] = review["fact_lock_id"]
            approved.pop("manifest_id", None)
            approved["status"] = "approved_human_reviewed"
            approved["review_id"] = review["review_id"]
            approved["scenarios"] = approved.pop("requests")
            args.output.write_text(
                json.dumps(approved, indent=2, ensure_ascii=False) + "\n",
                encoding="utf-8",
            )
    except (ValueError, KeyError) as exc:
        failures.append(str(exc))

    for failure in failures:
        print(f"FAIL {failure}")
    print(f"Result: {'FAIL' if failures else 'PASS'}")
    raise SystemExit(1 if failures else 0)


if __name__ == "__main__":
    main()
