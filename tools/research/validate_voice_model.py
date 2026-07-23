#!/usr/bin/env python3

"""Validate VOICE-MODEL-001 and its application evaluation records."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


EXPECTED_CHAINS = {
    "VM-C01": ("OBS-001", "EVID-001", "HYP-001", "VAL-001"),
    "VM-C02": ("OBS-002", "EVID-002", "HYP-002", "VAL-002"),
    "VM-C03": ("OBS-003", "EVID-003", "HYP-003", "VAL-003"),
    "VM-C04": ("OBS-004", "EVID-004", "HYP-004", "VAL-004"),
}
DIMENSIONS = {
    "context_fit",
    "characteristic_fidelity",
    "restraint",
    "clarity",
    "originality",
}


def load_json(path: Path) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except OSError as exc:
        raise ValueError(f"unable to read {path}: {exc}") from exc
    except json.JSONDecodeError as exc:
        raise ValueError(f"invalid JSON in {path}: {exc}") from exc


def validate_model(model: Any) -> list[str]:
    failures: list[str] = []
    if not isinstance(model, dict):
        return ["model root must be an object"]
    if model.get("schema_version") != 1:
        failures.append("model schema_version must equal 1")
    if model.get("artifact_id") != "VOICE-MODEL-001":
        failures.append("model artifact_id must equal VOICE-MODEL-001")
    if model.get("artifact_type") != "voice_model":
        failures.append("model artifact_type must equal voice_model")

    characteristics = model.get("characteristics")
    if not isinstance(characteristics, list):
        failures.append("model characteristics must be an array")
        return failures
    by_id = {
        item.get("characteristic_id"): item
        for item in characteristics
        if isinstance(item, dict)
    }
    if set(by_id) != set(EXPECTED_CHAINS):
        failures.append(
            "model must contain exactly VM-C01 through VM-C04"
        )
    for characteristic_id, chain in EXPECTED_CHAINS.items():
        item = by_id.get(characteristic_id)
        if item is None:
            continue
        trace = item.get("traceability", {})
        actual = (
            trace.get("observation"),
            trace.get("evidence"),
            trace.get("hypothesis"),
            trace.get("validation"),
        )
        if actual != chain:
            failures.append(
                f"{characteristic_id} traceability mismatch: {actual}"
            )
        if item.get("confidence") not in {"low", "medium", "high"}:
            failures.append(
                f"{characteristic_id} confidence is invalid"
            )
        for field in ("application", "avoid"):
            if not isinstance(item.get(field), list) or not item[field]:
                failures.append(
                    f"{characteristic_id}.{field} must be non-empty"
                )

    for index, interaction in enumerate(model.get("interactions", [])):
        if not isinstance(interaction, dict):
            failures.append(f"interactions[{index}] must be an object")
            continue
        references = interaction.get("characteristics")
        if (
            not isinstance(references, list)
            or len(references) < 2
            or not set(references).issubset(EXPECTED_CHAINS)
        ):
            failures.append(
                f"interactions[{index}] has invalid characteristic references"
            )
        if interaction.get("status") != "provisional":
            failures.append(
                f"interactions[{index}] must remain provisional"
            )

    if not model.get("application_constraints"):
        failures.append("model application_constraints must be non-empty")
    return failures


def validate_evaluation(evaluation: Any) -> list[str]:
    failures: list[str] = []
    if not isinstance(evaluation, dict):
        return ["evaluation root must be an object"]
    scenarios = evaluation.get("scenarios")
    if not isinstance(scenarios, list):
        return ["evaluation scenarios must be an array"]
    scenario_ids = [
        item.get("scenario_id")
        for item in scenarios
        if isinstance(item, dict)
    ]
    expected = [f"EVAL-{index:03d}" for index in range(1, 9)]
    if scenario_ids != expected:
        failures.append("evaluation must contain EVAL-001 through EVAL-008")
    if set(evaluation.get("dimensions", [])) != DIMENSIONS:
        failures.append("evaluation dimensions mismatch")
    return failures


def validate_run(
    run: Any,
    expected_scenarios: set[str],
    path: Path,
) -> list[str]:
    failures: list[str] = []
    if not isinstance(run, dict):
        return [f"{path}: run root must be an object"]
    items = run.get("items")
    if not isinstance(items, list):
        return [f"{path}: run items must be an array"]
    actual_scenarios = {
        item.get("scenario_id")
        for item in items
        if isinstance(item, dict)
    }
    if actual_scenarios != expected_scenarios:
        failures.append(f"{path}: scenario coverage mismatch")

    calculated_total = 0
    for index, item in enumerate(items):
        if not isinstance(item, dict):
            failures.append(f"{path}: items[{index}] must be an object")
            continue
        scores = item.get("scores")
        if not isinstance(scores, dict) or set(scores) != DIMENSIONS:
            failures.append(f"{path}: items[{index}] score dimensions mismatch")
            continue
        if any(
            not isinstance(value, int) or value < 0 or value > 2
            for value in scores.values()
        ):
            failures.append(f"{path}: items[{index}] score out of range")
            continue
        item_total = sum(scores.values())
        if item.get("total") != item_total:
            failures.append(f"{path}: items[{index}] total mismatch")
        calculated_total += item_total
    if run.get("total_score") != calculated_total:
        failures.append(f"{path}: run total_score mismatch")
    if run.get("maximum_score") != 80:
        failures.append(f"{path}: maximum_score must equal 80")
    if run.get("status") == "failed" and not run.get("failed_requirements"):
        failures.append(f"{path}: failed run must record failed_requirements")
    return failures


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Validate a Voice Model and evaluation records."
    )
    parser.add_argument("--model", type=Path, required=True)
    parser.add_argument("--evaluation", type=Path, required=True)
    parser.add_argument("--run", type=Path, action="append", default=[])
    args = parser.parse_args()

    failures: list[str] = []
    try:
        model = load_json(args.model)
        evaluation = load_json(args.evaluation)
        failures.extend(validate_model(model))
        failures.extend(validate_evaluation(evaluation))
        scenarios = {
            item["scenario_id"]
            for item in evaluation.get("scenarios", [])
        }
        for run_path in args.run:
            run = load_json(run_path)
            failures.extend(validate_run(run, scenarios, run_path))
    except (ValueError, KeyError) as exc:
        failures.append(str(exc))

    print("========================================")
    print(" Abbey Voice Model Validation")
    print("========================================")
    print()
    if failures:
        for failure in failures:
            print(f"FAIL {failure}")
        print()
        print("Result: FAIL")
        raise SystemExit(1)

    print("OK   Voice Model structure and traceability")
    print("OK   Provisional interaction boundaries")
    print("OK   Evaluation scenario coverage")
    print("OK   Evaluation score dimensions and totals")
    print(f"INFO Evaluation runs: {len(args.run)}")
    print()
    print("Result: PASS")


if __name__ == "__main__":
    main()
