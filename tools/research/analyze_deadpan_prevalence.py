#!/usr/bin/env python3

"""Validate reviewed annotations and calculate deadpan prevalence."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import math
from collections import Counter
from pathlib import Path


PREMISES = {
    "absurd_humorous",
    "other_humor",
    "non_humor",
    "unclear",
}
DELIVERIES = {
    "deadpan",
    "overt_or_explanatory",
    "mixed",
    "unclear",
    "not_applicable",
}
CONFIDENCE = {"high", "medium", "low"}


def wilson_interval(successes: int, total: int) -> tuple[float, float]:
    if total == 0:
        return 0.0, 0.0
    z = 1.959963984540054
    proportion = successes / total
    denominator = 1 + z * z / total
    centre = proportion + z * z / (2 * total)
    margin = z * math.sqrt(
        proportion * (1 - proportion) / total
        + z * z / (4 * total * total)
    )
    return (
        (centre - margin) / denominator,
        (centre + margin) / denominator,
    )


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def analyze(
    sample_path: Path,
    sample_manifest_path: Path,
    annotation_paths: list[Path],
    overrides_path: Path,
    output_path: Path,
    report_path: Path,
    threshold: float,
) -> dict:
    sample = read_csv(sample_path)
    sample_manifest = json.loads(
        sample_manifest_path.read_text(encoding="utf-8")
    )
    actual_sample_hash = hashlib.sha256(sample_path.read_bytes()).hexdigest()
    if sample_manifest["sample_sha256"] != actual_sample_hash:
        raise ValueError("sample fingerprint does not match manifest")

    annotations = []
    for path in annotation_paths:
        annotations.extend(read_csv(path))
    sample_ids = [row["source_id"] for row in sample]
    annotation_ids = [row["source_id"] for row in annotations]
    if annotation_ids != sample_ids:
        raise ValueError(
            "annotation identifiers do not exactly match sample order"
        )

    overrides = json.loads(overrides_path.read_text(encoding="utf-8"))
    unknown_overrides = set(overrides).difference(sample_ids)
    if unknown_overrides:
        raise ValueError(
            "override identifiers absent from sample: "
            + ", ".join(sorted(unknown_overrides))
        )

    sample_by_id = {row["source_id"]: row for row in sample}
    final_rows = []
    for annotation in annotations:
        source_id = annotation["source_id"]
        final = {**annotation, **overrides.get(source_id, {})}
        if final["premise"] not in PREMISES:
            raise ValueError(f"invalid premise for {source_id}")
        if final["delivery"] not in DELIVERIES:
            raise ValueError(f"invalid delivery for {source_id}")
        if final["confidence"] not in CONFIDENCE:
            raise ValueError(f"invalid confidence for {source_id}")
        if (
            final["premise"] == "absurd_humorous"
            and final["delivery"] == "not_applicable"
        ):
            raise ValueError(
                f"absurd premise lacks delivery label: {source_id}"
            )
        if (
            final["premise"] != "absurd_humorous"
            and final["delivery"] != "not_applicable"
        ):
            raise ValueError(
                f"non-absurd premise has delivery label: {source_id}"
            )
        source = sample_by_id[source_id]
        final_rows.append(
            {
                "stratum": source["stratum"],
                "source_id": source_id,
                "datetime": source["datetime"],
                "text": source["text"],
                "premise": final["premise"],
                "delivery": final["delivery"],
                "confidence": final["confidence"],
                "note": final["note"],
            }
        )

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=list(final_rows[0]),
        )
        writer.writeheader()
        writer.writerows(final_rows)

    premise_counts = Counter(row["premise"] for row in final_rows)
    delivery_counts = Counter(row["delivery"] for row in final_rows)
    total = len(final_rows)
    absurd = premise_counts["absurd_humorous"]
    deadpan = delivery_counts["deadpan"]
    overall_interval = wilson_interval(deadpan, total)
    conditional_interval = wilson_interval(deadpan, absurd)
    result = {
        "method": "human-reviewed-stratified-sample",
        "sample_sha256": actual_sample_hash,
        "annotation_sha256": hashlib.sha256(
            output_path.read_bytes()
        ).hexdigest(),
        "sample_size": total,
        "premise_counts": dict(sorted(premise_counts.items())),
        "delivery_counts": dict(sorted(delivery_counts.items())),
        "deadpan_posts": deadpan,
        "overall_rate": deadpan / total,
        "overall_wilson_95": list(overall_interval),
        "absurd_premise_posts": absurd,
        "conditional_rate": deadpan / absurd if absurd else 0.0,
        "conditional_wilson_95": list(conditional_interval),
        "frequently_threshold_lower_bound": threshold,
        "frequently_supported": conditional_interval[0] >= threshold,
    }
    report_path.write_text(
        json.dumps(result, indent=2) + "\n",
        encoding="utf-8",
    )
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--sample", type=Path, required=True)
    parser.add_argument("--sample-manifest", type=Path, required=True)
    parser.add_argument(
        "--annotations",
        type=Path,
        action="append",
        required=True,
    )
    parser.add_argument("--overrides", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--report", type=Path, required=True)
    parser.add_argument("--threshold", type=float, default=0.20)
    args = parser.parse_args()
    result = analyze(
        args.sample,
        args.sample_manifest,
        args.annotations,
        args.overrides,
        args.output,
        args.report,
        args.threshold,
    )
    print("Deadpan Prevalence")
    print("==================")
    print(f"Sample:           {result['sample_size']}")
    print(f"Absurd premises:  {result['absurd_premise_posts']}")
    print(f"Deadpan:          {result['deadpan_posts']}")
    print(f"Overall rate:     {result['overall_rate']:.2%}")
    print(f"Conditional rate: {result['conditional_rate']:.2%}")
    lower, upper = result["conditional_wilson_95"]
    print(f"Conditional 95%:  {lower:.2%} to {upper:.2%}")
    print(
        "Frequently:       "
        + ("SUPPORTED" if result["frequently_supported"] else "NOT SUPPORTED")
    )


if __name__ == "__main__":
    main()
