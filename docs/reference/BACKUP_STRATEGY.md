# Abbey Root Backup Strategy

## Overview

Abbey Root uses a dedicated external SSD for Proxmox backups.

## Backup Storage

- Device: SanDisk Extreme Portable SSD (2 TB)
- Label: abbey-backup
- Filesystem: ext4
- Mount Point: /mnt/abbey-backup
- Storage ID: abbey-backup

## Backup Schedule

- Node: pve
- Mode: Snapshot
- Compression: ZSTD
- Schedule: Daily
- Retention: Keep last 7 backups

## Protected Virtual Machines

- ubuntu-dev01
- ai-worker01
- rocky-ansible01

Templates are excluded from backups because they are reproducible.

## Restore Policy

Backups are not considered validated until a successful restore test has been completed.

Last Restore Test:
- Pending

## Future Improvements

- Scheduled restore testing
- Backup monitoring
- Backup reporting
- Off-site backup replication
