#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ABBEY_TOOLKIT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY="$ABBEY_TOOLKIT_ROOT/tools/bin/abbey"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

passed=0
failed=0
output=""
status=0
pass() { printf 'PASS %s\n' "$1"; passed=$((passed + 1)); }
fail() { printf 'FAIL %s\n' "$1"; failed=$((failed + 1)); }
assert_contains() { if grep -Fq -- "$2" <<<"$output"; then pass "$1"; else fail "$1"; printf '%s\n' "$output"; fi; }

fake_helper="$test_root/fake-derivative.py"
cat > "$fake_helper" <<'PY'
#!/usr/bin/env python3
import argparse
import hashlib
import json
import shutil
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("source", type=Path)
parser.add_argument("destination", type=Path)
parser.add_argument("--max-edge", type=int, required=True)
parser.add_argument("--quality", type=int, required=True)
args = parser.parse_args()
if args.source.read_text(encoding="utf-8") == "FAIL":
    raise SystemExit("controlled derivative failure")
args.destination.parent.mkdir(parents=True, exist_ok=True)
shutil.copyfile(args.source, args.destination)
digest = hashlib.sha256(args.destination.read_bytes()).hexdigest()
print(json.dumps({
    "source": {"path": str(args.source), "sha256": digest, "canonical_original_preserved": True},
    "derivative": {"path": str(args.destination), "sha256": digest, "format": args.destination.suffix.lstrip("."), "width": 1200, "height": 800},
    "transformation": {"auto_orient": True, "maximum_edge": args.max_edge, "colorspace": "sRGB", "metadata_removed": True, "quality": args.quality},
    "validation": {"private_metadata_detected": False, "source_hash_unchanged": True},
    "tools": {"imagemagick": "fixture", "exiftool": "fixture"},
}, sort_keys=True))
PY
chmod +x "$fake_helper"

create_project() {
  local slug="$1" name="$2"
  local root="$test_root/$slug"
  mkdir -p "$root/.abbey" "$root/media/prepared"
  cat > "$root/.abbey/project.yml" <<YAML
schema_version: 1
project:
  name: $name
  slug: $slug
configuration:
  allow_toolkit_defaults: false
YAML
  cat > "$root/.abbey/media.yml" <<'YAML'
schema_version: 1
rename_exports:
  caption_tag: XMP-dc:Description
  date_tag: DateTimeOriginal
  filename_template: "{caption_slug}-{capture_date}{sequence}"
  manifest: .abbey-rename-manifest.json
  extensions: [.jpg]
publish:
  gallery:
    source: media/prepared
    destination: site/public/images/gallery
    intake_manifest: media/prepared/intake.json
    manifest: generated/media/gallery.json
    output_format: jpg
    max_edge: 1600
    quality: 82
YAML
  printf 'prepared image bytes' > "$root/media/prepared/country-loaf-2026-08-08.jpg"
  cat > "$root/media/prepared/intake.json" <<'JSON'
{
  "schema_version": 1,
  "items": [
    {
      "caption": "Country Loaf",
      "capture_date": "2026-08-08",
      "original_image": "IMG_5001.JPG",
      "published_image": "country-loaf-2026-08-08.jpg"
    }
  ]
}
JSON
  (cd "$root" && pwd -P)
}

run_publish() {
  local project="$1"
  shift
  set +e
  output="$(cd "$project" && ABBEY_MEDIA_DERIVATIVE_HELPER="$fake_helper" "$ABBEY" media publish "$@" 2>&1)"
  status=$?
  set -e
}

bread="$(create_project bread-pitt "Bread Pitt")"
source_hash="$(shasum -a 256 "$bread/media/prepared/country-loaf-2026-08-08.jpg" | awk '{print $1}')"
run_publish "$bread" gallery --dry-run
[[ "$status" -eq 0 ]] && pass "Bread Pitt publication dry run succeeds" || fail "Bread Pitt publication dry run succeeds"
assert_contains "preflight reports Bread Pitt" "Active project:       Bread Pitt"
assert_contains "preflight reports the named workflow" "Workflow:             gallery"
assert_contains "preflight reports publication destination" "$bread/site/public/images/gallery"
assert_contains "preflight reports derivative mapping" "country-loaf-2026-08-08.jpg -> country-loaf-2026-08-08.jpg"
[[ ! -e "$bread/site/public/images/gallery/country-loaf-2026-08-08.jpg" ]] && pass "dry run writes no derivative" || fail "dry run writes no derivative"
[[ ! -e "$bread/generated/media/gallery.json" ]] && pass "dry run writes no publication manifest" || fail "dry run writes no publication manifest"

run_publish "$bread" gallery
[[ "$status" -eq 0 ]] && pass "Bread Pitt publication succeeds" || fail "Bread Pitt publication succeeds"
derivative="$bread/site/public/images/gallery/country-loaf-2026-08-08.jpg"
manifest="$bread/generated/media/gallery.json"
[[ -f "$derivative" ]] && pass "public derivative is created" || fail "public derivative is created"
[[ -f "$manifest" ]] && pass "publication manifest is created" || fail "publication manifest is created"
[[ "$(shasum -a 256 "$bread/media/prepared/country-loaf-2026-08-08.jpg" | awk '{print $1}')" == "$source_hash" ]] && pass "prepared source remains unchanged" || fail "prepared source remains unchanged"

if python3 - "$manifest" "$derivative" <<'PY'
import hashlib
import json
import sys
from pathlib import Path

manifest = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
derivative = Path(sys.argv[2])
item = manifest["items"][0]
assert manifest["schema_version"] == 1
assert manifest["project"] == "Bread Pitt"
assert manifest["workflow"] == "gallery"
assert manifest["profile"] == {"maximum_edge": 1600, "metadata_removed": True, "output_format": "jpg", "quality": 82}
assert item["caption"] == "Country Loaf"
assert item["original_image"] == "IMG_5001.JPG"
assert item["prepared_image"] == "country-loaf-2026-08-08.jpg"
assert item["source"]["path"] == "media/prepared/country-loaf-2026-08-08.jpg"
assert item["derivative"]["path"] == "site/public/images/gallery/country-loaf-2026-08-08.jpg"
assert item["derivative"]["sha256"] == hashlib.sha256(derivative.read_bytes()).hexdigest()
assert item["transformation"]["metadata_removed"] is True
assert item["validation"]["private_metadata_detected"] is False
PY
then
  pass "publication manifest records derivative provenance"
else
  fail "publication manifest records derivative provenance"
fi

manifest_hash="$(shasum -a 256 "$manifest" | awk '{print $1}')"
derivative_hash="$(shasum -a 256 "$derivative" | awk '{print $1}')"
run_publish "$bread" gallery
[[ "$status" -eq 0 ]] && pass "unchanged rerun succeeds" || fail "unchanged rerun succeeds"
assert_contains "unchanged rerun reports no changes" "already current; no files changed"
[[ "$(shasum -a 256 "$manifest" | awk '{print $1}')" == "$manifest_hash" ]] && pass "unchanged rerun preserves manifest" || fail "unchanged rerun preserves manifest"
[[ "$(shasum -a 256 "$derivative" | awk '{print $1}')" == "$derivative_hash" ]] && pass "unchanged rerun preserves derivative" || fail "unchanged rerun preserves derivative"

abbey_fixture="$(create_project abbey-fixture "Abbey Fixture")"
run_publish "$abbey_fixture" gallery
[[ "$status" -eq 0 ]] && pass "Abbey-style fixture uses the same publisher" || fail "Abbey-style fixture uses the same publisher"
[[ -f "$abbey_fixture/generated/media/gallery.json" ]] && pass "Abbey-style fixture receives a manifest" || fail "Abbey-style fixture receives a manifest"

unsafe="$(create_project unsafe-project "Unsafe Project")"
python3 - "$unsafe/.abbey/media.yml" <<'PY'
import sys
from pathlib import Path
path = Path(sys.argv[1])
path.write_text(path.read_text(encoding="utf-8").replace("site/public/images/gallery", "../other-project/public"), encoding="utf-8")
PY
run_publish "$unsafe" gallery --dry-run
[[ "$status" -eq 1 ]] && pass "destination outside the project fails closed" || fail "destination outside the project fails closed"
assert_contains "unsafe destination is explained" "escapes the active project"

failure="$(create_project derivative-failure "Derivative Failure")"
printf 'FAIL' > "$failure/media/prepared/country-loaf-2026-08-08.jpg"
mkdir -p "$failure/site/public/images/gallery" "$failure/generated/media"
printf 'existing derivative' > "$failure/site/public/images/gallery/country-loaf-2026-08-08.jpg"
printf 'existing manifest' > "$failure/generated/media/gallery.json"
run_publish "$failure" gallery
[[ "$status" -eq 1 ]] && pass "derivative failure fails publication" || fail "derivative failure fails publication"
[[ "$(cat "$failure/site/public/images/gallery/country-loaf-2026-08-08.jpg")" == "existing derivative" ]] && pass "derivative failure preserves existing public output" || fail "derivative failure preserves existing public output"
[[ "$(cat "$failure/generated/media/gallery.json")" == "existing manifest" ]] && pass "derivative failure preserves existing manifest" || fail "derivative failure preserves existing manifest"

printf '\nPassed: %d\n' "$passed"
printf 'Failed: %d\n' "$failed"
(( failed == 0 ))
