#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HELPER="$ABBEY_ROOT/tools/image/create_public_derivative.py"

test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

passed=0
failed=0

pass() {
  printf 'PASS %s\n' "$1"
  passed=$((passed + 1))
}

fail() {
  printf 'FAIL %s\n' "$1"
  failed=$((failed + 1))
}

for command in python3 exiftool identify sha256sum; do
  if ! command -v "$command" >/dev/null 2>&1; then
    echo "ERROR Required test command is missing: $command"
    exit 1
  fi
done

if command -v magick >/dev/null 2>&1; then
  image_command=(magick)
elif command -v convert >/dev/null 2>&1; then
  image_command=(convert)
else
  echo "ERROR ImageMagick is required for this test."
  exit 1
fi

source_image="$test_root/source.jpg"
public_image="$test_root/public.jpg"
provenance="$test_root/provenance.json"

"${image_command[@]}" \
  -size 80x40 \
  xc:white \
  "$source_image"

exiftool \
  -overwrite_original \
  -Orientation#=6 \
  -Make="Apple" \
  -Model="iPhone Test" \
  -GPSLatitude="32.9" \
  -GPSLatitudeRef="N" \
  -GPSLongitude="97.3" \
  -GPSLongitudeRef="W" \
  "$source_image" >/dev/null

source_hash_before="$(sha256sum "$source_image" | awk '{print $1}')"

set +e
output="$(
  "$HELPER" \
    "$source_image" \
    "$public_image" \
    --max-edge 60 \
    --quality 85 \
    > "$provenance" 2>&1
)"
status=$?
set -e

if [[ "$status" -eq 0 ]]; then
  pass "public derivative generation succeeds"
else
  fail "public derivative generation succeeds"
  printf '%s\n' "$output"
fi

if [[ -f "$public_image" ]]; then
  pass "public derivative is created"
else
  fail "public derivative is created"
fi

source_hash_after="$(sha256sum "$source_image" | awk '{print $1}')"

if [[ "$source_hash_before" == "$source_hash_after" ]]; then
  pass "canonical source remains unchanged"
else
  fail "canonical source remains unchanged"
fi

dimensions="$(identify -format '%wx%h' "$public_image")"

if [[ "$dimensions" == "30x60" ]]; then
  pass "orientation is baked in before resizing"
else
  fail "orientation is baked in before resizing"
  printf '     Expected: 30x60\n'
  printf '     Actual:   %s\n' "$dimensions"
fi

metadata="$(
  exiftool \
    -a \
    -G1 \
    -s \
    "$public_image"
)"

if grep -Eqi \
  'GPS|Latitude|Longitude|Make|Model|Orientation|Apple|DateTimeOriginal|PhotoIdentifier' \
  <<<"$metadata"
then
  fail "private metadata is removed"
  printf '%s\n' "$metadata"
else
  pass "private metadata is removed"
fi

if python3 - "$provenance" "$source_hash_before" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
expected_source_hash = sys.argv[2]

data = json.loads(path.read_text(encoding="utf-8"))

assert data["source"]["sha256"] == expected_source_hash
assert data["source"]["canonical_original_preserved"] is True
assert data["derivative"]["width"] == 30
assert data["derivative"]["height"] == 60
assert data["transformation"]["maximum_edge"] == 60
assert data["transformation"]["metadata_removed"] is True
assert data["validation"]["private_metadata_detected"] is False
assert data["validation"]["source_hash_unchanged"] is True
PY
then
  pass "provenance accurately describes the derivative"
else
  fail "provenance accurately describes the derivative"
fi

bad_source="$test_root/not-an-image.jpg"
bad_destination="$test_root/bad-public.jpg"
printf 'not an image\n' > "$bad_source"

set +e
bad_output="$(
  "$HELPER" \
    "$bad_source" \
    "$bad_destination" \
    2>&1
)"
bad_status=$?
set -e

if [[ "$bad_status" -ne 0 ]]; then
  pass "invalid source image fails safely"
else
  fail "invalid source image fails safely"
fi

if [[ ! -e "$bad_destination" ]]; then
  pass "failed conversion leaves no public derivative"
else
  fail "failed conversion leaves no public derivative"
fi

printf '\nResult\n'
printf '%s\n' '------'
printf 'PASS: %d  FAIL: %d\n' "$passed" "$failed"

if ((failed > 0)); then
  exit 1
fi
