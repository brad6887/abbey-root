#!/usr/bin/env python3

"""Calculate deterministic HYP-004 holdout validation."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import math
import re
from pathlib import Path
from typing import Any


CLASSIFICATION = re.compile(
    r"\bClassification: "
    r"(SD|IR|DQ|RS|TP|PC|MN|OT)-(S|C|X|R)\."
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_json(path: Path) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except OSError as exc:
        raise ValueError(f"unable to read {path}: {exc}") from exc
    except json.JSONDecodeError as exc:
        raise ValueError(f"invalid JSON in {path}: {exc}") from exc


def load_corpus(path: Path) -> dict[str, dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames is None:
            raise ValueError(f"corpus has no CSV header: {path}")
        required = {"source_id", "datetime", "text"}
        missing = required.difference(reader.fieldnames)
        if missing:
            raise ValueError(
                "corpus is missing required fields: "
                + ", ".join(sorted(missing))
            )
        return {
            f"FB-{int(row['source_id']):06d}": row
            for row in reader
        }


def wilson_interval(successes: int, total: int) -> tuple[float, float]:
    if total == 0:
        return 0.0, 0.0
    z = 1.959963984540054
    p = successes / total
    denominator = 1 + z * z / total
    center = (p + z * z / (2 * total)) / denominator
    margin = (
        z
        * math.sqrt(
            p * (1 - p) / total + z * z / (4 * total * total)
        )
        / denominator
    )
    return center - margin, center + margin


def require_equal(
    failures: list[str],
    label: str,
    actual: int,
    expected: int,
) -> None:
    if actual != expected:
        failures.append(f"{label}: expected {expected}, actual {actual}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Calculate deterministic HYP-004 validation."
    )
    parser.add_argument("--definition", type=Path, required=True)
    parser.add_argument("--review", type=Path, required=True)
    parser.add_argument("--corpus", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    try:
        definition = load_json(args.definition)
        review = load_json(args.review)
        corpus = load_corpus(args.corpus)
    except ValueError as exc:
        raise SystemExit(str(exc)) from exc

    failures: list[str] = []
    if definition.get("schema_version") != 1:
        failures.append("definition schema_version must equal 1")
    if review.get("schema_version") != 1:
        failures.append("review schema_version must equal 1")

    review_corpus = review.get("corpus", {})
    expected_hash = review_corpus.get("sha256")
    actual_hash = sha256(args.corpus)
    if expected_hash != actual_hash:
        failures.append(
            "review corpus fingerprint does not match supplied corpus"
        )

    records: dict[str, dict[str, Any]] = {}
    for index, item in enumerate(review.get("items", [])):
        citations = item.get("citations")
        if not isinstance(citations, list) or len(citations) != 1:
            failures.append(
                f"review item {index} must contain exactly one citation"
            )
            continue
        citation = citations[0]
        source_id = citation.get("source_id")
        if not isinstance(source_id, str):
            failures.append(f"review item {index} source ID is invalid")
            continue
        if source_id in records:
            failures.append(f"duplicate reviewed source ID: {source_id}")
            continue
        source = corpus.get(source_id)
        if source is None:
            failures.append(f"review source absent from corpus: {source_id}")
            continue
        if citation.get("text") != source["text"]:
            failures.append(
                f"review text does not match corpus: {source_id}"
            )
        match = CLASSIFICATION.search(item.get("note", ""))
        if match is None:
            failures.append(
                f"review classification code missing: {source_id}"
            )
            continue
        records[source_id] = {
            "code": f"{match.group(1)}-{match.group(2)}",
            "evidence_role": item.get("evidence_role"),
            "decision": item.get("decision"),
            "year": int(source["datetime"][:4]),
        }

    expected = definition["expected"]
    require_equal(
        failures,
        "candidate count",
        len(records),
        expected["candidate_count"],
    )

    canonical_support = set(definition["canonical_supporting_ids"])
    canonical_comparison = set(definition["canonical_comparison_ids"])
    if canonical_support.intersection(canonical_comparison):
        failures.append("canonical support and comparison sets overlap")
    unknown_canonical = (
        canonical_support | canonical_comparison
    ).difference(records)
    if unknown_canonical:
        failures.append(
            "canonical IDs absent from review: "
            + ", ".join(sorted(unknown_canonical))
        )

    rejected = {
        source_id
        for source_id, record in records.items()
        if record["decision"] == "reject"
    }
    require_equal(
        failures,
        "rejected count",
        len(rejected),
        expected["rejected_count"],
    )
    excluded = canonical_support | canonical_comparison | rejected
    if len(excluded) != (
        len(canonical_support) + len(canonical_comparison) + len(rejected)
    ):
        failures.append("holdout exclusion sets overlap")

    holdout = {
        source_id: record
        for source_id, record in records.items()
        if source_id not in excluded
    }
    require_equal(
        failures,
        "holdout count",
        len(holdout),
        expected["holdout_count"],
    )

    core_codes = set(definition["core_codes"])
    core = {
        source_id: record
        for source_id, record in holdout.items()
        if record["code"] in core_codes
    }
    distancing_count = sum(
        record["code"] == "SD-S"
        for record in holdout.values()
    )
    renaming_count = sum(
        record["code"] == "IR-S"
        for record in holdout.values()
    )
    comparison_count = sum(
        record["evidence_role"] == "comparison"
        and record["decision"] == "retain"
        for record in holdout.values()
    )
    core_rate = len(core) / len(holdout) if holdout else 0.0
    interval_low, interval_high = wilson_interval(
        len(core), len(holdout)
    )

    band_results = []
    passing_bands = 0
    for band in definition["chronological_bands"]:
        count = sum(
            band["start_year"] <= record["year"] <= band["end_year"]
            for record in core.values()
        )
        passed = count > 0
        passing_bands += int(passed)
        band_results.append(
            {
                **band,
                "core_count": count,
                "passed": passed,
            }
        )

    thresholds = definition["thresholds"]
    tests = {
        "holdout_integrity": {
            "actual": len(holdout),
            "threshold": expected["holdout_count"],
            "operator": "equals",
            "passed": len(holdout) == expected["holdout_count"],
        },
        "core_rate": {
            "actual": core_rate,
            "threshold": thresholds["minimum_core_rate"],
            "operator": "greater_than_or_equal",
            "passed": core_rate >= thresholds["minimum_core_rate"],
        },
        "distancing_count": {
            "actual": distancing_count,
            "threshold": thresholds["minimum_distancing_count"],
            "operator": "greater_than_or_equal",
            "passed": (
                distancing_count
                >= thresholds["minimum_distancing_count"]
            ),
        },
        "renaming_count": {
            "actual": renaming_count,
            "threshold": thresholds["minimum_renaming_count"],
            "operator": "greater_than_or_equal",
            "passed": (
                renaming_count >= thresholds["minimum_renaming_count"]
            ),
        },
        "chronological_bands": {
            "actual": passing_bands,
            "threshold": thresholds["minimum_passing_bands"],
            "operator": "greater_than_or_equal",
            "passed": (
                passing_bands >= thresholds["minimum_passing_bands"]
            ),
        },
        "comparison_count": {
            "actual": comparison_count,
            "threshold": thresholds["minimum_comparison_count"],
            "operator": "greater_than_or_equal",
            "passed": (
                comparison_count
                >= thresholds["minimum_comparison_count"]
            ),
        },
        "source_integrity": {
            "actual": len(failures),
            "threshold": 0,
            "operator": "equals",
            "passed": not failures,
        },
    }
    overall_passed = not failures and all(
        test["passed"] for test in tests.values()
    )

    result = {
        "schema_version": 1,
        "validation_id": definition["validation_id"],
        "hypothesis": definition["hypothesis"],
        "status": "passed" if overall_passed else "failed",
        "inputs": {
            "definition": {
                "path": str(args.definition),
                "sha256": sha256(args.definition),
            },
            "review": {
                "path": str(args.review),
                "sha256": sha256(args.review),
            },
            "corpus": {
                "path": str(args.corpus),
                "sha256": actual_hash,
            },
        },
        "population": {
            "candidate_count": len(records),
            "canonical_support_excluded": len(canonical_support),
            "canonical_comparison_excluded": len(canonical_comparison),
            "rejected_excluded": len(rejected),
            "holdout_count": len(holdout),
        },
        "results": {
            "core_count": len(core),
            "core_rate": core_rate,
            "core_rate_wilson_95": {
                "low": interval_low,
                "high": interval_high,
            },
            "distancing_count": distancing_count,
            "renaming_count": renaming_count,
            "comparison_count": comparison_count,
            "passing_band_count": passing_bands,
            "bands": band_results,
            "post_2021_core_count": sum(
                record["year"] > 2021 for record in core.values()
            ),
        },
        "tests": tests,
        "failures": failures,
        "holdout_source_ids": sorted(holdout),
        "core_source_ids": sorted(core),
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(result, indent=2) + "\n",
        encoding="utf-8",
    )

    print("Quoted-Language Validation")
    print(f"Candidates:  {len(records)}")
    print(f"Holdout:     {len(holdout)}")
    print(f"Core:        {len(core)} ({core_rate:.2%})")
    print(
        "Wilson 95%:  "
        f"{interval_low:.2%} to {interval_high:.2%}"
    )
    print(f"Distancing:  {distancing_count}")
    print(f"Renaming:    {renaming_count}")
    print(f"Comparisons: {comparison_count}")
    print(f"Bands:       {passing_bands}")
    print(f"Result:      {'PASS' if overall_passed else 'FAIL'}")
    if failures:
        for failure in failures:
            print(f"FAIL {failure}")
    raise SystemExit(0 if overall_passed else 1)


if __name__ == "__main__":
    main()
