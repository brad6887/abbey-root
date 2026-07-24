#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY_SITE="$ABBEY_ROOT/tools/bin/abbey-site"

passed=0
failed=0
test_root="$(mktemp -d)"

trap 'rm -rf "$test_root"' EXIT

pass() {
  echo "PASS $1"
  passed=$((passed + 1))
}

fail() {
  echo "FAIL $1"
  failed=$((failed + 1))
}

assert_status() {
  local name="$1"
  local actual="$2"
  local expected="$3"

  if [[ "$actual" -eq "$expected" ]]; then
    pass "$name"
  else
    fail "$name"
    echo "     Expected status: $expected"
    echo "     Actual status:   $actual"
  fi
}

assert_contains() {
  local name="$1"
  local output="$2"
  local expected="$3"

  if grep -Fq -- "$expected" <<<"$output"; then
    pass "$name"
  else
    fail "$name"
    echo "     Expected: $expected"
  fi
}

assert_file_absent() {
  local name="$1"
  local path="$2"

  if [[ ! -e "$path" ]]; then
    pass "$name"
  else
    fail "$name"
    echo "     Unexpected file: $path"
  fi
}

assert_file_value() {
  local name="$1"
  local path="$2"
  local expected="$3"
  local actual=""

  if [[ -f "$path" ]]; then
    actual="$(cat "$path")"
  fi

  if [[ "$actual" == "$expected" ]]; then
    pass "$name"
  else
    fail "$name"
    echo "     Expected: $expected"
    echo "     Actual:   ${actual:-<missing>}"
  fi
}

create_fixture() {
  local name="$1"
  local case_dir="$test_root/$name"
  local source_repo="$case_dir/source"
  local production_repo="$case_dir/production"
  local remote_repo="$case_dir/remote.git"
  local fake_bin="$case_dir/fake-bin"

  mkdir -p \
    "$source_repo/tools/bin" \
    "$source_repo/site" \
    "$production_repo" \
    "$fake_bin"

  cp "$ABBEY_SITE" "$source_repo/tools/bin/abbey-site"
  chmod +x "$source_repo/tools/bin/abbey-site"

  cat > "$fake_bin/npm" <<'SCRIPT'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" != "run" || "${2:-}" != "build" ]]; then
  echo "Unexpected npm invocation: $*" >&2
  exit 1
fi

mkdir -p dist
printf '<html>published fixture</html>\n' > dist/index.html
SCRIPT

  cat > "$fake_bin/curl" <<'SCRIPT'
#!/usr/bin/env bash
set -euo pipefail

state_file="${ABBEY_TEST_CURL_STATE:?}"
mode="${ABBEY_TEST_CURL_MODE:-success}"
count=0

if [[ -f "$state_file" ]]; then
  read -r count < "$state_file"
fi

count=$((count + 1))
printf '%s\n' "$count" > "$state_file"

case "$mode" in
  success)
    printf '200'
    exit 0
    ;;

  retry-success)
    if ((count < 2)); then
      printf '503'
    else
      printf '200'
    fi
    exit 0
    ;;

  http-failure)
    printf '503'
    exit 0
    ;;

  connection-failure)
    exit 7
    ;;

  *)
    echo "Unknown curl test mode: $mode" >&2
    exit 1
    ;;
esac
SCRIPT

  chmod +x "$fake_bin/npm" "$fake_bin/curl"

  git -C "$source_repo" init -q
  git -C "$source_repo" config user.name "Abbey Test"
  git -C "$source_repo" config user.email "abbey-test@example.invalid"
  git -C "$source_repo" add .
  git -C "$source_repo" commit -qm "Create Abbey Site fixture"

  git -C "$production_repo" init -q
  git -C "$production_repo" config user.name "Abbey Test"
  git -C "$production_repo" config user.email "abbey-test@example.invalid"

  printf 'bradcooke.com\n' > "$production_repo/CNAME"
  printf '<html>old fixture</html>\n' > "$production_repo/index.html"

  git -C "$production_repo" add .
  git -C "$production_repo" commit -qm "Create production fixture"

  git init -q --bare "$remote_repo"
  git -C "$production_repo" remote add origin "$remote_repo"
  git -C "$production_repo" push -qu origin HEAD

  printf '%s\n' "$case_dir"
}

run_publish() {
  local case_dir="$1"
  local curl_mode="$2"
  local input="$3"
  shift 3

  local source_repo="$case_dir/source"
  local production_repo="$case_dir/production"
  local fake_bin="$case_dir/fake-bin"
  local state_file="$case_dir/curl-count"

  set +e
  last_output="$(
    printf '%b' "$input" |
      env \
        ABBEY_SITE_PRODUCTION_REPO="$production_repo" \
        ABBEY_SITE_LIVE_URL="https://example.invalid/" \
        ABBEY_SITE_VERIFY_ATTEMPTS=3 \
        ABBEY_SITE_VERIFY_DELAY=0 \
        ABBEY_TEST_CURL_MODE="$curl_mode" \
        ABBEY_TEST_CURL_STATE="$state_file" \
        PATH="$fake_bin:$PATH" \
        "$source_repo/tools/bin/abbey-site" publish "$@" 2>&1
  )"
  last_status=$?
  set -e
}

echo "Abbey Site Regression Tests"
echo "==========================="
echo

case_dir="$(create_fixture success)"
run_publish "$case_dir" success 'y\ny\n'

assert_status \
  "successful verification exits successfully" \
  "$last_status" \
  0

assert_contains \
  "successful verification reports final HTTP status" \
  "$last_output" \
  "OK   Live site verified: HTTP 200 (attempt 1/3)"

assert_contains \
  "successful verification completes publish workflow" \
  "$last_output" \
  "OK   Publish and live-site verification complete."

assert_file_value \
  "successful verification calls curl once" \
  "$case_dir/curl-count" \
  1

case_dir="$(create_fixture retry-success)"
run_publish "$case_dir" retry-success 'y\ny\n'

assert_status \
  "retry success exits successfully" \
  "$last_status" \
  0

assert_contains \
  "retry success reports initial HTTP failure" \
  "$last_output" \
  "Verification attempt 1/3 returned HTTP 503."

assert_contains \
  "retry success reports later success" \
  "$last_output" \
  "OK   Live site verified: HTTP 200 (attempt 2/3)"

assert_file_value \
  "retry success calls curl twice" \
  "$case_dir/curl-count" \
  2

case_dir="$(create_fixture http-failure)"
run_publish "$case_dir" http-failure 'y\ny\n'

assert_status \
  "HTTP verification failure has distinct status" \
  "$last_status" \
  2

assert_contains \
  "HTTP verification failure preserves push result" \
  "$last_output" \
  "OK   BradCooke.com publish pushed successfully."

assert_contains \
  "HTTP verification failure is clearly distinguished" \
  "$last_output" \
  "WARN Production push completed, but live-site verification failed."

assert_file_value \
  "HTTP verification failure uses all attempts" \
  "$case_dir/curl-count" \
  3

case_dir="$(create_fixture connection-failure)"
run_publish "$case_dir" connection-failure 'y\ny\n'

assert_status \
  "connection verification failure has distinct status" \
  "$last_status" \
  2

assert_contains \
  "connection failure reports unreachable site" \
  "$last_output" \
  "could not reach the live site."

assert_file_value \
  "connection failure uses all attempts" \
  "$case_dir/curl-count" \
  3

case_dir="$(create_fixture dry-run)"
run_publish "$case_dir" success '' --dry-run

assert_status \
  "dry run exits successfully" \
  "$last_status" \
  0

assert_contains \
  "dry run reports no production changes" \
  "$last_output" \
  "DRY RUN complete. No production files were changed."

assert_file_absent \
  "dry run does not verify the live site" \
  "$case_dir/curl-count"

case_dir="$(create_fixture cancelled)"
run_publish "$case_dir" success 'n\n'

assert_status \
  "cancelled publish exits successfully" \
  "$last_status" \
  0

assert_contains \
  "cancelled publish reports cancellation" \
  "$last_output" \
  "Publish cancelled."

assert_file_absent \
  "cancelled publish does not verify the live site" \
  "$case_dir/curl-count"

case_dir="$(create_fixture current)"
printf '<html>published fixture</html>\n' \
  > "$case_dir/production/index.html"

git -C "$case_dir/production" add index.html
git -C "$case_dir/production" commit -qm "Make production current"
git -C "$case_dir/production" push -q

run_publish "$case_dir" success 'y\n'

assert_status \
  "already-current publish exits successfully" \
  "$last_status" \
  0

assert_contains \
  "already-current publish reports current state" \
  "$last_output" \
  "OK   Production site is already current."

assert_file_absent \
  "already-current publish does not verify the live site" \
  "$case_dir/curl-count"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if ((failed > 0)); then
  exit 1
fi
