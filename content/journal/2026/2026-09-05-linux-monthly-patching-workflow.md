---
title: "Linux Monthly Patching Workflow"
description: "Built and live-validated the Abbey Root monthly Linux patch workflow."
date: 2026-09-05
session_update: "docs/session-updates/2026-09-05-linux-monthly-patching-workflow.md"
draft: false
tags:
  - Abbey Root
  - Ansible
  - Linux
  - Patching
---

# Linux Monthly Patching Workflow

## Summary

Built and live-validated a safe monthly Linux patch workflow for the Abbey Root
home lab.

The workflow performs global preflight, patches managed hosts in an explicit
one-at-a-time order, installs available updates, reboots only when required,
waits for systemd startup to settle after reboot, validates each host, stops on
failure, retains reports, and sends email notifications.

The public command is:

    abbey lab patch

rocky-ansible01 remains a deliberate manual final step in v1.

## Accomplishments

- Added the patch_targets inventory group.
- Added strict reusable patch health validation.
- Added D-state processes as a hard patch failure.
- Added deterministic remote host sequencing.
- Added package-change detection.
- Added conditional Debian, Ubuntu, Rocky, and RHEL reboot handling.
- Added systemd startup settling after actual reboots.
- Added interactive PATCH confirmation before disruptive maintenance.
- Added abbey lab patch --preflight-only.
- Added --yes for intentional future noninteractive use.
- Added timestamped logging, reporting, and email notifications.
- Completed the first live patch cycle.
- Deprecated the unsafe legacy abbey-ansible-update helper.
- Documented the monthly maintenance workflow.
- Updated ISSUE-0001 after the NVIDIA driver hang recurred.

## Incident During Validation

An accidental second patch run exposed an unconditional reboot bug in the first
implementation.

No new packages were installed, but every remote host rebooted anyway.

The second reboot of ai-worker01 triggered the intermittent NVIDIA driver hang
documented in ISSUE-0001.

The failure included:

- nvidia-persistenced timeout
- NVIDIA kernel processes in D state
- llama-server processes in D state
- nvidia-smi hanging in D state

A physical power cycle recovered ai-worker01.

The incident directly led to interactive confirmation, systemd startup
settling, D-state hard failure handling, and conditional reboot logic.

## Conditional Reboot Validation

The corrected reboot behavior was validated on September 6.

sensor01 had no package updates available.

The patch playbook reported:

    Packages changed: False
    Reboot required: False
    Reboot performed: False

Its boot ID remained unchanged.

sites01 had a Rocky Linux kernel update available.

The workflow installed the update, detected that a reboot was required, and
rebooted the host.

After reboot, sites01 was running:

    6.12.0-211.51.1.el10_2.x86_64

A complete abbey lab check passed after the controlled tests.

## Lessons Learned

- Inventory ordering should not control safety-sensitive sequencing.
- SSH availability does not mean boot startup is complete.
- D-state processes are a critical health signal.
- Package metadata refresh must be separated from actual package changes.
- No-op patch runs must never trigger automatic reboots.
- Explicit confirmation is appropriate before multi-host maintenance.
- Conditional reboot behavior must be tested directly, including the no-op
  path.
- Repeated reboot timing may contribute to the intermittent ai-worker01 NVIDIA
  failure.

## Next Steps

- Continue investigation of ISSUE-0001.
- Design durable controller self-patching for rocky-ansible01.
- Make SMTP configuration reproducible without storing credentials in Git.
- Consider richer package and reboot details in final reports.
- Continue manual monthly runs before introducing scheduling.
