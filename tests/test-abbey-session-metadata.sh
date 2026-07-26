#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VALIDATOR="$ABBEY_ROOT/scripts/abbey_session_metadata.py"

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

fixture_root="$(mktemp -d)"
trap 'rm -rf "$fixture_root"' EXIT

mkdir -p "$fixture_root/docs/session-updates"

cat > "$fixture_root/docs/session-updates/2026-07-01-valid-history.md" <<'EOF'
---
title: "Valid History"
description: "A valid historical session."
date: 2026-07-01
status: complete
reviewed: true
session: primary
tags:
  - Abbey Root
---

# Valid History
EOF

cat > "$fixture_root/docs/session-updates/2026-07-02-invalid-history.md" <<'EOF'
---
title: "Invalid History"
date: 2026-07-02
status: completed
reviewed: true
session: standard
tags:
  - Abbey Root
---

# Invalid History
EOF

cat > "$fixture_root/docs/session-updates/2026-07-03-valid-change.md" <<'EOF'
---
title: "Valid Change"
description: "A valid changed session."
date: 2026-07-03
status: pending
reviewed: false
session: primary
tags:
  - Abbey Root
---

# Valid Change
EOF

cat > "$fixture_root/docs/session-updates/2026-07-04-invalid-change.md" <<'EOF'
---
title: "Invalid Change"
description: "TODO: Finish this description."
date: 2026-07-04
status: pending
reviewed: false
session: primary
tags:
  - Abbey Root
---

# Invalid Change
EOF

set +e
output="$(
  python3 "$VALIDATOR" \
    --root "$fixture_root" \
    --changed docs/session-updates/2026-07-03-valid-change.md \
    2>&1
)"
status=$?
set -e

assert_status \
  "valid changed metadata does not fail on historical debt" \
  "$status" \
  0

assert_contains \
  "valid changed metadata is reported" \
  "$output" \
  "Changed session update metadata is valid"

assert_contains \
  "historical debt is reported" \
  "$output" \
  "Pre-existing historical session metadata debt: 2 file(s)"

set +e
output="$(
  python3 "$VALIDATOR" \
    --root "$fixture_root" \
    --changed docs/session-updates/2026-07-04-invalid-change.md \
    2>&1
)"
status=$?
set -e

assert_status \
  "invalid changed metadata fails" \
  "$status" \
  1

assert_contains \
  "invalid changed file is identified" \
  "$output" \
  "FAIL docs/session-updates/2026-07-04-invalid-change.md"

assert_contains \
  "placeholder description is rejected" \
  "$output" \
  "incomplete required field: description"

set +e
output="$(
  python3 "$VALIDATOR" \
    --root "$fixture_root" \
    --all \
    2>&1
)"
status=$?
set -e

assert_status \
  "full historical audit fails when debt exists" \
  "$status" \
  1

assert_contains \
  "full audit lists missing description" \
  "$output" \
  "missing required field: description"

assert_contains \
  "full audit reports total invalid files" \
  "$output" \
  "Invalid session updates: 2"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if ((failed > 0)); then
  exit 1
fi
