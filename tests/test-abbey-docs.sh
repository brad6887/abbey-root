#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

passed=0
failed=0
test_root="$(mktemp -d)"
fixture_root="$test_root/repo"
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
  local expected="$2"

  if [[ "$status" -eq "$expected" ]]; then
    pass "$name"
  else
    fail "$name"
    echo "     Expected status: $expected"
    echo "     Actual status:   $status"
  fi
}

assert_contains() {
  local name="$1"
  local expected="$2"

  if grep -Fq -- "$expected" <<<"$output"; then
    pass "$name"
  else
    fail "$name"
    echo "     Expected: $expected"
  fi
}

assert_file() {
  local name="$1"
  local path="$2"

  if [[ -f "$path" ]]; then
    pass "$name"
  else
    fail "$name"
    echo "     Missing: $path"
  fi
}

run_docs() {
  set +e
  output="$(ABBEY_ROOT="$fixture_root" "$fixture_root/tools/bin/abbey-docs" "$@" 2>&1)"
  status=$?
  set -e
}

mkdir -p \
  "$fixture_root/config/cli" \
  "$fixture_root/docs/generated" \
  "$fixture_root/scripts" \
  "$fixture_root/tools/bin"

cp "$ABBEY_ROOT/tools/bin/abbey-docs" "$fixture_root/tools/bin/abbey-docs"
cp "$ABBEY_ROOT/scripts/abbey_cli.py" "$fixture_root/scripts/abbey_cli.py"
cp "$ABBEY_ROOT/scripts/abbey_docs_index.py" "$fixture_root/scripts/abbey_docs_index.py"
cp \
  "$ABBEY_ROOT/tools/generate-command-docs.sh" \
  "$fixture_root/tools/generate-command-docs.sh"

chmod +x \
  "$fixture_root/tools/bin/abbey-docs" \
  "$fixture_root/scripts/abbey_cli.py" \
  "$fixture_root/scripts/abbey_docs_index.py" \
  "$fixture_root/tools/generate-command-docs.sh"

cat > "$fixture_root/config/cli/cli.yml" <<'YAML'
version: 1
cli:
  name: abbey
  description: Test Abbey Toolkit
categories:
  core:
    description: Core commands
commands:
  help:
    category: core
    description: Show help.
    usage: abbey help
    hidden: false
YAML

cat > "$fixture_root/tools/abbey-example" <<'SH'
#!/usr/bin/env bash
#
# Purpose:
#   Exercise deterministic command documentation.
#
# Usage:
#   abbey-example
#
exit 0
SH
chmod +x "$fixture_root/tools/abbey-example"

mkdir -p \
  "$fixture_root/docs/guide" \
  "$fixture_root/docs/architecture/research/example" \
  "$fixture_root/docs/research/example" \
  "$fixture_root/docs/session-updates"
printf '# Getting Started\n' > "$fixture_root/docs/guide/GETTING_STARTED.md"
printf 'No heading here.\n' > "$fixture_root/docs/guide/fallback-title.md"
printf '# Excluded Research\n' > "$fixture_root/docs/research/example/RESEARCH.md"
printf '# Excluded Nested Research\n' > "$fixture_root/docs/architecture/research/example/NESTED.md"
printf '# Excluded Session\n' > "$fixture_root/docs/session-updates/session.md"

echo "Abbey Docs Regression Tests"
echo "==========================="
echo

run_docs help
assert_status "help exits successfully" 0
assert_contains "help documents generate" "abbey docs generate"
assert_contains "help documents check" "abbey docs check"
assert_contains "help documents documentation index" "docs/generated/DOCUMENTATION_INDEX.md"
assert_contains \
  "help identifies Ansible documents as out of scope" \
  "outside this deterministic command"

run_docs generate
assert_status "generate exits successfully" 0
assert_file \
  "generate writes CLI reference" \
  "$fixture_root/docs/generated/CLI_REFERENCE.md"
assert_file \
  "generate writes command reference" \
  "$fixture_root/docs/generated/abbey-commands.md"
assert_file \
  "generate writes documentation index" \
  "$fixture_root/docs/generated/DOCUMENTATION_INDEX.md"
assert_contains \
  "generate reports completion" \
  "PASS Deterministic documentation generated."

cli_reference="$fixture_root/docs/generated/CLI_REFERENCE.md"
command_reference="$fixture_root/docs/generated/abbey-commands.md"
documentation_index="$fixture_root/docs/generated/DOCUMENTATION_INDEX.md"

if grep -Fq "Generated automatically from \`config/cli/cli.yml\`" "$cli_reference"; then
  pass "CLI reference identifies its authoritative source"
else
  fail "CLI reference identifies its authoritative source"
fi

if grep -Fq "Exercise deterministic command documentation." "$command_reference"; then
  pass "command reference is generated from tool headers"
else
  fail "command reference is generated from tool headers"
fi

if grep -Eq '^Generated:' "$command_reference"; then
  fail "command reference omits volatile timestamps"
else
  pass "command reference omits volatile timestamps"
fi

if grep -Fq '[Getting Started](../guide/GETTING_STARTED.md)' "$documentation_index"; then
  pass "documentation index links durable documents"
else
  fail "documentation index links durable documents"
fi

if grep -Fq '[Fallback Title](../guide/fallback-title.md)' "$documentation_index"; then
  pass "documentation index falls back from missing headings"
else
  fail "documentation index falls back from missing headings"
fi

if grep -Fq 'Excluded Research' "$documentation_index" ||
   grep -Fq 'Excluded Nested Research' "$documentation_index" ||
   grep -Fq 'Excluded Session' "$documentation_index"; then
  fail "documentation index excludes artifact collections"
else
  pass "documentation index excludes artifact collections"
fi

if grep -Fq '(DOCUMENTATION_INDEX.md)' "$documentation_index"; then
  fail "documentation index does not recursively index itself"
else
  pass "documentation index does not recursively index itself"
fi

run_docs check
assert_status "fresh generated documentation passes check" 0
assert_contains "fresh CLI reference is reported" "OK   CLI reference is current"
assert_contains "fresh command reference is reported" "OK   Command reference is current"

before_hashes="$(
  git hash-object "$cli_reference" "$command_reference" "$documentation_index"
)"
run_docs generate
after_hashes="$(
  git hash-object "$cli_reference" "$command_reference" "$documentation_index"
)"

if [[ "$before_hashes" == "$after_hashes" ]]; then
  pass "generation is idempotent"
else
  fail "generation is idempotent"
fi

printf '%s\n' 'stale content' >> "$cli_reference"
stale_hash="$(git hash-object "$cli_reference")"
run_docs check

assert_status "stale generated documentation fails check" 1
assert_contains \
  "stale generated documentation identifies the file" \
  "FAIL CLI reference is stale: docs/generated/CLI_REFERENCE.md"
assert_contains \
  "stale generated documentation explains the repair" \
  "Run: abbey docs generate"

if [[ "$stale_hash" == "$(git hash-object "$cli_reference")" ]]; then
  pass "check does not modify stale output"
else
  fail "check does not modify stale output"
fi

run_docs generate
printf '%s\n' 'stale index content' >> "$documentation_index"
stale_index_hash="$(git hash-object "$documentation_index")"
run_docs check

assert_status "stale documentation index fails check" 1
assert_contains \
  "stale documentation index identifies the file" \
  "FAIL Documentation index is stale: docs/generated/DOCUMENTATION_INDEX.md"

if [[ "$stale_index_hash" == "$(git hash-object "$documentation_index")" ]]; then
  pass "check does not modify stale documentation index"
else
  fail "check does not modify stale documentation index"
fi

run_docs generate
rm "$documentation_index"
run_docs check

assert_status "missing documentation index fails check" 1
assert_contains \
  "missing documentation index identifies the file" \
  "FAIL Missing generated document: docs/generated/DOCUMENTATION_INDEX.md"

run_docs generate
rm "$command_reference"
run_docs check

assert_status "missing generated documentation fails check" 1
assert_contains \
  "missing generated documentation identifies the file" \
  "FAIL Missing generated document: docs/generated/abbey-commands.md"

run_docs unknown
assert_status "unknown command fails" 1
assert_contains "unknown command is reported" "ERROR Unknown docs command: unknown"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if ((failed > 0)); then
  exit 1
fi
