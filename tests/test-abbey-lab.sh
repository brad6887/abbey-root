#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT
passed=0
failed=0

pass() { printf 'PASS %s\n' "$1"; passed=$((passed + 1)); }
fail() { printf 'FAIL %s\n' "$1"; failed=$((failed + 1)); }
assert_contains() {
  if grep -Fq "$2" <<<"$output"; then pass "$1"; else fail "$1"; fi
}

command -v ansible-playbook >/dev/null 2>&1 || {
  echo "SKIP ansible-playbook is not installed"
  exit 0
}

cat > "$test_root/inventory.yml" <<'YAML'
all:
  hosts:
    present-host:
      ansible_connection: local
      expected_network_interfaces:
        - role: primary
          mac_address: "aa:bb:cc:dd:ee:ff"
    missing-host:
      ansible_connection: local
      expected_network_interfaces:
        - role: primary
          mac_address: "11:22:33:44:55:66"
    undeclared-host:
      ansible_connection: local
YAML

cat > "$test_root/playbook.yml" <<YAML
---
- name: Test network interface validation
  hosts: all
  gather_facts: false
  tasks:
    - name: Supply synthetic interface facts
      ansible.builtin.set_fact:
        ansible_facts:
          interfaces:
            - test0
          test0:
            macaddress: "aa:bb:cc:dd:ee:ff"
    - name: Run production validation tasks
      ansible.builtin.include_tasks: "$ABBEY_ROOT/ansible/tasks/validate-network-interfaces.yml"
YAML

output="$(ansible-playbook -i "$test_root/inventory.yml" "$test_root/playbook.yml" 2>&1)"
assert_contains "present interface is reported" "OK   Expected network interface present: primary (MAC aa:bb:cc:dd:ee:ff)"
assert_contains "missing or replaced interface is reported" "WARN Expected network interface missing or replaced: primary (MAC 11:22:33:44:55:66)"
assert_contains "observed identities accompany a mismatch" "WARN Observed network interfaces on missing-host:"
assert_contains "undeclared hosts are skipped" "SKIP No expected network interfaces declared for undeclared-host"
assert_contains "all fixture hosts continue through validation" "failed=0"

printf '\nPassed: %d\nFailed: %d\n' "$passed" "$failed"
((failed == 0))
