#!/usr/bin/env bash
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOL="$ROOT/tools/bin/abbey-knowledge"

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

run_status() {
  local test_root="$1"

  ABBEY_ROOT="$test_root" \
    "$test_root/tools/bin/abbey-knowledge" status \
    >/tmp/abbey-knowledge-test.out 2>&1
}

make_test_repo() {
  local test_root="$1"

  mkdir -p \
    "$test_root/tools/bin" \
    "$test_root/tools/lib" \
    "$test_root/scripts" \
    "$test_root/config" \
    "$test_root/ansible/inventory" \
    "$test_root/ansible/playbooks" \
    "$test_root/ansible/roles" \
    "$test_root/docs/planning" \
    "$test_root/docs/generated" \
    "$test_root/docs/runbooks" \
    "$test_root/docs/guides" \
    "$test_root/content/journal"

  cp "$ROOT/tools/bin/abbey-knowledge" \
    "$test_root/tools/bin/abbey-knowledge"

  cp "$ROOT/tools/lib/config.sh" \
    "$test_root/tools/lib/config.sh"

  cp "$ROOT/scripts/abbey_knowledge_manifest.py" \
    "$test_root/scripts/abbey_knowledge_manifest.py"

  cat > "$test_root/config/abbey.conf" <<'CONFIG'
ABBEY_KNOWLEDGE_FILE=".abbey/knowledge/snapshot.md"
CONFIG

  cat > "$test_root/ansible/inventory/hosts.yml" <<'DATA'
all:
  hosts:
    test01:
DATA

  for file in PROJECT_STATUS NEXT ROADMAP BACKLOG; do
    printf '# %s\n' "$file" \
      > "$test_root/docs/planning/$file.md"
  done

  printf '# Abbey CLI\n' \
    > "$test_root/docs/guides/abbey-cli.md"

  printf '%s\n' '---' \
    > "$test_root/content/journal/entry.md"
}

printf 'Abbey Knowledge Regression Tests\n'
printf '================================\n\n'

if bash -n "$TOOL"; then
  pass "tool syntax"
else
  fail "tool syntax"
fi

test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

make_test_repo "$test_root"

set +e
run_status "$test_root"
status_rc=$?
set -e

if [[ "$status_rc" -eq 2 ]] &&
   grep -q 'Repository:  MISSING' /tmp/abbey-knowledge-test.out; then
  pass "missing snapshot reported"
else
  fail "missing snapshot reported"
fi

if ABBEY_ROOT="$test_root" \
   "$test_root/tools/bin/abbey-knowledge" build \
   >/tmp/abbey-knowledge-build.out 2>&1; then
  pass "build succeeds"
else
  fail "build succeeds"
fi

if [[ -f "$test_root/.abbey/knowledge/snapshot.md" ]] &&
   [[ -f "$test_root/.abbey/knowledge/metadata.json" ]]; then
  pass "build writes snapshot and metadata"
else
  fail "build writes snapshot and metadata"
fi

set +e
run_status "$test_root"
status_rc=$?
set -e

if [[ "$status_rc" -eq 0 ]] &&
   grep -q 'Repository:  FRESH' /tmp/abbey-knowledge-test.out; then
  pass "fresh snapshot reported"
else
  fail "fresh snapshot reported"
fi

printf '\n- changed\n' \
  >> "$test_root/docs/planning/BACKLOG.md"

set +e
run_status "$test_root"
status_rc=$?
set -e

if [[ "$status_rc" -eq 1 ]] &&
   grep -q 'Repository:  STALE' /tmp/abbey-knowledge-test.out; then
  pass "content change makes snapshot stale"
else
  fail "content change makes snapshot stale"
fi

if ABBEY_ROOT="$test_root" \
   "$test_root/tools/bin/abbey-knowledge" ensure \
   --auto-build \
   --quiet; then
  pass "ensure rebuilds stale snapshot"
else
  fail "ensure rebuilds stale snapshot"
fi

set +e
run_status "$test_root"
status_rc=$?
set -e

if [[ "$status_rc" -eq 0 ]]; then
  pass "rebuilt snapshot is fresh"
else
  fail "rebuilt snapshot is fresh"
fi

printf '# new playbook\n' \
  > "$test_root/ansible/playbooks/new.yml"

set +e
ABBEY_ROOT="$test_root" \
  "$test_root/tools/bin/abbey-knowledge" ensure \
  --no-auto-build \
  --quiet \
  >/tmp/abbey-knowledge-no-auto.out 2>&1
ensure_rc=$?
set -e

if [[ "$ensure_rc" -eq 1 ]] &&
   grep -q 'WARN Abbey knowledge is stale' \
     /tmp/abbey-knowledge-no-auto.out; then
  pass "no-auto-build reports stale snapshot"
else
  fail "no-auto-build reports stale snapshot"
fi

printf '\nPassed: %d\n' "$passed"
printf 'Failed: %d\n' "$failed"

if (( failed > 0 )); then
  exit 1
fi
