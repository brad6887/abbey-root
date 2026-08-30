#!/usr/bin/env python3
"""Regression coverage for Abbey's private plant image review."""
import hashlib
import importlib.util
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("image_review", ROOT / "scripts/abbey_plant_image_review.py")
review = importlib.util.module_from_spec(spec)
spec.loader.exec_module(review)


class ImageReviewTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.plant = self.root / "working/plants/test-plant"
        (self.plant / "photos").mkdir(parents=True)
        (self.plant / "photos/one.jpg").write_bytes(b"source")
        self.facts("  current: photos/one.jpg\n")

    def facts(self, photos):
        (self.plant / "facts.yaml").write_text(
            'name: "A & B <orchid>"\nslug: test-plant\nphotos:\n' + photos)

    def test_absent_original_is_not_inferred_and_featured_fallback_is_explicit(self):
        row = review.collect(self.root, [])[0]
        self.assertIsNone(row["roles"][0]["selected"])
        self.assertEqual(row["roles"][2]["label"], "Featured")
        self.assertIsNone(row["roles"][2]["selected"])
        self.assertEqual(row["roles"][2]["fallback"], "current")

    def test_explicit_roles_and_template_exclusion(self):
        self.facts("  original: photos/one.jpg\n  current: photos/one.jpg\n  hero: photos/one.jpg\n")
        template = self.root / "working/plants/_template"
        template.mkdir()
        (template / "facts.yaml").write_text("not a plant")
        rows = review.collect(self.root, [])
        self.assertEqual(len(rows), 1)
        self.assertTrue(all(r["selected"] for r in rows[0]["roles"]))
        self.assertIsNone(rows[0]["roles"][2]["fallback"])

    def test_invalid_slug_missing_image_and_escape_fail(self):
        for slug in ("../outside", "_template", "/tmp/no"):
            with self.assertRaises(ValueError):
                review.collect(self.root, [slug])
        for path in ("photos/missing.jpg", "../../../outside.jpg"):
            self.facts("  hero: " + path + "\n")
            with self.assertRaises(ValueError):
                review.collect(self.root, [])

    def test_symlink_cannot_read_outside_workspace(self):
        outside = self.root / "outside.jpg"
        outside.write_bytes(b"private")
        (self.plant / "photos/link.jpg").symlink_to(outside)
        self.facts("  hero: photos/link.jpg\n")
        with self.assertRaises(ValueError):
            review.collect(self.root, [])

    def test_candidates_filter_sidecars_and_appledouble(self):
        for name in ("one.xmp", "._one.jpg", "readme.txt"):
            (self.plant / "photos" / name).write_text("not an image")
        row = review.collect(self.root, [], True)[0]
        self.assertEqual(row["candidates"], ["working/plants/test-plant/photos/one.jpg"])

    def test_render_escapes_text_and_source_is_unchanged(self):
        convert = shutil.which("magick") or shutil.which("convert")
        if not convert:
            self.skipTest("ImageMagick unavailable")
        photo = self.plant / "photos/one.jpg"
        subprocess.run([convert, "-size", "20x40", "xc:green", str(photo)], check=True)
        before = hashlib.sha256(photo.read_bytes()).hexdigest()
        output = self.root / ".abbey/review"
        document = review.render(self.root, review.collect(self.root, []), output)
        self.assertIn("A &amp; B &lt;orchid&gt;", document)
        self.assertIn("Fallback to current", document)
        self.assertEqual(before, hashlib.sha256(photo.read_bytes()).hexdigest())
        self.assertEqual(len(list((output / "thumbs").glob("*.jpg"))), 1)
        self.assertEqual(document, review.render(self.root, review.collect(self.root, []), output))

    def test_output_refuses_canonical_path_and_unknown_arguments(self):
        command = ["python3", str(ROOT / "scripts/abbey_plant_image_review.py"), "--root", str(self.root)]
        result = subprocess.run(command + ["--output", "working/plants"], capture_output=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse((self.plant / "index.html").exists())
        self.assertNotEqual(subprocess.run(command + ["--unknown"], capture_output=True).returncode, 0)


if __name__ == "__main__":
    unittest.main()
