#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ABBEY_TOOLKIT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY="$ABBEY_TOOLKIT_ROOT/tools/bin/abbey"
ABBEY_IMAGE="$ABBEY_TOOLKIT_ROOT/tools/bin/abbey-image"

test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

passed=0
failed=0
output=""
status=0

pass() {
  printf 'PASS %s\n' "$1"
  passed=$((passed + 1))
}

fail() {
  printf 'FAIL %s\n' "$1"
  failed=$((failed + 1))
}

assert_status() {
  local label="$1"
  local expected="$2"

  if [[ "$status" -eq "$expected" ]]; then
    pass "$label"
  else
    fail "$label"
    printf '     Expected status: %s\n' "$expected"
    printf '     Actual status:   %s\n' "$status"
    printf '%s\n' "$output"
  fi
}

assert_contains() {
  local label="$1"
  local expected="$2"

  if grep -Fq -- "$expected" <<<"$output"; then
    pass "$label"
  else
    fail "$label"
    printf '     Expected output: %s\n' "$expected"
    printf '%s\n' "$output"
  fi
}

assert_not_contains() {
  local label="$1"
  local unexpected="$2"

  if grep -Fq -- "$unexpected" <<<"$output"; then
    fail "$label"
    printf '     Unexpected output: %s\n' "$unexpected"
    printf '%s\n' "$output"
  else
    pass "$label"
  fi
}

assert_file_contains() {
  local label="$1"
  local file="$2"
  local expected="$3"

  if grep -Fq -- "$expected" "$file"; then
    pass "$label"
  else
    fail "$label"
    printf '     Expected file content: %s\n' "$expected"
    sed -n '1,120p' "$file"
  fi
}

assert_file_not_contains() {
  local label="$1"
  local file="$2"
  local unexpected="$3"

  if grep -Fq -- "$unexpected" "$file"; then
    fail "$label"
    printf '     Unexpected file content: %s\n' "$unexpected"
    sed -n '1,120p' "$file"
  else
    pass "$label"
  fi
}

create_project() {
  local fixture="$1"
  local root="$test_root/$fixture"
  local plant="$root/working/plants/test-plant"

  mkdir -p \
    "$root/.abbey" \
    "$plant/photos" \
    "$plant/sources"

  cat > "$root/.abbey/project.yml" <<'YAML'
schema_version: 1
project:
  name: Image Test Project
  slug: image-test-project
framework:
  name: Abbey
  schema_version: 1
configuration:
  allow_toolkit_defaults: false
YAML

  cat > "$root/.abbey/image-roles.yml" <<'YAML'
schema_version: 1

entities:
  plant:
    root: working/plants
    images: photos
    metadata: facts.yaml
    extensions:
      - .jpg
      - .jpeg
      - .png
      - .webp
    roles:
      hero:
        field: photos.hero
      index:
        field: photos.index
YAML

  cat > "$plant/facts.yaml" <<'YAML'
name: Test Plant
slug: test-plant
description: Preserve this unrelated value.

photos:
  hero: photos/Alpha One.JPG
  current: photos/Gamma.png
  index: null
YAML

  touch \
    "$plant/photos/Alpha One.JPG" \
    "$plant/photos/Beta Two.jpeg" \
    "$plant/photos/Gamma.png" \
    "$plant/photos/Ignore.xmp" \
    "$plant/photos/notes.txt"

  (cd "$root" && pwd -P)
}

run_direct() {
  local root="$1"
  shift

  set +e
  output="$(
    ABBEY_ROOT="$root" \
    ABBEY_TOOLKIT_ROOT="$ABBEY_TOOLKIT_ROOT" \
      "$ABBEY_IMAGE" "$@" 2>&1
  )"
  status=$?
  set -e
}

run_direct_input() {
  local root="$1"
  local input="$2"
  shift 2

  set +e
  output="$(
    printf '%s' "$input" |
      ABBEY_ROOT="$root" \
      ABBEY_TOOLKIT_ROOT="$ABBEY_TOOLKIT_ROOT" \
        "$ABBEY_IMAGE" "$@" 2>&1
  )"
  status=$?
  set -e
}

run_dispatch() {
  local root="$1"
  shift

  set +e
  output="$(
    cd "$root/working/plants/test-plant" &&
      "$ABBEY" "$@" 2>&1
  )"
  status=$?
  set -e
}

printf 'Abbey Image Selection Regression Tests\n'
printf '======================================\n\n'

run_direct "$test_root" help
assert_status "help succeeds" 0
assert_contains \
  "help documents generic image selection" \
  "abbey image select <entity> <item> --role <role>"

run_direct "$test_root" select
assert_status "missing entity and item returns usage status" 2
assert_contains \
  "missing entity and item are reported" \
  "ERROR Entity and item are required."

missing_config_root="$test_root/missing-config"
mkdir -p "$missing_config_root/.abbey"
cat > "$missing_config_root/.abbey/project.yml" <<'YAML'
schema_version: 1
project:
  name: Missing Image Configuration
  slug: missing-image-configuration
configuration:
  allow_toolkit_defaults: false
YAML

run_direct \
  "$missing_config_root" \
  select plant test-plant --role hero
assert_status "missing image-role configuration fails" 1
assert_contains \
  "missing configuration path is reported" \
  "$missing_config_root/.abbey/image-roles.yml"
assert_contains \
  "missing configuration reports disabled toolkit defaults" \
  "Toolkit defaults are disabled"

project="$(create_project valid-selection)"
facts="$project/working/plants/test-plant/facts.yaml"

run_direct_input \
  "$project" \
  $'q\n' \
  select plant test-plant --role hero
assert_status "interactive cancellation succeeds" 0
assert_contains \
  "current image is identified" \
  "1. Alpha One.JPG [current]"
assert_contains \
  "preflight reports the active project" \
  "Active project:       $project"
assert_contains \
  "preflight reports project configuration" \
  "Configuration:        $project/.abbey/image-roles.yml"
assert_contains \
  "preflight reports project configuration source" \
  "Configuration source: active project"
assert_contains \
  "preflight reports the image source" \
  "Image source:         $project/working/plants/test-plant/photos"
assert_contains \
  "preflight reports the metadata target" \
  "Metadata target:      $project/working/plants/test-plant/facts.yaml"
assert_contains \
  "eligible JPEG image is listed" \
  "2. Beta Two.jpeg"
assert_contains \
  "eligible PNG image is listed" \
  "3. Gamma.png"
assert_not_contains \
  "XMP sidecars are excluded" \
  "Ignore.xmp"
assert_not_contains \
  "non-image text files are excluded" \
  "notes.txt"
assert_contains \
  "cancellation reports no change" \
  "Cancelled. No files changed."
assert_file_contains \
  "cancellation preserves current hero" \
  "$facts" \
  "hero: photos/Alpha One.JPG"

interactive_project="$(create_project interactive-selection)"
interactive_facts="$interactive_project/working/plants/test-plant/facts.yaml"

run_direct_input \
  "$interactive_project" \
  $'2\ny\n' \
  select plant test-plant --role hero
assert_status "interactive numbered selection succeeds" 0
assert_contains \
  "interactive numbered selection reports the selected image" \
  "Selected: photos/Beta Two.jpeg"
assert_file_contains \
  "interactive numbered selection updates metadata" \
  "$interactive_facts" \
  'hero: "photos/Beta Two.jpeg"'

run_direct \
  "$project" \
  select plant test-plant --role hero --select 1 --yes
assert_status "reselecting current image succeeds" 0
assert_contains \
  "reselecting current image reports no change" \
  "The selected image already has this role."
assert_file_contains \
  "reselecting current image preserves metadata" \
  "$facts" \
  "hero: photos/Alpha One.JPG"

run_direct \
  "$project" \
  select plant test-plant --role hero --select 99 --yes
assert_status "out-of-range selection returns usage status" 2
assert_contains \
  "out-of-range selection reports valid range" \
  "--select must be between 1 and 3"
assert_file_contains \
  "invalid selection preserves metadata" \
  "$facts" \
  "hero: photos/Alpha One.JPG"

run_direct_input \
  "$project" \
  $'n\n' \
  select plant test-plant --role hero --select 2
assert_status "declined confirmation succeeds" 0
assert_contains \
  "declined confirmation reports cancellation" \
  "Cancelled. No files changed."
assert_file_contains \
  "declined confirmation preserves current hero" \
  "$facts" \
  "hero: photos/Alpha One.JPG"

run_direct \
  "$project" \
  select plant test-plant --role hero --select 2 --yes
assert_status "non-interactive selection succeeds" 0
assert_contains \
  "successful selection reports metadata path" \
  "Updated:"
assert_contains \
  "successful selection reports configured field" \
  "photos.hero: photos/Beta Two.jpeg"
assert_file_contains \
  "successful selection updates the configured field" \
  "$facts" \
  'hero: "photos/Beta Two.jpeg"'
assert_file_contains \
  "successful selection preserves unrelated metadata" \
  "$facts" \
  "description: Preserve this unrelated value."
assert_file_contains \
  "successful selection preserves the current image field" \
  "$facts" \
  "current: photos/Gamma.png"

if python3 - "$facts" <<'PY'
import sys
from pathlib import Path

import yaml

data = yaml.safe_load(Path(sys.argv[1]).read_text(encoding="utf-8"))
assert data["photos"]["hero"] == "photos/Beta Two.jpeg"
assert data["photos"]["current"] == "photos/Gamma.png"
assert data["description"] == "Preserve this unrelated value."
PY
then
  pass "updated metadata remains valid YAML"
else
  fail "updated metadata remains valid YAML"
fi

run_direct \
  "$project" \
  select recipe test-plant --role hero
assert_status "unsupported entity fails" 1
assert_contains \
  "unsupported entity is reported" \
  "unsupported image entity: recipe"

run_direct \
  "$project" \
  select plant test-plant --role thumbnail
assert_status "unsupported role fails" 1
assert_contains \
  "unsupported role is reported" \
  "unsupported role for plant: thumbnail"

run_direct \
  "$project" \
  select plant ../outside --role hero
assert_status "invalid item name returns usage status" 2
assert_contains \
  "invalid item name is reported" \
  "Invalid item name: ../outside"

missing_images_project="$(create_project missing-images)"
rm -rf "$missing_images_project/working/plants/test-plant/photos"

run_direct \
  "$missing_images_project" \
  select plant test-plant --role hero
assert_status "missing image directory fails" 1
assert_contains \
  "missing image directory is reported" \
  "image directory does not exist:"

empty_images_project="$(create_project empty-images)"
find \
  "$empty_images_project/working/plants/test-plant/photos" \
  -maxdepth 1 \
  -type f \
  -delete
touch \
  "$empty_images_project/working/plants/test-plant/photos/Ignore.xmp"

run_direct \
  "$empty_images_project" \
  select plant test-plant --role hero
assert_status "image directory without eligible files fails" 1
assert_contains \
  "absence of eligible images is reported" \
  "no eligible images found in:"

wrapper_project="$(create_project plant-wrapper)"
wrapper_facts="$wrapper_project/working/plants/test-plant/facts.yaml"

run_dispatch \
  "$wrapper_project" \
  plant hero test-plant --select 3 --yes
assert_status "plant hero wrapper succeeds in external project" 0
assert_contains \
  "plant wrapper delegates to image selector" \
  "Abbey Image Selection"
assert_file_contains \
  "plant wrapper updates external project metadata" \
  "$wrapper_facts" \
  'hero: "photos/Gamma.png"'

index_project="$(create_project plant-index-wrapper)"
index_facts="$index_project/working/plants/test-plant/facts.yaml"

run_dispatch   "$index_project"   plant index test-plant --select 2 --yes
assert_status "plant index wrapper succeeds in external project" 0
assert_contains   "plant index wrapper delegates to image selector"   "Abbey Image Selection"
assert_file_contains   "plant index wrapper updates external project metadata"   "$index_facts"   'index: "photos/Beta Two.jpeg"'
assert_file_contains   "plant index wrapper preserves the hero role"   "$index_facts"   "hero: photos/Alpha One.JPG"
assert_file_contains   "plant index wrapper preserves the current role"   "$index_facts"   "current: photos/Gamma.png"

generic_project="$(create_project generic-dispatch)"
generic_facts="$generic_project/working/plants/test-plant/facts.yaml"

run_dispatch \
  "$generic_project" \
  image select plant test-plant --role hero --select 2 --yes
assert_status "generic dispatcher succeeds in external project" 0
assert_file_contains \
  "generic dispatcher updates external project metadata" \
  "$generic_facts" \
  'hero: "photos/Beta Two.jpeg"'

assert_file_not_contains \
  "generic dispatcher does not modify the current image role" \
  "$generic_facts" \
  'current: "photos/Beta Two.jpeg"'

isolated_project="$(create_project isolated-configuration)"
rm "$isolated_project/.abbey/image-roles.yml"

run_dispatch \
  "$isolated_project" \
  image select plant test-plant --role hero --select 2 --yes
assert_status "project without image configuration fails closed" 1
assert_contains \
  "missing local configuration identifies the active project" \
  "$isolated_project/.abbey/image-roles.yml"
assert_not_contains \
  "project does not inherit the Abbey Root image configuration" \
  "$ABBEY_TOOLKIT_ROOT/.abbey/image-roles.yml"
assert_file_contains \
  "failed cross-project selection preserves metadata" \
  "$isolated_project/working/plants/test-plant/facts.yaml" \
  "hero: photos/Alpha One.JPG"

fallback_project="$(create_project explicit-toolkit-default)"
rm "$fallback_project/.abbey/image-roles.yml"
python3 - "$fallback_project/.abbey/project.yml" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
path.write_text(
    text.replace("allow_toolkit_defaults: false", "allow_toolkit_defaults: true"),
    encoding="utf-8",
)
PY

run_dispatch \
  "$fallback_project" \
  image select plant test-plant --role hero --select 2 --yes
assert_status "explicitly enabled toolkit image defaults succeed" 0
assert_contains \
  "toolkit fallback source is reported" \
  "Configuration source: toolkit default"
assert_contains \
  "toolkit fallback path is reported" \
  "Configuration:        $ABBEY_TOOLKIT_ROOT/.abbey/image-roles.yml"
assert_file_contains \
  "toolkit fallback updates only the active project" \
  "$fallback_project/working/plants/test-plant/facts.yaml" \
  'hero: "photos/Beta Two.jpeg"'

invalid_project="$(create_project invalid-project-metadata)"
cat > "$invalid_project/.abbey/project.yml" <<'YAML'
schema_version: 1
project: [invalid
YAML

run_direct \
  "$invalid_project" \
  select plant test-plant --role hero
assert_status "malformed project metadata fails before image selection" 1
assert_contains \
  "malformed project metadata identifies the project marker" \
  "$invalid_project/.abbey/project.yml"

printf '\nPassed: %d\n' "$passed"
printf 'Failed: %d\n' "$failed"

if (( failed > 0 )); then
  exit 1
fi
