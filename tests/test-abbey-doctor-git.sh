#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

passed=0
failed=0
fixture_root="$(mktemp -d)"
trap 'rm -rf "$fixture_root"' EXIT

pass() {
  echo "PASS $1"
  passed=$((passed + 1))
}

fail() {
  echo "FAIL $1"
  failed=$((failed + 1))
}

assert_contains() {
  local name="$1"
  local output="$2"
  local expected="$3"

  if [[ "$output" == *"$expected"* ]]; then
    pass "$name"
  else
    fail "$name"
    echo "     Expected output to contain: $expected"
    echo "     Actual output:"
    printf '%s\n' "$output" | sed 's/^/       /'
  fi
}

run_git_check() {
  local repository="$1"

  (
    ABBEY_ROOT="$repository"
    source "$PROJECT_ROOT/tools/doctor/lib/output.sh"
    source "$PROJECT_ROOT/tools/doctor/checks/01-git.sh"
  )
}

configured_repo="$fixture_root/configured"
missing_repo="$fixture_root/missing"

git init -q "$configured_repo"
git -C "$configured_repo" config user.name "Abbey Test"
git -C "$configured_repo" config user.email "abbey-test@example.invalid"

configured_output="$(
  GIT_CONFIG_GLOBAL=/dev/null \
    GIT_CONFIG_SYSTEM=/dev/null \
    run_git_check "$configured_repo"
)"

assert_contains \
  "configured user.name is reported" \
  "$configured_output" \
  "OK   Git user.name configured: Abbey Test"
assert_contains \
  "user.name source is reported" \
  "$configured_output" \
  "OK   Git user.name source: file:.git/config"
assert_contains \
  "configured user.email is reported" \
  "$configured_output" \
  "OK   Git user.email configured: abbey-test@example.invalid"
assert_contains \
  "user.email source is reported" \
  "$configured_output" \
  "OK   Git user.email source: file:.git/config"

git init -q "$missing_repo"

missing_output="$(
  GIT_CONFIG_GLOBAL=/dev/null \
    GIT_CONFIG_SYSTEM=/dev/null \
    run_git_check "$missing_repo"
)"

assert_contains \
  "missing user.name fails the check" \
  "$missing_output" \
  "FAIL Git user.name is not configured"
assert_contains \
  "missing user.email fails the check" \
  "$missing_output" \
  "FAIL Git user.email is not configured"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if [[ "$failed" -gt 0 ]]; then
  exit 1
fi
