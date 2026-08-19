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

check_review_help_without_codex() {
  local flag="$1"
  local description="$2"
  local output
  local status

  output="$(
    bash -c '
      source "$1" help >/dev/null

      command() {
        if [[ "${1:-}" == "-v" && "${2:-}" == "codex" ]]; then
          return 1
        fi
        builtin command "$@"
      }

      session_review "$2"
    ' _ "$SESSION" "$flag" 2>&1
  )"
  status=$?

  if (( status == 0 )) &&
    grep -Fq -- "abbey session review [file]" <<<"$output"; then
    printf 'PASS %s\n' "$description"
    passed=$((passed + 1))
  else
    printf 'FAIL %s\n' "$description"
    printf '%s\n' "$output"
    failed=$((failed + 1))
  fi
}

check_review_requires_codex() {
  local output
  local status

  output="$(
    bash -c '
      source "$1" help >/dev/null

      command() {
        if [[ "${1:-}" == "-v" && "${2:-}" == "codex" ]]; then
          return 1
        fi
        builtin command "$@"
      }

      session_review
    ' _ "$SESSION" 2>&1
  )"
  status=$?

  if (( status != 0 )) &&
    grep -Fq -- "ERROR Codex CLI is not available." <<<"$output"; then
    printf 'PASS review still requires Codex\n'
    passed=$((passed + 1))
  else
    printf 'FAIL review still requires Codex\n'
    printf '%s\n' "$output"
    failed=$((failed + 1))
  fi
}

printf 'Abbey Session Review Tests\n'
printf '==========================\n\n'

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

check_review_help_without_codex \
  "help" \
  "review help works without Codex"

check_review_help_without_codex \
  "-h" \
  "review -h works without Codex"

check_review_help_without_codex \
  "--help" \
  "review --help works without Codex"

check_review_requires_codex

printf '\nPassed: %d\n' "$passed"
printf 'Failed: %d\n' "$failed"

if (( failed > 0 )); then
  exit 1
fi
