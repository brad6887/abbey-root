#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ABBEY_TOOLKIT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CLI_RENDERER="$ABBEY_TOOLKIT_ROOT/scripts/abbey_cli.py"

passed=0
failed=0

pass() {
  echo "PASS $1"
  passed=$((passed + 1))
}

fail() {
  echo "FAIL $1"
  failed=$((failed + 1))
}

assert_contains() {
  local name="$1"
  local expected="$2"
  local output="$3"

  if grep -Fq -- "$expected" <<<"$output"; then
    pass "$name"
  else
    fail "$name"
  fi
}

output="$(
  python3 "$CLI_RENDERER" \
    context \
    --project-root "$ABBEY_TOOLKIT_ROOT"
)"

assert_contains \
  "context includes CLI architecture heading" \
  "## Abbey CLI Architecture" \
  "$output"

assert_contains \
  "context identifies toolkit root" \
  "Toolkit root (\`ABBEY_TOOLKIT_ROOT\`): \`$ABBEY_TOOLKIT_ROOT\`" \
  "$output"

assert_contains \
  "context identifies active project root" \
  "Active project root (\`ABBEY_ROOT\`): \`$ABBEY_TOOLKIT_ROOT\`" \
  "$output"

assert_contains \
  "context identifies dispatcher" \
  'Dispatcher: `tools/bin/abbey`' \
  "$output"

assert_contains \
  "context identifies command registry" \
  'Command registry: `config/cli/cli.yml`' \
  "$output"

assert_contains \
  "context includes registered commands heading" \
  "## Registered Commands" \
  "$output"

assert_contains \
  "context includes core command summary" \
  '`abbey init` — Create a new Abbey project from the default template.' \
  "$output"

assert_contains \
  "context includes workflow command summary" \
  '`abbey session` — Start and review Abbey Root work sessions.' \
  "$output"

assert_contains \
  "context includes registered subcommand summary" \
  '`abbey session context` — Generate an upload-ready session context file.' \
  "$output"

assert_contains \
  "context includes documentation command summary" \
  '`abbey docs check` — Verify tracked deterministic documentation without modifying it.' \
  "$output"

assert_contains \
  "context includes research command summary" \
  '`abbey research create` — Create a controlled, review-ready research candidate.' \
  "$output"

if CLI_RENDERER="$CLI_RENDERER" python3 - <<'PYTEST'
import importlib.util
import os
from pathlib import Path

renderer = Path(os.environ["CLI_RENDERER"])
spec = importlib.util.spec_from_file_location("abbey_cli", renderer)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

commands = module.visible_commands({
    "visible": {"hidden": False},
    "hidden": {"hidden": True},
})

assert "visible" in commands
assert "hidden" not in commands

subcommands = module.visible_subcommands({
    "subcommands": {
        "visible": {"hidden": False},
        "hidden": {"hidden": True},
    }
})

assert "visible" in subcommands
assert "hidden" not in subcommands
PYTEST
then
  pass "context excludes hidden commands and subcommands"
else
  fail "context excludes hidden commands and subcommands"
fi

if ((failed > 0)); then
  echo
  echo "FAILED: $failed test(s) failed; $passed passed."
  exit 1
fi

echo
echo "PASSED: $passed test(s) passed."
