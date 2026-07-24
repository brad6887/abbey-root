#!/usr/bin/env python3

"""Validate and normalize a semantic fact-lock verification response."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any


def load_json(path: Path) -> Any:
    try:
        text = path.read_text(encoding="utf-8").strip()
    except OSError as exc:
        raise ValueError(f"unable to read {path}: {exc}") from exc
    fenced = re.fullmatch(r"```(?:json)?\s*\n(.*)\n```", text, flags=re.DOTALL)
    if fenced:
        text = fenced.group(1).strip()
    try:
        return json.loads(text)
    except json.JSONDecodeError as exc:
        raise ValueError(f"invalid JSON in {path}: {exc}") from exc


def validate(spec: Any, verification: Any) -> list[str]:
    failures: list[str] = []
    if not isinstance(spec, dict) or not isinstance(verification, dict):
        return ["spec and verification roots must be objects"]
    if verification.get("schema_version") != 1:
        failures.append("verification schema_version must equal 1")
    if verification.get("workflow") != "fact_locked_voice_verification":
        failures.append("verification workflow mismatch")
    if verification.get("fact_lock_id") != spec.get("fact_lock_id"):
        failures.append("fact_lock_id mismatch")

    expected_ids = [
        item.get("scenario_id") for item in spec.get("scenarios", [])
        if isinstance(item, dict)
    ]
    items = verification.get("items")
    if not isinstance(items, list):
        return failures + ["verification items must be an array"]
    actual_ids = [
        item.get("scenario_id") for item in items if isinstance(item, dict)
    ]
    if actual_ids != expected_ids:
        failures.append("verification must contain every scenario exactly once and in order")

    item_results: list[str] = []
    for index, item in enumerate(items):
        if not isinstance(item, dict):
            failures.append(f"items[{index}] must be an object")
            continue
        scenario_id = item.get("scenario_id", f"items[{index}]")
        if not isinstance(item.get("all_facts_present"), bool):
            failures.append(f"{scenario_id}: all_facts_present must be boolean")
        claims = item.get("unsupported_claims")
        if not isinstance(claims, list) or any(
            not isinstance(claim, str) or not claim.strip() for claim in claims
        ):
            failures.append(f"{scenario_id}: unsupported_claims must be a text array")
        if not isinstance(item.get("creative_slots_valid"), bool):
            failures.append(f"{scenario_id}: creative_slots_valid must be boolean")
        expected_result = (
            "pass"
            if item.get("all_facts_present") is True
            and claims == []
            and item.get("creative_slots_valid") is True
            else "fail"
        )
        if item.get("result") != expected_result:
            failures.append(f"{scenario_id}: result does not match findings")
        item_results.append(expected_result)

    expected_overall = "pass" if item_results and all(
        result == "pass" for result in item_results
    ) else "fail"
    if verification.get("result") != expected_overall:
        failures.append("overall result does not match item results")
    return failures


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Validate semantic fact-lock verification output."
    )
    parser.add_argument("--spec", type=Path, required=True)
    parser.add_argument("--verification", type=Path, required=True)
    parser.add_argument("--normalized-output", type=Path)
    args = parser.parse_args()

    try:
        verification = load_json(args.verification)
        failures = validate(load_json(args.spec), verification)
        if args.normalized_output and not failures:
            args.normalized_output.write_text(
                json.dumps(verification, indent=2, ensure_ascii=False) + "\n",
                encoding="utf-8",
            )
    except ValueError as exc:
        failures = [str(exc)]

    print("========================================")
    print(" Abbey Fact-Lock Semantic Verification")
    print("========================================")
    print()
    for failure in failures:
        print(f"FAIL {failure}")
    print(f"Result: {'FAIL' if failures else 'VALID'}")
    raise SystemExit(1 if failures else 0)


if __name__ == "__main__":
    main()
