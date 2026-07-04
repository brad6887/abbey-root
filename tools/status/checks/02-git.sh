section "Repository"

if [[ -d "$ABBEY_ROOT/.git" ]]; then
  cd "$ABBEY_ROOT"
  ok "Git repository detected"
  info "Branch: $(git branch --show-current 2>/dev/null || echo unknown)"

  if [[ -z "$(git status --porcelain)" ]]; then
    ok "Working tree clean"
  else
    warn "Working tree has uncommitted changes"
    git status --short
  fi

  if git remote get-url origin >/dev/null 2>&1; then
    info "Origin: $(git remote get-url origin)"
  else
    warn "No origin remote configured"
  fi
else
  warn "Git repository not found: $ABBEY_ROOT"
fi
