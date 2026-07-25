#!/usr/bin/env bash
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="$(mktemp -d)"
BIN_DIR="$TEST_DIR/bin"
LOG_FILE="$TEST_DIR/ansible-playbook.log"

cleanup() {
  rm -rf "$TEST_DIR"
}
trap cleanup EXIT

mkdir -p "$BIN_DIR"

pass_count=0
fail_count=0

pass() {
  printf 'PASS %s\n' "$1"
  pass_count=$((pass_count + 1))
}

fail() {
  printf 'FAIL %s\n' "$1"
  fail_count=$((fail_count + 1))
}

assert_contains() {
  local output="$1"
  local expected="$2"
  local description="$3"

  if grep -Fq -- "$expected" <<<"$output"; then
    pass "$description"
  else
    fail "$description"
    printf 'Expected: %s\n' "$expected"
    printf 'Output:\n%s\n' "$output"
  fi
}

cat > "$BIN_DIR/hostname" <<'SCRIPT'
#!/usr/bin/env bash
if [[ "${1:-}" == "-s" ]]; then
  printf '%s\n' "${TEST_HOSTNAME:-rocky-ansible01}"
else
  printf '%s\n' "${TEST_HOSTNAME:-rocky-ansible01}"
fi
SCRIPT

cat > "$BIN_DIR/ansible-playbook" <<SCRIPT
#!/usr/bin/env bash
printf '%s\n' "\$*" >> "$LOG_FILE"
exit 0
SCRIPT

chmod +x "$BIN_DIR/hostname" "$BIN_DIR/ansible-playbook"

export PATH="$BIN_DIR:$PATH"

output="$("$ROOT_DIR/tools/bin/abbey" ssh help 2>&1)"
assert_contains "$output" "abbey ssh audit" \
  "top-level abbey routes to SSH help"

output="$("$ROOT_DIR/tools/bin/abbey-ssh" audit 2>&1)"
assert_contains "$output" "Mode: audit" \
  "audit mode runs on the control host"

output="$("$ROOT_DIR/tools/bin/abbey-ssh" sync --check --limit edge01 2>&1)"
assert_contains "$output" "Check mode: true" \
  "sync accepts check mode"
assert_contains "$output" "Targets: edge01" \
  "sync accepts a target limit"

log_output="$(cat "$LOG_FILE")"
assert_contains "$log_output" "ssh-audit.yml" \
  "audit invokes the audit playbook"
assert_contains "$log_output" "ssh-sync.yml" \
  "sync invokes the synchronization playbook"
assert_contains "$log_output" "--check --diff" \
  "check mode passes Ansible check and diff options"
assert_contains "$log_output" "abbey_ssh_targets=edge01" \
  "limit is passed as the destination target"

TEST_HOSTNAME="ubuntu-dev01"
export TEST_HOSTNAME

set +e
output="$("$ROOT_DIR/tools/bin/abbey-ssh" sync 2>&1)"
status=$?
set -e

if [[ "$status" -ne 0 ]]; then
  pass "sync refuses to run outside the Ansible control node"
else
  fail "sync refuses to run outside the Ansible control node"
fi

assert_contains "$output" \
  "must run on rocky-ansible01" \
  "control-node failure explains where to run"

set +e
output="$("$ROOT_DIR/tools/bin/abbey-ssh" sync --limit 2>&1)"
status=$?
set -e

if [[ "$status" -ne 0 ]]; then
  pass "missing limit value fails"
else
  fail "missing limit value fails"
fi

assert_contains "$output" "--limit requires a value" \
  "missing limit value has a useful error"

printf '\nResult: %d PASS, %d FAIL\n' "$pass_count" "$fail_count"

((fail_count == 0))
