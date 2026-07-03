#!/usr/bin/env bash

section "Backup Freshness"

BACKUP_HOST="pve"
BACKUP_DIR="/mnt/abbey-backup/proxmox/dump"
MAX_AGE_HOURS=36

current_host="$(hostname -s)"

if [ "$current_host" != "$BACKUP_HOST" ]; then
  warn "Backup freshness check skipped on $current_host; expected host is $BACKUP_HOST"
  echo
  return
fi

if [ ! -d "$BACKUP_DIR" ]; then
  fail "Backup directory missing: $BACKUP_DIR"
  echo
  return
fi

latest_backup="$(find "$BACKUP_DIR" -type f -name '*.vma.zst' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -1)"

if [ -z "$latest_backup" ]; then
  fail "No Proxmox backup archives found"
  echo
  return
fi

latest_epoch="${latest_backup%% *}"
latest_file="${latest_backup#* }"
now_epoch="$(date +%s)"
age_hours="$(( (now_epoch - ${latest_epoch%.*}) / 3600 ))"

ok "Latest backup: $(basename "$latest_file")"

if [ "$age_hours" -le "$MAX_AGE_HOURS" ]; then
  ok "Latest backup age: ${age_hours} hours"
else
  warn "Latest backup age: ${age_hours} hours"
fi

echo
