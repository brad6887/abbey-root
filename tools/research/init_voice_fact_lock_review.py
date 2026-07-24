#!/usr/bin/env python3

"""Create a blank, hash-bound review scaffold for a fact-lock proposal."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

from validate_voice_fact_lock_proposal import canonical_hash, load_json, validate


def build_scaffold(
    suite: dict[str, Any],
    proposal: dict[str, Any],
) -> dict[str, Any]:
    return {
        "schema_version": 1,
        "review_id": None,
        "fact_lock_id": None,
        "proposal_manifest_id": proposal.get("manifest_id"),
        "proposal_sha256": canonical_hash(proposal),
        "source_request_sha256": canonical_hash(suite["requests"]),
        "decision": "undecided",
        "items": [
            {
                "scenario_id": item["scenario_id"],
                "facts": "undecided",
                "constraints": "undecided",
                "note": "",
            }
            for item in proposal["requests"]
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Create a blank Voice fact-lock review scaffold."
    )
    parser.add_argument("--suite", type=Path, required=True)
    parser.add_argument("--proposal", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    failures: list[str] = []
    try:
        suite = load_json(args.suite)
        proposal = load_json(args.proposal)
        failures.extend(validate(suite, proposal))
        suite_hash = canonical_hash(suite["requests"])
        recorded_hash = proposal.get("source_request_sha256")
        if recorded_hash is not None and recorded_hash != suite_hash:
            failures.append("proposal source_request_sha256 mismatch")
        if args.output.exists():
            failures.append(f"output already exists: {args.output}")
        if not failures:
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(
                json.dumps(
                    build_scaffold(suite, proposal),
                    indent=2,
                    ensure_ascii=False,
                )
                + "\n",
                encoding="utf-8",
            )
    except ValueError as exc:
        failures.append(str(exc))

    for failure in failures:
        print(f"FAIL {failure}")
    if failures:
        print("Result: FAIL")
        raise SystemExit(1)

    print("========================================")
    print(" Abbey Voice Fact-Lock Review Init")
    print("========================================")
    print()
    print(f"Proposal: {args.proposal}")
    print(f"Output:   {args.output}")
    print(f"Scenarios: {len(proposal['requests'])}")
    print()
    print("Result: PASS")
    print("All review decisions are undecided.")
    print("This command did not approve or promote the proposal.")


if __name__ == "__main__":
    main()
