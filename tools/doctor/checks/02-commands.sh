#!/usr/bin/env bash

section "Required Commands"

for cmd in git python3 ansible ansible-playbook; do
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "Command available: $cmd"
  else
    fail "Missing command: $cmd"
  fi
done

echo
