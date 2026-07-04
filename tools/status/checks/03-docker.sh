section "Docker"

if command -v docker >/dev/null 2>&1; then
  ok "Docker command available"

  if docker info >/dev/null 2>&1; then
    ok "Docker daemon reachable"
    docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
  else
    warn "Docker daemon not reachable by current user"
  fi
else
  warn "Docker command not found"
fi
