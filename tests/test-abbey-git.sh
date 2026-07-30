#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY_GIT="$ABBEY_ROOT/tools/bin/abbey-git"
test_root="$(mktemp -d)"
bin_dir="$test_root/bin"
log_file="$test_root/ansible-playbook.log"
trap 'rm -rf "$test_root"' EXIT

passed=0
failed=0

pass() { echo "PASS $1"; passed=$((passed + 1)); }
fail() { echo "FAIL $1"; failed=$((failed + 1)); }

assert_contains() {
  if grep -Fq -- "$2" <<<"$3"; then
    pass "$1"
  else
    fail "$1"
  fi
}

help_output="$("$ABBEY_GIT" --help)"
assert_contains "help documents audit" "abbey git audit" "$help_output"
assert_contains "help documents sync preview" "abbey git sync [--check]" "$help_output"
assert_contains "help states non-mutating boundaries" "does not clone repositories" "$help_output"

assert_contains \
  "managed identity is declared" \
  "abbey_git_user_email: brad6887@gmail.com" \
  "$(cat "$ABBEY_ROOT/ansible/inventory/group_vars/all/main.yml")"
assert_contains \
  "managed pull policy is fast-forward only" \
  "ff = only" \
  "$(cat "$ABBEY_ROOT/ansible/roles/git_config/templates/gitconfig.j2")"
assert_contains \
  "GitHub HTTPS URLs are rewritten to SSH" \
  "insteadOf = https://github.com/" \
  "$(cat "$ABBEY_ROOT/ansible/roles/git_config/templates/gitconfig.j2")"
assert_contains \
  "pull alias follows managed policy" \
  "alias gl='git pull --ff-only'" \
  "$(cat "$ABBEY_ROOT/ansible/roles/common/files/abbey-aliases.sh")"

python3 - "$ABBEY_ROOT" <<'PY'
import sys
from pathlib import Path

import yaml

root = Path(sys.argv[1])
for path in [
    root / "ansible/inventory/group_vars/all/main.yml",
    root / "ansible/playbooks/git-audit.yml",
    root / "ansible/playbooks/git-sync.yml",
    root / "ansible/playbooks/tasks/git-audit-repository.yml",
    root / "ansible/playbooks/tasks/git-sync-repository.yml",
]:
    yaml.safe_load(path.read_text(encoding="utf-8"))
PY
pass "Ansible Git YAML parses"

mkdir -p "$bin_dir"
cat > "$bin_dir/hostname" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "${TEST_HOSTNAME:-rocky-ansible01}"
SH
cat > "$bin_dir/ansible-playbook" <<SH
#!/usr/bin/env bash
printf '%s\n' "\$*" >> "$log_file"
SH
chmod +x "$bin_dir/hostname" "$bin_dir/ansible-playbook"
export PATH="$bin_dir:$PATH"

routed_output="$("$ABBEY_ROOT/tools/bin/abbey" git help)"
assert_contains \
  "top-level abbey routes to Git help" \
  "abbey git audit" \
  "$routed_output"

audit_output="$("$ABBEY_GIT" audit --limit ubuntu-dev01)"
assert_contains \
  "audit accepts a target limit" \
  "Targets: ubuntu-dev01" \
  "$audit_output"

sync_output="$("$ABBEY_GIT" sync --check --limit infrastructure)"
assert_contains \
  "sync accepts check mode" \
  "Check mode: true" \
  "$sync_output"

playbook_log="$(cat "$log_file")"
assert_contains \
  "audit invokes its playbook" \
  "git-audit.yml" \
  "$playbook_log"
assert_contains \
  "sync invokes its playbook" \
  "git-sync.yml" \
  "$playbook_log"
assert_contains \
  "check mode passes Ansible preview options" \
  "--check --diff" \
  "$playbook_log"

TEST_HOSTNAME="ubuntu-dev01"
export TEST_HOSTNAME
set +e
wrong_host_output="$("$ABBEY_GIT" sync 2>&1)"
wrong_host_status=$?
set -e
if [[ "$wrong_host_status" -ne 0 ]]; then
  pass "sync refuses to run outside the control node"
else
  fail "sync refuses to run outside the control node"
fi
assert_contains \
  "control-node failure is explicit" \
  "must run on rocky-ansible01" \
  "$wrong_host_output"

echo
echo "Passed: $passed"
echo "Failed: $failed"
[[ "$failed" -eq 0 ]]
