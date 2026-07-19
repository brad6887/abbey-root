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
  "$fixture_root/config" \
  "$fixture_root/working"

cp "$TOOL" \
  "$fixture_root/tools/bin/abbey-research"

cp "$ROOT/tools/lib/config.sh" \
  "$fixture_root/tools/lib/config.sh"

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

printf '\nPassed: %d\n' "$passed"
printf 'Failed: %d\n' "$failed"

if (( failed > 0 )); then
  exit 1
fi
