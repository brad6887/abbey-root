#!/usr/bin/env bash
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="$(mktemp -d)"
BIN_DIR="$TEST_DIR/bin"

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

cat > "$BIN_DIR/tailscale" <<'SCRIPT'
#!/usr/bin/env bash
if [[ "${TAILSCALE_FAILURE:-false}" == "true" ]]; then
  printf 'Tailscale is stopped\n' >&2
  exit 1
fi

cat <<JSON
{
  "BackendState": "Running",
  "Peer": {
    "peer-key": {
      "HostName": "ubuntu-dev01",
      "DNSName": "ubuntu-dev01.example.ts.net.",
      "Online": ${TAILSCALE_ONLINE:-true},
      "TailscaleIPs": ["100.100.10.20", "fd7a:115c:a1e0::1"]
    }
  }
}
JSON
SCRIPT

cat > "$BIN_DIR/ssh" <<'SCRIPT'
#!/usr/bin/env bash
printf 'SSH_CALLED %s\n' "$*"
SCRIPT

chmod +x "$BIN_DIR/tailscale" "$BIN_DIR/ssh"
export PATH="$BIN_DIR:$PATH"

output="$("$ROOT_DIR/tools/bin/abbey" remote help 2>&1)"
assert_contains "$output" "abbey remote connect --name ubuntu-dev01" \
  "canonical remote help shows a connection example"
assert_contains "$output" "--name NAME" \
  "canonical remote help documents the required host option"
assert_contains "$output" "--user USER" \
  "canonical remote help documents the SSH user override"

output="$("$ROOT_DIR/tools/bin/abbey" remote connect help 2>&1)"
assert_contains "$output" "usage: abbey remote connect" \
  "canonical connect help routes to command-specific help"
assert_contains "$output" "Required Tailscale and Abbey inventory host name" \
  "command-specific help explains the name option"
assert_contains "$output" "Override the SSH user from the Abbey inventory" \
  "command-specific help explains the user option"

output="$("$ROOT_DIR/tools/bin/abbey" remote connect --name ubuntu-dev01 2>&1)"
assert_contains "$output" "Tailscale IPv4: 100.100.10.20" \
  "connect resolves the peer IPv4 address"
assert_contains "$output" "SSH target: bcooke@100.100.10.20" \
  "connect uses the inventory SSH user"
assert_contains "$output" "SSH_CALLED bcooke@100.100.10.20" \
  "connect hands the resolved target to SSH"

output="$("$ROOT_DIR/tools/bin/abbey" remote connect --name ubuntu-dev01 --user operator 2>&1)"
assert_contains "$output" "SSH_CALLED operator@100.100.10.20" \
  "an explicit SSH user overrides inventory"

set +e
output="$("$ROOT_DIR/tools/bin/abbey" remote connect --name missing-host 2>&1)"
status=$?
set -e
[[ "$status" -ne 0 ]] && pass "an unknown peer fails" || fail "an unknown peer fails"
assert_contains "$output" "No Tailscale peer named 'missing-host' was found" \
  "an unknown peer has a useful error"

TAILSCALE_ONLINE=false
export TAILSCALE_ONLINE
set +e
output="$("$ROOT_DIR/tools/bin/abbey" remote connect --name ubuntu-dev01 2>&1)"
status=$?
set -e
[[ "$status" -ne 0 ]] && pass "an offline peer fails" || fail "an offline peer fails"
assert_contains "$output" "Tailscale peer 'ubuntu-dev01' is offline" \
  "an offline peer has a useful error"
unset TAILSCALE_ONLINE

TAILSCALE_FAILURE=true
export TAILSCALE_FAILURE
set +e
output="$("$ROOT_DIR/tools/bin/abbey" remote connect --name ubuntu-dev01 2>&1)"
status=$?
set -e
[[ "$status" -ne 0 ]] && pass "a disconnected client fails" || fail "a disconnected client fails"
assert_contains "$output" "Open Tailscale and confirm it is connected" \
  "a disconnected client explains how to recover"

printf '\nResult: %d PASS, %d FAIL\n' "$pass_count" "$fail_count"

((fail_count == 0))
