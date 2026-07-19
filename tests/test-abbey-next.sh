#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY_NEXT="$ABBEY_ROOT/tools/bin/abbey-next"

passed=0
failed=0

pass() {
  echo "PASS $1"
  passed=$((passed + 1))
}

fail() {
  echo "FAIL $1"
  failed=$((failed + 1))
}

create_fixture() {
  local fixture_root

  fixture_root="$(mktemp -d)"
  mkdir -p "$fixture_root/docs/planning"

  cp "$ABBEY_ROOT"/docs/planning/{PROJECT_STATUS,NEXT,BACKLOG,ROADMAP}.md \
    "$fixture_root/docs/planning/"

  sed -i \
    's/- \[x\] Create `abbey next`\./- [ ] Create `abbey next`./' \
    "$fixture_root/docs/planning/BACKLOG.md"

  git -C "$fixture_root" init -q
  git -C "$fixture_root" config user.name "Abbey Test"
  git -C "$fixture_root" config user.email "abbey-test@example.invalid"
  git -C "$fixture_root" add docs
  git -C "$fixture_root" commit -qm "Create Abbey Next test fixture"

  printf '%s\n' "$fixture_root"
}

assert_contains() {
  local name="$1"
  local output="$2"
  local expected="$3"

  if grep -Fq -- "$expected" <<<"$output"; then
    pass "$name"
  else
    fail "$name"
    echo "     Expected: $expected"
  fi
}

assert_not_contains() {
  local name="$1"
  local output="$2"
  local unexpected="$3"

  if grep -Fq -- "$unexpected" <<<"$output"; then
    fail "$name"
    echo "     Unexpected: $unexpected"
  else
    pass "$name"
  fi
}

echo "Abbey Next Regression Tests"
echo "==========================="
echo

fixture_root="$(create_fixture)"
trap 'rm -rf "${fixture_root:-}"' EXIT

mkdir -p "$fixture_root/tools/bin"
touch "$fixture_root/tools/bin/abbey-next"

output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_NEXT")"

assert_contains \
  "reads current theme" \
  "$output" \
  "Theme: Build with the Framework"

assert_contains \
  "recommends first incomplete item" \
  "$output" \
  "Create abbey next"

assert_contains \
  "detects active recommendation work" \
  "$output" \
  "Related implementation or architecture work is active in the repository."

assert_contains \
  "prioritizes coherent work in progress" \
  "$output" \
  "Completing coherent work already in progress takes precedence over unrelated work."

assert_contains \
  "generates Definition of Done for selected recommendation" \
  "$output" \
  "- Implement the initial deterministic command."

assert_not_contains \
  "does not use neighboring backlog items as Definition of Done" \
  "$output" \
  "- Generate session objectives from planning documents."

sed -i \
  's/- \[ \] Create `abbey next`\./- [x] Create `abbey next`./' \
  "$fixture_root/docs/planning/BACKLOG.md"

git -C "$fixture_root" add docs/planning/BACKLOG.md
git -C "$fixture_root" commit -qm "Complete initial Abbey Next item"

output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_NEXT")"

assert_contains \
  "skips completed recommendation" \
  "$output" \
  "Build deterministic project recommendation engine"

assert_contains \
  "updates promoted objective" \
  "$output" \
  "Build the deterministic engine that ranks project work using"

assert_contains \
  "updates promoted first step" \
  "$output" \
  "Define the initial candidate collection and scoring functions."


mkdir -p "$fixture_root/docs/session-updates"

cat > "$fixture_root/docs/session-updates/recent-completion.md" <<'EOF'
---
title: "Deterministic Recommendation Engine"
status: completed
reviewed: false
---

# Deterministic Recommendation Engine

## Accomplishments

- Built the deterministic project recommendation engine.

## Next Steps

- Generate focused session objectives from planning documents.
EOF

output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_NEXT")"

recommended_item="$(
  awk '
    $0 == "Recommended Session" {
      getline
      getline
      print
      exit
    }
  ' <<<"$output"
)"

if [[ "$recommended_item" != "Build deterministic project recommendation engine" ]]; then
  pass "suppresses work completed in an unreconciled update"
else
  fail "suppresses work completed in an unreconciled update"
fi

assert_contains \
  "uses session-update next steps as recommendation evidence" \
  "$output" \
  "supported by follow-up work recorded in an unreconciled session update"

assert_contains \
  "reports stale planning state" \
  "$output" \
  "Planning Conflicts"

assert_contains \
  "identifies stale backlog item" \
  "$output" \
  "BACKLOG.md still lists incomplete: Build deterministic project recommendation engine"


cat > "$fixture_root/docs/session-updates/generic-planning-followup.md" <<'EOF'
---
title: "Planning Reconciliation"
status: pending
reviewed: false
---

## Next Steps

- Continue refining planning documents as reconciliation identifies drift.
EOF

candidate_output="$(
  "$ABBEY_ROOT/scripts/abbey_next_candidates.py" \
    --repo "$fixture_root" \
    --next "$fixture_root/docs/planning/NEXT.md" \
    --project-status "$fixture_root/docs/planning/PROJECT_STATUS.md" \
    --backlog "$fixture_root/docs/planning/BACKLOG.md"
)"

session_objective_row="$(
  grep -F '|Generate session objectives from planning documents|' \
    <<<"$candidate_output" || true
)"

if grep -Fq 'generic-planning-followup.md' <<<"$session_objective_row"; then
  fail "does not promote candidates from generic planning language"
else
  pass "does not promote candidates from generic planning language"
fi

cat > "$fixture_root/docs/session-updates/pending-work.md" <<'EOF'
---
title: "Pending Documentation Work"
status: pending
reviewed: false
---

## Accomplishments

- Started reviewing documentation.

## Next Steps

- Explain recommendation reasoning using visible project evidence.
EOF

candidate_output="$(
  "$ABBEY_ROOT/scripts/abbey_next_candidates.py" \
    --repo "$fixture_root" \
    --next "$fixture_root/docs/planning/NEXT.md" \
    --project-status "$fixture_root/docs/planning/PROJECT_STATUS.md" \
    --backlog "$fixture_root/docs/planning/BACKLOG.md"
)"

if grep -Fq '|Explain recommendation reasoning|' <<<"$candidate_output"; then
  pass "does not treat pending updates as completed"
else
  fail "does not treat pending updates as completed"
fi

rm "$fixture_root/docs/planning/ROADMAP.md"

set +e
output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_NEXT" 2>&1)"
status=$?
set -e

if (( status != 0 )); then
  pass "fails when required planning document is missing"
else
  fail "fails when required planning document is missing"
fi

assert_contains \
  "identifies missing planning document" \
  "$output" \
  "FAIL Document missing: docs/planning/ROADMAP.md"

assert_contains \
  "explains recommendation cannot be generated" \
  "$output" \
  "Unable to generate a recommendation."

echo
echo "Summary"
echo "-------"
echo "Passed: $passed"
echo "Failed: $failed"

if (( failed > 0 )); then
  exit 1
fi
