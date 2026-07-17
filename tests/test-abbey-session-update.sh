#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY_SESSION="$ABBEY_ROOT/tools/bin/abbey-session"

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

fixture_root="$(mktemp -d)"
trap 'rm -rf "$fixture_root"' EXIT

mkdir -p \
  "$fixture_root/tools/bin" \
  "$fixture_root/docs/session-updates"

cp "$ABBEY_SESSION" "$fixture_root/tools/bin/abbey-session"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-session" update --help 2>&1
)"
status=$?
set -e

assert_status \
  "--help exits successfully" \
  "$status" \
  0

assert_contains \
  "--help shows usage" \
  "$output" \
  "abbey session update [--title TITLE] <slug>"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-session" update 2>&1
)"
status=$?
set -e

assert_status \
  "missing slug exits with error" \
  "$status" \
  1

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-session" \
      update abbey-ai-decision-help 2>&1
)"
status=$?
set -e

assert_status \
  "valid slug creates update" \
  "$status" \
  0

date_value="$(date '+%Y-%m-%d')"
created_file="$fixture_root/docs/session-updates/${date_value}-abbey-ai-decision-help.md"

if [[ -f "$created_file" ]]; then
  pass "created expected file"
else
  fail "created expected file"
fi

created_content="$(cat "$created_file")"

assert_contains \
  "derives readable title" \
  "$created_content" \
  'title: "Abbey AI Decision Help"'

assert_contains \
  "sets pending status" \
  "$created_content" \
  "status: pending"

assert_contains \
  "sets update as unreviewed" \
  "$created_content" \
  "reviewed: false"

assert_contains \
  "includes objective section" \
  "$created_content" \
  "## Objective"

assert_contains \
  "includes definition of done section" \
  "$created_content" \
  "## Definition of Done"

assert_contains \
  "includes impact section" \
  "$created_content" \
  "## Impact"

assert_contains \
  "includes next steps section" \
  "$created_content" \
  "## Next Steps"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-session" \
      update abbey-ai-decision-help 2>&1
)"
status=$?
set -e

assert_status \
  "existing update is not overwritten" \
  "$status" \
  1

assert_contains \
  "overwrite refusal identifies existing file" \
  "$output" \
  "Session update already exists"

rm "$created_file"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-session" \
      update \
      --title "Custom Session Title" \
      custom-session 2>&1
)"
status=$?
set -e

assert_status \
  "custom title exits successfully" \
  "$status" \
  0

custom_file="$fixture_root/docs/session-updates/${date_value}-custom-session.md"
custom_content="$(cat "$custom_file")"

assert_contains \
  "custom title is preserved" \
  "$custom_content" \
  'title: "Custom Session Title"'

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-session" \
      update Invalid_Slug 2>&1
)"
status=$?
set -e

assert_status \
  "invalid slug exits with error" \
  "$status" \
  1

assert_contains \
  "invalid slug reports validation problem" \
  "$output" \
  "Invalid session update slug"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if [[ "$failed" -gt 0 ]]; then
  exit 1
fi
