#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY_PLANT="$ABBEY_ROOT/tools/bin/abbey-plant"

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
  local expected="$2"

  if [[ "$status" -eq "$expected" ]]; then
    pass "$name"
  else
    fail "$name"
    echo "     Expected status: $expected"
    echo "     Actual status:   $status"
  fi
}

assert_contains() {
  local name="$1"
  local expected="$2"

  if grep -Fq -- "$expected" <<<"$output"; then
    pass "$name"
  else
    fail "$name"
    echo "     Expected: $expected"
  fi
}

create_plant() {
  local fixture="$1"
  local plant_dir="$test_root/$fixture/working/plants/test-plant"

  mkdir -p "$plant_dir/photos" "$plant_dir/sources"
  touch \
    "$plant_dir/history.md" \
    "$plant_dir/story.md" \
    "$plant_dir/inventory.md" \
    "$plant_dir/photo-metadata.md" \
    "$plant_dir/photos/hero.jpg" \
    "$plant_dir/photos/current.jpg"

  cat > "$plant_dir/facts.yaml" <<'YAML'
name: Test Plant
slug: test-plant
plant:
  type: Orchid
  genus: Phalaenopsis
  species: amabilis
rescue:
  date: 2026-07-01
status:
  current: Recovering
  updated: 2026-07-26
photos:
  hero: photos/hero.jpg
  current: photos/current.jpg
YAML

  printf '%s\n' "$plant_dir"
}

empty_field() {
  local facts_file="$1"
  local field="$2"
  local pattern

  case "$field" in
    name) pattern='^name:' ;;
    slug) pattern='^slug:' ;;
    plant.type) pattern='^  type:' ;;
    plant.genus) pattern='^  genus:' ;;
    plant.species) pattern='^  species:' ;;
    rescue.date) pattern='^  date:' ;;
    status.current) pattern='^  current: Recovering' ;;
    status.updated) pattern='^  updated:' ;;
    photos.hero) pattern='^  hero:' ;;
    photos.current) pattern='^  current: photos/current.jpg' ;;
    *)
      echo "Unknown field: $field" >&2
      return 1
      ;;
  esac

  awk -v pattern="$pattern" '
    $0 ~ pattern {
      sub(/:.*/, ":")
    }
    { print }
  ' "$facts_file" > "$facts_file.tmp"
  mv "$facts_file.tmp" "$facts_file"
}

run_validate() {
  local fixture_root="$1"
  shift

  set +e
  output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_PLANT" validate "$@" 2>&1)"
  status=$?
  set -e
}

echo "Abbey Plant Validate Regression Tests"
echo "====================================="
echo

run_validate "$test_root/no-slug"
assert_status "missing slug returns usage status" 2
assert_contains "missing slug explains the requirement" "ERROR: Plant slug is required."

run_validate "$test_root/missing-workspace" test-plant
assert_status "missing plant directory fails" 1
assert_contains \
  "missing plant directory is reported" \
  "FAIL Plant directory does not exist:"

create_plant valid >/dev/null
run_validate "$test_root/valid" test-plant
assert_status "complete plant workspace passes" 0
assert_contains \
  "complete plant workspace has no warnings or failures" \
  "OK: 20  WARN: 0  FAIL: 0"
assert_contains \
  "complete plant workspace reports success" \
  "PASS Plant model validation completed successfully."

for required_file in \
  history.md \
  story.md \
  inventory.md \
  photo-metadata.md
do
  fixture="missing-${required_file%.md}"
  plant_dir="$(create_plant "$fixture")"
  rm "$plant_dir/$required_file"
  run_validate "$test_root/$fixture" test-plant
  assert_status "missing $required_file fails" 1
  assert_contains \
    "missing $required_file is reported" \
    "FAIL $required_file is missing"
done

plant_dir="$(create_plant missing-facts)"
rm "$plant_dir/facts.yaml"
run_validate "$test_root/missing-facts" test-plant
assert_status "missing facts.yaml fails" 1
assert_contains "missing facts.yaml is reported" "FAIL facts.yaml is missing"
assert_contains \
  "facts validation stops when facts.yaml is missing" \
  "FAIL Cannot validate facts because facts.yaml is missing"

for required_dir in photos sources; do
  fixture="missing-$required_dir"
  plant_dir="$(create_plant "$fixture")"
  rm -r "$plant_dir/$required_dir"
  run_validate "$test_root/$fixture" test-plant
  assert_status "missing $required_dir directory fails" 1
  assert_contains \
    "missing $required_dir directory is reported" \
    "FAIL $required_dir/ is missing"
done

plant_dir="$(create_plant invalid-yaml)"
printf '%s\n' 'name: [invalid' > "$plant_dir/facts.yaml"
run_validate "$test_root/invalid-yaml" test-plant
assert_status "invalid YAML fails" 1
assert_contains \
  "invalid YAML is reported" \
  "FAIL facts.yaml contains invalid YAML:"

plant_dir="$(create_plant non-mapping)"
printf '%s\n' '- not' '- a' '- mapping' > "$plant_dir/facts.yaml"
run_validate "$test_root/non-mapping" test-plant
assert_status "non-mapping YAML fails" 1
assert_contains \
  "non-mapping YAML is reported" \
  "FAIL facts.yaml must contain a YAML mapping"

for required_field in name slug plant.type status.current; do
  fixture="missing-${required_field//./-}"
  plant_dir="$(create_plant "$fixture")"
  empty_field "$plant_dir/facts.yaml" "$required_field"
  run_validate "$test_root/$fixture" test-plant
  assert_status "empty required field $required_field fails" 1
  assert_contains \
    "empty required field $required_field is reported" \
    "FAIL Required field is missing or empty: $required_field"
done

for optional_field in \
  plant.genus \
  plant.species \
  rescue.date \
  status.updated
do
  fixture="missing-${optional_field//./-}"
  plant_dir="$(create_plant "$fixture")"
  empty_field "$plant_dir/facts.yaml" "$optional_field"
  run_validate "$test_root/$fixture" test-plant
  assert_status "empty optional field $optional_field still passes" 0
  assert_contains \
    "empty optional field $optional_field warns" \
    "WARN Optional field is not set: $optional_field"
done

plant_dir="$(create_plant slug-mismatch)"
awk '
  /^slug:/ { print "slug: different-plant"; next }
  { print }
' "$plant_dir/facts.yaml" > "$plant_dir/facts.yaml.tmp"
mv "$plant_dir/facts.yaml.tmp" "$plant_dir/facts.yaml"
run_validate "$test_root/slug-mismatch" test-plant
assert_status "slug mismatch fails" 1
assert_contains \
  "slug mismatch identifies both values" \
  "FAIL facts.yaml slug 'different-plant' does not match directory name 'test-plant'"

for photo_field in photos.hero photos.current; do
  fixture="unset-${photo_field//./-}"
  plant_dir="$(create_plant "$fixture")"
  empty_field "$plant_dir/facts.yaml" "$photo_field"
  run_validate "$test_root/$fixture" test-plant
  assert_status "unset photo reference $photo_field still passes" 0
  assert_contains \
    "unset photo reference $photo_field warns" \
    "WARN Photo reference is not set: $photo_field"
done

for photo_field in photos.hero photos.current; do
  fixture="missing-${photo_field//./-}"
  plant_dir="$(create_plant "$fixture")"
  photo_path="${photo_field#photos.}"
  rm "$plant_dir/photos/$photo_path.jpg"
  run_validate "$test_root/$fixture" test-plant
  assert_status "missing referenced photo $photo_field fails" 1
  assert_contains \
    "missing referenced photo $photo_field is reported" \
    "FAIL $photo_field does not exist: photos/$photo_path.jpg"
done

plant_dir="$(create_plant unreadable-facts)"
chmod 000 "$plant_dir/facts.yaml"
run_validate "$test_root/unreadable-facts" test-plant
assert_status "unreadable facts.yaml fails" 1
assert_contains \
  "unreadable facts.yaml is reported" \
  "FAIL Unable to read facts.yaml:"
chmod 600 "$plant_dir/facts.yaml"

fake_bin="$test_root/fake-bin"
mkdir -p "$fake_bin"
real_python="$(command -v python3)"
cat > "$fake_bin/python3" <<'SH'
#!/usr/bin/env bash
if [[ "${ABBEY_TEST_PYTHON_MODE:-}" == "missing-yaml" && "${1:-}" == "-c" ]]; then
  exit 1
fi
if [[ "${ABBEY_TEST_PYTHON_MODE:-}" == "execution-failure" && "${1:-}" == "-" ]]; then
  exit 42
fi
exec "$ABBEY_TEST_REAL_PYTHON" "$@"
SH
chmod +x "$fake_bin/python3"

create_plant missing-pyyaml >/dev/null
set +e
output="$(
  ABBEY_ROOT="$test_root/missing-pyyaml" \
  ABBEY_TEST_PYTHON_MODE=missing-yaml \
  ABBEY_TEST_REAL_PYTHON="$real_python" \
  PATH="$fake_bin:$PATH" \
  "$ABBEY_PLANT" validate test-plant 2>&1
)"
status=$?
set -e
assert_status "missing PyYAML fails" 1
assert_contains \
  "missing PyYAML includes installation guidance" \
  "FAIL Python module PyYAML is not installed"

create_plant execution-failure >/dev/null
set +e
output="$(
  ABBEY_ROOT="$test_root/execution-failure" \
  ABBEY_TEST_PYTHON_MODE=execution-failure \
  ABBEY_TEST_REAL_PYTHON="$real_python" \
  PATH="$fake_bin:$PATH" \
  "$ABBEY_PLANT" validate test-plant 2>&1
)"
status=$?
set -e
assert_status "facts validator execution failure fails" 1
assert_contains \
  "facts validator execution failure is reported" \
  "FAIL Unable to execute facts.yaml validation"

echo
echo "Passed: $passed"
echo "Failed: $failed"

if ((failed > 0)); then
  exit 1
fi
