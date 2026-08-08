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

assert_contains() {
  if grep -Fq -- "$2" <<<"$output"; then pass "$1"; else fail "$1"; printf '%s\n' "$output"; fi
}

assert_not_contains() {
  if grep -Fq -- "$2" <<<"$output"; then fail "$1"; printf '%s\n' "$output"; else pass "$1"; fi
}

create_project() {
  local root="$test_root/$1"
  mkdir -p "$root/.abbey"
  cat > "$root/.abbey/project.yml" <<YAML
schema_version: 1
project:
  name: $2
  slug: $1
configuration:
  allow_toolkit_defaults: false
YAML
  cat > "$root/.abbey/media.yml" <<'YAML'
schema_version: 1
rename_exports:
  caption_tag: XMP-dc:Description
  date_tag: DateTimeOriginal
  filename_template: "{caption_slug}-{capture_date}{sequence}"
  manifest: bread-publishing-manifest.json
  extensions:
    - .jpg
YAML
  (cd "$root" && pwd -P)
}

mkdir -p "$test_root/bin"
cat > "$test_root/bin/exiftool" <<'SCRIPT'
#!/usr/bin/env bash
tag="$2"
file="${3##*/}"
case "$tag:$file" in
  -XMP-dc:Description:IMG_5001.xmp) echo "Country Loaf" ;;
  -DateTimeOriginal:IMG_5001.JPG) echo "2026:08:08 06:30:00" ;;
esac
SCRIPT
chmod +x "$test_root/bin/exiftool"

run_media() {
  local project="$1"
  shift
  set +e
  output="$(cd "$project" && PATH="$test_root/bin:$PATH" "$ABBEY" media rename-exports "$@" 2>&1)"
  status=$?
  set -e
}

project="$(create_project bread-pitt "Bread Pitt")"
exports="$test_root/bread-exports"
mkdir -p "$exports"
exports="$(cd "$exports" && pwd -P)"
touch "$exports/IMG_5001.JPG" "$exports/IMG_5001.xmp"

run_media "$project" "$exports" --dry-run
[[ "$status" -eq 0 ]] && pass "Bread Pitt dry run succeeds" || fail "Bread Pitt dry run succeeds"
assert_contains "preflight reports Bread Pitt" "Active project:       Bread Pitt"
assert_contains "preflight reports local media configuration" "Configuration:        $project/.abbey/media.yml"
assert_contains "preflight reports active-project source" "Configuration source: active project"
assert_contains "caption produces a generic filename" "IMG_5001.JPG -> country-loaf-2026-08-08.jpg"
assert_contains "configured manifest is reported" "Manifest:             $exports/bread-publishing-manifest.json"
[[ ! -e "$exports/bread-publishing-manifest.json" ]] && pass "dry run writes no manifest" || fail "dry run writes no manifest"
[[ -f "$exports/IMG_5001.JPG" ]] && pass "dry run preserves the source image" || fail "dry run preserves the source image"

run_media "$project" "$exports"
[[ "$status" -eq 0 ]] && pass "Bread Pitt rename succeeds" || fail "Bread Pitt rename succeeds"
[[ -f "$exports/country-loaf-2026-08-08.jpg" ]] && pass "renamed bread image exists" || fail "renamed bread image exists"
[[ -f "$exports/country-loaf-2026-08-08.xmp" ]] && pass "renamed bread sidecar exists" || fail "renamed bread sidecar exists"
[[ -f "$exports/bread-publishing-manifest.json" ]] && pass "publishing manifest exists" || fail "publishing manifest exists"

if python3 - "$exports/bread-publishing-manifest.json" <<'PY'
import json
import sys
from pathlib import Path

manifest = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
item = manifest["items"][0]
assert manifest["schema_version"] == 1
assert manifest["project"] == "Bread Pitt"
assert manifest["configuration_source"] == "active project"
assert item["caption"] == "Country Loaf"
assert item["original_image"] == "IMG_5001.JPG"
assert item["published_image"] == "country-loaf-2026-08-08.jpg"
assert item["original_sidecar"] == "IMG_5001.xmp"
assert item["published_sidecar"] == "country-loaf-2026-08-08.xmp"
PY
then
  pass "manifest records the original-to-published mapping"
else
  fail "manifest records the original-to-published mapping"
fi

isolated="$(create_project isolated-project "Isolated Project")"
rm "$isolated/.abbey/media.yml"
isolated_exports="$test_root/isolated-exports"
mkdir -p "$isolated_exports"
touch "$isolated_exports/IMG_5001.JPG" "$isolated_exports/IMG_5001.xmp"
run_media "$isolated" "$isolated_exports" --dry-run
[[ "$status" -eq 1 ]] && pass "missing project media configuration fails closed" || fail "missing project media configuration fails closed"
assert_contains "missing media configuration identifies the active project" "$isolated/.abbey/media.yml"
assert_not_contains "isolated project does not inherit Abbey Root media configuration" "$ABBEY_TOOLKIT_ROOT/.abbey/media.yml"

fallback="$(create_project fallback-project "Fallback Project")"
rm "$fallback/.abbey/media.yml"
python3 - "$fallback/.abbey/project.yml" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
path.write_text(
    path.read_text(encoding="utf-8").replace(
        "allow_toolkit_defaults: false",
        "allow_toolkit_defaults: true",
    ),
    encoding="utf-8",
)
PY
fallback_exports="$test_root/fallback-exports"
mkdir -p "$fallback_exports"
touch "$fallback_exports/IMG_5001.JPG" "$fallback_exports/IMG_5001.xmp"
run_media "$fallback" "$fallback_exports" --dry-run
[[ "$status" -eq 0 ]] && pass "explicit toolkit media fallback succeeds" || fail "explicit toolkit media fallback succeeds"
assert_contains "toolkit media fallback is reported" "Configuration source: toolkit default"
assert_contains "toolkit media configuration path is reported" "$ABBEY_TOOLKIT_ROOT/.abbey/media.yml"

rollback="$(create_project manifest-rollback "Manifest Rollback")"
rollback_exports="$test_root/rollback-exports"
mkdir -p "$rollback_exports/bread-publishing-manifest.json"
touch "$rollback_exports/IMG_5001.JPG" "$rollback_exports/IMG_5001.xmp"
run_media "$rollback" "$rollback_exports"
[[ "$status" -eq 1 ]] && pass "manifest failure fails the operation" || fail "manifest failure fails the operation"
[[ -f "$rollback_exports/IMG_5001.JPG" && -f "$rollback_exports/IMG_5001.xmp" ]] && pass "manifest failure restores original pair" || fail "manifest failure restores original pair"
[[ ! -e "$rollback_exports/country-loaf-2026-08-08.jpg" && ! -e "$rollback_exports/country-loaf-2026-08-08.xmp" ]] && pass "manifest failure leaves no renamed pair" || fail "manifest failure leaves no renamed pair"

printf '\nPassed: %d\n' "$passed"
printf 'Failed: %d\n' "$failed"
(( failed == 0 ))
