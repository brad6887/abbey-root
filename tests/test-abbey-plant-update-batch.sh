#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
TOOLKIT_ROOT="$(cd "$(dirname "$SCRIPT_PATH")/.." && pwd)"
ABBEY_PLANT="$TOOLKIT_ROOT/tools/bin/abbey-plant"
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

create_plant() {
  local slug="$1" name="$2" plant_dir="$test_root/working/plants/$1"
  mkdir -p "$plant_dir/photos" "$plant_dir/sources"
  printf '# %s\n\n## 2026-07-26 — Baseline\n' "$name" > "$plant_dir/history.md"
  touch "$plant_dir/story.md" "$plant_dir/inventory.md" "$plant_dir/photo-metadata.md"
  cat > "$plant_dir/facts.yaml" <<YAML
name: $name
slug: $slug
plant:
  type: orchid
status:
  current: recovering
  updated: 2026-07-26
photos:
  hero: null
  current: null
  index: null
documents:
  story: story.md
  history: history.md
tags:
  - orchid
  - recovering
YAML
}

run_batch() {
  set +e
  output="$(ABBEY_ROOT="$test_root" ABBEY_TOOLKIT_ROOT="$TOOLKIT_ROOT" "$ABBEY_PLANT" update-batch "$@" 2>&1)"
  status=$?
  set -e
}

create_plant doctor-robert "Doctor Robert"
create_plant something "Something"
create_plant no-update "No Update"
mkdir -p "$test_root/working/plants/_template"
mkdir -p "$test_root/incoming"
for file in \
  doctor-robert-2026-08-02-01.jpg \
  doctor-robert-2026-08-02-02.jpg \
  something-2026-08-02.jpg
do
  printf '%s\n' "$file" > "$test_root/incoming/$file"
  printf 'sidecar\n' > "$test_root/incoming/${file%.*}.xmp"
done
printf 'older\n' > "$test_root/incoming/something-2026-08-01.jpg"
printf 'sidecar\n' > "$test_root/incoming/something-2026-08-01.xmp"

worksheet="$test_root/working/plant-updates/2026-08-02.yml"
run_batch prepare "$test_root/incoming" --date 2026-08-02
[[ "$status" -eq 0 ]] && pass "prepare succeeds" || fail "prepare succeeds"
assert_contains "prepare reports multi-photo plant" "OK   doctor-robert: 2 photo(s)" "$output"
assert_contains "prepare warns and skips plant without photos" "WARN no-update: no photos for 2026-08-02; skipped" "$output"
if grep -Fq '_template' <<<"$output"; then fail "prepare ignores template workspace"; else pass "prepare ignores template workspace"; fi
assert_contains "prepare reports ignored older photo" "INFO Ignored 1 photo(s) from other dates" "$output"
[[ -f "$worksheet" ]] && pass "prepare creates default worksheet" || fail "prepare creates default worksheet"
grep -Fq 'current: something-2026-08-02.jpg' "$worksheet" && pass "single photo becomes current" || fail "single photo becomes current"
grep -Fq 'current: null' "$worksheet" && pass "multiple photos require current selection" || fail "multiple photos require current selection"
if grep -Fq 'plant: no-update' "$worksheet"; then fail "skipped plant is omitted"; else pass "skipped plant is omitted"; fi

run_batch apply "$worksheet" --dry-run
[[ "$status" -eq 1 ]] && pass "incomplete worksheet fails" || fail "incomplete worksheet fails"
assert_contains "missing narrative is explained" "narrative is required" "$output"
assert_contains "missing multi-photo current is explained" "current is required when multiple photos are listed" "$output"
[[ ! -e "$test_root/working/plants/something/photos/something-2026-08-02.jpg" ]] && pass "failed validation changes nothing" || fail "failed validation changes nothing"

cat > "$worksheet" <<YAML
date: '2026-08-02'
source: $test_root/incoming
updates:
  - plant: doctor-robert
    photos:
      - doctor-robert-2026-08-02-01.jpg
      - doctor-robert-2026-08-02-02.jpg
    current: doctor-robert-2026-08-02-02.jpg
    narrative: Firm leaves and two active root tips.
    care: Watered.
    status: thriving
  - plant: something
    photos:
      - something-2026-08-02.jpg
    current: null
    narrative: New leaf remains firm.
    care: ''
    status: null
YAML

facts_before="$(shasum -a 256 "$test_root/working/plants/doctor-robert/facts.yaml")"
run_batch apply "$worksheet" --dry-run
[[ "$status" -eq 0 ]] && pass "complete worksheet dry run succeeds" || fail "complete worksheet dry run succeeds"
assert_contains "dry run reports both updates" "2 plant update(s) validated" "$output"
[[ "$facts_before" == "$(shasum -a 256 "$test_root/working/plants/doctor-robert/facts.yaml")" ]] && pass "dry run preserves facts" || fail "dry run preserves facts"

run_batch apply "$worksheet"
[[ "$status" -eq 0 ]] && pass "batch apply succeeds" || fail "batch apply succeeds"
for file in doctor-robert-2026-08-02-01.jpg doctor-robert-2026-08-02-02.jpg; do
  [[ -f "$test_root/working/plants/doctor-robert/photos/$file" ]] && pass "copies $file" || fail "copies $file"
  grep -Fq -- "- $file" "$test_root/working/plants/doctor-robert/history.md" && pass "records $file" || fail "records $file"
done
[[ -f "$test_root/working/plants/something/photos/something-2026-08-02.jpg" ]] && pass "copies single photo" || fail "copies single photo"
[[ ! -e "$test_root/working/plants/something/photos/something-2026-08-02.xmp" ]] && pass "leaves XMP in incoming" || fail "leaves XMP in incoming"
grep -Fq 'current: photos/doctor-robert-2026-08-02-02.jpg' "$test_root/working/plants/doctor-robert/facts.yaml" && pass "sets selected current photo" || fail "sets selected current photo"
grep -Fq 'current: photos/something-2026-08-02.jpg' "$test_root/working/plants/something/facts.yaml" && pass "sets only photo current" || fail "sets only photo current"
grep -Fq 'current: thriving' "$test_root/working/plants/doctor-robert/facts.yaml" && pass "updates requested status" || fail "updates requested status"
grep -Fq '### Care' "$test_root/working/plants/doctor-robert/history.md" && pass "records care" || fail "records care"

run_batch apply "$worksheet"
[[ "$status" -eq 1 ]] && pass "repeat apply fails" || fail "repeat apply fails"
assert_contains "repeat apply reports existing history" "a dated history entry already exists" "$output"

echo
echo "Result: $passed passed, $failed failed"
[[ "$failed" -eq 0 ]]
