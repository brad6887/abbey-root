#!/usr/bin/env bash

section "System"

root_usage="$(df -P / | awk 'NR==2 {print $5}' | tr -d '%')"

if [ "$root_usage" -lt 80 ]; then
  ok "Root filesystem usage: ${root_usage}%"
elif [ "$root_usage" -lt 90 ]; then
  warn "Root filesystem usage: ${root_usage}%"
else
  fail "Root filesystem usage: ${root_usage}%"
fi

load_1="$(awk '{print $1}' /proc/loadavg)"
ok "Load average 1 minute: $load_1"

uptime_text="$(uptime -p 2>/dev/null || uptime)"
ok "Uptime: $uptime_text"

timezone="$(timedatectl show -p Timezone --value 2>/dev/null || true)"
if [ "$timezone" = "America/Chicago" ]; then
  ok "Timezone: America/Chicago"
else
  warn "Timezone is $timezone"
fi

if timedatectl show -p NTPSynchronized --value 2>/dev/null | grep -q yes; then
  ok "NTP synchronized"
else
  warn "NTP not synchronized"
fi

echo
