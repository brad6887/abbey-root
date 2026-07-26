#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

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

test_root="$(mktemp -d)"
fixture_root="$test_root/repo"

trap 'rm -rf "$test_root"' EXIT

mkdir -p \
  "$fixture_root/tools/bin" \
  "$fixture_root/scripts" \
  "$fixture_root/docs/session-updates" \
  "$fixture_root/docs/planning"

cp "$ABBEY_ROOT/tools/bin/abbey-review" \
  "$fixture_root/tools/bin/abbey-review"

cp "$ABBEY_ROOT/scripts/abbey_session_metadata.py" \
  "$fixture_root/scripts/abbey_session_metadata.py"

cat > "$fixture_root/tools/bin/abbey-backlog" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF

chmod +x \
  "$fixture_root/tools/bin/abbey-review" \
  "$fixture_root/tools/bin/abbey-backlog" \
  "$fixture_root/scripts/abbey_session_metadata.py"

cat > "$fixture_root/docs/session-updates/2026-07-01-historical-debt.md" <<'EOF'
---
title: "Historical Debt"
date: 2026-07-01
status: complete
reviewed: true
session: primary
tags:
  - Abbey Root
---

# Historical Debt
EOF

git -C "$fixture_root" init -q
git -C "$fixture_root" config user.name "Abbey Test"
git -C "$fixture_root" config user.email "abbey@example.invalid"
git -C "$fixture_root" add .
git -C "$fixture_root" commit -qm "Create metadata test fixture"

run_review() {
  set +e
  output="$(
    ABBEY_ROOT="$fixture_root" \
      "$fixture_root/tools/bin/abbey-review" 2>&1
  )"
  status=$?
  set -e
}

cat > "$fixture_root/docs/session-updates/2026-07-02-valid-change.md" <<'EOF'
---
title: "Valid Change"
description: "A valid changed session update."
date: 2026-07-02
status: pending
reviewed: false
session: primary
tags:
  - Abbey Root
---

# Valid Change
EOF

run_review

assert_status \
  "historical debt does not block a valid changed update" \
  "$status" \
  0

assert_contains \
  "review validates the changed update" \
  "$output" \
  "Changed session update metadata is valid: 1 file(s)"

assert_contains \
  "review reports historical debt" \
  "$output" \
  "Pre-existing historical session metadata debt: 1 file(s)"

rm "$fixture_root/docs/session-updates/2026-07-02-valid-change.md"

cat > "$fixture_root/docs/session-updates/2026-07-03-invalid-change.md" <<'EOF'
---
title: "Invalid Change"
description: "TODO: Add a concise description of this session."
date: 2026-07-03
status: pending
reviewed: false
session: primary
tags:
  - Abbey Root
---

# Invalid Change
EOF

run_review

assert_status \
  "invalid changed metadata blocks review" \
  "$status" \
  1

assert_contains \
  "review identifies the invalid changed file" \
  "$output" \
  "FAIL docs/session-updates/2026-07-03-invalid-change.md"

assert_contains \
  "review explains the incomplete field" \
  "$output" \
  "incomplete required field: description"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if ((failed > 0)); then
  exit 1
fi
