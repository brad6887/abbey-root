#!/usr/bin/env python3

from __future__ import annotations

import importlib.util
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def load_module(name: str, path: str):
    module_path = ROOT / path
    spec = importlib.util.spec_from_file_location(name, module_path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load module: {module_path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


sampler = load_module(
    "sample_voice_prevalence",
    "tools/research/sample_voice_prevalence.py",
)
analyzer = load_module(
    "analyze_deadpan_prevalence",
    "tools/research/analyze_deadpan_prevalence.py",
)


class PrevalenceResearchTests(unittest.TestCase):
    def test_selection_key_is_deterministic(self):
        first = sampler.selection_key("seed", "1")
        second = sampler.selection_key("seed", "1")
        self.assertEqual(first, second)

    def test_selection_key_changes_with_seed(self):
        first = sampler.selection_key("seed-a", "1")
        second = sampler.selection_key("seed-b", "1")
        self.assertNotEqual(first, second)

    def test_wilson_interval_matches_prevalence_result(self):
        lower, upper = analyzer.wilson_interval(11, 16)
        self.assertAlmostEqual(lower, 0.4440435583)
        self.assertAlmostEqual(upper, 0.8583535615)

    def test_wilson_interval_handles_empty_denominator(self):
        self.assertEqual(
            analyzer.wilson_interval(0, 0),
            (0.0, 0.0),
        )


if __name__ == "__main__":
    unittest.main()
