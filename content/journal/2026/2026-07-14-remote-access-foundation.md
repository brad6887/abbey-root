---
title: "Remote Access Foundation"
description: "Established the foundation for secure remote access to the Abbey Root lab using Tailscale and integrated remote access validation into Abbey Doctor."
date: 2026-07-14
draft: false
tags:
  - Abbey Root
  - Remote Access
  - Tailscale
---

# Remote Access Foundation

## Summary

This session established the architectural foundation for secure remote access to the Abbey Root lab. Rather than simply installing software, the focus was on defining a long-term remote access strategy that supports future collaboration, operator onboarding, and reproducible infrastructure management.

Tailscale was adopted as the standard remote access solution, allowing secure connectivity without exposing management interfaces directly to the Internet. A new architecture document was created to document the design, and Abbey Doctor was extended to validate remote access readiness.

During implementation, an existing assumption in the host reachability check was discovered. The check relied on inventory hostnames rather than the configured `ansible_host` addresses, causing false failures when local name resolution was unavailable. The validation logic was updated to use the inventory as the authoritative source of connectivity information.

The session also clarified an important architectural distinction within Abbey Root. While `ubuntu-dev01` now serves as the Remote Access & Operations Node, `rocky-ansible01` continues to function as the dedicated Ansible Control Node. Preserving that distinction avoids introducing unnecessary infrastructure changes while providing a clear path for future evaluation.

## Accomplishments

- Adopted Tailscale as the Abbey Root remote access standard.
- Successfully established secure remote connectivity to `ubuntu-dev01`.
- Created `docs/architecture/REMOTE_ACCESS.md`.
- Added a Remote Access section to `abbey doctor`.
- Added validation for:
  - Tailscale installation
  - `tailscaled` service status
  - Tailnet connectivity
  - Assigned Tailscale IP address
  - SSH availability (including Ubuntu socket activation)
- Enhanced the Host Reachability check to use `ansible_host` values from the Ansible inventory.
- Eliminated false host reachability failures caused by missing local DNS resolution.
- Added architecture diagrams as a future Abbey backlog item.
- Validated the updated `abbey doctor` workflow with no failures.

## Lessons Learned

- Architecture decisions should precede implementation whenever practical.
- Ubuntu's default OpenSSH configuration uses socket activation, so health checks should validate the SSH socket in addition to the service.
- The Ansible inventory should remain the single source of truth for host connectivity information.
- Abbey currently has two operational control planes:
  - `ubuntu-dev01` for remote operations and day-to-day administration.
  - `rocky-ansible01` for Ansible automation.
- Separating these responsibilities keeps the architecture simple while allowing future consolidation if it becomes beneficial.

## Next Steps

- Continue refining `REMOTE_ACCESS.md`.
- Create lightweight architecture diagrams for the remote access design.
- Develop a Remote Operator Guide for first-time users.
- Validate remote access from an external network such as the office or a mobile hotspot.
- Evaluate whether the Ansible Control Node should eventually be consolidated onto `ubuntu-dev01`.
- Begin designing an `abbey operator add` workflow for onboarding additional operators such as Zack.
