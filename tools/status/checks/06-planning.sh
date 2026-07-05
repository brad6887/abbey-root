section "Planning"

planning_files=(
  "PROJECT_STATUS.md"
  "NEXT.md"
  "ROADMAP.md"
  "BACKLOG.md"
  "VISION.md"
)

for file in "${planning_files[@]}"; do
  if [[ -f "$ABBEY_ROOT/$file" ]]; then
    ok "$file exists"
  elif [[ -f "$ABBEY_ROOT/docs/$file" ]]; then
    ok "docs/$file exists"
  elif [[ -f "$ABBEY_ROOT/docs/status/$file" ]]; then
    ok "docs/status/$file exists"
  elif [[ -f "$ABBEY_ROOT/docs/planning/$file" ]]; then
    ok "docs/planning/$file exists"
  else
    warn "$file not found"
  fi
done

next_file=""

for candidate in \
    "$ABBEY_ROOT/NEXT.md" \
    "$ABBEY_ROOT/docs/NEXT.md" \
    "$ABBEY_ROOT/docs/planning/NEXT.md"; do
  if [[ -f "$candidate" ]]; then
    next_file="$candidate"
    break
  fi
done

if [[ -n "$next_file" ]]; then
  info "Next session file: ${next_file#$ABBEY_ROOT/}"

  next_task="$(grep -m1 '^- \[ \]' "$next_file" | sed 's/^- \[ \] //')"

  if [[ -n "${next_task:-}" ]]; then
    info "Recommended next task: $next_task"
  else
    warn "No open next-session task found"
  fi
fi
