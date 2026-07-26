#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

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

assert_status() {
  local name="$1"
  local actual="$2"
  local expected="$3"

  if [[ "$actual" -eq "$expected" ]]; then
    pass "$name"
  else
    fail "$name"
    echo "     Expected status: $expected"
    echo "     Actual status:   $actual"
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
    echo "     Expected: $expected"
  fi
}

assert_file_exists() {
  local name="$1"
  local path="$2"

  if [[ -f "$path" ]]; then
    pass "$name"
  else
    fail "$name"
    echo "     Missing file: $path"
  fi
}

test_root="$(mktemp -d)"
fixture_root="$test_root/repo"

trap 'rm -rf "$test_root"' EXIT

mkdir -p \
  "$fixture_root/tools/bin" \
  "$fixture_root/docs/session-updates" \
  "$fixture_root/content/journal"

cp "$ABBEY_ROOT/tools/bin/abbey-session" \
  "$fixture_root/tools/bin/abbey-session"

cp "$ABBEY_ROOT/tools/bin/abbey-journal" \
  "$fixture_root/tools/bin/abbey-journal"

run_capture() {
  set +e
  output="$(
    ABBEY_ROOT="$fixture_root" \
      "$fixture_root/tools/bin/abbey-session" \
      capture "$@" 2>&1
  )"
  status=$?
  set -e
}

echo "Abbey Session Capture Regression Tests"
echo "======================================"
echo

run_capture \
  --title "Guided Session Capture Workflow" \
  guided-session-capture-workflow

date_value="$(date +%F)"
year_value="$(date +%Y)"

session_file="$fixture_root/docs/session-updates/${date_value}-guided-session-capture-workflow.md"
journal_file="$fixture_root/content/journal/${year_value}/${date_value}-guided-session-capture-workflow.md"

assert_status \
  "capture exits successfully" \
  "$status" \
  0

assert_file_exists \
  "capture creates session update" \
  "$session_file"

assert_file_exists \
  "capture creates journal entry" \
  "$journal_file"

assert_contains \
  "capture reports session update" \
  "$output" \
  "Session update created:"

assert_contains \
  "capture reports journal entry" \
  "$output" \
  "Journal entry created:"

session_before="$(cat "$session_file")"
journal_before="$(cat "$journal_file")"

run_capture guided-session-capture-workflow

assert_status \
  "capture can be rerun safely" \
  "$status" \
  0

assert_contains \
  "rerun reports existing session update" \
  "$output" \
  "Session update already exists:"

assert_contains \
  "rerun reports existing journal entry" \
  "$output" \
  "Journal entry already exists:"

if [[ "$(cat "$session_file")" == "$session_before" ]]; then
  pass "rerun preserves session update"
else
  fail "rerun preserves session update"
fi

if [[ "$(cat "$journal_file")" == "$journal_before" ]]; then
  pass "rerun preserves journal entry"
else
  fail "rerun preserves journal entry"
fi

rm "$journal_file"

run_capture guided-session-capture-workflow

assert_status \
  "capture repairs missing journal entry" \
  "$status" \
  0

assert_file_exists \
  "missing journal entry is recreated" \
  "$journal_file"

run_capture \
  --title "Different Title" \
  guided-session-capture-workflow

assert_status \
  "conflicting title is rejected" \
  "$status" \
  1

assert_contains \
  "conflicting title explains mismatch" \
  "$output" \
  "Existing session update title does not match --title"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if ((failed > 0)); then
  exit 1
fi
