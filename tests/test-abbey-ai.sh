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
    "$fixture_root/tools/bin" \
    "$fixture_root/tools/lib" \
    "$fixture_root/scripts" \
    "$fixture_root/ansible/inventory" \
    "$fixture_root/ansible/playbooks" \
    "$fixture_root/ansible/roles" \
    "$fixture_root/docs/planning" \
    "$fixture_root/docs/generated" \
    "$fixture_root/docs/runbooks" \
    "$fixture_root/docs/guides" \
    "$fixture_root/content/journal" \
    "$fixture_root/config/ai/decisions/alpha" \
    "$fixture_root/config/ai/decisions/beta" \
    "$fixture_root/config/ai/decisions/broken" \
    "$fixture_root/config/ai/decisions/incomplete"

  cp "$ABBEY_ROOT/tools/bin/abbey-knowledge" \
    "$fixture_root/tools/bin/abbey-knowledge"

  cp "$ABBEY_ROOT/tools/lib/config.sh" \
    "$fixture_root/tools/lib/config.sh"

  cp "$ABBEY_ROOT/scripts/abbey_knowledge_manifest.py" \
    "$fixture_root/scripts/abbey_knowledge_manifest.py"

  cat > "$fixture_root/config/abbey.conf" <<'CONFIG'
OPEN_WEBUI_URL="http://localhost:3000"
ABBEY_KNOWLEDGE_FILE=".abbey/knowledge/snapshot.md"
OLLAMA_URL="http://localhost:11434"
ABBEY_AI_DECISION_MODEL="test-model"
ABBEY_AI_AUTO_BUILD_KNOWLEDGE="true"
CONFIG

  cat > "$fixture_root/ansible/inventory/hosts.yml" <<'YAML'
all:
  hosts:
    test01:
YAML

  for file in PROJECT_STATUS NEXT ROADMAP BACKLOG; do
    printf '# %s\n' "$file" \
      > "$fixture_root/docs/planning/$file.md"
  done

  printf '# Abbey CLI\n' \
    > "$fixture_root/docs/guides/abbey-cli.md"

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


ABBEY_ROOT="$fixture_root" \
  "$fixture_root/tools/bin/abbey-knowledge" build \
  >/dev/null

initial_hash="$(
  python3 -c '
import json
import sys
print(json.load(open(sys.argv[1]))["repository_hash"])
' "$fixture_root/.abbey/knowledge/metadata.json"
)"

printf '\n- auto-build freshness change\n' \
  >> "$fixture_root/docs/planning/BACKLOG.md"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$ABBEY_AI" context 2>&1
)"
status=$?
set -e

rebuilt_hash="$(
  python3 -c '
import json
import sys
print(json.load(open(sys.argv[1]))["repository_hash"])
' "$fixture_root/.abbey/knowledge/metadata.json"
)"

set +e
ABBEY_ROOT="$fixture_root" \
  "$fixture_root/tools/bin/abbey-knowledge" status \
  >/tmp/abbey-ai-auto-status.out 2>&1
auto_status=$?
set -e

assert_status \
  "AI context succeeds when auto-build refreshes stale knowledge" \
  "$status" \
  0

if [[ "$rebuilt_hash" != "$initial_hash" ]]; then
  pass "AI context rebuilds stale knowledge when auto-build is enabled"
else
  fail "AI context rebuilds stale knowledge when auto-build is enabled"
fi

assert_status \
  "auto-built knowledge reports fresh" \
  "$auto_status" \
  0

sed -i \
  's/ABBEY_AI_AUTO_BUILD_KNOWLEDGE="true"/ABBEY_AI_AUTO_BUILD_KNOWLEDGE="false"/' \
  "$fixture_root/config/abbey.conf"

disabled_hash_before="$(
  python3 -c '
import json
import sys
print(json.load(open(sys.argv[1]))["repository_hash"])
' "$fixture_root/.abbey/knowledge/metadata.json"
)"

printf '\n- disabled freshness change\n' \
  >> "$fixture_root/docs/planning/BACKLOG.md"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$ABBEY_AI" context 2>&1
)"
status=$?
set -e

disabled_hash_after="$(
  python3 -c '
import json
import sys
print(json.load(open(sys.argv[1]))["repository_hash"])
' "$fixture_root/.abbey/knowledge/metadata.json"
)"

assert_status \
  "AI context exits nonzero when stale auto-build is disabled" \
  "$status" \
  1

assert_contains \
  "disabled auto-build reports stale knowledge" \
  "$output" \
  "WARN Abbey knowledge is stale"

if [[ "$disabled_hash_after" == "$disabled_hash_before" ]]; then
  pass "disabled auto-build leaves knowledge metadata unchanged"
else
  fail "disabled auto-build leaves knowledge metadata unchanged"
fi

echo
echo "Passed: $passed"
echo "Failed: $failed"

if [[ "$failed" -gt 0 ]]; then
  exit 1
fi
