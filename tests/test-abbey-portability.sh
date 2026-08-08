#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ABBEY_TOOLKIT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY="$ABBEY_TOOLKIT_ROOT/tools/bin/abbey"

test_root="$(mktemp -d)"
project="$test_root/portable-project"
log_file="$test_root/commands.log"

trap 'rm -rf "$test_root"' EXIT

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

assert_contains() {
  local label="$1"
  local expected="$2"
  local actual="$3"

  if grep -Fq -- "$expected" <<<"$actual"; then
    pass "$label"
  else
    fail "$label"
  fi
}

assert_file() {
  local label="$1"
  local path="$2"

  if [[ -f "$path" ]]; then
    pass "$label"
  else
    fail "$label"
  fi
}

run_in_project() {
  local label="$1"
  local working_directory="$2"
  shift 2

  local output
  local status

  output="$(
    cd "$working_directory" &&
      "$ABBEY" "$@"
  2>&1)"
  status=$?

  {
    printf '\n== %s ==\n' "$label"
    printf 'COMMAND: abbey %s\n' "$*"
    printf 'STATUS: %s\n' "$status"
    printf '%s\n' "$output"
  } >> "$log_file"

  if (( status == 0 )); then
    pass "$label"
  else
    fail "$label"
    printf '%s\n' "$output"
  fi
}

printf 'Abbey External Project Portability Tests\n'
printf '========================================\n\n'

if "$ABBEY" init \
  "$project" \
  --name "Portable Project" \
  --description "Temporary external Abbey project." \
  --yes \
  >/tmp/abbey-portability-init.out 2>&1
then
  pass "external project initializes"
else
  fail "external project initializes"
  cat /tmp/abbey-portability-init.out
fi

nested="$project/docs/planning/nested"
mkdir -p "$nested"

run_in_project \
  "knowledge build uses toolkit implementation" \
  "$project" \
  knowledge build

assert_file \
  "knowledge snapshot is written inside project" \
  "$project/.abbey/knowledge/snapshot.md"

assert_file \
  "knowledge metadata is written inside project" \
  "$project/.abbey/knowledge/metadata.json"

knowledge_status="$(
  cd "$project" &&
    "$ABBEY" knowledge status
  2>&1
)"
knowledge_status_rc=$?

printf '%s\n' "$knowledge_status" >> "$log_file"

if (( knowledge_status_rc == 0 )); then
  pass "knowledge status succeeds externally"
else
  fail "knowledge status succeeds externally"
fi

assert_contains \
  "external knowledge is fresh" \
  "Repository:  FRESH" \
  "$knowledge_status"

run_in_project \
  "brief context uses external project" \
  "$project" \
  context brief

assert_file \
  "context is written inside project" \
  "$project/.abbey/context/current.md"

run_in_project \
  "full context locates toolkit knowledge command" \
  "$nested" \
  context full

context_path="$(
  cd "$nested" &&
    "$ABBEY" context path
  2>&1
)"
context_path_rc=$?
canonical_project="$(cd "$project" && pwd -P)"

printf '%s\n' "$context_path" >> "$log_file"

if (( context_path_rc == 0 )) &&
   [[ "$context_path" == "$canonical_project/.abbey/context/current.md" ]]; then
  pass "nested context path resolves to project root"
else
  fail "nested context path resolves to project root"
fi

run_in_project \
  "AI rebuild locates toolkit knowledge command" \
  "$nested" \
  ai rebuild

run_in_project \
  "AI help loads toolkit configuration" \
  "$nested" \
  ai help

run_in_project \
  "research status locates toolkit helper" \
  "$nested" \
  research status

run_in_project \
  "docs generation locates toolkit generators" \
  "$project" \
  docs generate

assert_file \
  "CLI reference is generated inside project" \
  "$project/docs/generated/CLI_REFERENCE.md"

assert_file \
  "command reference is generated inside project" \
  "$project/docs/generated/abbey-commands.md"

mkdir -p \
  "$project/.abbey/ai" \
  "$project/.abbey/context" \
  "$project/.abbey/knowledge"

touch \
  "$project/.abbey/ai/history.json" \
  "$project/.abbey/context/current.md" \
  "$project/.abbey/knowledge/runtime-test.md" \
  "$project/.abbey/config.conf"

for runtime_file in \
  .abbey/ai/history.json \
  .abbey/context/current.md \
  .abbey/knowledge/runtime-test.md \
  .abbey/config.conf
do
  if git -C "$project" check-ignore -q "$runtime_file"; then
    pass "runtime state ignored: $runtime_file"
  else
    fail "runtime state ignored: $runtime_file"
  fi
done

for project_file in \
  .abbey/project.yml \
  .abbey/session-guidance.md
do
  if git -C "$project" check-ignore -q "$project_file"; then
    fail "project file remains trackable: $project_file"
  else
    pass "project file remains trackable: $project_file"
  fi
done

set +e
end_output="$(
  cd "$project" &&
    "$ABBEY" end
  2>&1
)"
end_status=$?
set -e

{
  printf '\n== abbey end ==\n'
  printf 'STATUS: %s\n' "$end_status"
  printf '%s\n' "$end_output"
} >> "$log_file"

if grep -Fq "Abbey Backlog command not found" <<<"$end_output"; then
  fail "abbey end locates toolkit backlog command"
else
  pass "abbey end locates toolkit backlog command"
fi

if grep -Fq "Abbey Doctor command not found" <<<"$end_output"; then
  fail "abbey end locates toolkit doctor command"
else
  pass "abbey end locates toolkit doctor command"
fi

if grep -Fq "$project/tools/" "$log_file"; then
  fail "commands do not load toolkit files from project root"
else
  pass "commands do not load toolkit files from project root"
fi

if grep -Fq "No such file or directory" "$log_file"; then
  fail "commands produce no missing toolkit-file errors"
else
  pass "commands produce no missing toolkit-file errors"
fi

if grep -Fq "fatal: your current branch" "$log_file"; then
  fail "unborn repositories produce no Git fatal output"
else
  pass "unborn repositories produce no Git fatal output"
fi

if grep -RInE \
  'readarray|mapfile|\$\{[^}]+,,\}|\$\{[^}]+\^\^\}' \
  "$ABBEY_TOOLKIT_ROOT/tools/bin" \
  >/dev/null
then
  fail "runtime commands avoid Bash 4-only constructs"
else
  pass "runtime commands avoid Bash 4-only constructs"
fi

if grep -RInE \
  'sed[[:space:]]+-i([[:space:]]|$)' \
  "$ABBEY_TOOLKIT_ROOT/tests" \
  >/dev/null
then
  fail "tests avoid platform-specific sed in-place syntax"
else
  pass "tests avoid platform-specific sed in-place syntax"
fi

printf '\nPassed: %d\n' "$passed"
printf 'Failed: %d\n' "$failed"

if (( failed > 0 )); then
  printf '\nCommand log:\n'
  cat "$log_file"
  exit 1
fi
