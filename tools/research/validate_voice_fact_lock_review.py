#!/usr/bin/env python3

"""Validate a completed human review for a Voice fact-lock proposal."""

from __future__ import annotations

import argparse
from pathlib import Path
from typing import Any

from validate_voice_fact_lock_proposal import canonical_hash, load_json, validate


DECISIONS = {"approve", "revise"}


def validate_review(
    suite: Any,
    proposal: Any,
    review: Any,
    required_decision: str | None = None,
) -> list[str]:
    failures: list[str] = []
    failures.extend(validate(suite, proposal))
    if not isinstance(review, dict):
        return failures + ["review root must be an object"]
    if review.get("schema_version") != 1:
        failures.append("review schema_version must equal 1")
    if not isinstance(review.get("review_id"), str) or not review["review_id"].strip():
        failures.append("review_id must be a non-empty string")
    if review.get("proposal_manifest_id") != proposal.get("manifest_id"):
        failures.append("proposal_manifest_id mismatch")
    if review.get("proposal_sha256") != canonical_hash(proposal):
        failures.append("proposal_sha256 mismatch")
    source_hash = canonical_hash(suite.get("requests", []))
    if review.get("source_request_sha256") != source_hash:
        failures.append("source_request_sha256 mismatch")

    decision = review.get("decision")
    if decision not in DECISIONS:
        failures.append("review decision must equal approve or revise")
    if required_decision is not None and decision != required_decision:
        failures.append(f"review decision must equal {required_decision}")

    expected_ids = [
        item.get("scenario_id") for item in proposal.get("requests", [])
        if isinstance(item, dict)
    ]
    items = review.get("items")
    if not isinstance(items, list):
        return failures + ["review items must be an array"]
    actual_ids = [
        item.get("scenario_id") for item in items if isinstance(item, dict)
    ]
    if actual_ids != expected_ids:
        failures.append("review scenario coverage or order mismatch")

    has_revision = False
    for index, item in enumerate(items):
        if not isinstance(item, dict):
            failures.append(f"items[{index}] must be an object")
            continue
        scenario_id = item.get("scenario_id", f"items[{index}]")
        facts = item.get("facts")
        constraints = item.get("constraints")
        if facts not in DECISIONS:
            failures.append(f"{scenario_id}: facts must equal approve or revise")
        if constraints not in DECISIONS:
            failures.append(
                f"{scenario_id}: constraints must equal approve or revise"
            )
        if facts == "revise" or constraints == "revise":
            has_revision = True
        if not isinstance(item.get("note"), str) or not item["note"].strip():
            failures.append(f"{scenario_id}: review note required")

    fact_lock_id = review.get("fact_lock_id")
    if decision == "approve":
        if not isinstance(fact_lock_id, str) or not fact_lock_id.strip():
            failures.append("approved review requires fact_lock_id")
        if has_revision:
            failures.append("approved review cannot contain revise item decisions")
    elif decision == "revise":
        if fact_lock_id is not None:
            failures.append("revision review fact_lock_id must remain null")
        if not has_revision:
            failures.append("revision review requires at least one revise decision")
    return failures


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Validate a completed Voice fact-lock review."
    )
    parser.add_argument("--suite", type=Path, required=True)
    parser.add_argument("--proposal", type=Path, required=True)
    parser.add_argument("--review", type=Path, required=True)
    parser.add_argument("--require-decision", choices=sorted(DECISIONS))
    args = parser.parse_args()

    try:
        suite = load_json(args.suite)
        proposal = load_json(args.proposal)
        review = load_json(args.review)
        failures = validate_review(
            suite,
            proposal,
            review,
            required_decision=args.require_decision,
        )
    except ValueError as exc:
        failures = [str(exc)]

    print("========================================")
    print(" Abbey Voice Fact-Lock Review Validation")
    print("========================================")
    print()
    for failure in failures:
        print(f"FAIL {failure}")
    if failures:
        print("Result: FAIL")
        raise SystemExit(1)

    print(f"Decision: {review['decision']}")
    print(f"Scenarios: {len(review['items'])}")
    print("Result: PASS")
    print("Validation did not revise, approve, or promote the proposal.")


if __name__ == "__main__":
    main()
