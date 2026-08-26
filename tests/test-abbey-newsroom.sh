#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ABBEY_TOOLKIT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY="$ABBEY_TOOLKIT_ROOT/tools/bin/abbey"
test_root="$(mktemp -d)"
trap 'rm -rf "$test_root"' EXIT

passed=0
failed=0

pass() { printf 'PASS %s\n' "$1"; passed=$((passed + 1)); }
fail() { printf 'FAIL %s\n' "$1"; failed=$((failed + 1)); }

assert_contains() {
  if grep -Fq -- "$2" <<<"$3"; then pass "$1"; else fail "$1"; fi
}

make_project() {
  local root="$1"
  local name="$2"

  mkdir -p \
    "$root/.abbey" \
    "$root/bin" \
    "$root/nested/deeper" \
    "$root/newsroom/assignments" \
    "$root/newsroom/drafts"
  cat > "$root/.abbey/project.yml" <<YAML
schema_version: 1
project:
  name: $name
newsroom:
  assignments_dir: newsroom/assignments
  assign:
    entrypoint: bin/assign
  generate:
    entrypoint: bin/generate
    output_dir: newsroom/drafts
    repair_model: project-repair-model
    repair_temperature: 0.2
    repair_context: 8192
YAML
  cat > "$root/bin/assign" <<'SH'
#!/usr/bin/env bash
printf 'engine=%s\n' "$(basename "$(dirname "$(dirname "$0")")")"
printf 'stdout-line\n'
printf 'stderr-line\n' >&2
printf 'arg=<%s>\n' "$@"
exit "${ENGINE_STATUS:-0}"
SH
  cat > "$root/bin/generate" <<'SH'
#!/usr/bin/env bash
printf 'engine=%s\n' "$(basename "$(dirname "$(dirname "$0")")")"
printf 'stdout-line\n'
printf 'stderr-line\n' >&2
printf 'repair_model=<%s>\n' "${ARTICLE_AI_REPAIR_MODEL:-}"
printf 'repair_temperature=<%s>\n' "${ARTICLE_AI_REPAIR_TEMPERATURE:-}"
printf 'repair_context=<%s>\n' "${ARTICLE_AI_REPAIR_CONTEXT:-}"
printf 'arg=<%s>\n' "$@"

assignment=""
output=""
while (( $# > 0 )); do
  case "$1" in
    --assignment)
      assignment="$2"
      shift 2
      ;;
    --output)
      output="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

assignment_name="$(basename "$assignment")"
if [[ -n "${ORDER_LOG:-}" ]]; then
  printf '%s\n' "$assignment_name" >> "$ORDER_LOG"
fi
if [[ "$assignment_name" == *fail* ]]; then
  printf 'simulated failure for %s\n' "$assignment_name" >&2
  exit 37
fi
if [[ -n "$output" ]]; then
  mkdir -p "$(dirname "$output")"
  : > "$output"
fi
exit "${ENGINE_STATUS:-0}"
SH
  chmod +x "$root/bin/assign" "$root/bin/generate"
}

use_symlinked_interpreter() {
  python3 - "$1/.abbey/project.yml" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
path.write_text(
    text.replace(
        "    entrypoint: bin/assign\n",
        "    entrypoint: bin/assign\n    interpreter: bin/interpreter\n",
    ),
    encoding="utf-8",
)
PY
  ln -s /bin/bash "$1/bin/interpreter"
  chmod -x "$1/bin/assign"
}

project_a="$test_root/project-a"
project_b="$test_root/project-b"
missing="$test_root/missing"
make_project "$project_a" "Project A"
make_project "$project_b" "Project B"
use_symlinked_interpreter "$project_b"
mkdir -p "$missing/.abbey"
cat > "$missing/.abbey/project.yml" <<'YAML'
schema_version: 1
project:
  name: Missing Newsroom Configuration
YAML

output="$(
  cd "$project_a/nested/deeper" &&
    "$ABBEY" newsroom assign \
      --date 2008-01 \
      --writer martin-quist \
      --category culture \
      --entity "Fairview Regional Theater" \
      --count 3 \
      2>&1
)"
status=$?

[[ "$status" -eq 0 ]] && pass "newsroom assign is discovered by the main CLI" || fail "newsroom assign is discovered by the main CLI"
assert_contains "nested command discovery uses the active project" "engine=project-a" "$output"
assert_contains "date option is forwarded" "arg=<--date>" "$output"
assert_contains "date is forwarded" "arg=<2008-01>" "$output"
assert_contains "writer option is forwarded" "arg=<--writer>" "$output"
assert_contains "writer is forwarded" "arg=<martin-quist>" "$output"
assert_contains "category option is forwarded" "arg=<--category>" "$output"
assert_contains "category is forwarded" "arg=<culture>" "$output"
assert_contains "entity option is forwarded" "arg=<--entity>" "$output"
assert_contains "entity with spaces is forwarded as one argument" "arg=<Fairview Regional Theater>" "$output"
assert_contains "count option is forwarded" "arg=<--count>" "$output"
assert_contains "count is forwarded" "arg=<3>" "$output"

assignment_file="$project_a/newsroom/assignments/2008-01-test.yml"
draft_output="$project_a/newsroom/drafts/2008-01-test.md"
output="$(
  cd "$project_a/nested/deeper" &&
    "$ABBEY" newsroom generate "$assignment_file" \
      --model test-model \
      --attempts 4 \
      2>&1
)"
status=$?

[[ "$status" -eq 0 ]] && pass "newsroom generate is discovered by the main CLI" || fail "newsroom generate is discovered by the main CLI"
assert_contains "generate discovery uses the active project" "engine=project-a" "$output"
assert_contains "assignment option is supplied" "arg=<--assignment>" "$output"
assert_contains "assignment path is forwarded" "arg=<$assignment_file>" "$output"
assert_contains "generation is enabled" "arg=<--generate>" "$output"
assert_contains "default output option is supplied" "arg=<--output>" "$output"
assert_contains "default output uses the configured directory and assignment basename" "arg=<$draft_output>" "$output"
assert_contains "model option is forwarded" "arg=<--model>" "$output"
assert_contains "model is forwarded" "arg=<test-model>" "$output"
assert_contains "attempts option is forwarded" "arg=<--attempts>" "$output"
assert_contains "attempt count is forwarded" "arg=<4>" "$output"
assert_contains "project repair model is supplied as a fallback" "repair_model=<project-repair-model>" "$output"
assert_contains "project repair temperature is supplied as a fallback" "repair_temperature=<0.2>" "$output"
assert_contains "project repair context is supplied as a fallback" "repair_context=<8192>" "$output"

output="$(
  cd "$project_a" &&
    ARTICLE_AI_REPAIR_MODEL=environment-repair-model \
    ARTICLE_AI_REPAIR_TEMPERATURE=0.15 \
    ARTICLE_AI_REPAIR_CONTEXT=6144 \
    "$ABBEY" newsroom generate "$assignment_file" \
      --repair-model cli-repair-model \
      --repair-temperature 0.1 \
      --repair-context 4096 \
      2>&1
)"
assert_contains "environment repair model overrides project fallback" "repair_model=<environment-repair-model>" "$output"
assert_contains "environment repair temperature overrides project fallback" "repair_temperature=<0.15>" "$output"
assert_contains "environment repair context overrides project fallback" "repair_context=<6144>" "$output"
assert_contains "explicit repair model is forwarded over the fallback environment" "arg=<cli-repair-model>" "$output"
assert_contains "explicit repair temperature is forwarded over the fallback environment" "arg=<0.1>" "$output"
assert_contains "explicit repair context is forwarded over the fallback environment" "arg=<4096>" "$output"

custom_output="$project_a/custom/special-draft.md"
output="$(
  cd "$project_a" &&
    "$ABBEY" newsroom generate "$assignment_file" --output "$custom_output" 2>&1
)"
assert_contains "output override is forwarded" "arg=<$custom_output>" "$output"

output="$(cd "$project_a" && "$ABBEY" newsroom generate --help 2>&1)"
status=$?
[[ "$status" -eq 0 ]] && pass "newsroom generate help exits successfully" || fail "newsroom generate help exits successfully"
assert_contains "generate help shows generate usage" "abbey newsroom generate <assignment-file>" "$output"
if grep -Fq "engine=" <<<"$output"; then
  fail "generate help does not invoke the configured generator"
else
  pass "generate help does not invoke the configured generator"
fi

output="$(cd "$project_b" && "$ABBEY" newsroom generate "$assignment_file" 2>&1)"
assert_contains "a second project's own generator is used" "engine=project-b" "$output"

output="$(cd "$project_b" && "$ABBEY" newsroom assign 2>&1)"
assert_contains "a second project's own engine is used" "engine=project-b" "$output"
assert_contains "a project-local symlinked interpreter is supported" "stdout-line" "$output"
if grep -Fq "project-a" <<<"$output"; then
  fail "newsroom integration is project agnostic"
else
  pass "newsroom integration is project agnostic"
fi

stdout_file="$test_root/stdout"
stderr_file="$test_root/stderr"
set +e
(
  cd "$project_a" &&
    ENGINE_STATUS=23 "$ABBEY" newsroom assign
) >"$stdout_file" 2>"$stderr_file"
status=$?
set -e
[[ "$status" -eq 23 ]] && pass "assignment engine exit status is preserved" || fail "assignment engine exit status is preserved"
assert_contains "assignment engine stdout is preserved" "stdout-line" "$(cat "$stdout_file")"
assert_contains "assignment engine stderr is preserved" "stderr-line" "$(cat "$stderr_file")"

set +e
(
  cd "$project_a" &&
    ENGINE_STATUS=29 "$ABBEY" newsroom generate "$assignment_file"
) >"$stdout_file" 2>"$stderr_file"
status=$?
set -e
[[ "$status" -eq 29 ]] && pass "article generator exit status is preserved" || fail "article generator exit status is preserved"
assert_contains "article generator stdout is preserved" "stdout-line" "$(cat "$stdout_file")"
assert_contains "article generator stderr is preserved" "stderr-line" "$(cat "$stderr_file")"

set +e
output="$(cd "$missing" && "$ABBEY" newsroom assign 2>&1)"
status=$?
set -e
[[ "$status" -ne 0 ]] && pass "missing newsroom assignment configuration fails" || fail "missing newsroom assignment configuration fails"
assert_contains "missing configuration error names the required key" "newsroom.assign.entrypoint" "$output"

set +e
output="$(cd "$missing" && "$ABBEY" newsroom generate assignment.yml --output draft.md 2>&1)"
status=$?
set -e
[[ "$status" -ne 0 ]] && pass "missing newsroom generate configuration fails" || fail "missing newsroom generate configuration fails"
assert_contains "missing generate configuration error names the required key" "newsroom.generate.entrypoint" "$output"
batch_assignments="$project_a/newsroom/assignments"
batch_drafts="$project_a/newsroom/drafts"
mkdir -p "$batch_assignments" "$batch_drafts"
: > "$batch_assignments/2008-02-a.yml"
: > "$batch_assignments/2008-02-b-skip.yml"
: > "$batch_assignments/2008-02-c-fail.yml"
: > "$batch_assignments/2008-02-d.yaml"
: > "$batch_drafts/2008-02-b-skip.md"
order_log="$test_root/generation-order"

set +e
output="$(
  cd "$project_a" &&
    ORDER_LOG="$order_log" "$ABBEY" newsroom generate --all \
      --model batch-model \
      --repair-model cli-repair-model \
      --repair-temperature 0.1 \
      --repair-context 4096 \
      2>&1
)"
status=$?
set -e

[[ "$status" -ne 0 ]] && pass "batch exits nonzero after an assignment failure" || fail "batch exits nonzero after an assignment failure"
[[ "$(cat "$order_log")" == $'2008-02-a.yml\n2008-02-c-fail.yml\n2008-02-d.yaml' ]] &&
  pass "batch processes assignments in deterministic filename order and continues after failure" ||
  fail "batch processes assignments in deterministic filename order and continues after failure"
assert_contains "batch reports an existing draft as skipped" "SKIP 2008-02-b-skip.yml" "$output"
assert_contains "batch summary counts are correct" "Batch summary: total=4 generated=2 skipped=1 failed=1" "$output"
assert_contains "batch failure details name the assignment and reason" "2008-02-c-fail.yml: simulated failure for 2008-02-c-fail.yml" "$output"
[[ "$(grep -Fc 'arg=<--model>' <<<"$output")" -eq 3 ]] &&
  pass "batch generation options are forwarded to every attempted assignment" ||
  fail "batch generation options are forwarded to every attempted assignment"
[[ -f "$batch_drafts/2008-02-a.md" && -f "$batch_drafts/2008-02-d.md" ]] &&
  pass "batch uses per-assignment draft output names after a failure" ||
  fail "batch uses per-assignment draft output names after a failure"

set +e
output="$(cd "$project_a" && "$ABBEY" newsroom generate "$assignment_file" --all 2>&1)"
status=$?
set -e
[[ "$status" -ne 0 ]] && pass "assignment plus --all is rejected" || fail "assignment plus --all is rejected"
assert_contains "assignment plus --all has a clear error" "mutually exclusive" "$output"

set +e
output="$(cd "$project_a" && "$ABBEY" newsroom generate --all "$assignment_file" 2>&1)"
status=$?
set -e
[[ "$status" -ne 0 ]] && pass "--all plus assignment is rejected" || fail "--all plus assignment is rejected"
assert_contains "--all plus assignment has a clear error" "mutually exclusive" "$output"


printf '\nPassed: %d\n' "$passed"
printf 'Failed: %d\n' "$failed"
(( failed == 0 ))
