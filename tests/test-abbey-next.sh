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

replace_in_file() {
  local old="$1"
  local new="$2"
  local file="$3"

  python3 - "$old" "$new" "$file" <<'PYTHON'
from pathlib import Path
import sys

old, new, filename = sys.argv[1:]
path = Path(filename)
text = path.read_text(encoding="utf-8")

if old not in text:
    raise SystemExit(f"Expected text not found in {filename}: {old}")

path.write_text(text.replace(old, new, 1), encoding="utf-8")
PYTHON
}

create_fixture() {
  local fixture_root

  fixture_root="$(mktemp -d)"
  mkdir -p "$fixture_root/docs/planning"

  cat > "$fixture_root/docs/planning/PROJECT_STATUS.md" <<'EOF'
# Test Project Status

## Current Focus

- Recommendation Engine
EOF

  cat > "$fixture_root/docs/planning/NEXT.md" <<'EOF'
# Test Project Next

## Current Theme

### Build with the Framework

## Primary Objective

Build the Abbey Recommendation Engine.

## Current Priorities

- Create and refine `abbey next`.

## Success Criteria

- Recommendations are deterministic and tested.

## Future Direction

Expand project-aware recommendations after the foundation is stable.

## Guiding Principle

Prefer deterministic project evidence.
EOF

  cat > "$fixture_root/docs/planning/BACKLOG.md" <<'EOF'
# Test Backlog

## Project-Aware Recommendations

- [ ] Create `abbey next`.
- [ ] Build deterministic project recommendation engine.
- [ ] Generate session objectives from planning documents.
- [ ] Generate Definitions of Done.
- [ ] Explain recommendation reasoning.
EOF

  cat > "$fixture_root/docs/planning/ROADMAP.md" <<'EOF'
# Test Roadmap

## Recommendation Engine

- Build deterministic, explainable project recommendations.
EOF

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

assert_not_contains \
  "candidate extraction avoids Python 3.9-only str.removeprefix" \
  "$(cat "$ABBEY_ROOT/scripts/abbey_next_candidates.py")" \
  ".removeprefix("

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

cp "$fixture_root/docs/planning/NEXT.md" "$fixture_root/docs/planning/NEXT.valid.md"

for missing_section in \
  "Current Theme" \
  "Primary Objective" \
  "Current Priorities" \
  "Success Criteria" \
  "Future Direction" \
  "Guiding Principle"; do
  awk -v section="$missing_section" '
    BEGIN { skip = 0; level = 0 }
    /^#{1,6} / {
      current_level = index($0, " ") - 1
      heading = $0
      sub(/^#{1,6} /, "", heading)
      if (heading == section) {
        skip = 1
        level = current_level
        next
      }
      if (skip && current_level <= level) {
        skip = 0
      }
    }
    !skip { print }
  ' "$fixture_root/docs/planning/NEXT.valid.md" \
    > "$fixture_root/docs/planning/NEXT.md"

  set +e
  output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_NEXT" 2>&1)"
  status=$?
  set -e

  if (( status != 0 )); then
    pass "fails when $missing_section is missing"
  else
    fail "fails when $missing_section is missing"
  fi

  assert_contains \
    "identifies missing $missing_section section" \
    "$output" \
    "FAIL NEXT.md missing required section: $missing_section"
done

mv "$fixture_root/docs/planning/NEXT.valid.md" \
  "$fixture_root/docs/planning/NEXT.md"

replace_in_file \
  '### Build with the Framework' \
  'Build with the Framework' \
  "$fixture_root/docs/planning/NEXT.md"

output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_NEXT")"
assert_contains \
  "supports normal Markdown theme body text" \
  "$output" \
  "Theme: Build with the Framework"

replace_in_file \
  '- [ ] Create `abbey next`.' \
  '- [x] Create `abbey next`.' \
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

init_root="$(mktemp -d)"
rm -rf "$init_root/docs"
mkdir -p "$init_root/.abbey"
cat > "$init_root/.abbey/project.yml" <<'EOF'
schema_version: 1
project:
  name: Abbey Next Test
EOF

output="$(ABBEY_ROOT="$init_root" "$ABBEY_NEXT" init)"
assert_contains \
  "init reports created template" \
  "$output" \
  "OK   Created docs/planning/NEXT.md"

for required_section in \
  "Current Theme" \
  "Primary Objective" \
  "Current Priorities" \
  "Success Criteria" \
  "Future Direction" \
  "Guiding Principle"; do
  if grep -Eq "^#{1,6} ${required_section}$" \
    "$init_root/docs/planning/NEXT.md"; then
    pass "init includes $required_section"
  else
    fail "init includes $required_section"
  fi
done

set +e
output="$(ABBEY_ROOT="$init_root" "$ABBEY_NEXT" init 2>&1)"
status=$?
set -e
if (( status != 0 )); then
  pass "init refuses to overwrite NEXT.md"
else
  fail "init refuses to overwrite NEXT.md"
fi

rm -rf "$init_root"

echo
echo "Summary"
echo "-------"
echo "Passed: $passed"
echo "Failed: $failed"

if (( failed > 0 )); then
  exit 1
fi
