#!/usr/bin/env python3

"""Run and aggregate resumable full-corpus observation discovery."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import subprocess
import sys
from pathlib import Path
from typing import Any

from validate_discovery_manifest import validate


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_json(path: Path) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except OSError as exc:
        raise ValueError(f"unable to read {path}: {exc}") from exc
    except json.JSONDecodeError as exc:
        raise ValueError(f"invalid JSON in {path}: {exc}") from exc


def load_corpus(path: Path) -> dict[str, str]:
    with path.open(encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames is None:
            raise ValueError(f"corpus has no CSV header: {path}")
        required = {"source_id", "text"}
        missing = required.difference(reader.fieldnames)
        if missing:
            raise ValueError(
                "corpus is missing required fields: "
                + ", ".join(sorted(missing))
            )
        return {
            f"FB-{int(row['source_id']):06d}": row["text"]
            for row in reader
        }


def batch_entries(manifest_path: Path) -> list[tuple[str, Path]]:
    manifest = load_json(manifest_path)
    if not isinstance(manifest, dict):
        raise ValueError("batch manifest root must be an object")
    batches = manifest.get("batches")
    if not isinstance(batches, list) or not batches:
        raise ValueError("batch manifest must contain a non-empty batches array")

    entries: list[tuple[str, Path]] = []
    for index, item in enumerate(batches):
        if not isinstance(item, dict):
            raise ValueError(f"batches[{index}] must be an object")
        number = item.get("batch")
        relative_path = item.get("path")
        if not isinstance(number, int) or number < 1:
            raise ValueError(f"batches[{index}].batch must be a positive integer")
        if not isinstance(relative_path, str) or not relative_path:
            raise ValueError(f"batches[{index}].path must be a non-empty string")
        batch_id = f"batch-{number:03d}"
        batch_path = manifest_path.parent / relative_path
        if not batch_path.is_file():
            raise ValueError(f"batch file not found: {batch_path}")
        entries.append((batch_id, batch_path))
    return entries


def hydrate_citations(raw: Any, corpus: dict[str, str]) -> Any:
    if not isinstance(raw, dict):
        raise ValueError("raw discovery result root must be an object")
    candidates = raw.get("candidates")
    if not isinstance(candidates, list):
        raise ValueError("raw discovery result candidates must be an array")

    for candidate_index, candidate in enumerate(candidates):
        if not isinstance(candidate, dict):
            raise ValueError(f"candidates[{candidate_index}] must be an object")
        citations = candidate.get("citations")
        if not isinstance(citations, list):
            raise ValueError(
                f"candidates[{candidate_index}].citations must be an array"
            )
        for citation_index, citation in enumerate(citations):
            if not isinstance(citation, dict):
                raise ValueError(
                    f"candidates[{candidate_index}].citations"
                    f"[{citation_index}] must be an object"
                )
            source_id = citation.get("source_id")
            if not isinstance(source_id, str) or source_id not in corpus:
                raise ValueError(
                    f"citation source ID not found in corpus: {source_id!r}"
                )
            citation["text"] = corpus[source_id]
    return raw


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(value, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )


def valid_result(
    result_path: Path,
    corpus_path: Path,
    batch_path: Path,
) -> tuple[bool, list[str]]:
    if not result_path.is_file():
        return False, ["result does not exist"]
    try:
        result = load_json(result_path)
    except ValueError as exc:
        return False, [str(exc)]
    failures, _, _ = validate(result, corpus_path, batch_path)
    return not failures, failures


def build_outputs(
    results: list[dict[str, Any]],
    corpus_path: Path,
    batch_manifest_path: Path,
    model: str,
    prompt_path: Path,
    output_dir: Path,
) -> None:
    candidates: list[dict[str, Any]] = []
    citation_count = 0
    for result in results:
        batch_id = result["batch_id"]
        for candidate in result["candidates"]:
            citations = candidate["citations"]
            citation_count += len(citations)
            candidates.append(
                {
                    "candidate_id": candidate["candidate_id"],
                    "batch_id": batch_id,
                    "label": candidate["label"],
                    "description": candidate["description"],
                    "scope_note": candidate["scope_note"],
                    "boundary_note": candidate["boundary_note"],
                    "citations": citations,
                }
            )

    index = {
        "schema_version": 1,
        "artifact_type": "observation_discovery_candidate_index",
        "status": "candidate_discovery_human_review_required",
        "corpus": {
            "path": str(corpus_path),
            "sha256": sha256(corpus_path),
        },
        "batch_manifest": {
            "path": str(batch_manifest_path),
            "sha256": sha256(batch_manifest_path),
        },
        "method": {
            "model": model,
            "prompt": str(prompt_path),
            "prompt_sha256": sha256(prompt_path),
        },
        "batch_count": len(results),
        "candidate_count": len(candidates),
        "citation_count": citation_count,
        "candidates": candidates,
    }
    write_json(output_dir / "candidate-index.json", index)

    review = {
        "schema_version": 1,
        "artifact_type": "observation_discovery_review_scaffold",
        "status": "human_review_required",
        "source_candidate_index": "candidate-index.json",
        "instructions": (
            "Cluster related candidates, distinguish voice from topic or "
            "platform convention, relate existing observations, and record "
            "a decision for every candidate. Do not promote automatically."
        ),
        "items": [
            {
                "candidate_id": candidate["candidate_id"],
                "batch_id": candidate["batch_id"],
                "label": candidate["label"],
                "decision": "pending",
                "cluster_id": None,
                "related_artifact": None,
                "review_note": "",
            }
            for candidate in candidates
        ],
    }
    write_json(output_dir / "review-scaffold.json", review)


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run resumable full-corpus observation discovery."
    )
    parser.add_argument("--runner", type=Path, required=True)
    parser.add_argument("--model", required=True)
    parser.add_argument("--prompt", type=Path, required=True)
    parser.add_argument("--corpus", type=Path, required=True)
    parser.add_argument("--batch-manifest", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--max-tokens", type=int, default=6144)
    parser.add_argument("--resume", action="store_true")
    parser.add_argument(
        "--validate-only",
        action="store_true",
        help="Validate and aggregate existing normalized results.",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_arguments()
    for label, path in (
        ("runner", args.runner),
        ("prompt", args.prompt),
        ("corpus", args.corpus),
        ("batch manifest", args.batch_manifest),
    ):
        if not path.is_file():
            raise SystemExit(f"{label} not found: {path}")
    if args.max_tokens < 1:
        raise SystemExit("--max-tokens must be a positive integer")

    try:
        entries = batch_entries(args.batch_manifest)
        corpus = load_corpus(args.corpus)
    except ValueError as exc:
        raise SystemExit(str(exc)) from exc

    raw_dir = args.output_dir / "raw-results"
    result_dir = args.output_dir / "results"
    prompt_dir = args.output_dir / "prompts"
    completed: list[dict[str, Any]] = []

    print("Abbey Observation Discovery")
    print(f"Batches: {len(entries)}")
    print(f"Output:  {args.output_dir}")
    print()

    for batch_id, batch_path in entries:
        result_path = result_dir / f"{batch_id}.json"
        is_valid, prior_failures = valid_result(
            result_path, args.corpus, batch_path
        )
        if is_valid and (args.resume or args.validate_only):
            print(f"SKIP {batch_id}: existing result passes validation")
            completed.append(load_json(result_path))
            continue
        if args.validate_only:
            print(f"FAIL {batch_id}: " + "; ".join(prior_failures))
            raise SystemExit(1)

        rendered_prompt = (
            args.prompt.read_text(encoding="utf-8")
            .replace("BATCH_ID_VALUE", batch_id)
            .replace("CORPUS_SHA256_VALUE", sha256(args.corpus))
            .replace("MODEL_VALUE", args.model)
        )
        prompt_path = prompt_dir / f"{batch_id}.md"
        prompt_path.parent.mkdir(parents=True, exist_ok=True)
        prompt_path.write_text(rendered_prompt, encoding="utf-8")

        raw_path = raw_dir / f"{batch_id}.json"
        command = [
            str(args.runner),
            "run",
            "--model",
            args.model,
            "--prompt",
            str(prompt_path),
            "--input",
            str(batch_path),
            "--output",
            str(raw_path),
            "--max-tokens",
            str(args.max_tokens),
            "--force",
        ]
        print(f"RUN  {batch_id}")
        subprocess.run(command, check=True)

        try:
            normalized = hydrate_citations(load_json(raw_path), corpus)
        except ValueError as exc:
            print(f"FAIL {batch_id}: {exc}", file=sys.stderr)
            raise SystemExit(1) from exc
        write_json(result_path, normalized)

        failures, _, _ = validate(normalized, args.corpus, batch_path)
        if failures:
            for failure in failures:
                print(f"FAIL {batch_id}: {failure}", file=sys.stderr)
            raise SystemExit(1)
        print(f"PASS {batch_id}")
        completed.append(normalized)

    build_outputs(
        completed,
        args.corpus,
        args.batch_manifest,
        args.model,
        args.prompt,
        args.output_dir,
    )
    print()
    print(f"PASS batches:    {len(completed)}")
    print(
        "INFO candidates: "
        f"{sum(len(result['candidates']) for result in completed)}"
    )
    print(f"Review scaffold: {args.output_dir / 'review-scaffold.json'}")


if __name__ == "__main__":
    main()
