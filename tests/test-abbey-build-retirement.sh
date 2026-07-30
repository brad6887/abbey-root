#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY="$ABBEY_ROOT/tools/bin/abbey"

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

assert_absent() {
  local description="$1"
  local path="$2"

  if [[ ! -e "$path" ]]; then
    pass "$description"
  else
    fail "$description"
  fi
}

assert_not_contains() {
  local description="$1"
  local pattern="$2"
  local path="$3"

  if grep -Fq "$pattern" "$path"; then
    fail "$description"
  else
    pass "$description"
  fi
}

assert_absent \
  "legacy abbey-build executable is absent" \
  "$ABBEY_ROOT/tools/abbey-build"

assert_not_contains \
  "legacy help does not recommend abbey-build" \
  "abbey-build" \
  "$ABBEY_ROOT/tools/abbey-help"

assert_not_contains \
  "README does not recommend unsupported abbey build" \
  "abbey build" \
  "$ABBEY_ROOT/docs/README.md"

assert_not_contains \
  "vision does not list unsupported abbey build" \
  '`abbey build`' \
  "$ABBEY_ROOT/docs/planning/VISION.md"

assert_not_contains \
  "generated command reference excludes abbey-build" \
  "## abbey-build" \
  "$ABBEY_ROOT/docs/generated/abbey-commands.md"

output_file="$(mktemp)"
trap 'rm -f "$output_file"' EXIT

if "$ABBEY" build >"$output_file" 2>&1; then
  fail "dispatcher rejects unsupported abbey build"
elif grep -Fq "Unknown command: build" "$output_file"; then
  pass "dispatcher rejects unsupported abbey build"
else
  fail "dispatcher rejects unsupported abbey build"
fi

printf '\nPASSED: %d\n' "$passed"
printf 'FAILED: %d\n' "$failed"

if ((failed > 0)); then
  exit 1
fi
