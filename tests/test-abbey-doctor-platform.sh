#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$ABBEY_ROOT/tools/doctor/lib/platform.sh"

passed=0
failed=0
fixture_root="$(mktemp -d)"
trap 'rm -rf "$fixture_root"' EXIT

pass() {
  echo "PASS $1"
  passed=$((passed + 1))
}

fail() {
  echo "FAIL $1"
  failed=$((failed + 1))
}

assert_equal() {
  local name="$1"
  local actual="$2"
  local expected="$3"

  if [[ "$actual" == "$expected" ]]; then
    pass "$name"
  else
    fail "$name"
    echo "     Expected: $expected"
    echo "     Actual:   $actual"
  fi
}

mock_bin="$fixture_root/bin"
mkdir -p "$mock_bin"

cat > "$mock_bin/ping" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" > "$PING_ARGUMENTS_FILE"
EOF
chmod +x "$mock_bin/ping"

export PATH="$mock_bin:$PATH"
export PING_ARGUMENTS_FILE="$fixture_root/ping-arguments"

echo "Abbey Doctor Platform Regression Tests"
echo "======================================"
echo

ABBEY_PLATFORM=Darwin doctor_ping_host 192.168.1.87
assert_equal \
  "macOS uses supported ping options" \
  "$(cat "$PING_ARGUMENTS_FILE")" \
  "-c 2 -W 1000 192.168.1.87"

ABBEY_PLATFORM=Linux doctor_ping_host 192.168.1.87
assert_equal \
  "Linux retains IPv4 and seconds-based timeout options" \
  "$(cat "$PING_ARGUMENTS_FILE")" \
  "-4 -c 1 -W 1 192.168.1.87"

ABBEY_PLATFORM=FreeBSD doctor_ping_host 192.168.1.87
assert_equal \
  "unknown platforms use conservative ping options" \
  "$(cat "$PING_ARGUMENTS_FILE")" \
  "-c 1 192.168.1.87"

timezone_root="$fixture_root/zoneinfo"
mkdir -p "$timezone_root/America"
touch "$timezone_root/America/Chicago"
ln -s "$timezone_root/America/Chicago" "$fixture_root/localtime"

assert_equal \
  "macOS timezone is derived from the localtime symlink" \
  "$(
    ABBEY_PLATFORM=Darwin \
      ABBEY_LOCALTIME_PATH="$fixture_root/localtime" \
      doctor_timezone
  )" \
  "America/Chicago"

cat > "$mock_bin/sysctl" <<'EOF'
#!/usr/bin/env bash
echo "{ 2.50 2.25 2.00 }"
EOF
chmod +x "$mock_bin/sysctl"

assert_equal \
  "macOS load average uses sysctl output" \
  "$(ABBEY_PLATFORM=Darwin doctor_load_average)" \
  "2.50"

cat > "$mock_bin/launchctl" <<'EOF'
#!/usr/bin/env bash
echo "state = running"
EOF
chmod +x "$mock_bin/launchctl"

assert_equal \
  "macOS recognizes the network time service" \
  "$(ABBEY_PLATFORM=Darwin doctor_network_time_status)" \
  "running"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if [[ "$failed" -gt 0 ]]; then
  exit 1
fi
