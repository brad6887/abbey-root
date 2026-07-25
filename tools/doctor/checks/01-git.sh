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

for identity_key in user.name user.email; do
  identity_config="$(
    git -C "$ABBEY_ROOT" config --show-origin --get "$identity_key" 2>/dev/null \
      || true
  )"

  if [ -z "$identity_config" ]; then
    fail "Git $identity_key is not configured"
    continue
  fi

  identity_origin="${identity_config%%$'\t'*}"
  identity_value="${identity_config#*$'\t'}"

  ok "Git $identity_key configured: $identity_value"
  ok "Git $identity_key source: $identity_origin"
done

echo
