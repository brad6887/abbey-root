#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
ABBEY_ROOT="$(cd "$(dirname "$SCRIPT_PATH")/.." && pwd)"
ABBEY_PLANT="$ABBEY_ROOT/tools/bin/abbey-plant"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

passed=0
failed=0
pass() { echo "PASS $1"; passed=$((passed + 1)); }
fail() { echo "FAIL $1"; failed=$((failed + 1)); }

assert_contains() {
  local name="$1" expected="$2" value="$3"
  if grep -Fq -- "$expected" <<<"$value"; then pass "$name"; else fail "$name"; fi
}

mkdir -p "$test_root/bin" "$test_root/incoming" \
  "$test_root/working/plants/test-plant/photos" \
  "$test_root/working/plants/test-plant/sources"

cat > "$test_root/bin/exiftool" <<'SCRIPT'
#!/usr/bin/env bash
tag="$2"
file="${3##*/}"
case "$tag:$file" in
  -XMP-dc:Description:IMG_5001.xmp) echo "Test Plant" ;;
  -DateTimeOriginal:IMG_5001.JPG) echo "2026:08:28 09:30:00" ;;
esac
SCRIPT
chmod +x "$test_root/bin/exiftool"

plant_dir="$test_root/working/plants/test-plant"
touch "$plant_dir/inventory.md" "$plant_dir/photo-metadata.md"
printf '# Story\n' > "$plant_dir/story.md"
printf '# Test Plant\n\n## 2026-08-01 — Baseline\n' > "$plant_dir/history.md"
printf 'hero\n' > "$plant_dir/photos/hero.jpg"
printf 'current\n' > "$plant_dir/photos/current.jpg"
printf 'incoming photo\n' > "$test_root/incoming/IMG_5001.JPG"
printf 'incoming sidecar\n' > "$test_root/incoming/IMG_5001.xmp"

cat > "$plant_dir/facts.yaml" <<'YAML'
name: Test Plant
slug: test-plant
description: Test fixture.

plant:
  type: orchid
  genus: Phalaenopsis
  species: null
rescue:
  date: 2026-08-01
status:
  current: recovering
  updated: 2026-08-01
photos:
  hero: photos/hero.jpg
  current: photos/current.jpg
  index: null
documents:
  story: story.md
  history: history.md
tags:
  - orchid
  - recovering
YAML

output="$(
  printf '\nthriving\nNew Flower Spike\nA new spike is visible.\nWatered.\ny\n' |
    PATH="$test_root/bin:$PATH" ABBEY_ROOT="$test_root" \
      "$ABBEY_PLANT" update --incoming "$test_root/incoming"
)"

assert_contains "metadata matches the plant" "Matched plant: Test Plant (test-plant)" "$output"
assert_contains "interactive flow shows a dry-run preview" "Result: DRY RUN; no files changed" "$output"
assert_contains "interactive flow applies and validates" "Interactive result: update applied and validated" "$output"
[[ -f "$test_root/incoming/test-plant-2026-08-28.jpg" ]] && pass "photo is renamed from metadata" || fail "photo is renamed from metadata"
[[ -f "$test_root/incoming/test-plant-2026-08-28.xmp" ]] && pass "sidecar stays paired after rename" || fail "sidecar stays paired after rename"
[[ ! -e "$test_root/incoming/IMG_5001.JPG" && ! -e "$test_root/incoming/IMG_5001.xmp" ]] && pass "original incoming names are replaced" || fail "original incoming names are replaced"
[[ -f "$plant_dir/photos/test-plant-2026-08-28.jpg" ]] && pass "selected photo is copied into the workspace" || fail "selected photo is copied into the workspace"
grep -Fq "## 2026-08-28 — New Flower Spike" "$plant_dir/history.md" && pass "special update title is canonical" || fail "special update title is canonical"
grep -Fq "current: thriving" "$plant_dir/facts.yaml" && pass "prompted status is applied" || fail "prompted status is applied"

echo
echo "Result: $passed passed, $failed failed"
[[ "$failed" -eq 0 ]]
