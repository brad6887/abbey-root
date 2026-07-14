#!/usr/bin/env bash

section "Remote Access"

CONTROL_NODE="ubuntu-dev01"
current_host="$(hostname -s 2>/dev/null || hostname)"

if [ "$current_host" != "$CONTROL_NODE" ]; then
  ok "Remote access check not required on host: $current_host"
  echo
  return
fi

ok "Remote access node: $current_host"

if ! command -v tailscale >/dev/null 2>&1; then
  fail "Tailscale client is not installed"
  echo
  return
fi

ok "Tailscale client installed"

if systemctl is-active --quiet tailscaled; then
  ok "tailscaled service running"
else
  fail "tailscaled service is not running"
fi

tailscale_ipv4="$(tailscale ip -4 2>/dev/null | head -n 1 || true)"

if [ -n "$tailscale_ipv4" ]; then
  ok "Tailscale connected: $tailscale_ipv4"
else
  fail "Tailscale is not connected"
fi

if systemctl is-active --quiet ssh || systemctl is-active --quiet sshd; then
  ok "SSH service running"
elif systemctl is-active --quiet ssh.socket || systemctl is-active --quiet sshd.socket; then
  ok "SSH socket active"
else
  fail "SSH service and socket are not active"
fi

echo
