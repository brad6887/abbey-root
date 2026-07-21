#!/usr/bin/env bash
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SESSION="$ROOT/tools/bin/abbey-session"

passed=0
failed=0

check() {
  local description="$1"
  local pattern="$2"

  if grep -Fq -- "$pattern" "$SESSION"; then
    printf 'PASS %s\n' "$description"
    passed=$((passed + 1))
  else
    printf 'FAIL %s\n' "$description"
    failed=$((failed + 1))
  fi
}

printf 'Abbey Session Review Prompt Tests\n'
printf '=================================\n\n'

check "requires decisive result" \
  "State exactly one of:"

check "defines ready state" \
  "Use READY only when no required session-related reconciliation remains."

check "separates verification" \
  "Verification Required"

check "prevents status inference" \
  "Never recommend changing status unless PLANNING_SCHEMA.md explicitly defines"

check "prevents invented follow-up work" \
  "Do not invent new implementation approaches"

check "keeps incidental drift non-blocking" \
  "Incidental drift must never affect the"

check "avoids project-status rollout duplication" \
  "PROJECT_STATUS.md should summarize durable completed capabilities."

check "maintains dates for changed planning documents" \
  "When recommending a substantive change to a planning document that contains a"

check "requires single file classification" \
  "Each supplied authoritative file must appear exactly once"

printf '\nPassed: %d\n' "$passed"
printf 'Failed: %d\n' "$failed"

if (( failed > 0 )); then
  exit 1
fi
