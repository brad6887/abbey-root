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
