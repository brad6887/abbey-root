#!/usr/bin/env bash

section "Documentation"

docs=(
  "docs/status/PROJECT_STATUS.md"
  "docs/planning/NEXT.md"
  "docs/planning/ROADMAP.md"
  "docs/planning/BACKLOG.md"
)

for doc in "${docs[@]}"; do
  path="$ABBEY_ROOT/$doc"

  if [ -f "$path" ]; then
    ok "Document present: $doc"
  else
    warn "Document missing: $doc"
  fi
done

echo
