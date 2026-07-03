#!/usr/bin/env bash

section "Repository"

if git -C "$ABBEY_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  ok "Git repository detected"
else
  fail "Not inside a Git repository"
  echo
  return
fi

branch="$(git -C "$ABBEY_ROOT" branch --show-current 2>/dev/null)"
[ -n "$branch" ] && ok "Current branch: $branch" || warn "Unable to determine current branch"

if git -C "$ABBEY_ROOT" diff --quiet && git -C "$ABBEY_ROOT" diff --cached --quiet; then
  ok "Working tree clean"
else
  warn "Working tree has uncommitted changes"
fi

if git -C "$ABBEY_ROOT" remote -v | grep -q .; then
  ok "Git remote configured"
else
  warn "No Git remote configured"
fi

echo
