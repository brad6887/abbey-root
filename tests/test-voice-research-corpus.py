#!/usr/bin/env python3

from __future__ import annotations

import csv
import importlib.util
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def load_module(name: str, relative_path: str):
    path = ROOT / relative_path
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load module: {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


eligibility = load_module(
    "build_voice_eligible_corpus",
    "tools/research/build_voice_eligible_corpus.py",
)
batching = load_module(
    "batch_voice_corpus",
    "tools/research/batch_voice_corpus.py",
)


class EligibilityTests(unittest.TestCase):
    def test_foursquare_checkin_is_excluded(self):
        result = eligibility.classify(
            "I'm at Example Place http://4sq.com/example"
        )
        self.assertEqual(result, ("excluded", "automated_checkin", []))

    def test_tco_checkin_is_excluded(self):
        result = eligibility.classify(
            "I'm at Example Place http://t.co/example"
        )
        self.assertEqual(result, ("excluded", "automated_checkin", []))

    def test_foursquare_mayor_template_is_excluded(self):
        result = eligibility.classify(
            "I just ousted Sam as mayor on @foursquare! "
            "http://4sq.com/example"
        )
        self.assertEqual(result, ("excluded", "automated_checkin", []))

    def test_link_only_record_is_excluded(self):
        result = eligibility.classify("https://example.com/post")
        self.assertEqual(result, ("excluded", "link_only", []))

    def test_mobile_upload_location_metadata_is_excluded(self):
        result = eligibility.classify(
            "Mobile uploads Place: Example Cafe (32.0, -97.0) "
            "Address: 123 Main St"
        )
        self.assertEqual(result, ("excluded", "location_metadata", []))

    def test_authored_mobile_upload_reference_remains_eligible(self):
        result = eligibility.classify(
            "My mobile uploads finally found the right place."
        )
        self.assertEqual(
            result,
            ("eligible", "authored_voice_candidate", []),
        )

    def test_facebook_mention_token_requires_review(self):
        result = eligibility.classify(
            "Hello @[12345:2048:Example Person]"
        )
        self.assertEqual(result, ("review", "facebook_mention_token", []))

    def test_quiz_template_requires_review(self):
        result = eligibility.classify(
            'Took the "Example" quiz. Result is: Brad.'
        )
        self.assertEqual(result, ("review", "application_quiz_template", []))

    def test_status_prompt_completion_is_flagged(self):
        result = eligibility.classify("wonders where the coffee went.")
        self.assertEqual(
            result,
            (
                "eligible",
                "authored_voice_candidate",
                ["facebook_status_prompt_completion"],
            ),
        )

    def test_authored_link_comment_remains_eligible(self):
        result = eligibility.classify(
            "Like a Boss. https://example.com/video"
        )
        self.assertEqual(
            result,
            ("eligible", "authored_voice_candidate", []),
        )


class BatchingTests(unittest.TestCase):
    def write_fixture(self, path: Path) -> None:
        fields = [
            "source_id",
            "datetime",
            "text",
            "research_status",
            "platform_context",
        ]
        rows = [
            {
                "source_id": "3",
                "datetime": "2011-01-01T00:00:00",
                "text": "third",
                "research_status": "eligible",
                "platform_context": "",
            },
            {
                "source_id": "1",
                "datetime": "2009-01-01T00:00:00",
                "text": "first",
                "research_status": "eligible",
                "platform_context": "",
            },
            {
                "source_id": "2",
                "datetime": "2010-01-01T00:00:00",
                "text": "flagged",
                "research_status": "eligible",
                "platform_context": "facebook_status_prompt_completion",
            },
            {
                "source_id": "4",
                "datetime": "2012-01-01T00:00:00",
                "text": "review",
                "research_status": "review",
                "platform_context": "",
            },
        ]
        with path.open("w", encoding="utf-8", newline="") as handle:
            writer = csv.DictWriter(handle, fieldnames=fields)
            writer.writeheader()
            writer.writerows(rows)

    def test_batches_are_chronological_and_exclude_context(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            corpus = root / "corpus.csv"
            output = root / "batches"
            self.write_fixture(corpus)

            manifest = batching.create_batches(
                corpus=corpus,
                output_dir=output,
                batch_size=1,
                include_platform_context=False,
            )

            self.assertEqual(manifest["eligible_posts"], 2)
            self.assertEqual(manifest["batch_count"], 2)
            first = (output / "batch-001.md").read_text(encoding="utf-8")
            second = (output / "batch-002.md").read_text(encoding="utf-8")
            self.assertIn("FB-000001", first)
            self.assertIn("FB-000003", second)
            self.assertNotIn("flagged", first + second)


if __name__ == "__main__":
    unittest.main()
