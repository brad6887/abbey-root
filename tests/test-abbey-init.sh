#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY="$ABBEY_ROOT/tools/bin/abbey"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

passed=0
failed=0

pass() { echo "PASS $1"; passed=$((passed + 1)); }
fail() { echo "FAIL $1"; failed=$((failed + 1)); }

assert_contains() {
  if grep -Fq -- "$2" <<<"$3"; then pass "$1"; else fail "$1"; fi
}

dry_project="$test_root/dry-project"
output="$("$ABBEY" init "$dry_project" --dry-run --yes)"
[[ ! -e "$dry_project" ]] && pass "dry-run is read-only" || fail "dry-run is read-only"
assert_contains "dry-run reports metadata" "CREATE .abbey/project.yml" "$output"

project="$test_root/bread-pitt"
output="$(
  "$ABBEY" init "$project" \
    --name "Bread Pitt" \
    --description "Track Bread Pitt starter history." \
    --yes
)"
[[ -f "$project/.abbey/project.yml" ]] && pass "metadata is created" || fail "metadata is created"
[[ -f "$project/docs/planning/PROJECT_STATUS.md" ]] && pass "planning is created" || fail "planning is created"
git -C "$project" rev-parse --is-inside-work-tree >/dev/null 2>&1 &&
  pass "Git is initialized" || fail "Git is initialized"
[[ -z "$(git -C "$project" remote)" ]] && pass "no remote is created" || fail "no remote is created"
[[ -z "$(git -C "$project" log --oneline 2>/dev/null)" ]] &&
  pass "no commit is created" || fail "no commit is created"
assert_contains "created files are reported" "CREATE README.md" "$output"

version_output="$(cd "$project" && "$ABBEY" version)"
assert_contains "version uses project metadata" "Bread Pitt" "$version_output"

session_output="$(cd "$project" && "$ABBEY" session)"
assert_contains "session uses project metadata" "Bread Pitt Session" "$session_output"

context_output="$(cd "$project" && "$ABBEY" session context --stdout)"
assert_contains "context uses project metadata" "# Bread Pitt Session Context" "$context_output"

mkdir "$test_root/nonempty"
touch "$test_root/nonempty/existing"
if "$ABBEY" init "$test_root/nonempty" --yes >/dev/null 2>&1; then
  fail "nonempty destination is refused"
else
  pass "nonempty destination is refused"
fi

no_git="$test_root/no-git"
"$ABBEY" init "$no_git" --no-git --yes >/dev/null
[[ ! -d "$no_git/.git" ]] && pass "--no-git skips Git" || fail "--no-git skips Git"

echo
echo "Passed: $passed"
echo "Failed: $failed"
[[ "$failed" -eq 0 ]]
