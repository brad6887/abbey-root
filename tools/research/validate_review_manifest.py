#!/usr/bin/env python3

"""Validate a machine-readable research review manifest against a corpus."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import re
from pathlib import Path
from typing import Any


SOURCE_ID_PATTERN = re.compile(r"^FB-\d{6}$")
DECISIONS = {"retain", "provisional", "reject"}
EVIDENCE_ROLES = {
    "supporting",
    "contradictory",
    "comparison",
}
REVIEW_SCOPES = {
    "canonical_evidence_selection",
    "complete_candidate_review",
}


def corpus_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_corpus(path: Path) -> dict[str, str]:
    with path.open(encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames is None:
            raise ValueError(f"corpus has no CSV header: {path}")
        required = {"source_id", "text"}
        missing = required.difference(reader.fieldnames)
        if missing:
            fields = ", ".join(sorted(missing))
            raise ValueError(f"corpus is missing required fields: {fields}")

        corpus: dict[str, str] = {}
        for row in reader:
            source_id = f"FB-{int(row['source_id']):06d}"
            if source_id in corpus:
                raise ValueError(f"duplicate corpus source ID: {source_id}")
            corpus[source_id] = row["text"]
        return corpus


def require_string(
    value: Any,
    field: str,
    failures: list[str],
) -> str:
    if not isinstance(value, str) or not value:
        failures.append(f"{field} must be a non-empty string")
        return ""
    return value


def validate_manifest(
    manifest: Any,
    corpus_path: Path,
) -> list[str]:
    failures: list[str] = []

    if not isinstance(manifest, dict):
        return ["manifest root must be an object"]

    if manifest.get("schema_version") != 1:
        failures.append("schema_version must equal 1")

    require_string(manifest.get("review_id"), "review_id", failures)
    require_string(
        manifest.get("evidence_artifact"),
        "evidence_artifact",
        failures,
    )
    if manifest.get("review_scope") not in REVIEW_SCOPES:
        failures.append(
            "review_scope must be one of: "
            + ", ".join(sorted(REVIEW_SCOPES))
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
        require_string(
            corpus_metadata.get("path"),
            "corpus.path",
            failures,
        )
        expected_hash = require_string(
            corpus_metadata.get("sha256"),
            "corpus.sha256",
            failures,
        )
        actual_hash = corpus_sha256(corpus_path)
        if expected_hash and expected_hash != actual_hash:
            failures.append(
                "corpus.sha256 does not match supplied corpus: "
                f"expected {expected_hash}, actual {actual_hash}"
            )

    method = manifest.get("method")
    if not isinstance(method, dict):
        failures.append("method must be an object")
    else:
        for field in (
            "model",
            "prompt",
            "reviewer",
            "review_date",
        ):
            require_string(
                method.get(field),
                f"method.{field}",
                failures,
            )

    items = manifest.get("items")
    if not isinstance(items, list) or not items:
        failures.append("items must be a non-empty array")
        return failures

    try:
        corpus = load_corpus(corpus_path)
    except (OSError, ValueError) as exc:
        failures.append(str(exc))
        return failures

    seen_item_ids: set[str] = set()
    for index, item in enumerate(items):
        prefix = f"items[{index}]"
        if not isinstance(item, dict):
            failures.append(f"{prefix} must be an object")
            continue

        item_id = require_string(
            item.get("review_item_id"),
            f"{prefix}.review_item_id",
            failures,
        )
        if item_id:
            if item_id in seen_item_ids:
                failures.append(f"duplicate review_item_id: {item_id}")
            seen_item_ids.add(item_id)

        decision = item.get("decision")
        if decision not in DECISIONS:
            failures.append(
                f"{prefix}.decision must be one of: "
                + ", ".join(sorted(DECISIONS))
            )

        evidence_role = item.get("evidence_role")
        if evidence_role not in EVIDENCE_ROLES:
            failures.append(
                f"{prefix}.evidence_role must be one of: "
                + ", ".join(sorted(EVIDENCE_ROLES))
            )

        require_string(item.get("note"), f"{prefix}.note", failures)

        citations = item.get("citations")
        if not isinstance(citations, list) or not citations:
            failures.append(
                f"{prefix}.citations must be a non-empty array"
            )
            continue

        seen_citations: set[str] = set()
        for citation_index, citation in enumerate(citations):
            citation_prefix = (
                f"{prefix}.citations[{citation_index}]"
            )
            if not isinstance(citation, dict):
                failures.append(
                    f"{citation_prefix} must be an object"
                )
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

            if source_id:
                if not SOURCE_ID_PATTERN.fullmatch(source_id):
                    failures.append(
                        f"{citation_prefix}.source_id must match "
                        "FB-000000"
                    )
                if source_id in seen_citations:
                    failures.append(
                        f"{prefix} contains duplicate citation: "
                        f"{source_id}"
                    )
                seen_citations.add(source_id)

                source_text = corpus.get(source_id)
                if source_text is None:
                    failures.append(
                        f"{citation_prefix} source ID not found: "
                        f"{source_id}"
                    )
                elif isinstance(text, str) and text != source_text:
                    failures.append(
                        f"{citation_prefix} text does not exactly match "
                        f"corpus source {source_id}"
                    )

    return failures


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "Validate a research review manifest and exact citations."
        )
    )
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--corpus", type=Path, required=True)
    args = parser.parse_args()

    try:
        manifest = json.loads(
            args.manifest.read_text(encoding="utf-8")
        )
    except OSError as exc:
        raise SystemExit(f"Unable to read manifest: {exc}") from exc
    except json.JSONDecodeError as exc:
        raise SystemExit(f"Invalid manifest JSON: {exc}") from exc

    failures = validate_manifest(manifest, args.corpus)

    print("========================================")
    print(" Abbey Research Review Validation")
    print("========================================")
    print()
    print(f"Manifest: {args.manifest}")
    print(f"Corpus:   {args.corpus}")
    print()

    if failures:
        print("Failures")
        print("--------")
        for failure in failures:
            print(f"FAIL {failure}")
        print()
        print("Result: FAIL")
        raise SystemExit(1)

    citation_count = sum(
        len(item["citations"])
        for item in manifest["items"]
    )
    print("Checks")
    print("------")
    print("OK   Manifest structure is valid")
    print("OK   Corpus fingerprint matches")
    print("OK   Review decisions and roles are valid")
    print("OK   Review item identifiers are unique")
    print("OK   Citation identifiers resolve")
    print("OK   Citation text matches exactly")
    print()
    print(f"Review items: {len(manifest['items'])}")
    print(f"Citations:    {citation_count}")
    print()
    print("Result: PASS")


if __name__ == "__main__":
    main()
