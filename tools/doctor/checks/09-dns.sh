#!/usr/bin/env bash

section "DNS Resolution"

VALIDATION_HOST="${ABBEY_DNS_VALIDATION_HOST:-ubuntu-dev01}"
INTERNAL_NAME="${ABBEY_DNS_INTERNAL_NAME:-edge01.home.arpa}"
EXTERNAL_NAME="${ABBEY_DNS_EXTERNAL_NAME:-github.com}"
current_host="${ABBEY_DOCTOR_HOSTNAME:-$(hostname -s 2>/dev/null || hostname)}"

resolve_name() {
  local hostname="$1"

  doctor_resolve_ipv4 "$hostname" 2>/dev/null || true
}

external_addresses="$(resolve_name "$EXTERNAL_NAME")"

if [ -n "$external_addresses" ]; then
  ok "External DNS resolves: $EXTERNAL_NAME"
else
  fail "External DNS resolution failed: $EXTERNAL_NAME"
fi

if [ "$current_host" != "$VALIDATION_HOST" ]; then
  ok "Internal DNS check not required on $current_host; validation host is $VALIDATION_HOST"
  echo
  return
fi

expected_address="${ABBEY_DNS_INTERNAL_ADDRESS:-}"

if [ -z "$expected_address" ]; then
  edge_vars="$ABBEY_ROOT/ansible/inventory/host_vars/edge01.yml"

  if [ ! -f "$edge_vars" ]; then
    fail "Internal DNS source missing: ${edge_vars#$ABBEY_ROOT/}"
    echo
    return
  fi

  expected_address="$(
    python3 - "$edge_vars" <<'PY' 2>/dev/null || true
import sys
import yaml

with open(sys.argv[1], "r", encoding="utf-8") as handle:
    data = yaml.safe_load(handle) or {}

print(data.get("primary_ip", ""))
PY
  )"
fi

if [ -z "$expected_address" ]; then
  fail "Internal DNS expected address is not configured"
  echo
  return
fi

internal_addresses="$(resolve_name "$INTERNAL_NAME")"

if [ -z "$internal_addresses" ]; then
  fail "Internal DNS resolution failed: $INTERNAL_NAME"
elif grep -Fqx -- "$expected_address" <<<"$internal_addresses"; then
  ok "Internal DNS resolves: $INTERNAL_NAME -> $expected_address"
else
  actual_addresses="$(tr '\n' ',' <<<"$internal_addresses" | sed 's/,$//')"
  fail "Internal DNS mismatch: $INTERNAL_NAME -> $actual_addresses; expected $expected_address"
fi

echo
