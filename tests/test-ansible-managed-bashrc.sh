#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

tasks="$ABBEY_ROOT/ansible/roles/common/tasks/main.yml"
aliases="$ABBEY_ROOT/ansible/roles/common/files/abbey-aliases.sh"
functions="$ABBEY_ROOT/ansible/roles/common/files/abbey-functions.sh"
readme="$ABBEY_ROOT/ansible/roles/common/README.md"

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
  local description="$1"
  local expected="$2"
  local file="$3"

  if grep -Fq "$expected" "$file"; then
    pass "$description"
  else
    fail "$description"
  fi
}

assert_contains \
  "common role inspects the admin user bashrc" \
  'path: "{{ abbey_git_home }}/.bashrc"' \
  "$tasks"

assert_contains \
  "common role requires an existing bashrc" \
  "Require an existing admin user Bash configuration" \
  "$tasks"

assert_contains \
  "common role removes legacy shell helper sources" \
  "Remove legacy Abbey shell helper source block" \
  "$tasks"

assert_contains \
  "common role manages a bounded bashrc block" \
  "ANSIBLE MANAGED BLOCK - Abbey shell" \
  "$tasks"

assert_contains \
  "managed bashrc limits Abbey helpers to toolkit hosts" \
  'if [ -d "$HOME/git/abbey-root" ]; then' \
  "$tasks"

assert_contains \
  "managed bashrc sources Abbey aliases" \
  ". /etc/profile.d/abbey-aliases.sh" \
  "$tasks"

assert_contains \
  "managed bashrc sources Abbey functions" \
  ". /etc/profile.d/abbey-functions.sh" \
  "$tasks"

assert_contains \
  "managed bashrc supports local customization" \
  '. "$HOME/.bashrc.local"' \
  "$tasks"

assert_contains \
  "managed bashrc is syntax validated" \
  'validate: "bash -n %s"' \
  "$tasks"

assert_contains \
  "Ansible aliases preserve the ans shortcut" \
  "alias ans='cd ~/git/abbey-root/ansible'" \
  "$aliases"

assert_contains \
  "Ansible aliases preserve fast-forward-only pulls" \
  "alias gl='git pull --ff-only'" \
  "$aliases"

assert_contains \
  "aliases activate only for users with the toolkit" \
  'if [ ! -d "$HOME/git/abbey-root" ]; then' \
  "$aliases"

assert_contains \
  "shell initialization checks for toolkit installation" \
  'if [ -d "$abbey_toolkit_root" ]; then' \
  "$functions"

assert_contains \
  "shell initialization includes the registered dispatcher directory" \
  '"$abbey_toolkit_root/tools/bin"' \
  "$functions"

assert_contains \
  "role documents bounded bashrc ownership" \
  "The distribution-provided Bash configuration remains intact" \
  "$readme"

for legacy_file in \
  "$ABBEY_ROOT/scripts/bash/abbey-aliases.sh" \
  "$ABBEY_ROOT/scripts/bash/abbey-functions.sh"
do
  if [[ ! -e "$legacy_file" ]]; then
    pass "legacy duplicate shell source is absent: ${legacy_file#$ABBEY_ROOT/}"
  else
    fail "legacy duplicate shell source is absent: ${legacy_file#$ABBEY_ROOT/}"
  fi
done

if bash -n "$aliases" && bash -n "$functions"; then
  pass "managed shell files pass Bash syntax validation"
else
  fail "managed shell files pass Bash syntax validation"
fi

tmp_home="$(mktemp -d)"
trap 'rm -rf "$tmp_home"' EXIT

mkdir -p \
  "$tmp_home/git/abbey-root/tools" \
  "$tmp_home/git/abbey-root/tools/bin"

cat > "$tmp_home/git/abbey-root/tools/bin/abbey" <<'SCRIPT'
#!/usr/bin/env bash
exit 0
SCRIPT
chmod +x "$tmp_home/git/abbey-root/tools/bin/abbey"

path_output="$(
  HOME="$tmp_home" \
  PATH="/usr/bin:/bin" \
  bash --noprofile --norc -c '
    source "$1"
    source "$1"
    printf "%s\n" "$PATH"
  ' _ "$functions"
)"

for expected_path in \
  "$tmp_home/git/abbey-root/tools" \
  "$tmp_home/git/abbey-root/tools/bin"
do
  path_count="$(
    printf '%s\n' "$path_output" |
    awk -v RS=: -v target="$expected_path" '
      $0 == target { count++ }
      END { print count + 0 }
    '
  )"

  if [[ "$path_count" == "1" ]]; then
    pass "PATH contains exactly one ${expected_path#$tmp_home/} entry"
  else
    fail "PATH contains exactly one ${expected_path#$tmp_home/} entry"
  fi
done

command_output="$(
  HOME="$tmp_home" \
  PATH="/usr/bin:/bin" \
  bash --noprofile --norc -c '
    source "$1"
    command -v abbey
  ' _ "$functions"
)"

if [[ "$command_output" == "$tmp_home/git/abbey-root/tools/bin/abbey" ]]; then
  pass "registered Abbey dispatcher is available through PATH"
else
  fail "registered Abbey dispatcher is available through PATH"
fi

printf '\nPASSED: %d\n' "$passed"
printf 'FAILED: %d\n' "$failed"

if ((failed > 0)); then
  exit 1
fi
