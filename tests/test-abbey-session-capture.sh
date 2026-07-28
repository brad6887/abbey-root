#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY_TOOLKIT_ROOT="$ABBEY_ROOT"

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
  "$fixture_root/docs/session-updates" \
  "$fixture_root/content/journal"

run_capture() {
  set +e
  output="$(
    ABBEY_ROOT="$fixture_root" \
      ABBEY_TOOLKIT_ROOT="$ABBEY_TOOLKIT_ROOT" \
      "$ABBEY_TOOLKIT_ROOT/tools/bin/abbey-session" \
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

assert_contains \
  "capture stores resolved slug as session state" \
  "$(cat "$session_file")" \
  "session: guided-session-capture-workflow"

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

run_capture --title "Automatic Session Slug"

automatic_session="$fixture_root/docs/session-updates/${date_value}-automatic-session-slug.md"
automatic_journal="$fixture_root/content/journal/${year_value}/${date_value}-automatic-session-slug.md"

assert_status \
  "title-only capture exits successfully" \
  "$status" \
  0

assert_file_exists \
  "title-only capture derives session filename" \
  "$automatic_session"

assert_file_exists \
  "title-only capture reuses slug for journal filename" \
  "$automatic_journal"

assert_contains \
  "title-only capture reports resolved slug" \
  "$output" \
  "Session slug: automatic-session-slug"

assert_contains \
  "title-only capture stores resolved slug" \
  "$(cat "$automatic_session")" \
  "session: automatic-session-slug"

run_capture \
  --title "Override Session Slug" \
  --slug manually-selected-slug

override_session="$fixture_root/docs/session-updates/${date_value}-manually-selected-slug.md"
override_journal="$fixture_root/content/journal/${year_value}/${date_value}-manually-selected-slug.md"

assert_status \
  "explicit capture slug exits successfully" \
  "$status" \
  0

assert_file_exists \
  "explicit capture slug controls session filename" \
  "$override_session"

assert_file_exists \
  "explicit capture slug controls journal filename" \
  "$override_journal"

assert_contains \
  "explicit capture slug is stored as session state" \
  "$(cat "$override_session")" \
  "session: manually-selected-slug"

mkdir -p "$fixture_root/.abbey"
cat > "$fixture_root/.abbey/project.yml" <<'YAML'
schema_version: 1
project:
  name: External Project
workflow:
  journal:
    policy: event-driven
YAML

run_capture --title "External Event Driven"

event_session="$fixture_root/docs/session-updates/${date_value}-external-event-driven.md"
event_journal="$fixture_root/content/journal/${year_value}/${date_value}-external-event-driven.md"

assert_status "event-driven capture succeeds without a journal" "$status" 0
assert_file_exists "event-driven capture creates session update" "$event_session"
[[ ! -e "$event_journal" ]] &&
  pass "event-driven capture does not create a journal by default" ||
  fail "event-driven capture does not create a journal by default"
assert_contains \
  "event-driven capture explains the journal policy" \
  "$output" \
  "Journal entry not created (policy: event-driven)"

run_capture --journal --title "Explicit External Journal"

explicit_journal="$fixture_root/content/journal/${year_value}/${date_value}-explicit-external-journal.md"
assert_status "event-driven capture accepts --journal" "$status" 0
assert_file_exists "event-driven --journal uses toolkit journal command" "$explicit_journal"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if ((failed > 0)); then
  exit 1
fi
