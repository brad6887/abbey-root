#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
ABBEY_ROOT="$(cd "$(dirname "$SCRIPT_PATH")/.." && pwd)"
ABBEY_PLANT="$ABBEY_ROOT/tools/bin/abbey-plant"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

passed=0
failed=0
pass() { echo "PASS $1"; passed=$((passed + 1)); }
fail() { echo "FAIL $1"; failed=$((failed + 1)); }

assert_contains() {
  local name="$1" expected="$2" value="$3"
  if grep -Fq -- "$expected" <<<"$value"; then pass "$name"; else fail "$name"; fi
}

assert_not_contains() {
  local name="$1" unexpected="$2" value="$3"
  if grep -Fq -- "$unexpected" <<<"$value"; then fail "$name"; else pass "$name"; fi
}

mkdir -p "$test_root/bin"
cat > "$test_root/bin/exiftool" <<'SCRIPT'
#!/usr/bin/env bash
tag="$2"
file="${3##*/}"
case "$tag:$file" in
  -XMP-dc:Description:IMG_1001.xmp|-XMP-dc:Description:IMG_1002.xmp) echo "Revolution" ;;
  -XMP-dc:Description:IMG_2001.xmp) echo "Lady Madonna" ;;
  -XMP-dc:Description:IMG_3001.xmp) : ;;
  -XMP-dc:Description:IMG_4001.xmp) echo "Something" ;;
  -DateTimeOriginal:IMG_1001.JPG) echo "2026:08:02 08:18:01" ;;
  -DateTimeOriginal:IMG_1002.HEIC) echo "2026:08:02 08:17:59" ;;
  -DateTimeOriginal:IMG_2001.jpeg) echo "2026:08:03 10:00:00" ;;
  -DateTimeOriginal:IMG_3001.JPG) echo "2026:08:04 10:00:00" ;;
esac
SCRIPT
chmod +x "$test_root/bin/exiftool"

run_rename() {
  set +e
  output="$(PATH="$test_root/bin:$PATH" "$ABBEY_PLANT" rename-exports "$@" 2>&1)"
  status=$?
  set -e
}

photos="$test_root/photos"
mkdir -p "$photos"
touch "$photos/IMG_1001.JPG" "$photos/IMG_1001.xmp"
touch "$photos/IMG_1002.HEIC" "$photos/IMG_1002.xmp"
touch "$photos/IMG_2001.jpeg" "$photos/IMG_2001.xmp"
touch "$photos/._IMG_1001.JPG" "$photos/._IMG_1001.xmp"

run_rename "$photos" --dry-run
[[ "$status" -eq 0 ]] && pass "dry run succeeds" || fail "dry run succeeds"
assert_contains "earlier duplicate gets first sequence" "IMG_1002.HEIC -> revolution-2026-08-02-01.heic" "$output"
assert_contains "later duplicate gets second sequence" "IMG_1001.JPG -> revolution-2026-08-02-02.jpg" "$output"
assert_contains "single photo has no sequence" "IMG_2001.jpeg -> lady-madonna-2026-08-03.jpeg" "$output"
assert_not_contains "AppleDouble files are ignored" "._IMG_1001" "$output"
[[ -f "$photos/IMG_1001.JPG" ]] && pass "dry run preserves files" || fail "dry run preserves files"

run_rename "$photos"
[[ "$status" -eq 0 ]] && pass "rename succeeds" || fail "rename succeeds"
for file in \
  revolution-2026-08-02-01.heic revolution-2026-08-02-01.xmp \
  revolution-2026-08-02-02.jpg revolution-2026-08-02-02.xmp \
  lady-madonna-2026-08-03.jpeg lady-madonna-2026-08-03.xmp
do
  [[ -f "$photos/$file" ]] && pass "creates $file" || fail "creates $file"
done
[[ -f "$photos/._IMG_1001.JPG" && -f "$photos/._IMG_1001.xmp" ]] && pass "AppleDouble files remain untouched" || fail "AppleDouble files remain untouched"

missing="$test_root/missing"
mkdir -p "$missing"
touch "$missing/IMG_1001.JPG"
run_rename "$missing"
[[ "$status" -eq 1 ]] && pass "missing sidecar fails" || fail "missing sidecar fails"
assert_contains "missing sidecar is explained" "adjacent XMP sidecar is missing" "$output"
[[ -f "$missing/IMG_1001.JPG" ]] && pass "validation failure preserves image" || fail "validation failure preserves image"

caption="$test_root/caption"
mkdir -p "$caption"
touch "$caption/IMG_3001.JPG" "$caption/IMG_3001.xmp"
run_rename "$caption"
[[ "$status" -eq 1 ]] && pass "missing caption fails" || fail "missing caption fails"
assert_contains "missing caption is explained" "XMP-dc:Description caption is missing" "$output"

date_missing="$test_root/date-missing"
mkdir -p "$date_missing"
touch "$date_missing/IMG_4001.JPG" "$date_missing/IMG_4001.xmp"
run_rename "$date_missing"
[[ "$status" -eq 1 ]] && pass "missing date fails" || fail "missing date fails"
assert_contains "missing date is explained" "DateTimeOriginal is missing or invalid" "$output"

collision="$test_root/collision"
mkdir -p "$collision"
touch "$collision/IMG_2001.jpeg" "$collision/IMG_2001.xmp"
touch "$collision/lady-madonna-2026-08-03.xmp"
run_rename "$collision"
[[ "$status" -eq 1 ]] && pass "existing destination fails" || fail "existing destination fails"
assert_contains "existing destination is explained" "Destination already exists" "$output"
[[ -f "$collision/IMG_2001.jpeg" ]] && pass "collision preserves source" || fail "collision preserves source"

echo
echo "Result: $passed passed, $failed failed"
[[ "$failed" -eq 0 ]]
