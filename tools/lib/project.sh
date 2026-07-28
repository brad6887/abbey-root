#!/usr/bin/env bash

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
