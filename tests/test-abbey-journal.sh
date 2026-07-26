#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY_JOURNAL="$ABBEY_ROOT/tools/bin/abbey-journal"

passed=0
failed=0
test_root="$(mktemp -d)"
fixture_root="$test_root/repo"
fake_bin="$test_root/fake-bin"
editor_log="$test_root/editor.log"

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

assert_file_absent() {
  local name="$1"
  local path="$2"

  if [[ ! -e "$path" ]]; then
    pass "$name"
  else
    fail "$name"
    echo "     Unexpected file: $path"
  fi
}

run_journal() {
  set +e
  output="$(
    env \
      ABBEY_ROOT="$fixture_root" \
      ABBEY_TEST_EDITOR_LOG="$editor_log" \
      PATH="$fake_bin:$PATH" \
      "$ABBEY_JOURNAL" "$@" 2>&1
  )"
  status=$?
  set -e
}

mkdir -p "$fixture_root/content/journal" "$fake_bin"

cat > "$fake_bin/vi" <<'SCRIPT'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$1" > "${ABBEY_TEST_EDITOR_LOG:?}"
SCRIPT

chmod +x "$fake_bin/vi"

echo "Abbey Journal Regression Tests"
echo "=============================="
echo

run_journal --help

assert_status \
  "--help exits successfully" \
  "$status" \
  0

assert_contains \
  "--help shows usage" \
  "$output" \
  "abbey journal <journal title>"

assert_file_absent \
  "--help does not open the editor" \
  "$editor_log"

if find "$fixture_root/content/journal" -type f -print -quit | grep -q .; then
  fail "--help does not create a journal entry"
else
  pass "--help does not create a journal entry"
fi

run_journal help

assert_status \
  "help command exits successfully" \
  "$status" \
  0

assert_contains \
  "help command shows usage" \
  "$output" \
  "Abbey Journal"

run_journal

assert_status \
  "missing title exits with failure" \
  "$status" \
  1

assert_contains \
  "missing title shows usage" \
  "$output" \
  "abbey journal <journal title>"

run_journal "Abbey Site Live Verification"

expected_file="$fixture_root/content/journal/$(date +%Y)/$(date +%F)-abbey-site-live-verification.md"

assert_status \
  "journal creation exits successfully" \
  "$status" \
  0

assert_file_exists \
  "journal creation writes the expected file" \
  "$expected_file"

assert_contains \
  "journal creation writes the title" \
  "$(cat "$expected_file")" \
  'title: "Abbey Site Live Verification"'

assert_contains \
  "journal creation opens the expected file" \
  "$(cat "$editor_log")" \
  "$expected_file"

run_journal --title "Explicit Journal Title"

title_file="$fixture_root/content/journal/$(date +%Y)/$(date +%F)-explicit-journal-title.md"

assert_status \
  "--title exits successfully" \
  "$status" \
  0

assert_file_exists \
  "--title creates the expected journal file" \
  "$title_file"

assert_contains \
  "--title preserves the supplied title" \
  "$(cat "$title_file")" \
  'title: "Explicit Journal Title"'

assert_contains \
  "--title opens the expected journal file" \
  "$(cat "$editor_log")" \
  "$title_file"

run_journal \
  --no-edit \
  --title "Explicit Journal Slug" \
  --slug manually-selected-journal

slug_file="$fixture_root/content/journal/$(date +%Y)/$(date +%F)-manually-selected-journal.md"

assert_status \
  "--slug exits successfully" \
  "$status" \
  0

assert_file_exists \
  "--slug controls the journal filename" \
  "$slug_file"

assert_contains \
  "--slug preserves the supplied title" \
  "$(cat "$slug_file")" \
  'title: "Explicit Journal Slug"'

run_journal \
  --no-edit \
  --title "Invalid Journal Slug" \
  --slug Invalid_Slug

assert_status \
  "invalid --slug fails" \
  "$status" \
  1

assert_contains \
  "invalid --slug explains the problem" \
  "$output" \
  "FAIL Invalid journal slug: Invalid_Slug"

rm -f "$editor_log"

run_journal --no-edit --title "Noninteractive Journal"

no_edit_file="$fixture_root/content/journal/$(date +%Y)/$(date +%F)-noninteractive-journal.md"

assert_status \
  "--no-edit exits successfully" \
  "$status" \
  0

assert_file_exists \
  "--no-edit creates the expected journal file" \
  "$no_edit_file"

assert_contains \
  "--no-edit reports the created path" \
  "$output" \
  "Journal entry created:"

assert_file_absent \
  "--no-edit does not open the editor" \
  "$editor_log"

run_journal --no-edit --title "Noninteractive Journal"

assert_status \
  "--no-edit rerun exits successfully" \
  "$status" \
  0

assert_contains \
  "--no-edit rerun reports the existing entry" \
  "$output" \
  "Journal entry already exists:"

assert_file_absent \
  "--no-edit rerun does not open the editor" \
  "$editor_log"

run_journal --title

assert_status \
  "--title without a value fails" \
  "$status" \
  1

assert_contains \
  "--title without a value explains the error" \
  "$output" \
  "FAIL --title requires a value."

run_journal --title Unquoted Multi Word Title

assert_status \
  "unquoted --title value fails" \
  "$status" \
  1

assert_contains \
  "unquoted --title value explains quoting" \
  "$output" \
  "Quote multi-word titles as one argument."

run_journal --bogus

assert_status \
  "unknown option exits with failure" \
  "$status" \
  1

assert_contains \
  "unknown option reports the option" \
  "$output" \
  "FAIL Unknown option: --bogus"

assert_file_absent \
  "unknown option does not create a journal entry" \
  "$fixture_root/content/journal/$(date +%Y)/$(date +%F)-bogus.md"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if ((failed > 0)); then
  exit 1
fi
