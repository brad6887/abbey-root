#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY="$ABBEY_ROOT/tools/bin/abbey"
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
    echo "     Output:   $output"
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
    "$source_repo/.abbey" \
    "$source_repo/scripts" \
    "$source_repo/tools/bin" \
    "$source_repo/tools/lib" \
    "$source_repo/site" \
    "$production_repo" \
    "$fake_bin"

  cp "$ABBEY_SITE" "$source_repo/tools/bin/abbey-site"
  cp "$ABBEY_ROOT/scripts/abbey_site_validate.py" "$source_repo/scripts/abbey_site_validate.py"
  cp "$ABBEY_ROOT/tools/lib/project.sh" "$source_repo/tools/lib/project.sh"
  chmod +x "$source_repo/tools/bin/abbey-site" "$source_repo/scripts/abbey_site_validate.py"

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

  printf 'example.invalid\n' > "$production_repo/CNAME"
  printf '<html>old fixture</html>\n' > "$production_repo/index.html"

  git -C "$production_repo" add .
  git -C "$production_repo" commit -qm "Create production fixture"

  git init -q --bare "$remote_repo"
  git -C "$production_repo" remote add origin "$remote_repo"
  git -C "$production_repo" push -qu origin HEAD

  cat > "$source_repo/.abbey/project.yml" <<EOF
schema_version: 1
project:
  name: Abbey Site Fixture
  slug: abbey-site-fixture
site:
  source: site
  build:
    method: npm
    output: dist
  publish:
    method: git-rsync
    target: $production_repo
    domain: example.invalid
EOF

  git -C "$source_repo" add .abbey/project.yml
  git -C "$source_repo" commit -qm "Configure fixture publishing"

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
        ABBEY_ROOT="$source_repo" \
        ABBEY_TOOLKIT_ROOT="$source_repo" \
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
resolved_case_dir="$(cd "$case_dir" && pwd -P)"
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

assert_contains \
  "publish reports the resolved target before changes" \
  "$last_output" \
  "Target:            $resolved_case_dir/production"

assert_contains \
  "publish reports the resolved domain" \
  "$last_output" \
  "Domain:            example.invalid"

assert_contains \
  "publish reports the deployment method" \
  "$last_output" \
  "Deployment method: git-rsync"

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
  "OK   example.invalid publish pushed successfully."

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

bread_root="$test_root/bread-pitt"
mkdir -p \
  "$bread_root/.abbey" \
  "$bread_root/generated/media" \
  "$bread_root/media/prepared" \
  "$bread_root/site/gallery" \
  "$bread_root/site/images"
cat > "$bread_root/.abbey/project.yml" <<'YAML'
schema_version: 1
project:
  name: Bread Pitt
  slug: bread-pitt
site:
  source: site
  build:
    method: static
  validation:
    public_root: site
    media_manifests:
      - generated/media/gallery.json
    required_routes:
      - /
      - /gallery/
YAML
printf '<html>Bread Pitt</html>\n' > "$bread_root/site/index.html"
printf '<html>Gallery</html>\n' > "$bread_root/site/gallery/index.html"
printf '%s' 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=' |
  base64 --decode > "$bread_root/media/prepared/loaf.png"
cp "$bread_root/media/prepared/loaf.png" "$bread_root/site/images/loaf.png"
bread_image_hash="$(shasum -a 256 "$bread_root/site/images/loaf.png" | awk '{print $1}')"
resolved_bread_root="$(cd "$bread_root" && pwd -P)"
cat > "$bread_root/generated/media/gallery.json" <<JSON
{
  "schema_version": 1,
  "project": "Bread Pitt",
  "workflow": "gallery",
  "destination": "site/images",
  "profile": {"output_format": "png", "metadata_removed": true},
  "items": [{
    "source": {
      "path": "media/prepared/loaf.png",
      "sha256": "$bread_image_hash",
      "canonical_original_preserved": true
    },
    "derivative": {
      "path": "site/images/loaf.png",
      "sha256": "$bread_image_hash",
      "format": "png",
      "width": 1,
      "height": 1
    },
    "transformation": {"metadata_removed": true},
    "validation": {
      "private_metadata_detected": false,
      "source_hash_unchanged": true
    }
  }]
}
JSON

set +e
bread_build_output="$(
  cd "$bread_root" &&
    "$ABBEY" site build 2>&1
)"
bread_build_status=$?
set -e

assert_status "Bread Pitt static build succeeds" "$bread_build_status" 0
assert_contains \
  "Bread Pitt build resolves the active project" \
  "$bread_build_output" \
  "Project:           Bread Pitt ($resolved_bread_root)"
assert_contains \
  "Bread Pitt build reports direct static artifact" \
  "$bread_build_output" \
  "OK   Static site artifact ready: $resolved_bread_root/site"
assert_contains \
  "Bread Pitt build validates its publication manifest" \
  "$bread_build_output" \
  "OK   Media manifest: generated/media/gallery.json"
assert_contains \
  "Bread Pitt build validates configured routes" \
  "$bread_build_output" \
  "OK   Required route: /gallery/"

set +e
bread_validate_output="$(
  cd "$bread_root" &&
    "$ABBEY" site validate 2>&1
)"
bread_validate_status=$?
set -e

assert_status "Bread Pitt standalone site validation succeeds" "$bread_validate_status" 0
assert_contains \
  "standalone validation reports manifest, derivative, and route totals" \
  "$bread_validate_output" \
  "OK   Site validation passed: 1 manifest(s), 1 derivative(s), 2 route(s)."

cp "$bread_root/generated/media/gallery.json" "$bread_root/generated/media/foreign.json"
python3 - "$bread_root/generated/media/foreign.json" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
data = json.loads(path.read_text())
data["project"] = "Abbey Root"
path.write_text(json.dumps(data))
PY
python3 - "$bread_root/.abbey/project.yml" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text()
path.write_text(text.replace(
    "      - generated/media/gallery.json\n",
    "      - generated/media/gallery.json\n      - generated/media/foreign.json\n",
))
PY

set +e
foreign_validate_output="$(
  cd "$bread_root" &&
    "$ABBEY" site validate 2>&1
)"
foreign_validate_status=$?
set -e

assert_status \
  "cross-project publication manifest fails closed" \
  "$foreign_validate_status" \
  1
assert_contains \
  "cross-project refusal identifies the manifest owner" \
  "$foreign_validate_output" \
  "belongs to 'Abbey Root', not 'Bread Pitt'"

python3 - "$bread_root/.abbey/project.yml" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
path.write_text(path.read_text().replace("      - generated/media/foreign.json\n", ""))
PY
mv "$bread_root/site/images/loaf.png" "$bread_root/site/images/loaf.missing"

set +e
stale_validate_output="$(
  cd "$bread_root" &&
    "$ABBEY" site validate 2>&1
)"
stale_validate_status=$?
set -e

assert_status "stale publication manifest fails closed" "$stale_validate_status" 1
assert_contains \
  "stale manifest refusal identifies the missing derivative" \
  "$stale_validate_output" \
  "derivative does not exist"

brad_path="$test_root/bradcooke-production-must-not-change"
mkdir -p "$brad_path"
printf 'protected\n' > "$brad_path/sentinel"

set +e
bread_publish_output="$(
  cd "$bread_root" &&
    "$ABBEY" site publish --dry-run 2>&1
)"
bread_publish_status=$?
set -e

assert_status \
  "Bread Pitt publish fails closed without explicit configuration" \
  "$bread_publish_status" \
  1
assert_contains \
  "Bread Pitt refusal names the active project" \
  "$bread_publish_output" \
  "Publishing refused: Bread Pitt has no explicit site.publish configuration."
assert_file_value \
  "Bread Pitt cannot invoke a BradCooke.com publishing path" \
  "$brad_path/sentinel" \
  "protected"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if ((failed > 0)); then
  exit 1
fi
