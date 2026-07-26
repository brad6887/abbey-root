#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY_BACKLOG="$ABBEY_ROOT/tools/bin/abbey-backlog"

passed=0
failed=0
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

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
  local actual="$2"
  local expected="$3"

  if grep -Fq -- "$expected" <<<"$actual"; then
    pass "$name"
  else
    fail "$name"
    echo "     Expected: $expected"
  fi
}

create_backlog() {
  local name="$1"
  local path="$test_root/$name/BACKLOG.md"

  mkdir -p "$(dirname "$path")"
  cp "$test_root/source.md" "$path"
  printf '%s\n' "$path"
}

run_backlog() {
  local backlog_file="$1"
  shift

  set +e
  output="$(
    env \
      ABBEY_ROOT="$test_root" \
      ABBEY_BACKLOG_FILE="$backlog_file" \
      "$ABBEY_BACKLOG" "$@" 2>&1
  )"
  status=$?
  set -e
}

cat > "$test_root/source.md" <<'MARKDOWN'
# Test Backlog

Introductory text.

## First

- [x] Complete item.
- [ ] Pending item.
  - [X] Nested complete item.
- ordinary bullet

## Second

- [ ] Another pending item.
MARKDOWN

echo "Abbey Backlog Regression Tests"
echo "=============================="
echo

backlog_file="$(create_backlog missing)"
run_backlog "$backlog_file" check

assert_status "missing block fails check" "$status" 1
assert_contains \
  "missing block explains refresh command" \
  "$output" \
  "Generated backlog status block is missing"

run_backlog "$backlog_file" refresh

assert_status "refresh inserts a missing block" "$status" 0
assert_contains \
  "refresh reports complete, pending, and total counts" \
  "$(cat "$backlog_file")" \
  "> **Backlog Status:** 2 complete · 2 pending · 4 total"
assert_contains \
  "refresh writes the begin marker" \
  "$(cat "$backlog_file")" \
  "<!-- BEGIN GENERATED BACKLOG STATUS -->"
assert_contains \
  "refresh writes the end marker" \
  "$(cat "$backlog_file")" \
  "<!-- END GENERATED BACKLOG STATUS -->"

run_backlog "$backlog_file" check
assert_status "generated block passes check" "$status" 0

before_hash="$(git hash-object "$backlog_file")"
run_backlog "$backlog_file" refresh
after_hash="$(git hash-object "$backlog_file")"

assert_status "second refresh succeeds" "$status" 0
if [[ "$before_hash" == "$after_hash" ]]; then
  pass "refresh is idempotent"
else
  fail "refresh is idempotent"
fi

sed 's/2 complete · 2 pending · 4 total/99 complete · 0 pending · 99 total/' \
  "$backlog_file" > "$test_root/stale.md"
run_backlog "$test_root/stale.md" check

assert_status "incorrect counts fail check" "$status" 1
assert_contains \
  "incorrect counts are reported as stale" \
  "$output" \
  "statistics are stale or incorrectly formatted"

run_backlog "$test_root/stale.md" refresh
assert_status "refresh repairs stale counts" "$status" 0
assert_contains \
  "refresh restores canonical formatting" \
  "$(cat "$test_root/stale.md")" \
  "> **Backlog Status:** 2 complete · 2 pending · 4 total"

malformed_file="$(create_backlog malformed)"
{
  sed -n '1p' "$malformed_file"
  echo
  echo "<!-- BEGIN GENERATED BACKLOG STATUS -->"
  sed -n '2,$p' "$malformed_file"
} > "$test_root/malformed-content.md"
mv "$test_root/malformed-content.md" "$malformed_file"
malformed_hash="$(git hash-object "$malformed_file")"

run_backlog "$malformed_file" refresh

assert_status "malformed block fails refresh" "$status" 1
assert_contains \
  "malformed block explains the problem" \
  "$output" \
  "malformed generated status block"

if [[ "$malformed_hash" == "$(git hash-object "$malformed_file")" ]]; then
  pass "malformed block is not modified"
else
  fail "malformed block is not modified"
fi

duplicate_file="$(create_backlog duplicate)"
{
  sed -n '1p' "$duplicate_file"
  echo
  echo "<!-- BEGIN GENERATED BACKLOG STATUS -->"
  echo "> **Backlog Status:** 2 complete · 2 pending · 4 total"
  echo "<!-- END GENERATED BACKLOG STATUS -->"
  echo "<!-- BEGIN GENERATED BACKLOG STATUS -->"
  echo "> **Backlog Status:** 2 complete · 2 pending · 4 total"
  echo "<!-- END GENERATED BACKLOG STATUS -->"
  sed -n '2,$p' "$duplicate_file"
} > "$test_root/duplicate-content.md"
mv "$test_root/duplicate-content.md" "$duplicate_file"

run_backlog "$duplicate_file" check
assert_status "duplicate blocks fail check" "$status" 1
assert_contains \
  "duplicate blocks explain the problem" \
  "$output" \
  "duplicate generated status markers"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if ((failed > 0)); then
  exit 1
fi
