title: "Abbey Lab Healthcheck"
description: "Validated Abbey Root lab health, corrected a stale AI Worker network wait failure, and added sites01 to Proxmox backups."
date: 2026-09-03
status: completed
reviewed: false
session: abbey-lab-healthcheck
tags:
- Abbey Root
- Infrastructure
- Healthcheck
- Backups

---

# Abbey Lab Healthcheck

## Objective

Validate the current health of the Abbey Root lab across managed hosts,
networking, DNS, remote access, Docker, AI Worker services, Proxmox, and
backups, and correct any bounded operational issues discovered during the
review.

## Definition of Done

- Core Abbey Root repository state is clean and understood.
- `abbey doctor` completes without failures.
- `abbey lab check` completes across all managed hosts without unreachable
  hosts or failed tasks.
- Active systemd, Docker, NVIDIA, Ollama, DNS, and remote-access health is
  validated.
- Proxmox storage and existing backup freshness are validated.
- Any bounded operational issues found during the healthcheck are corrected
  and revalidated.
- Findings that require future framework or automation work are captured
  without expanding the session unnecessarily.

## Summary

Completed a full Abbey Root lab healthcheck across the managed Linux hosts,
AI Worker, Proxmox, Docker, networking, DNS, remote access, and backups.

The lab is healthy. One stale systemd failure was corrected on `ai-worker01`,
and `sites01` was added to the existing Proxmox backup policy and validated
with its first successful backup.

## Accomplishments

- Ran `abbey doctor` from `ubuntu-dev01`.
  - 32 checks passed.
  - 0 failures were reported.
  - Two backup checks were skipped because the current implementation expects
    execution on `pve`.
- Ran `abbey lab check` across all six managed hosts.
- Investigated the only failed systemd unit found:
  `systemd-networkd-wait-online.service` on `ai-worker01`.
- Confirmed `ai-worker01` networking is intentionally managed by
  NetworkManager.
  - USB Ethernet is the primary active interface.
  - Wi-Fi remains configured for emergency use.
  - Wi-Fi autoconnect remains disabled.
- Disabled the unnecessary `systemd-networkd-wait-online.service`.
- Cleared its stale failed state.
- Re-ran `abbey lab check` and confirmed zero failed systemd units across all
  managed hosts.
- Validated Proxmox host health and storage.
- Confirmed the existing Proxmox backup job runs at 02:30 and 22:30 and
  retains the latest seven backups.
- Confirmed successful recent backups for VMs 102, 103, and 104.
- Confirmed the nightly Open WebUI backup on `ai-worker01` is current.
- Identified that VM 105 (`sites01`) had never been added to the Proxmox
  backup policy.
- Added VM 105 to the existing Proxmox backup job.
- Ran an immediate snapshot backup of `sites01`.
- Confirmed the backup completed successfully with:
  `Finished Backup of VM 105`.

## Impact

The Abbey Root lab has been validated as operationally healthy with no known
active infrastructure failures.

`ai-worker01` no longer carries a stale failed systemd unit caused by an
unused network wait-online service.

`sites01`, now part of the production static-hosting platform, is protected by
the same Proxmox backup policy as the other managed Abbey VMs.

The healthcheck also identified several reusable Abbey improvements that can
make future health reviews more accurate and better aligned with the current
lab architecture.

## Validation

- Abbey Root Git working tree was clean before the healthcheck.
- `abbey doctor`:
  - 32 OK
  - 2 warnings
  - 0 failures
- All six managed hosts were reachable through `abbey lab check`.
- Final `abbey lab check` reported:
  - 0 unreachable hosts
  - 0 failed Ansible tasks
  - 0 failed systemd units
  - 0 D-state processes
- Docker health:
  - `ubuntu-dev01`: 7 running containers, 0 unhealthy
  - `ai-worker01`: 2 running containers, 0 unhealthy
- `ai-worker01`:
  - NVIDIA driver healthy
  - GPU temperature 38 C
  - Ollama service active
  - NetworkManager active
  - NetworkManager wait-online active
  - `systemd-networkd-wait-online.service` disabled
- DNS validation passed for both external and internal DNS.
- Tailscale and SSH remote-access checks passed.
- Proxmox:
  - 0 failed systemd units
  - all configured storage active
  - `/mnt/abbey-backup` approximately 8% utilized
- Existing Proxmox backups for VMs 102, 103, and 104 completed successfully.
- Open WebUI backup dated 2026-09-03 was present.
- Proxmox backup job now includes:
  `102,103,104,105`
- Backup schedule remains:
  `2,22:30`
- Backup retention remains:
  `keep-last=7`
- Manual VM 105 validation backup completed successfully in 12 seconds and
  produced a 1.50 GB archive.

## Lessons Learned

The current `abbey lab check` memory summary can make healthy Linux memory use
look excessive because filesystem cache is counted as used memory. During this
healthcheck, `ai-worker01` initially appeared to be using approximately 29 GB
of 31 GB, while `free -h` showed approximately 28 GB still available.

Abbey backup health checks also currently assume they can execute directly on
`pve`, but `pve` intentionally contains neither the Abbey toolkit nor Git
repositories. Proxmox and backup validation should eventually be performed
remotely from an Abbey control host.

The `ai-worker01` wait-online configuration should become Ansible-owned so the
correct NetworkManager-only behavior is declared and reproducible rather than
remaining a manual host change.

## Next Steps

- Improve `abbey lab check` memory reporting to include meaningful available
  memory.
- Improve Abbey Proxmox and backup health checks so they can run remotely from
  a control host.
- Make the `ai-worker01` network wait-online state Ansible-managed.
- Reconcile the stale `docs/planning/PROJECT_STATUS.md` as part of normal
  planning-document maintenance.

## Notes

No broad infrastructure redesign was performed during this session. Changes
were limited to correcting a confirmed stale service state and closing the
newly identified `sites01` backup gap.
