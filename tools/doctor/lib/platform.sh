#!/usr/bin/env bash

doctor_platform() {
  printf '%s\n' "${ABBEY_PLATFORM:-$(uname -s)}"
}

doctor_ping_host() {
  local target="$1"

  case "$(doctor_platform)" in
    Darwin)
      ping -c 2 -W 1000 "$target" >/dev/null 2>&1
      ;;
    Linux)
      ping -4 -c 1 -W 1 "$target" >/dev/null 2>&1
      ;;
    *)
      ping -c 1 "$target" >/dev/null 2>&1
      ;;
  esac
}

doctor_load_average() {
  local load_average=""

  case "$(doctor_platform)" in
    Darwin)
      load_average="$(sysctl -n vm.loadavg 2>/dev/null | awk '{print $2}')"
      if [ -z "$load_average" ]; then
        load_average="$(
          uptime | sed -E \
            's/.*load averages?:[[:space:]]*([0-9.]+).*/\1/'
        )"
      fi
      ;;
    Linux)
      if [ -r /proc/loadavg ]; then
        load_average="$(awk '{print $1}' /proc/loadavg)"
      fi
      ;;
  esac

  printf '%s\n' "$load_average"
}

doctor_timezone() {
  local localtime_path="${ABBEY_LOCALTIME_PATH:-/etc/localtime}"
  local timezone=""

  case "$(doctor_platform)" in
    Darwin)
      timezone="$(readlink "$localtime_path" 2>/dev/null || true)"
      timezone="${timezone#*zoneinfo/}"
      ;;
    Linux)
      timezone="$(timedatectl show -p Timezone --value 2>/dev/null || true)"
      ;;
  esac

  printf '%s\n' "$timezone"
}

doctor_network_time_status() {
  case "$(doctor_platform)" in
    Darwin)
      if launchctl print system/com.apple.timed 2>/dev/null \
        | grep -q 'state = running'; then
        printf 'running\n'
      else
        printf 'unavailable\n'
      fi
      ;;
    Linux)
      if timedatectl show -p NTPSynchronized --value 2>/dev/null \
        | grep -q yes; then
        printf 'synchronized\n'
      else
        printf 'unsynchronized\n'
      fi
      ;;
    *)
      printf 'unavailable\n'
      ;;
  esac
}
