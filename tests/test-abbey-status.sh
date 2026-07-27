#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
METRICS_CHECK="$ABBEY_ROOT/tools/status/checks/07-project-metrics.sh"
OUTPUT_LIBRARY="$ABBEY_ROOT/tools/status/lib/output.sh"

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

run_metrics() {
  local fixture_root="$1"

  output="$(
    ABBEY_ROOT="$fixture_root" \
      bash -c 'source "$1"; source "$2"' \
      _ "$OUTPUT_LIBRARY" "$METRICS_CHECK"
  )"
}

fixture_root="$test_root/complete"
mkdir -p \
  "$fixture_root/tools/bin" \
  "$fixture_root/site/src/pages/projects" \
  "$fixture_root/content/journal/2026" \
  "$fixture_root/docs/planning"

touch \
  "$fixture_root/tools/bin/abbey-status" \
  "$fixture_root/tools/bin/abbey-doctor" \
  "$fixture_root/tools/bin/not-an-abbey-command"
chmod +x \
  "$fixture_root/tools/bin/abbey-status" \
  "$fixture_root/tools/bin/abbey-doctor" \
  "$fixture_root/tools/bin/not-an-abbey-command"
touch "$fixture_root/tools/bin/abbey-not-executable"

touch \
  "$fixture_root/site/src/pages/index.astro" \
  "$fixture_root/site/src/pages/projects/[slug].astro" \
  "$fixture_root/site/src/pages/ignored.md"
touch \
  "$fixture_root/content/journal/2026/first.md" \
  "$fixture_root/content/journal/2026/second.md" \
  "$fixture_root/content/journal/2026/ignored.txt"
touch \
  "$fixture_root/docs/README.md" \
  "$fixture_root/docs/planning/BACKLOG.md" \
  "$fixture_root/docs/planning/ignored.txt"

echo "Abbey Status Regression Tests"
echo "============================="
echo

run_metrics "$fixture_root"

assert_contains "project metrics section is shown" "$output" "Project Metrics"
assert_contains "executable Abbey command wrappers are counted" "$output" "INFO Toolkit commands: 2"
assert_contains "Astro page routes are counted" "$output" "INFO Website pages: 2"
assert_contains "journal Markdown entries are counted" "$output" "INFO Journal entries: 2"
assert_contains "documentation Markdown files are counted" "$output" "INFO Documentation files: 2"

missing_root="$test_root/missing"
mkdir -p "$missing_root"
run_metrics "$missing_root"

assert_contains "missing toolkit directory fails safely" "$output" "INFO Toolkit commands: Unavailable"
assert_contains "missing website directory fails safely" "$output" "INFO Website pages: Unavailable"
assert_contains "missing journal directory fails safely" "$output" "INFO Journal entries: Unavailable"
assert_contains "missing documentation directory fails safely" "$output" "INFO Documentation files: Unavailable"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if ((failed > 0)); then
  exit 1
fi
