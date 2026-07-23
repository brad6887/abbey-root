#!/usr/bin/env python3

"""Validate a batch observation-discovery manifest."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import re
from pathlib import Path
from typing import Any


SOURCE_ID_PATTERN = re.compile(r"^FB-\d{6}$")
BATCH_ID_PATTERN = re.compile(r"^batch-\d{3}$")
CANDIDATE_ID_PATTERN = re.compile(r"^B\d{3}-C\d{2}$")
BATCH_SOURCE_PATTERN = re.compile(r"\[(FB-\d{6})\]")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


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

        corpus: dict[str, str] = {}
        for row in reader:
            source_id = f"FB-{int(row['source_id']):06d}"
            if source_id in corpus:
                raise ValueError(f"duplicate corpus source ID: {source_id}")
            corpus[source_id] = row["text"]
        return corpus


def require_string(value: Any, field: str, failures: list[str]) -> str:
    if not isinstance(value, str) or not value.strip():
        failures.append(f"{field} must be a non-empty string")
        return ""
    return value


def validate(
    manifest: Any,
    corpus_path: Path,
    batch_path: Path,
) -> tuple[list[str], int, int]:
    failures: list[str] = []
    citation_count = 0

    if not isinstance(manifest, dict):
        return ["manifest root must be an object"], 0, 0

    if manifest.get("schema_version") != 1:
        failures.append("schema_version must equal 1")

    batch_id = require_string(
        manifest.get("batch_id"), "batch_id", failures
    )
    if batch_id and not BATCH_ID_PATTERN.fullmatch(batch_id):
        failures.append("batch_id must match batch-000")

    if manifest.get("status") != "candidate_discovery_human_review_required":
        failures.append(
            "status must equal candidate_discovery_human_review_required"
        )

    corpus_metadata = manifest.get("corpus")
    if not isinstance(corpus_metadata, dict):
        failures.append("corpus must be an object")
    else:
        require_string(
            corpus_metadata.get("artifact_id"),
            "corpus.artifact_id",
            failures,
        )
        expected_hash = require_string(
            corpus_metadata.get("sha256"),
            "corpus.sha256",
            failures,
        )
        actual_hash = sha256(corpus_path)
        if expected_hash and expected_hash != actual_hash:
            failures.append(
                "corpus.sha256 does not match supplied corpus: "
                f"expected {expected_hash}, actual {actual_hash}"
            )

    require_string(manifest.get("model"), "model", failures)
    require_string(manifest.get("prompt"), "prompt", failures)

    try:
        corpus = load_corpus(corpus_path)
        batch_ids = set(
            BATCH_SOURCE_PATTERN.findall(
                batch_path.read_text(encoding="utf-8")
            )
        )
    except (OSError, ValueError) as exc:
        failures.append(str(exc))
        return failures, 0, 0

    candidates = manifest.get("candidates")
    if not isinstance(candidates, list) or not candidates:
        failures.append("candidates must be a non-empty array")
        return failures, 0, 0
    if len(candidates) > 6:
        failures.append("candidates must contain no more than 6 items")

    seen_candidate_ids: set[str] = set()
    for index, candidate in enumerate(candidates):
        prefix = f"candidates[{index}]"
        if not isinstance(candidate, dict):
            failures.append(f"{prefix} must be an object")
            continue

        candidate_id = require_string(
            candidate.get("candidate_id"),
            f"{prefix}.candidate_id",
            failures,
        )
        if candidate_id:
            if not CANDIDATE_ID_PATTERN.fullmatch(candidate_id):
                failures.append(
                    f"{prefix}.candidate_id must match B000-C00"
                )
            if batch_id and candidate_id[1:4] != batch_id[-3:]:
                failures.append(
                    f"{prefix}.candidate_id must use the batch number"
                )
            if candidate_id in seen_candidate_ids:
                failures.append(f"duplicate candidate_id: {candidate_id}")
            seen_candidate_ids.add(candidate_id)

        require_string(candidate.get("label"), f"{prefix}.label", failures)
        require_string(
            candidate.get("description"),
            f"{prefix}.description",
            failures,
        )
        require_string(
            candidate.get("scope_note"),
            f"{prefix}.scope_note",
            failures,
        )
        require_string(
            candidate.get("boundary_note"),
            f"{prefix}.boundary_note",
            failures,
        )

        citations = candidate.get("citations")
        if not isinstance(citations, list) or len(citations) < 2:
            failures.append(
                f"{prefix}.citations must contain at least 2 items"
            )
            continue
        if len(citations) > 4:
            failures.append(
                f"{prefix}.citations must contain no more than 4 items"
            )

        seen_sources: set[str] = set()
        for citation_index, citation in enumerate(citations):
            citation_count += 1
            citation_prefix = f"{prefix}.citations[{citation_index}]"
            if not isinstance(citation, dict):
                failures.append(f"{citation_prefix} must be an object")
                continue

            source_id = require_string(
                citation.get("source_id"),
                f"{citation_prefix}.source_id",
                failures,
            )
            text = citation.get("text")
            if not isinstance(text, str) or not text:
                failures.append(
                    f"{citation_prefix}.text must be a non-empty string"
                )

            if not source_id:
                continue
            if not SOURCE_ID_PATTERN.fullmatch(source_id):
                failures.append(
                    f"{citation_prefix}.source_id must match FB-000000"
                )
            if source_id in seen_sources:
                failures.append(
                    f"{prefix} contains duplicate citation: {source_id}"
                )
            seen_sources.add(source_id)
            if source_id not in batch_ids:
                failures.append(
                    f"{citation_prefix} source is not in supplied batch: "
                    f"{source_id}"
                )
            corpus_text = corpus.get(source_id)
            if corpus_text is None:
                failures.append(
                    f"{citation_prefix} source ID not found: {source_id}"
                )
            elif isinstance(text, str) and text != corpus_text:
                failures.append(
                    f"{citation_prefix} text does not exactly match "
                    f"corpus source {source_id}"
                )

    return failures, len(candidates), citation_count


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Validate a batch observation-discovery manifest."
    )
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--corpus", type=Path, required=True)
    parser.add_argument("--batch", type=Path, required=True)
    args = parser.parse_args()

    try:
        manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
    except OSError as exc:
        raise SystemExit(f"Unable to read manifest: {exc}") from exc
    except json.JSONDecodeError as exc:
        raise SystemExit(f"Invalid manifest JSON: {exc}") from exc

    failures, candidate_count, citation_count = validate(
        manifest, args.corpus, args.batch
    )

    print("========================================")
    print(" Abbey Research Discovery Validation")
    print("========================================")
    print()
    print(f"Manifest: {args.manifest}")
    print(f"Corpus:   {args.corpus}")
    print(f"Batch:    {args.batch}")
    print()

    if failures:
        for failure in failures:
            print(f"FAIL {failure}")
        print()
        print("Result: FAIL")
        raise SystemExit(1)

    print("OK   Manifest structure is valid")
    print("OK   Corpus fingerprint matches")
    print("OK   Candidate identifiers are unique")
    print("OK   Citation sources belong to the supplied batch")
    print("OK   Citation text matches the corpus exactly")
    print(f"INFO Candidates: {candidate_count}")
    print(f"INFO Citations:  {citation_count}")
    print()
    print("Result: PASS")


if __name__ == "__main__":
    main()
