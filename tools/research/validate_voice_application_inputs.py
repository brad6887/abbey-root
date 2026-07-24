#!/usr/bin/env python3

"""Validate the approved inputs to the public Voice Model application."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


def load_json(path: Path) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"unable to load {path}: {exc}") from exc


def validate(model: Any, fact_lock: Any) -> list[str]:
    failures: list[str] = []
    if not isinstance(model, dict) or not isinstance(fact_lock, dict):
        return ["voice model and fact lock roots must be objects"]
    if model.get("artifact_id") != "VOICE-MODEL-001":
        failures.append("voice model artifact_id must equal VOICE-MODEL-001")
    if model.get("scope", {}).get("formats") != ["facebook_post"]:
        failures.append("VOICE-MODEL-001 scope must remain facebook_post")
    if fact_lock.get("schema_version") != 1:
        failures.append("fact lock schema_version must equal 1")
    if fact_lock.get("status") != "approved_human_reviewed":
        failures.append("fact lock status must equal approved_human_reviewed")
    if fact_lock.get("voice_model") != "VOICE-MODEL-001":
        failures.append("fact lock voice_model must equal VOICE-MODEL-001")
    for field in ("fact_lock_id", "review_id"):
        value = fact_lock.get(field)
        if not isinstance(value, str) or not value.strip():
            failures.append(f"approved fact lock must have a non-empty {field}")
    scenarios = fact_lock.get("scenarios")
    if not isinstance(scenarios, list) or not scenarios:
        failures.append("approved fact lock must contain scenarios")
    return failures


def main() -> None:
    parser = argparse.ArgumentParser(description="Validate inputs to fact-locked VOICE-MODEL-001 application.")
    parser.add_argument("--model", type=Path, required=True)
    parser.add_argument("--fact-lock", type=Path, required=True)
    args = parser.parse_args()
    try:
        failures = validate(load_json(args.model), load_json(args.fact_lock))
    except ValueError as exc:
        failures = [str(exc)]
    for failure in failures:
        print(f"FAIL {failure}")
    print(f"Result: {'FAIL' if failures else 'PASS'}")
    raise SystemExit(1 if failures else 0)


if __name__ == "__main__":
    main()
