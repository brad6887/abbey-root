#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DNS_CHECK="$ABBEY_ROOT/tools/doctor/checks/09-dns.sh"
OUTPUT_LIBRARY="$ABBEY_ROOT/tools/doctor/lib/output.sh"

passed=0
failed=0

pass() {
  echo "PASS $1"
  passed=$((passed + 1))
}

fail_test() {
  echo "FAIL $1"
  failed=$((failed + 1))
}

assert_contains() {
  local name="$1"
  local actual="$2"
  local expected="$3"

  if grep -Fq -- "$expected" <<<"$actual"; then
    pass "$name"
  else
    fail_test "$name"
    echo "     Expected: $expected"
  fi
}

run_dns_check() {
  local current_host="$1"
  local internal_result="$2"
  local external_result="$3"

  output="$(
    ABBEY_ROOT="$ABBEY_ROOT" \
    ABBEY_DOCTOR_HOSTNAME="$current_host" \
    ABBEY_DNS_INTERNAL_ADDRESS="192.168.1.221" \
    INTERNAL_RESULT="$internal_result" \
    EXTERNAL_RESULT="$external_result" \
      bash -c '
        source "$1"
        doctor_resolve_ipv4() {
          case "$1" in
            edge01.home.arpa)
              [ -n "$INTERNAL_RESULT" ] || return 1
              printf "%s\n" "$INTERNAL_RESULT"
              ;;
            github.com)
              [ -n "$EXTERNAL_RESULT" ] || return 1
              printf "%s\n" "$EXTERNAL_RESULT"
              ;;
          esac
        }
        source "$2"
      ' _ "$OUTPUT_LIBRARY" "$DNS_CHECK"
  )"
}

echo "Abbey Doctor DNS Regression Tests"
echo "================================="
echo

run_dns_check "ubuntu-dev01" "192.168.1.221" "140.82.114.4"
assert_contains \
  "external DNS success is reported" \
  "$output" \
  "OK   External DNS resolves: github.com"
assert_contains \
  "expected internal address is accepted" \
  "$output" \
  "OK   Internal DNS resolves: edge01.home.arpa -> 192.168.1.221"

run_dns_check "ubuntu-dev01" "192.168.1.99" "140.82.114.4"
assert_contains \
  "incorrect internal address fails" \
  "$output" \
  "FAIL Internal DNS mismatch: edge01.home.arpa -> 192.168.1.99; expected 192.168.1.221"

run_dns_check "ubuntu-dev01" "" "140.82.114.4"
assert_contains \
  "missing internal resolution fails" \
  "$output" \
  "FAIL Internal DNS resolution failed: edge01.home.arpa"

run_dns_check "ubuntu-dev01" "192.168.1.221" ""
assert_contains \
  "missing external resolution fails" \
  "$output" \
  "FAIL External DNS resolution failed: github.com"

run_dns_check "edge01" "" "140.82.114.4"
assert_contains \
  "internal DNS is scoped to the validation host" \
  "$output" \
  "OK   Internal DNS check not required on edge01; validation host is ubuntu-dev01"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if ((failed > 0)); then
  exit 1
fi
