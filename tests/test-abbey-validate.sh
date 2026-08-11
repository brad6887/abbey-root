#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ABBEY_TOOLKIT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VALIDATE="$ABBEY_TOOLKIT_ROOT/tools/bin/abbey-validate"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT
passed=0
failed=0

pass() { printf 'PASS %s\n' "$1"; passed=$((passed + 1)); }
fail() { printf 'FAIL %s\n' "$1"; failed=$((failed + 1)); }
assert_contains() { grep -Fq "$2" <<<"$output" && pass "$1" || fail "$1"; }

project="$test_root/project"
mkdir -p "$project/.abbey" "$project/docs/planning" "$project/docs/session-updates" "$project/content/journal"
git -C "$project" init -q
cat > "$project/.abbey/project.yml" <<'YAML'
schema_version: 1
project:
  name: Test Project
  slug: test-project
paths:
  planning: docs/planning
  session_updates: docs/session-updates
  journal: content/journal
YAML
printf '# Test Status\n' > "$project/docs/planning/PROJECT_STATUS.md"
cat > "$project/docs/planning/NEXT.md" <<'MARKDOWN'
# Test Next
## Current Theme
## Primary Objective
## Current Priorities
## Success Criteria
## Future Direction
## Guiding Principle
MARKDOWN

set +e
output="$(ABBEY_ROOT="$project" ABBEY_TOOLKIT_ROOT="$ABBEY_TOOLKIT_ROOT" "$VALIDATE" 2>&1)"
status=$?
set -e
[[ $status -eq 0 ]] && pass "valid external project passes" || fail "valid external project passes"
assert_contains "success is summarized" "PASS Repository consistency checks passed."
assert_contains "NEXT contract is checked" "OK   NEXT.md satisfies the canonical six-section contract"

set +e
output="$(cd "$project/docs" && "$ABBEY_TOOLKIT_ROOT/tools/bin/abbey" validate 2>&1)"
status=$?
set -e
[[ $status -eq 0 ]] && pass "dispatcher resolves a nested external project" || fail "dispatcher resolves a nested external project"
resolved_project="$(cd "$project" && pwd -P)"
assert_contains "dispatcher reports the resolved project" "Project: $resolved_project"

sed -i.bak '/## Guiding Principle/d' "$project/docs/planning/NEXT.md"
rm "$project/docs/planning/NEXT.md.bak"
set +e
output="$(ABBEY_ROOT="$project" ABBEY_TOOLKIT_ROOT="$ABBEY_TOOLKIT_ROOT" "$VALIDATE" 2>&1)"
status=$?
set -e
[[ $status -eq 1 ]] && pass "invalid external project fails" || fail "invalid external project fails"
assert_contains "missing NEXT section is actionable" "FAIL NEXT.md is missing required sections: Guiding Principle"

set +e
output="$(ABBEY_ROOT="$project" ABBEY_TOOLKIT_ROOT="$ABBEY_TOOLKIT_ROOT" "$VALIDATE" unexpected 2>&1)"
status=$?
set -e
[[ $status -eq 1 ]] && pass "unexpected arguments fail" || fail "unexpected arguments fail"
assert_contains "unexpected arguments are explained" "ERROR validate does not accept arguments."

printf '\nPassed: %d\nFailed: %d\n' "$passed" "$failed"
((failed == 0))
