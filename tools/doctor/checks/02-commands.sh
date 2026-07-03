#!/usr/bin/env bash

section "Required Commands"

current_host="$(hostname -s)"

required_commands=(
  git
  python3
)

if [ "$current_host" = "rocky-ansible01" ]; then
  required_commands+=(
    ansible
    ansible-playbook
  )
fi

for cmd in "${required_commands[@]}"; do
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "Command available: $cmd"
  else
    fail "Missing command: $cmd"
  fi
done

echo
