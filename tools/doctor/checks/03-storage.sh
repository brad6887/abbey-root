#!/usr/bin/env bash

section "Backup Storage"

BACKUP_HOST="pve"
BACKUP_MOUNT="/mnt/abbey-backup"
BACKUP_UUID="c98883e9-bdc4-462d-afbd-39eab68c1d57"

current_host="$(hostname -s)"

if [ "$current_host" != "$BACKUP_HOST" ]; then
  warn "Backup storage check skipped on $current_host; expected host is $BACKUP_HOST"
  echo
  return
fi

if findmnt "$BACKUP_MOUNT" >/dev/null 2>&1; then
  ok "Backup mount present: $BACKUP_MOUNT"
else
  fail "Backup mount missing: $BACKUP_MOUNT"
  echo
  return
fi

source_device="$(findmnt -n -o SOURCE "$BACKUP_MOUNT")"
fstype="$(findmnt -n -o FSTYPE "$BACKUP_MOUNT")"

ok "Backup source: $source_device"
ok "Filesystem type: $fstype"

actual_uuid="$(blkid -s UUID -o value "$source_device" 2>/dev/null || true)"

if [ "$actual_uuid" = "$BACKUP_UUID" ]; then
  ok "Backup UUID matches expected value"
else
  fail "Backup UUID mismatch"
fi

usage_percent="$(df -P "$BACKUP_MOUNT" | awk 'NR==2 {print $5}' | tr -d '%')"
available="$(df -h "$BACKUP_MOUNT" | awk 'NR==2 {print $4}')"

if [ "$usage_percent" -lt 80 ]; then
  ok "Backup free space available: $available"
elif [ "$usage_percent" -lt 90 ]; then
  warn "Backup filesystem usage is ${usage_percent}%"
else
  fail "Backup filesystem usage is ${usage_percent}%"
fi

echo
