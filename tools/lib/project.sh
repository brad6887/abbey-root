#!/usr/bin/env bash

abbey_find_project_root() {
  local start="${1:-$PWD}"
  local search_dir

  if [[ ! -d "$start" ]]; then
    return 1
  fi

  search_dir="$(cd "$start" && pwd -P)"
  while :; do
    if [[ -f "$search_dir/.abbey/project.yml" ]]; then
      printf '%s\n' "$search_dir"
      return 0
    fi
    [[ "$search_dir" == "/" ]] && break
    search_dir="$(dirname "$search_dir")"
  done

  return 1
}

abbey_project_path() {
  local root="$1"
  local configured_path="$2"

  python3 - "$root" "$configured_path" <<'PY'
import sys
from pathlib import Path

root = Path(sys.argv[1]).resolve()
candidate = (root / sys.argv[2]).resolve()
try:
    candidate.relative_to(root)
except ValueError:
    print(
        f"ERROR: Configured path escapes the active project: {sys.argv[2]}",
        file=sys.stderr,
    )
    raise SystemExit(1)
print(candidate)
PY
}

abbey_project_name() {
  local root="${1:-$ABBEY_ROOT}"
  local metadata="$root/.abbey/project.yml"

  if [[ ! -f "$metadata" ]]; then
    printf '%s\n' "Abbey Root"
    return
  fi

  python3 - "$metadata" <<'PY'
import sys
from pathlib import Path

import yaml

data = yaml.safe_load(Path(sys.argv[1]).read_text(encoding="utf-8")) or {}
print(data.get("project", {}).get("name", "Abbey Project"))
PY
}

abbey_project_value() {
  local root="$1"
  local key="$2"
  local default_value="${3:-}"
  local metadata="$root/.abbey/project.yml"

  if [[ ! -f "$metadata" ]]; then
    printf '%s\n' "$default_value"
    return
  fi

  python3 - "$metadata" "$key" "$default_value" <<'PY'
import sys
from pathlib import Path

import yaml

data = yaml.safe_load(Path(sys.argv[1]).read_text(encoding="utf-8")) or {}
value = data
for part in sys.argv[2].split("."):
    if not isinstance(value, dict) or part not in value:
        value = sys.argv[3]
        break
    value = value[part]

if isinstance(value, bool):
    print("true" if value else "false")
elif value is None:
    print(sys.argv[3])
else:
    print(value)
PY
}

abbey_project_list() {
  local root="$1"
  local key="$2"
  local metadata="$root/.abbey/project.yml"

  [[ -f "$metadata" ]] || return 0

  python3 - "$metadata" "$key" <<'PY'
import sys
from pathlib import Path

import yaml

value = yaml.safe_load(Path(sys.argv[1]).read_text(encoding="utf-8")) or {}
for part in sys.argv[2].split("."):
    if not isinstance(value, dict) or part not in value:
        value = []
        break
    value = value[part]

if isinstance(value, list):
    for item in value:
        if isinstance(item, str) and item.strip():
            print(item)
PY
}
