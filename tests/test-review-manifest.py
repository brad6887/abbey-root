#!/usr/bin/env python3

from __future__ import annotations

import csv
import hashlib
import importlib.util
import json
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MODULE_PATH = (
    ROOT / "tools/research/validate_review_manifest.py"
)
SPEC = importlib.util.spec_from_file_location(
    "validate_review_manifest",
    MODULE_PATH,
)
if SPEC is None or SPEC.loader is None:
    raise RuntimeError(f"cannot load module: {MODULE_PATH}")
validator = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(validator)


class ReviewManifestTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.corpus = self.root / "corpus.csv"
        with self.corpus.open(
            "w",
            encoding="utf-8",
            newline="",
        ) as handle:
            writer = csv.DictWriter(
                handle,
                fieldnames=["source_id", "text"],
            )
            writer.writeheader()
            writer.writerow(
                {
                    "source_id": "1",
                    "text": "Complete exact source text.",
                }
            )

    def tearDown(self):
        self.temporary.cleanup()

    def manifest(self):
        return {
            "schema_version": 1,
            "review_id": "REVIEW-TEST",
            "evidence_artifact": "EVID-TEST",
            "review_scope": "canonical_evidence_selection",
            "corpus": {
                "artifact_id": "CORPUS-TEST",
                "path": str(self.corpus),
                "sha256": hashlib.sha256(
                    self.corpus.read_bytes()
                ).hexdigest(),
            },
            "method": {
                "model": "test-model",
                "prompt": "test-prompt.md",
                "reviewer": "Test Reviewer",
                "review_date": "2026-07-23",
            },
            "items": [
                {
                    "review_item_id": "ITEM-001",
                    "evidence_role": "supporting",
                    "decision": "retain",
                    "note": "Verified test citation.",
                    "citations": [
                        {
                            "source_id": "FB-000001",
                            "text": "Complete exact source text.",
                        }
                    ],
                }
            ],
        }

    def validate(self, manifest):
        return validator.validate_manifest(
            manifest,
            self.corpus,
        )

    def test_valid_manifest_passes(self):
        self.assertEqual(self.validate(self.manifest()), [])

    def test_wrong_text_fails_exact_match(self):
        manifest = self.manifest()
        manifest["items"][0]["citations"][0]["text"] = (
            "Plausible but incorrect text."
        )
        failures = self.validate(manifest)
        self.assertTrue(
            any("does not exactly match" in item for item in failures)
        )

    def test_missing_source_id_fails(self):
        manifest = self.manifest()
        manifest["items"][0]["citations"][0]["source_id"] = (
            "FB-999999"
        )
        failures = self.validate(manifest)
        self.assertTrue(
            any("source ID not found" in item for item in failures)
        )

    def test_wrong_corpus_fingerprint_fails(self):
        manifest = self.manifest()
        manifest["corpus"]["sha256"] = "0" * 64
        failures = self.validate(manifest)
        self.assertTrue(
            any("does not match supplied corpus" in item for item in failures)
        )

    def test_duplicate_review_item_id_fails(self):
        manifest = self.manifest()
        manifest["items"].append(
            json.loads(json.dumps(manifest["items"][0]))
        )
        failures = self.validate(manifest)
        self.assertIn(
            "duplicate review_item_id: ITEM-001",
            failures,
        )

    def test_invalid_decision_fails(self):
        manifest = self.manifest()
        manifest["items"][0]["decision"] = "maybe"
        failures = self.validate(manifest)
        self.assertTrue(
            any(".decision must be one of" in item for item in failures)
        )

    def test_invalid_review_scope_fails(self):
        manifest = self.manifest()
        manifest["review_scope"] = "everything"
        failures = self.validate(manifest)
        self.assertTrue(
            any(
                "review_scope must be one of" in item
                for item in failures
            )
        )

    def test_empty_citations_fail(self):
        manifest = self.manifest()
        manifest["items"][0]["citations"] = []
        failures = self.validate(manifest)
        self.assertTrue(
            any(
                ".citations must be a non-empty array" in item
                for item in failures
            )
        )


if __name__ == "__main__":
    unittest.main()
