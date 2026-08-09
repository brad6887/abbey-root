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
    "$plant_dir/photos/current.jpg" \
    "$plant_dir/photos/index.jpg"

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
  index: null

documents:
  story: story.md
  history: history.md

tags: []
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
    photos.index) pattern='^  index:' ;;
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

prepare_template() {
  local fixture_root="$1"
  mkdir -p "$fixture_root/working/plants"
  if [[ ! -d "$fixture_root/working/plants/_template" ]]; then
    cp -R "$ABBEY_ROOT/working/plants/_template" \
      "$fixture_root/working/plants/_template"
  fi
}

run_new() {
  local fixture_root="$1"
  shift

  prepare_template "$fixture_root"

  set +e
  output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_PLANT" new "$@" 2>&1)"
  status=$?
  set -e
}

run_publish() {
  local fixture_root="$1"
  shift

  set +e
  output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_PLANT" publish "$@" 2>&1)"
  status=$?
  set -e
}

run_publish_batch() {
  local fixture_root="$1"
  shift

  set +e
  output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_PLANT" publish-batch "$@" 2>&1)"
  status=$?
  set -e
}

echo "Abbey Plant Validate Regression Tests"
echo "====================================="
echo

run_new "$test_root/new-valid" rocky-raccoon \
  --name "Rocky Raccoon" \
  --type orchid \
  --date 2026-08-02
assert_status "new creates and validates a plant workspace" 0
assert_contains \
  "new reports the created workspace" \
  "Plant: Rocky Raccoon (rocky-raccoon)"
assert_contains \
  "new runs plant validation" \
  "PASS Plant model validation completed with warnings."
for document in story.md history.md inventory.md photo-metadata.md; do
  assert_contains \
    "new reports template placeholders in $document" \
    "WARN $document still contains template placeholders"
done

new_plant_dir="$test_root/new-valid/working/plants/rocky-raccoon"
for required_path in \
  facts.yaml \
  story.md \
  history.md \
  inventory.md \
  photo-metadata.md \
  photos \
  sources \
  photos/.gitkeep \
  sources/.gitkeep
do
  if [[ -e "$new_plant_dir/$required_path" ]]; then
    pass "new creates $required_path"
  else
    fail "new creates $required_path"
  fi
done

if [[ ! -e "$new_plant_dir/README.md" ]]; then
  pass "new does not copy template instructions into the plant workspace"
else
  fail "new does not copy template instructions into the plant workspace"
fi

if grep -Fq "name: Rocky Raccoon" "$new_plant_dir/facts.yaml" && \
   grep -Fq "slug: rocky-raccoon" "$new_plant_dir/facts.yaml" && \
   grep -Fq "  type: orchid" "$new_plant_dir/facts.yaml" && \
   grep -Fq "  date: 2026-08-02" "$new_plant_dir/facts.yaml"
then
  pass "new initializes verified plant facts"
else
  fail "new initializes verified plant facts"
fi

initial_photo="$test_root/rocky-raccoon.jpg"
initial_sidecar="$test_root/rocky-raccoon.xmp"
printf 'initial photograph fixture\n' > "$initial_photo"
printf 'initial XMP fixture\n' > "$initial_sidecar"
run_new "$test_root/new-photo" rocky-raccoon \
  --name "Rocky Raccoon" \
  --type orchid \
  --photo "$initial_photo"
assert_status "new imports an initial photograph" 0
assert_contains "new reports the imported photograph" "Photos imported: 1"
assert_contains "new reports the imported XMP sidecar" "XMP sidecars imported: 1"

photo_plant_dir="$test_root/new-photo/working/plants/rocky-raccoon"
if cmp -s "$initial_photo" "$photo_plant_dir/photos/rocky-raccoon.jpg"; then
  pass "new preserves the imported photograph"
else
  fail "new preserves the imported photograph"
fi
if cmp -s "$initial_sidecar" "$photo_plant_dir/photos/rocky-raccoon.xmp"; then
  pass "new preserves the adjacent XMP sidecar"
else
  fail "new preserves the adjacent XMP sidecar"
fi
if grep -Fq "hero: photos/rocky-raccoon.jpg" "$photo_plant_dir/facts.yaml" && \
   grep -Fq "current: photos/rocky-raccoon.jpg" "$photo_plant_dir/facts.yaml"
then
  pass "new assigns the first photograph to hero and current roles"
else
  fail "new assigns the first photograph to hero and current roles"
fi

run_new "$test_root/new-photo" rocky-raccoon \
  --name "Rocky Raccoon" \
  --type orchid
assert_status "new refuses to overwrite an existing workspace" 1
assert_contains \
  "new reports an existing workspace" \
  "ERROR: Plant workspace already exists:"

run_new "$test_root/new-missing-name" rocky-raccoon --type orchid
assert_status "new requires a name" 2
assert_contains \
  "new explains required identity options" \
  "ERROR: --name and --type are required."

run_new "$test_root/new-invalid-slug" "Rocky Raccoon" \
  --name "Rocky Raccoon" \
  --type orchid
assert_status "new rejects an invalid slug" 2
assert_contains \
  "new explains the slug contract" \
  "ERROR: Plant slug must contain lowercase letters, numbers, and single hyphens"

run_new "$test_root/new-missing-photo" rocky-raccoon \
  --name "Rocky Raccoon" \
  --type orchid \
  --photo "$test_root/does-not-exist.jpg"
assert_status "new rejects a missing initial photograph" 1
assert_contains \
  "new reports a missing initial photograph" \
  "ERROR: Photo does not exist:"

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

plant_dir="$(create_plant valid-index-photo)"
awk '
  /^  index:/ { print "  index: photos/index.jpg"; next }
  { print }
' "$plant_dir/facts.yaml" > "$plant_dir/facts.yaml.tmp"
mv "$plant_dir/facts.yaml.tmp" "$plant_dir/facts.yaml"

run_validate "$test_root/valid-index-photo" test-plant
assert_status "configured index photo passes validation" 0
assert_contains   "configured index photo is validated"   "OK   photos.index exists: photos/index.jpg"

plant_dir="$(create_plant missing-index-photo)"
awk '
  /^  index:/ { print "  index: photos/missing-index.jpg"; next }
  { print }
' "$plant_dir/facts.yaml" > "$plant_dir/facts.yaml.tmp"
mv "$plant_dir/facts.yaml.tmp" "$plant_dir/facts.yaml"

run_validate "$test_root/missing-index-photo" test-plant
assert_status "missing configured index photo fails" 1
assert_contains   "missing configured index photo is reported"   "FAIL photos.index does not exist: photos/missing-index.jpg"

plant_dir="$(create_plant publish-index-photo)"
awk '
  /^  index:/ { print "  index: photos/index.jpg"; next }
  { print }
' "$plant_dir/facts.yaml" > "$plant_dir/facts.yaml.tmp"
mv "$plant_dir/facts.yaml.tmp" "$plant_dir/facts.yaml"

if command -v magick >/dev/null 2>&1; then
  image_command="magick"
elif command -v convert >/dev/null 2>&1; then
  image_command="convert"
else
  echo "ERROR ImageMagick is required for plant publishing tests."
  exit 1
fi

"$image_command"   -size 80x40   xc:white   "$plant_dir/photos/hero.jpg"

cp   "$plant_dir/photos/hero.jpg"   "$plant_dir/photos/current.jpg"

cp   "$plant_dir/photos/hero.jpg"   "$plant_dir/photos/index.jpg"

exiftool   -overwrite_original   -Orientation#=6   -Make="Apple"   -Model="iPhone Test"   -GPSLatitude="32.9"   -GPSLatitudeRef="N"   -GPSLongitude="97.3"   -GPSLongitudeRef="W"   "$plant_dir/photos/index.jpg" >/dev/null

source_index="$plant_dir/photos/index.jpg"
source_index_hash_before="$(
  sha256sum "$source_index" |
    awk '{print $1}'
)"

run_publish "$test_root/publish-index-photo" test-plant
assert_status "plant publishing with index photo succeeds" 0
assert_contains   "plant publishing reports the public index image"   "Published index image: /images/plants/test-plant/index.jpg"

published_index="$test_root/publish-index-photo/site/public/images/plants/test-plant/index.jpg"
generated_content="$test_root/publish-index-photo/content/plants/test-plant.md"

if [[ -f "$published_index" ]]; then
  pass "plant publishing creates the stable public index image"
else
  fail "plant publishing creates the stable public index image"
fi

source_index_hash_after="$(
  sha256sum "$source_index" |
    awk '{print $1}'
)"

if [[ "$source_index_hash_before" == "$source_index_hash_after" ]]; then
  pass "plant publishing preserves the canonical index image"
else
  fail "plant publishing preserves the canonical index image"
fi

if cmp -s "$source_index" "$published_index"; then
  fail "published index image is a generated derivative"
else
  pass "published index image is a generated derivative"
fi

published_metadata="$(
  exiftool     -a     -G1     -s     "$published_index"
)"

if grep -Eqi   'GPS|Latitude|Longitude|Make|Model|Orientation|Apple|PhotoIdentifier'   <<<"$published_metadata"
then
  fail "published index image removes private metadata"
  printf '%s\n' "$published_metadata"
else
  pass "published index image removes private metadata"
fi

published_dimensions="$(
  identify     -format '%wx%h'     "$published_index"
)"

if [[ "$published_dimensions" == "40x80" ]]; then
  pass "published index image applies EXIF orientation"
else
  fail "published index image applies EXIF orientation"
  printf '     Expected: 40x80\n'
  printf '     Actual:   %s\n' "$published_dimensions"
fi

publication_manifest="$test_root/publish-index-photo/generated/plant-publication/test-plant.json"

if [[ -f "$publication_manifest" ]]; then
  pass "plant publishing creates a non-public publication manifest"
else
  fail "plant publishing creates a non-public publication manifest"
fi

if python3 -   "$publication_manifest"   "$source_index_hash_before"   "$published_index" <<'PY_MANIFEST'
import hashlib
import json
import sys
from pathlib import Path

manifest_path = Path(sys.argv[1])
expected_source_hash = sys.argv[2]
published_path = Path(sys.argv[3])

data = json.loads(
    manifest_path.read_text(encoding="utf-8")
)

published_hash = hashlib.sha256(
    published_path.read_bytes()
).hexdigest()

index_records = [
    record
    for record in data["images"]
    if record["publication"].get("name") == "index"
]

assert data["schema_version"] == 1
assert data["plant"]["slug"] == "test-plant"
assert data["profile"]["maximum_edge"] == 2400
assert data["profile"]["colorspace"] == "sRGB"
assert data["profile"]["metadata_removed"] is True
assert data["profile"]["jpeg_quality"] == 85
assert len(index_records) == 1

record = index_records[0]

assert record["source"]["path"] == (
    "working/plants/test-plant/photos/index.jpg"
)
assert record["source"]["sha256"] == expected_source_hash
assert record["source"]["canonical_original_preserved"] is True

assert record["derivative"]["path"] == (
    "site/public/images/plants/test-plant/index.jpg"
)
assert record["derivative"]["sha256"] == published_hash
assert record["derivative"]["width"] == 40
assert record["derivative"]["height"] == 80

assert record["validation"]["private_metadata_detected"] is False
assert record["validation"]["source_hash_unchanged"] is True
PY_MANIFEST
then
  pass "publication manifest records the index transformation"
else
  fail "publication manifest records the index transformation"
fi

if grep -Eq   '^indexImage: /images/plants/test-plant/index\.jpg\?v=[0-9a-f]{12}$'   "$generated_content"
then
  pass "generated frontmatter contains a versioned indexImage"
else
  fail "generated frontmatter contains a versioned indexImage"
fi

if grep -Eq   '^currentImage: /images/plants/test-plant/current\.jpg\?v=[0-9a-f]{12}$'   "$generated_content"
then
  pass "generated frontmatter cache-busts the current image"
else
  fail "generated frontmatter cache-busts the current image"
fi

proof_file="$test_root/publish-index-photo/site/public/images/plants/test-plant/proof/reference.txt"
mkdir -p "$(dirname "$proof_file")"
printf 'preserve me\n' > "$proof_file"
run_publish "$test_root/publish-index-photo" test-plant
assert_status "repeat plant publishing succeeds" 0
if [[ -f "$proof_file" ]] && grep -Fq 'preserve me' "$proof_file"; then
  pass "plant publishing preserves unmanaged public artifacts"
else
  fail "plant publishing preserves unmanaged public artifacts"
fi

lock_dir="$test_root/publish-index-photo/site/public/images/plants/.test-plant.publish.lock"
mkdir "$lock_dir"
run_publish "$test_root/publish-index-photo" test-plant
assert_status "plant publishing rejects an overlapping publication" 1
assert_contains "plant publishing explains the overlapping publication" "publication is already in progress"
rmdir "$lock_dir"

published_content_hash_before="$(sha256sum "$generated_content" | awk '{print $1}')"
printf 'not an image\n' > "$plant_dir/photos/current.jpg"
run_publish "$test_root/publish-index-photo" test-plant
assert_status "failed derivative generation fails publication" 1
published_content_hash_after="$(sha256sum "$generated_content" | awk '{print $1}')"
if [[ "$published_content_hash_before" == "$published_content_hash_after" ]]; then
  pass "failed publication preserves the previous generated page"
else
  fail "failed publication preserves the previous generated page"
fi
if find "$test_root/publish-index-photo/site/public/images/plants" \
  -maxdepth 1 -type d -name '.test-plant.publish.*' | grep -q .
then
  fail "failed publication removes its staging directory"
else
  pass "failed publication removes its staging directory"
fi
cp "$plant_dir/photos/hero.jpg" "$plant_dir/photos/current.jpg"

batch_root="$test_root/publish-batch"
first_plant="$(create_plant publish-batch)"
"$image_command" -size 80x40 xc:white "$first_plant/photos/hero.jpg"
cp "$first_plant/photos/hero.jpg" "$first_plant/photos/current.jpg"
cp "$first_plant/photos/hero.jpg" "$first_plant/photos/index.jpg"
second_plant="$batch_root/working/plants/second-plant"
cp -R "$first_plant" "$second_plant"
awk '
  /^name: Test Plant$/ { print "name: Second Plant"; next }
  /^slug: test-plant$/ { print "slug: second-plant"; next }
  { print }
' "$second_plant/facts.yaml" > "$second_plant/facts.yaml.tmp"
mv "$second_plant/facts.yaml.tmp" "$second_plant/facts.yaml"

run_publish_batch "$batch_root" test-plant second-plant
assert_status "batch publishing succeeds" 0
assert_contains "batch publishing reports serialized mode" "Mode: serialized"
assert_contains "batch publishing reports completion" "PASS Published 2 plant(s) serially."
if [[ -f "$batch_root/content/plants/test-plant.md" && -f "$batch_root/content/plants/second-plant.md" ]]; then
  pass "batch publishing generates every requested plant"
else
  fail "batch publishing generates every requested plant"
fi

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
