#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY_AI="$ABBEY_ROOT/tools/bin/abbey-ai"

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

assert_not_contains() {
  local name="$1"
  local output="$2"
  local unexpected="$3"

  if grep -Fq -- "$unexpected" <<<"$output"; then
    fail "$name"
    echo "     Unexpected: $unexpected"
  else
    pass "$name"
  fi
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

create_fixture() {
  local fixture_root

  fixture_root="$(mktemp -d)"

  mkdir -p \
    "$fixture_root/tools/lib" \
    "$fixture_root/config/ai/decisions/alpha" \
    "$fixture_root/config/ai/decisions/beta" \
    "$fixture_root/config/ai/decisions/broken" \
    "$fixture_root/config/ai/decisions/incomplete"

  cp "$ABBEY_ROOT/tools/lib/config.sh" \
    "$fixture_root/tools/lib/config.sh"

  cat > "$fixture_root/config/abbey.conf" <<'CONFIG'
OPEN_WEBUI_URL="http://localhost:3000"
ABBEY_KNOWLEDGE_FILE=".abbey/knowledge/snapshot.md"
OLLAMA_URL="http://localhost:11434"
ABBEY_AI_DECISION_MODEL="test-model"
CONFIG

  cat > "$fixture_root/config/ai/decisions/alpha/decision.json" <<'JSON'
{
  "name": "Alpha Decision",
  "description": "Choose the best alpha option."
}
JSON

  cat > "$fixture_root/config/ai/decisions/beta/decision.json" <<'JSON'
{
  "name": "Beta Decision",
  "description": "Choose the best beta option."
}
JSON

  cat > "$fixture_root/config/ai/decisions/broken/decision.json" <<'JSON'
{
  "name": "Broken Decision",
  "description":
}
JSON

  printf '%s\n' "$fixture_root"
}

echo "Abbey AI Regression Tests"
echo "========================="
echo

fixture_root="$(create_fixture)"
trap 'rm -rf "${fixture_root:-}"' EXIT

set +e
output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_AI" decide --help 2>&1)"
status=$?
set -e

assert_status \
  "--help exits successfully" \
  "$status" \
  0

assert_contains \
  "--help shows command usage" \
  "$output" \
  "abbey ai decide [--model MODEL] <decision>"

assert_contains \
  "--help lists synthetic decision id" \
  "$output" \
  "alpha"

assert_contains \
  "--help lists friendly decision name" \
  "$output" \
  "Alpha Decision"

assert_contains \
  "--help lists metadata description" \
  "$output" \
  "Choose the best alpha option."

assert_contains \
  "--help lists second metadata decision" \
  "$output" \
  "Beta Decision"

assert_not_contains \
  "--help ignores invalid JSON" \
  "$output" \
  "Broken Decision"

assert_not_contains \
  "--help ignores directories without metadata" \
  "$output" \
  "incomplete"

set +e
output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_AI" decide help 2>&1)"
status=$?
set -e

assert_status \
  "help argument exits successfully" \
  "$status" \
  0

assert_contains \
  "help argument shows decision listing" \
  "$output" \
  "Alpha Decision"

set +e
output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_AI" decide 2>&1)"
status=$?
set -e

assert_status \
  "missing decision exits with error" \
  "$status" \
  1

assert_contains \
  "missing decision still shows help" \
  "$output" \
  "Available decisions:"

set +e
output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_AI" decide --bogus 2>&1)"
status=$?
set -e

assert_status \
  "unknown option exits with error" \
  "$status" \
  1

assert_contains \
  "unknown option reports the option" \
  "$output" \
  "Unknown option: --bogus"

mv \
  "$fixture_root/config/ai/decisions" \
  "$fixture_root/config/ai/decisions.saved"

set +e
output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_AI" decide --help 2>&1)"
status=$?
set -e

assert_status \
  "missing decisions directory help exits successfully" \
  "$status" \
  0

assert_contains \
  "missing decisions directory reports none" \
  "$output" \
  "None"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if [[ "$failed" -gt 0 ]]; then
  exit 1
fi
