#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOL="$ROOT/tools/bin/abbey-research"

passed=0
failed=0

pass() {
  printf 'PASS %s\n' "$1"
  passed=$((passed + 1))
}

fail() {
  printf 'FAIL %s\n' "$1"
  failed=$((failed + 1))
}

assert_status() {
  local name="$1"
  local actual="$2"
  local expected="$3"

  if [[ "$actual" -eq "$expected" ]]; then
    pass "$name"
  else
    fail "$name"
    printf '     Expected status: %s\n' "$expected"
    printf '     Actual status:   %s\n' "$actual"
  fi
}

assert_contains() {
  local name="$1"
  local output="$2"
  local expected="$3"

  if grep -Fq -- "$expected" <<<"$output"; then
    pass "$name"
  else
    fail "$name"
    printf '     Expected: %s\n' "$expected"
  fi
}

printf 'Abbey Research Regression Tests\n'
printf '===============================\n\n'

if bash -n "$TOOL"; then
  pass "tool syntax"
else
  fail "tool syntax"
fi

set +e
output="$("$TOOL" --help 2>&1)"
status=$?
set -e

assert_status \
  "--help exits successfully" \
  "$status" \
  0

assert_contains \
  "--help shows run usage" \
  "$output" \
  "abbey research run"

assert_contains \
  "--help shows status usage" \
  "$output" \
  "abbey research status"

assert_contains \
  "--help shows review validation usage" \
  "$output" \
  "abbey research validate-review"

set +e
output="$("$TOOL" status 2>&1)"
status=$?
set -e

assert_status \
  "status exits successfully for repository artifacts" \
  "$status" \
  0

assert_contains \
  "status reports Voice Analysis project" \
  "$output" \
  "OK   voice-analysis"

assert_contains \
  "status reports formal artifact count" \
  "$output" \
  "Formal artifacts:     14"

assert_contains \
  "status reports first complete chain" \
  "$output" \
  "OBS-001 → EVID-001 → HYP-001 → VAL-001"

assert_contains \
  "status reports second complete chain" \
  "$output" \
  "OBS-002 → EVID-002 → HYP-002 → VAL-002"

assert_contains \
  "status reports third complete chain" \
  "$output" \
  "OBS-003 → EVID-003 → HYP-003 → VAL-003"

assert_contains \
  "status reports three complete chains" \
  "$output" \
  "Complete chains:      3"

assert_contains \
  "status reports legacy provenance" \
  "$output" \
  "INFO OBS-001 → OBSERVATION004-deadpan-delivery"

set +e
output="$("$TOOL" run 2>&1)"
status=$?
set -e

assert_status \
  "missing model exits with error" \
  "$status" \
  1

assert_contains \
  "missing model reports required option" \
  "$output" \
  "Missing required option: --model"

set +e
output="$("$TOOL" validate-review 2>&1)"
status=$?
set -e

assert_status \
  "missing review manifest exits with error" \
  "$status" \
  1

assert_contains \
  "missing review manifest is reported" \
  "$output" \
  "Missing required option: --manifest"

set +e
output="$(
  "$TOOL" run \
    --model test-model \
    --prompt /missing/prompt.md \
    --output /tmp/abbey-research-result.md \
    2>&1
)"
status=$?
set -e

assert_status \
  "missing prompt file exits with error" \
  "$status" \
  1

assert_contains \
  "missing prompt file is reported" \
  "$output" \
  "Prompt file not found:"

fixture_root="$(mktemp -d)"
trap 'rm -rf "$fixture_root"' EXIT

mkdir -p \
  "$fixture_root/tools/bin" \
  "$fixture_root/tools/lib" \
  "$fixture_root/scripts" \
  "$fixture_root/config" \
  "$fixture_root/working"

cp "$TOOL" \
  "$fixture_root/tools/bin/abbey-research"

cp "$ROOT/tools/lib/config.sh" \
  "$fixture_root/tools/lib/config.sh"

cp "$ROOT/scripts/abbey_research_status.py" \
  "$fixture_root/scripts/abbey_research_status.py"

cat > "$fixture_root/config/abbey.conf" <<'CONFIG'
OLLAMA_URL="http://localhost:11434"
CONFIG

printf '# Prompt\n' \
  > "$fixture_root/working/prompt.md"

printf '# Existing result\n' \
  > "$fixture_root/working/result.md"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-research" run \
    --model test-model \
    --prompt "$fixture_root/working/prompt.md" \
    --output "$fixture_root/working/result.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "existing output exits with error" \
  "$status" \
  1

assert_contains \
  "existing output reports overwrite protection" \
  "$output" \
  "Use --force to replace it."


cat > "$fixture_root/working/valid-normalized.md" <<'MARKDOWN'
# Research Result

## Summary

A recurring humorous writing structure was identified.

## Observations

Each post begins with a mundane statement followed by an exaggerated comment.

## Evidence

Three supplied posts use the same two-clause structure.

## Conclusions

The pattern appears intentional and recurring.

## Limitations

The sample contains only three posts.

## Open Questions

Whether the pattern appears consistently in a larger corpus remains unknown.
MARKDOWN

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-research" validate \
    --input "$fixture_root/working/valid-normalized.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "valid normalized artifact passes validation" \
  "$status" \
  0

assert_contains \
  "valid normalized artifact reports PASS" \
  "$output" \
  "Result: PASS"

cat > "$fixture_root/working/missing-section.md" <<'MARKDOWN'
# Research Result

## Summary

Summary text.

## Observations

Observation text.

## Evidence

Evidence text.

## Conclusions

Conclusion text.

## Limitations

Limitation text.
MARKDOWN

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-research" validate \
    --input "$fixture_root/working/missing-section.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "missing section fails validation" \
  "$status" \
  1

assert_contains \
  "missing section is reported" \
  "$output" \
  "Missing required section: ## Open Questions"

cat > "$fixture_root/working/empty-section.md" <<'MARKDOWN'
# Research Result

## Summary

Summary text.

## Observations

Observation text.

## Evidence

## Conclusions

Conclusion text.

## Limitations

Limitation text.

## Open Questions

Question text.
MARKDOWN

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-research" validate \
    --input "$fixture_root/working/empty-section.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "empty section fails validation" \
  "$status" \
  1

assert_contains \
  "empty section is reported" \
  "$output" \
  "Section is empty: ## Evidence"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-research" normalize \
    --model test-model \
    --input "$fixture_root/working/valid-normalized.md" \
    --output "$fixture_root/working/result.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "normalize protects existing output" \
  "$status" \
  1

assert_contains \
  "normalize reports overwrite protection" \
  "$output" \
  "Use --force to replace it."

printf '\nPassed: %d\n' "$passed"
printf 'Failed: %d\n' "$failed"

if (( failed > 0 )); then
  exit 1
fi
