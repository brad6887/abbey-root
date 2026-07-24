#!/usr/bin/env python3

"""Validate and normalize a proposed Voice Model fact-lock manifest."""

from __future__ import annotations

import argparse
import hashlib
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


def canonical_hash(value: Any) -> str:
    encoded = json.dumps(
        value, sort_keys=True, separators=(",", ":"), ensure_ascii=False
    ).encode("utf-8")
    return hashlib.sha256(encoded).hexdigest()


def validate(suite: Any, proposal: Any) -> list[str]:
    failures: list[str] = []
    if not isinstance(suite, dict) or not isinstance(proposal, dict):
        return ["suite and proposal roots must be objects"]
    if proposal.get("schema_version") != 1:
        failures.append("proposal schema_version must equal 1")
    if proposal.get("evaluation_id") != suite.get("evaluation_id"):
        failures.append("evaluation_id mismatch")
    if proposal.get("voice_model") != suite.get("voice_model"):
        failures.append("voice_model mismatch")
    if proposal.get("status") != "proposed_human_review_required":
        failures.append("proposal status must require human review")

    source = suite.get("requests")
    proposed = proposal.get("requests")
    if not isinstance(source, list) or not isinstance(proposed, list):
        return failures + ["suite and proposal requests must be arrays"]
    expected_ids = [item.get("request_id") for item in source if isinstance(item, dict)]
    actual_ids = [item.get("scenario_id") for item in proposed if isinstance(item, dict)]
    if actual_ids != expected_ids:
        failures.append("proposal must contain every request exactly once and in order")
    source_by_id = {item["request_id"]: item for item in source}

    for item in proposed:
        if not isinstance(item, dict):
            failures.append("proposal request entries must be objects")
            continue
        scenario_id = item.get("scenario_id")
        source_item = source_by_id.get(scenario_id)
        if source_item is None:
            continue
        facts = item.get("immutable_facts")
        if not isinstance(facts, list) or not facts:
            failures.append(f"{scenario_id}: immutable_facts must be non-empty")
            continue
        expected_fact_ids = [f"F{index:03d}" for index in range(1, len(facts) + 1)]
        actual_fact_ids = [
            fact.get("fact_id") for fact in facts if isinstance(fact, dict)
        ]
        if actual_fact_ids != expected_fact_ids:
            failures.append(f"{scenario_id}: fact IDs must be sequential")
        for fact in facts:
            if not isinstance(fact, dict):
                failures.append(f"{scenario_id}: facts must be objects")
                continue
            if not isinstance(fact.get("proposition"), str) or not fact["proposition"].strip():
                failures.append(f"{scenario_id}: fact proposition must be non-empty")
            has_any = "required_any" in fact
            has_all = "required_all" in fact
            if has_any == has_all:
                failures.append(
                    f"{scenario_id}: each fact needs exactly one anchor mode"
                )
                anchors: list[str] = []
            elif has_any:
                value = fact.get("required_any")
                anchors = value if isinstance(value, list) else []
                if not anchors or any(
                    not isinstance(anchor, str) or not anchor.strip()
                    for anchor in anchors
                ):
                    failures.append(
                        f"{scenario_id}: required_any must be a non-empty text array"
                    )
            else:
                groups = fact.get("required_all")
                anchors = []
                if not isinstance(groups, list) or not groups:
                    failures.append(
                        f"{scenario_id}: required_all must be a non-empty group array"
                    )
                else:
                    for group in groups:
                        if not isinstance(group, list) or not group or any(
                            not isinstance(anchor, str) or not anchor.strip()
                            for anchor in group
                        ):
                            failures.append(
                                f"{scenario_id}: required_all groups must be non-empty text arrays"
                            )
                        else:
                            anchors.extend(group)
            if any(len(anchor.split()) > 8 for anchor in anchors):
                failures.append(
                    f"{scenario_id}: lexical anchors must contain at most eight words"
                )
            if any("..." in anchor or "…" in anchor for anchor in anchors):
                failures.append(f"{scenario_id}: lexical anchors cannot use ellipses")
            proposition = str(fact.get("proposition", "")).casefold()
            if re.search(
                r"\b(?:message|notice|output|response)\s+(?:must|has|contains)",
                proposition,
            ):
                failures.append(
                    f"{scenario_id}: output constraints cannot be immutable facts"
                )
        for field in (
            "protected_literals",
            "allowed_numbers",
            "forbidden_patterns",
            "creative_slots",
            "required_applied",
            "prohibited_applied",
            "extraction_notes",
        ):
            if not isinstance(item.get(field), list):
                failures.append(f"{scenario_id}: {field} must be an array")
        if any(
            not isinstance(value, str) or not value
            for value in item.get("allowed_numbers", [])
        ):
            failures.append(f"{scenario_id}: allowed_numbers must contain strings")
        if item.get("required_applied") != source_item.get("style_targets"):
            failures.append(f"{scenario_id}: required_applied does not copy source targets")
        if item.get("prohibited_applied") != source_item.get("style_prohibitions"):
            failures.append(f"{scenario_id}: prohibited_applied does not copy source prohibitions")
        expected_sentences = source_item.get("format_constraints", {}).get("sentence_count")
        if item.get("required_sentence_count") != expected_sentences:
            if expected_sentences is not None or "required_sentence_count" in item:
                failures.append(f"{scenario_id}: sentence-count constraint mismatch")
        if set(item.get("required_applied", [])) - CHARACTERISTICS:
            failures.append(f"{scenario_id}: invalid required characteristic")
        if set(item.get("prohibited_applied", [])) - CHARACTERISTICS:
            failures.append(f"{scenario_id}: invalid prohibited characteristic")
        for pattern in item.get("forbidden_patterns", []):
            try:
                re.compile(pattern)
            except (re.error, TypeError):
                failures.append(f"{scenario_id}: invalid forbidden regular expression")
            if (
                isinstance(pattern, str)
                and "(?i)" in pattern
                and "[A-Z]" in pattern
            ):
                failures.append(
                    f"{scenario_id}: case-insensitive uppercase class is overbroad"
                )
        for slot in item.get("creative_slots", []):
            if not isinstance(slot, dict):
                failures.append(f"{scenario_id}: creative slots must be objects")
                continue
            if (
                not isinstance(slot.get("slot_id"), str)
                or not isinstance(slot.get("description"), str)
                or not isinstance(slot.get("minimum", 0), int)
                or not isinstance(slot.get("maximum"), int)
                or slot.get("minimum", 0) < 0
                or slot["maximum"] < slot.get("minimum", 0)
            ):
                failures.append(f"{scenario_id}: invalid creative slot")
            elif len(slot["description"].split()) < 6:
                failures.append(
                    f"{scenario_id}: creative slot description is too vague"
                )
    return failures


def main() -> None:
    parser = argparse.ArgumentParser(description="Validate a proposed voice fact lock.")
    parser.add_argument("--suite", type=Path, required=True)
    parser.add_argument("--proposal", type=Path, required=True)
    parser.add_argument("--normalized-output", type=Path)
    args = parser.parse_args()
    try:
        suite = load_json(args.suite)
        proposal = load_json(args.proposal)
        failures = validate(suite, proposal)
        if args.normalized_output and not failures:
            proposal["source_request_sha256"] = canonical_hash(suite["requests"])
            args.normalized_output.write_text(
                json.dumps(proposal, indent=2, ensure_ascii=False) + "\n",
                encoding="utf-8",
            )
    except ValueError as exc:
        failures = [str(exc)]
    for failure in failures:
        print(f"FAIL {failure}")
    print(f"Result: {'FAIL' if failures else 'PASS'}")
    raise SystemExit(1 if failures else 0)


if __name__ == "__main__":
    main()
