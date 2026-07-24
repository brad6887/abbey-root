#!/usr/bin/env python3

"""Deterministically validate a fact-locked Voice Model output."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any


CHARACTERISTICS = {"VM-C01", "VM-C02", "VM-C03", "VM-C04"}


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


def validate(spec: Any, output: Any) -> tuple[list[str], list[dict[str, Any]]]:
    failures: list[str] = []
    checks: list[dict[str, Any]] = []
    if not isinstance(spec, dict) or not isinstance(output, dict):
        return ["spec and output roots must be objects"], checks
    if output.get("schema_version") != 1:
        failures.append("output schema_version must equal 1")
    if output.get("workflow") != "fact_locked_voice_application":
        failures.append("output workflow mismatch")
    if output.get("fact_lock_id") != spec.get("fact_lock_id"):
        failures.append("fact_lock_id mismatch")

    scenarios = spec.get("scenarios")
    items = output.get("items")
    if not isinstance(scenarios, list) or not isinstance(items, list):
        return failures + ["spec scenarios and output items must be arrays"], checks
    expected_ids = [scenario.get("scenario_id") for scenario in scenarios]
    actual_ids = [item.get("scenario_id") for item in items if isinstance(item, dict)]
    if actual_ids != expected_ids:
        failures.append("output must contain every scenario exactly once and in order")
    by_id = {
        item.get("scenario_id"): item for item in items if isinstance(item, dict)
    }

    for scenario in scenarios:
        scenario_id = scenario["scenario_id"]
        item = by_id.get(scenario_id)
        scenario_failures: list[str] = []
        if not isinstance(item, dict):
            failures.append(f"{scenario_id}: missing output item")
            continue
        response = item.get("response")
        if not isinstance(response, str) or not response.strip():
            scenario_failures.append("response must be non-empty text")
            response = ""
        response_folded = response.casefold()

        expected_facts = [fact["fact_id"] for fact in scenario["immutable_facts"]]
        if item.get("used_fact_ids") != expected_facts:
            scenario_failures.append("used_fact_ids must contain all and only fact IDs in order")
        if item.get("added_facts") != []:
            scenario_failures.append("added_facts must be empty")

        for fact in scenario["immutable_facts"]:
            alternatives = fact.get("required_any", [])
            if not any(phrase.casefold() in response_folded for phrase in alternatives):
                scenario_failures.append(
                    f"{fact['fact_id']} lacks a required lexical anchor"
                )
        for literal in scenario.get("protected_literals", []):
            if literal not in response:
                scenario_failures.append(f"protected literal absent: {literal}")
        response_alternatives = scenario.get("required_response_any", [])
        if response_alternatives and not any(
            phrase.casefold() in response_folded for phrase in response_alternatives
        ):
            scenario_failures.append("response lacks a required scenario-level anchor")
        for pattern in scenario.get("forbidden_patterns", []):
            if re.search(pattern, response, flags=re.IGNORECASE):
                scenario_failures.append(f"forbidden pattern present: {pattern}")

        allowed_numbers = {str(value).casefold() for value in scenario.get("allowed_numbers", [])}
        numeric_text = re.sub(
            r"\b(?:no|some|any|every)\s+one\b", "", response_folded
        )
        number_tokens = re.findall(
            r"\b(?:\d+(?:[.:]\d+)?|zero|one|two|three|four|five|six|seven|eight|nine|ten)\b",
            numeric_text,
        )
        unexpected_numbers = sorted(set(number_tokens) - allowed_numbers)
        if unexpected_numbers:
            scenario_failures.append(
                "unauthorized numeric tokens: " + ", ".join(unexpected_numbers)
            )

        slots = {
            slot["slot_id"]: slot for slot in scenario.get("creative_slots", [])
        }
        uses = item.get("creative_slot_uses")
        if not isinstance(uses, list):
            scenario_failures.append("creative_slot_uses must be an array")
        else:
            counts: dict[str, int] = {}
            for use in uses:
                if not isinstance(use, dict) or use.get("slot_id") not in slots:
                    scenario_failures.append("creative_slot_uses contains an unauthorized slot")
                    continue
                slot_id = use["slot_id"]
                counts[slot_id] = counts.get(slot_id, 0) + 1
                if not isinstance(use.get("content"), str) or not use["content"].strip():
                    scenario_failures.append(f"{slot_id} use must describe its content")
            for slot_id, count in counts.items():
                if count > slots[slot_id]["maximum"]:
                    scenario_failures.append(f"{slot_id} exceeds maximum uses")
            for slot_id, slot in slots.items():
                if counts.get(slot_id, 0) < slot.get("minimum", 0):
                    scenario_failures.append(f"{slot_id} is required")

        applied = item.get("applied")
        omitted = item.get("omitted")
        if not isinstance(applied, list) or not set(applied).issubset(CHARACTERISTICS):
            scenario_failures.append("applied contains invalid characteristic IDs")
        if not isinstance(omitted, list) or not set(omitted).issubset(CHARACTERISTICS):
            scenario_failures.append("omitted contains invalid characteristic IDs")
        if isinstance(applied, list) and isinstance(omitted, list):
            if set(applied) & set(omitted):
                scenario_failures.append("applied and omitted overlap")
            missing_required = set(scenario.get("required_applied", [])) - set(applied)
            if missing_required:
                scenario_failures.append(
                    "required characteristics absent: " + ", ".join(sorted(missing_required))
                )
            prohibited_present = set(scenario.get("prohibited_applied", [])) & set(applied)
            if prohibited_present:
                scenario_failures.append(
                    "prohibited characteristics applied: "
                    + ", ".join(sorted(prohibited_present))
                )

        required_sentences = scenario.get("required_sentence_count")
        if required_sentences is not None:
            sentence_count = len(
                [part for part in re.split(r"(?<=[.!?])(?:\s+|$)", response.strip()) if part]
            )
            if sentence_count != required_sentences:
                scenario_failures.append(
                    f"sentence count must equal {required_sentences}, got {sentence_count}"
                )

        for detail in scenario_failures:
            failures.append(f"{scenario_id}: {detail}")
        checks.append(
            {
                "scenario_id": scenario_id,
                "result": "fail" if scenario_failures else "pass",
                "failures": scenario_failures,
            }
        )
    return failures, checks


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Validate fact-locked Voice Model application output."
    )
    parser.add_argument("--spec", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--report", type=Path)
    parser.add_argument("--normalized-output", type=Path)
    args = parser.parse_args()

    try:
        spec = load_json(args.spec)
        output = load_json(args.output)
        failures, checks = validate(spec, output)
        if args.normalized_output and not failures:
            args.normalized_output.write_text(
                json.dumps(output, indent=2, ensure_ascii=False) + "\n",
                encoding="utf-8",
            )
    except ValueError as exc:
        failures, checks = [str(exc)], []
    result = "fail" if failures else "pass"
    report = {
        "schema_version": 1,
        "workflow": "fact_locked_voice_deterministic_validation",
        "fact_lock": str(args.spec),
        "output": str(args.output),
        "checks": checks,
        "result": result,
        "failures": failures,
    }
    if args.report:
        args.report.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")

    print("========================================")
    print(" Abbey Fact-Locked Voice Validation")
    print("========================================")
    print()
    for check in checks:
        print(f"{check['result'].upper():4} {check['scenario_id']}")
    for failure in failures:
        print(f"FAIL {failure}")
    print()
    print(f"Result: {result.upper()}")
    raise SystemExit(1 if failures else 0)


if __name__ == "__main__":
    main()
