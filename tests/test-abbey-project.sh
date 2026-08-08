#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ABBEY_TOOLKIT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY="$ABBEY_TOOLKIT_ROOT/tools/bin/abbey"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

passed=0
failed=0

pass() { printf 'PASS %s\n' "$1"; passed=$((passed + 1)); }
fail() { printf 'FAIL %s\n' "$1"; failed=$((failed + 1)); }

assert_contains() {
  if grep -Fq -- "$2" <<<"$3"; then pass "$1"; else fail "$1"; fi
}

project_a="$test_root/project-a"
project_b="$test_root/project-b"
"$ABBEY" init "$project_a" --name "Project A" --no-git --yes >/dev/null
"$ABBEY" init "$project_b" --name "Project B" --no-git --yes >/dev/null
project_a="$(cd "$project_a" && pwd -P)"
project_b="$(cd "$project_b" && pwd -P)"
mkdir -p "$project_a/content/nested"

output="$(cd "$project_a/content/nested" && "$ABBEY" project show)"
assert_contains "nested discovery identifies the active project" "Active project:       Project A" "$output"
assert_contains "nested discovery identifies the project root" "Project root:         $project_a" "$output"
assert_contains "toolkit root remains separate" "Toolkit root:         $ABBEY_TOOLKIT_ROOT" "$output"
assert_contains "toolkit defaults are disabled by default" "Toolkit defaults:     disabled" "$output"

output="$(cd "$project_a" && "$ABBEY" project show --project "$project_b")"
assert_contains "explicit project selects the exact requested root" "Active project:       Project B" "$output"
if grep -Fq "Project A" <<<"$output"; then
  fail "explicit project does not retain current-directory configuration"
else
  pass "explicit project does not retain current-directory configuration"
fi

mkdir -p "$project_a/.abbey"
touch "$project_a/.abbey/image-roles.yml"
output="$(cd "$project_a" && "$ABBEY" project show --config .abbey/image-roles.yml)"
assert_contains "local command configuration resolves inside the project" "Resolved configuration: $project_a/.abbey/image-roles.yml" "$output"
assert_contains "existing command configuration is reported" "Configuration status: present" "$output"

set +e
outside_output="$(cd "$test_root" && "$ABBEY" project show 2>&1)"
outside_status=$?
escape_output="$(cd "$project_a" && "$ABBEY" project show --config ../project-b/.abbey/project.yml 2>&1)"
escape_status=$?
set -e

[[ "$outside_status" -ne 0 ]] && pass "directory without a project fails closed" || fail "directory without a project fails closed"
assert_contains "missing project error is actionable" "no Abbey project found" "$outside_output"
[[ "$escape_status" -ne 0 ]] && pass "configuration path escape fails closed" || fail "configuration path escape fails closed"
assert_contains "path escape error is actionable" "configured path escapes the active project" "$escape_output"

cat > "$project_b/.abbey/project.yml" <<'YAML'
schema_version: 1
project: [invalid
YAML
set +e
invalid_output="$($ABBEY project show --project "$project_b" 2>&1)"
invalid_status=$?
set -e
[[ "$invalid_status" -ne 0 ]] && pass "malformed project metadata fails closed" || fail "malformed project metadata fails closed"
assert_contains "malformed metadata error identifies the file" "$project_b/.abbey/project.yml" "$invalid_output"

printf '\nPassed: %d\n' "$passed"
printf 'Failed: %d\n' "$failed"
(( failed == 0 ))
