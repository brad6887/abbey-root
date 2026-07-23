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

load_1="$(doctor_load_average)"
if [ -n "$load_1" ]; then
  ok "Load average 1 minute: $load_1"
else
  warn "Load average unavailable"
fi

uptime_text="$(uptime -p 2>/dev/null || uptime)"
ok "Uptime: $uptime_text"

timezone="$(doctor_timezone)"
if [ "$timezone" = "America/Chicago" ]; then
  ok "Timezone: America/Chicago"
else
  warn "Timezone is $timezone"
fi

network_time_status="$(doctor_network_time_status)"
case "$network_time_status" in
  synchronized)
    ok "NTP synchronized"
    ;;
  running)
    ok "Network time service running"
    ;;
  *)
    warn "Network time status unavailable"
    ;;
esac

echo
