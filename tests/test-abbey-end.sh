#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY_END="$ABBEY_ROOT/tools/bin/abbey-end"

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

create_fixture() {
  local name="$1"
  local journal_policy="${2:-required}"
  local fixture_root="$test_root/$name"

  mkdir -p \
    "$fixture_root/.abbey" \
    "$fixture_root/tools/bin" \
    "$fixture_root/tools/lib" \
    "$fixture_root/docs/planning" \
    "$fixture_root/docs/session-updates" \
    "$fixture_root/content/journal/2026"

  cp "$ABBEY_END" "$fixture_root/tools/bin/abbey-end"
  cp "$ABBEY_ROOT/tools/lib/project.sh" "$fixture_root/tools/lib/project.sh"

  cat > "$fixture_root/tools/bin/abbey-backlog" <<'SH'
#!/usr/bin/env bash
exit 0
SH

  cat > "$fixture_root/tools/bin/abbey-doctor" <<'SH'
#!/usr/bin/env bash
echo "Failures: 0"
exit 0
SH

  chmod +x "$fixture_root/tools/bin/"*

  cat > "$fixture_root/.abbey/project.yml" <<EOF
workflow:
  journal:
    policy: $journal_policy
EOF

  printf '%s\n' '# Test Backlog' > "$fixture_root/docs/planning/BACKLOG.md"

  git -C "$fixture_root" init -q
  git -C "$fixture_root" config user.name "Abbey Test"
  git -C "$fixture_root" config user.email "abbey-test@example.invalid"
  git -C "$fixture_root" add .
  git -C "$fixture_root" commit -qm "Create Abbey End fixture"

  printf '%s\n' "$fixture_root"
}

write_session_update() {
  local path="$1"
  local title="$2"
  local status_value="$3"
  local reviewed_value="$4"

  cat > "$path" <<EOF
---
title: "$title"
description: "Test session update."
date: 2026-07-26
status: $status_value
reviewed: $reviewed_value
session: test
tags:
  - Abbey Root
---

# $title
EOF
}

write_journal() {
  local path="$1"

  cat > "$path" <<'EOF'
---
title: "Test Journal"
description: "Test journal entry."
pubDate: 2026-07-26
tags:
  - Abbey Root
---

# Test Journal
EOF
}

run_end() {
  local fixture_root="$1"

  set +e
  output="$(ABBEY_ROOT="$fixture_root" "$fixture_root/tools/bin/abbey-end" 2>&1)"
  status=$?
  set -e
}

echo "Abbey End Regression Tests"
echo "=========================="
echo

fixture_root="$(create_fixture reconciliation-only)"
session_file="$fixture_root/docs/session-updates/2026-07-01-reconciliation.md"
write_session_update "$session_file" "Reconciliation" complete false
git -C "$fixture_root" add "$session_file"
git -C "$fixture_root" commit -qm "Capture completed session"

write_session_update "$session_file" "Reconciliation" complete true
printf '%s\n' 'Reconciled planning.' >> "$fixture_root/docs/planning/BACKLOG.md"
git -C "$fixture_root" add "$session_file" "$fixture_root/docs/planning/BACKLOG.md"
git -C "$fixture_root" commit -qm "Reconcile completed session"

run_end "$fixture_root"
assert_status "reconciliation-only commit passes without a journal" 0
assert_contains \
  "reconciliation-only commit explains the journal exception" \
  "OK   Journal entry not required for reconciliation-only commit"
assert_contains \
  "reconciliation-only commit completes the session" \
  "Session Complete"

fixture_root="$(create_fixture new-session)"
session_file="$fixture_root/docs/session-updates/2026-07-02-new-session.md"
write_session_update "$session_file" "New Session" complete false
git -C "$fixture_root" add "$session_file"
git -C "$fixture_root" commit -qm "Add session without journal"

run_end "$fixture_root"
assert_status "new session still requires a journal" 1
assert_contains \
  "new session reports the missing journal" \
  "FAIL Latest commit does not contain a journal entry (policy: required)"

for journal_policy in event-driven optional; do
  fixture_root="$(create_fixture "$journal_policy-policy" "$journal_policy")"
  session_file="$fixture_root/docs/session-updates/2026-07-02-$journal_policy.md"
  write_session_update "$session_file" "$journal_policy Session" complete false
  git -C "$fixture_root" add "$session_file"
  git -C "$fixture_root" commit -qm "Add session without journal"

  run_end "$fixture_root"
  assert_status "$journal_policy policy passes without a journal" 0
  assert_contains \
    "$journal_policy policy explains the journal exception" \
    "OK   Journal entry not required (policy: $journal_policy)"
done

fixture_root="$(create_fixture unreviewed-change)"
session_file="$fixture_root/docs/session-updates/2026-07-03-unreviewed.md"
write_session_update "$session_file" "Unreviewed" complete false
git -C "$fixture_root" add "$session_file"
git -C "$fixture_root" commit -qm "Capture unreviewed session"

write_session_update "$session_file" "Unreviewed Updated" complete false
git -C "$fixture_root" add "$session_file"
git -C "$fixture_root" commit -qm "Update unreviewed session"

run_end "$fixture_root"
assert_status "modified unreviewed session still requires a journal" 1
assert_contains \
  "modified unreviewed session reports the missing journal" \
  "FAIL Latest commit does not contain a journal entry (policy: required)"

fixture_root="$(create_fixture incomplete-change)"
session_file="$fixture_root/docs/session-updates/2026-07-04-incomplete.md"
write_session_update "$session_file" "Incomplete" pending false
git -C "$fixture_root" add "$session_file"
git -C "$fixture_root" commit -qm "Capture incomplete session"

write_session_update "$session_file" "Incomplete" pending true
git -C "$fixture_root" add "$session_file"
git -C "$fixture_root" commit -qm "Review incomplete session"

run_end "$fixture_root"
assert_status "modified incomplete session still requires a journal" 1
assert_contains \
  "modified incomplete session reports the missing journal" \
  "FAIL Latest commit does not contain a journal entry (policy: required)"

fixture_root="$(create_fixture normal-session)"
session_file="$fixture_root/docs/session-updates/2026-07-05-normal.md"
journal_file="$fixture_root/content/journal/2026/2026-07-05-normal.md"
write_session_update "$session_file" "Normal Session" complete false
write_journal "$journal_file"
git -C "$fixture_root" add "$session_file" "$journal_file"
git -C "$fixture_root" commit -qm "Capture normal session"

run_end "$fixture_root"
assert_status "normal session with journal still passes" 0
assert_contains \
  "normal session reports its journal" \
  "OK   Journal entry committed: content/journal/2026/2026-07-05-normal.md"

fixture_root="$(create_fixture no-session)"
printf '%s\n' 'Planning only.' >> "$fixture_root/docs/planning/BACKLOG.md"
git -C "$fixture_root" add "$fixture_root/docs/planning/BACKLOG.md"
git -C "$fixture_root" commit -qm "Update planning only"

run_end "$fixture_root"
assert_status "commit without a session update fails" 1
assert_contains \
  "commit without a session update reports the failure" \
  "FAIL Latest commit does not contain a session update"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if ((failed > 0)); then
  exit 1
fi
