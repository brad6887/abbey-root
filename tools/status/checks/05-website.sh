section "Website"

SITE_DIR="$ABBEY_ROOT/site"

if [[ -d "$SITE_DIR" ]]; then
  ok "Site directory exists"

  if [[ -f "$SITE_DIR/package.json" ]]; then
    ok "package.json exists"
  else
    warn "package.json missing"
  fi

  if [[ -d "$SITE_DIR/node_modules" ]]; then
    ok "node_modules exists"
  else
    warn "node_modules missing"
  fi

  if [[ -d "$SITE_DIR/dist" ]]; then
    info "Build output exists: site/dist"
  else
    warn "Build output missing: site/dist"
  fi

  pid="$(pgrep -f "npm run dev|astro dev" | head -n 1 || true)"

  if [[ -n "${pid:-}" ]]; then
    ok "Site dev server running: PID $pid"
  else
    warn "Site dev server not running"
  fi
else
  warn "Site directory not found: $SITE_DIR"
fi
