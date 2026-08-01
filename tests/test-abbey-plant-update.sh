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
  local name="$1"
  local expected="$2"
  local value="$3"
  if grep -Fq -- "$expected" <<<"$value"; then pass "$name"; else fail "$name"; fi
}

plant_dir="$test_root/working/plants/test-plant"
mkdir -p "$plant_dir/photos" "$plant_dir/sources"
touch "$plant_dir/inventory.md" "$plant_dir/photo-metadata.md"
printf '# Story\n' > "$plant_dir/story.md"
printf '# Test Plant\n\n## 2026-07-26 — Baseline\n' > "$plant_dir/history.md"
printf 'hero\n' > "$plant_dir/photos/hero.jpg"
printf 'current\n' > "$plant_dir/photos/current.jpg"
printf 'new photo\n' > "$test_root/candidate.jpg"

cat > "$plant_dir/facts.yaml" <<'YAML'
name: Test Plant
slug: test-plant
description: "Keep this exact formatting."

plant:
  type: orchid
  genus: Phalaenopsis
  species: null
rescue:
  date: 2026-07-01
status:
  current: recovering
  updated: 2026-07-26
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

facts_before="$(shasum -a 256 "$plant_dir/facts.yaml")"
history_before="$(shasum -a 256 "$plant_dir/history.md")"

output="$(ABBEY_ROOT="$test_root" "$ABBEY_PLANT" update test-plant \
  --photo "$test_root/candidate.jpg" \
  --narrative "A dry-run observation." \
  --care "Watered." \
  --status thriving \
  --date 2026-08-01 \
  --dry-run)"

assert_contains "dry run reports no writes" "Result: DRY RUN; no files changed" "$output"
assert_contains "dry run previews care" "Watered." "$output"
[[ "$facts_before" == "$(shasum -a 256 "$plant_dir/facts.yaml")" ]] && pass "dry run preserves facts" || fail "dry run preserves facts"
[[ "$history_before" == "$(shasum -a 256 "$plant_dir/history.md")" ]] && pass "dry run preserves history" || fail "dry run preserves history"
[[ ! -e "$plant_dir/photos/test-plant-2026-08-01.jpg" ]] && pass "dry run does not copy photo" || fail "dry run does not copy photo"

output="$(ABBEY_ROOT="$test_root" "$ABBEY_PLANT" update test-plant \
  --photo "$test_root/candidate.jpg" \
  --narrative "The plant has firm leaves and active roots." \
  --care "Watered and fertilized." \
  --status thriving \
  --date 2026-08-01)"

assert_contains "applied update validates" "FAIL: 0" "$output"
[[ -f "$plant_dir/photos/test-plant-2026-08-01.jpg" ]] && pass "applied update copies photo" || fail "applied update copies photo"
grep -Fq "current: photos/test-plant-2026-08-01.jpg" "$plant_dir/facts.yaml" && pass "current photo changes" || fail "current photo changes"
grep -Fq "hero: photos/hero.jpg" "$plant_dir/facts.yaml" && pass "hero photo is preserved" || fail "hero photo is preserved"
grep -Fq "current: thriving" "$plant_dir/facts.yaml" && pass "optional status changes" || fail "optional status changes"
grep -Fq 'description: "Keep this exact formatting."' "$plant_dir/facts.yaml" && pass "unrelated facts formatting is preserved" || fail "unrelated facts formatting is preserved"
grep -Fq "  - thriving" "$plant_dir/facts.yaml" && pass "status tag changes with status" || fail "status tag changes with status"
if grep -Fq "  - recovering" "$plant_dir/facts.yaml"; then fail "old status tag is removed"; else pass "old status tag is removed"; fi
grep -Fq "## 2026-08-01 — Weekly Update" "$plant_dir/history.md" && pass "history entry is appended" || fail "history entry is appended"
grep -Fq "### Care" "$plant_dir/history.md" && pass "care note is appended" || fail "care note is appended"
grep -Fq "## 2026-07-26 — Baseline" "$plant_dir/history.md" && pass "existing history is preserved" || fail "existing history is preserved"

set +e
output="$(ABBEY_ROOT="$test_root" "$ABBEY_PLANT" update test-plant \
  --photo "$test_root/candidate.jpg" \
  --narrative "Duplicate." \
  --date 2026-08-01 2>&1)"
status=$?
set -e
[[ "$status" -eq 1 ]] && pass "duplicate date fails" || fail "duplicate date fails"
assert_contains "duplicate date is explained" "A weekly update already exists" "$output"

echo
echo "Result: $passed passed, $failed failed"
[[ "$failed" -eq 0 ]]
