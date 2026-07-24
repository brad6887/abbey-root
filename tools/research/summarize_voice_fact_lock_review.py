#!/usr/bin/env python3

"""Print a deterministic, read-only review summary for a fact-lock proposal."""

from __future__ import annotations

import argparse
from pathlib import Path
from typing import Any

from validate_voice_fact_lock_proposal import canonical_hash, load_json, validate


def joined(values: list[Any]) -> str:
    return ", ".join(str(value) for value in values) if values else "none"


def attention_items(source: dict[str, Any], item: dict[str, Any]) -> list[str]:
    attention: list[str] = []
    if source.get("context"):
        attention.append("supplied callback context")
    if source.get("source_text"):
        attention.append("source-text preservation")
    if source.get("request_type") == "sensitive_message":
        attention.append("sensitive message")
    if item.get("creative_slots"):
        attention.append("authorized invention")
    if any("required_all" in fact for fact in item.get("immutable_facts", [])):
        attention.append("compound fact with grouped anchors")
    if item.get("protected_literals"):
        attention.append("protected literals")
    if item.get("allowed_numbers"):
        attention.append("numeric content")
    if item.get("forbidden_patterns"):
        attention.append("forbidden factual patterns")
    if item.get("prohibited_applied"):
        attention.append("prohibited voice characteristics")
    if item.get("required_sentence_count") is not None:
        attention.append("fixed sentence count")
    return attention


def print_summary(
    suite_path: Path,
    proposal_path: Path,
    suite: dict[str, Any],
    proposal: dict[str, Any],
) -> bool:
    requests = suite["requests"]
    items = proposal["requests"]
    source_by_id = {item["request_id"]: item for item in requests}
    suite_hash = canonical_hash(requests)
    proposal_hash = canonical_hash(proposal)

    fact_count = sum(len(item["immutable_facts"]) for item in items)
    slot_count = sum(len(item["creative_slots"]) for item in items)
    protected_count = sum(len(item["protected_literals"]) for item in items)
    number_count = sum(len(item["allowed_numbers"]) for item in items)
    pattern_count = sum(len(item["forbidden_patterns"]) for item in items)

    print("========================================")
    print(" Abbey Voice Fact-Lock Review")
    print("========================================")
    print()
    print(f"Suite:          {suite_path}")
    print(f"Proposal:       {proposal_path}")
    print(f"Manifest:       {proposal.get('manifest_id', 'not recorded')}")
    print(f"Status:         {proposal['status']}")
    print(f"Voice model:    {proposal['voice_model']}")
    print(f"Suite SHA-256:  {suite_hash}")
    print(f"Proposal SHA-256: {proposal_hash}")
    recorded_hash = proposal.get("source_request_sha256")
    if recorded_hash is None:
        print("Recorded source hash: not recorded")
    else:
        result = "MATCH" if recorded_hash == suite_hash else "MISMATCH"
        print(f"Recorded source hash: {recorded_hash} ({result})")
    print()
    print("Summary")
    print("-------")
    print(f"Scenarios:          {len(items)}")
    print(f"Immutable facts:    {fact_count}")
    print(f"Creative slots:     {slot_count}")
    print(f"Protected literals: {protected_count}")
    print(f"Allowed numbers:    {number_count}")
    print(f"Forbidden patterns: {pattern_count}")

    for item in items:
        scenario_id = item["scenario_id"]
        source = source_by_id[scenario_id]
        print()
        print(f"{scenario_id}: {source.get('request_type', 'unspecified')}")
        print("-" * (len(scenario_id) + len(source.get("request_type", "")) + 2))
        print(f"Task: {item['task']}")
        print("Facts:")
        for fact in item["immutable_facts"]:
            if "required_all" in fact:
                group_text = " + ".join(
                    "(" + " | ".join(group) + ")"
                    for group in fact["required_all"]
                )
                anchor_text = f"all groups: {group_text}"
            else:
                anchor_text = "any: " + " | ".join(fact["required_any"])
            print(
                f"  {fact['fact_id']}: {fact['proposition']} "
                f"[{anchor_text}]"
            )
        print(f"Protected literals: {joined(item['protected_literals'])}")
        print(f"Allowed numbers:    {joined(item['allowed_numbers'])}")
        print(f"Required style:     {joined(item['required_applied'])}")
        print(f"Prohibited style:   {joined(item['prohibited_applied'])}")
        sentence_count = item.get("required_sentence_count")
        print(
            "Sentence count:     "
            + (str(sentence_count) if sentence_count is not None else "none")
        )
        if item["forbidden_patterns"]:
            print("Forbidden patterns:")
            for pattern in item["forbidden_patterns"]:
                print(f"  - {pattern}")
        else:
            print("Forbidden patterns: none")
        if item["creative_slots"]:
            print("Creative slots:")
            for slot in item["creative_slots"]:
                print(
                    f"  {slot['slot_id']}: {slot['description']} "
                    f"[{slot.get('minimum', 0)}..{slot['maximum']}]"
                )
        else:
            print("Creative slots: none")
        notes = item.get("extraction_notes", [])
        print(f"Extraction notes: {joined(notes)}")
        print(f"Review attention: {joined(attention_items(source, item))}")

    print()
    print("Decision")
    print("--------")
    print("HUMAN REVIEW REQUIRED")
    print(f"Review this exact proposal: {proposal_path}")
    if recorded_hash is None:
        print(
            "Normalize the proposal before approval to record its source hash."
        )
    elif recorded_hash != suite_hash:
        print("BLOCKED: recorded source hash does not match the request suite.")
    print("This command did not create, modify, approve, or promote any artifact.")
    return recorded_hash is not None and recorded_hash != suite_hash


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Print a read-only Voice fact-lock review summary."
    )
    parser.add_argument("--suite", type=Path, required=True)
    parser.add_argument("--proposal", type=Path, required=True)
    args = parser.parse_args()

    try:
        suite = load_json(args.suite)
        proposal = load_json(args.proposal)
        failures = validate(suite, proposal)
    except ValueError as exc:
        failures = [str(exc)]

    if failures:
        for failure in failures:
            print(f"FAIL {failure}")
        print("Result: FAIL")
        raise SystemExit(1)

    source_hash_mismatch = print_summary(
        args.suite, args.proposal, suite, proposal
    )
    if source_hash_mismatch:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
