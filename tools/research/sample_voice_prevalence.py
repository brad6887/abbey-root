#!/usr/bin/env python3

"""Create a deterministic stratified sample for prevalence annotation."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import math
from pathlib import Path


def selection_key(seed: str, source_id: str) -> str:
    value = f"{seed}:{source_id}".encode("utf-8")
    return hashlib.sha256(value).hexdigest()


def create_sample(
    corpus: Path,
    batch_manifest: Path,
    output: Path,
    sample_rate: float,
    seed: str,
) -> dict:
    manifest = json.loads(batch_manifest.read_text(encoding="utf-8"))
    with corpus.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))

    eligible = [
        row
        for row in rows
        if row["research_status"] == "eligible"
        and not row["platform_context"].strip()
    ]
    eligible.sort(key=lambda row: (row["datetime"], int(row["source_id"])))

    selected = []
    offset = 0
    strata = []
    for batch in manifest["batches"]:
        size = batch["posts"]
        batch_rows = eligible[offset : offset + size]
        offset += size
        count = max(1, math.ceil(size * sample_rate))
        ranked = sorted(
            batch_rows,
            key=lambda row: selection_key(seed, row["source_id"]),
        )
        chosen_ids = {row["source_id"] for row in ranked[:count]}
        chosen = [
            row for row in batch_rows if row["source_id"] in chosen_ids
        ]
        for row in chosen:
            selected.append(
                {
                    "stratum": f"batch-{batch['batch']:03d}",
                    "source_id": f"FB-{int(row['source_id']):06d}",
                    "datetime": row["datetime"],
                    "text": row["text"],
                }
            )
        strata.append(
            {
                "stratum": f"batch-{batch['batch']:03d}",
                "population": size,
                "sample": len(chosen),
            }
        )

    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=["stratum", "source_id", "datetime", "text"],
        )
        writer.writeheader()
        writer.writerows(selected)

    result = {
        "method": "deterministic-stratified-hash-sample",
        "seed": seed,
        "sample_rate": sample_rate,
        "population": len(eligible),
        "sample_size": len(selected),
        "source_sha256": hashlib.sha256(corpus.read_bytes()).hexdigest(),
        "sample_sha256": hashlib.sha256(output.read_bytes()).hexdigest(),
        "strata": strata,
    }
    output.with_suffix(".manifest.json").write_text(
        json.dumps(result, indent=2) + "\n",
        encoding="utf-8",
    )
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--corpus", type=Path, required=True)
    parser.add_argument("--batch-manifest", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--sample-rate", type=float, default=0.10)
    parser.add_argument("--seed", default="deadpan-prevalence-v1")
    args = parser.parse_args()
    if not 0 < args.sample_rate <= 1:
        raise SystemExit("--sample-rate must be greater than 0 and at most 1")
    result = create_sample(
        args.corpus,
        args.batch_manifest,
        args.output,
        args.sample_rate,
        args.seed,
    )
    print("Deadpan Prevalence Sample")
    print("=========================")
    print(f"Population: {result['population']}")
    print(f"Sample:     {result['sample_size']}")
    print(f"SHA-256:   {result['sample_sha256']}")


if __name__ == "__main__":
    main()
