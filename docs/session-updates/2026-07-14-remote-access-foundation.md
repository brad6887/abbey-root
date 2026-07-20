---
title: "Remote Access Foundation"
description: "Established and validated a secure remote access foundation for the Abbey Root lab using Tailscale."
date: 2026-07-14
status: complete
reviewed: true
session: primary
tags:
  - Abbey Root
  - Infrastructure
  - Remote Access
  - Tailscale
---

# Remote Access Foundation

**Date:** 2026-07-14

## Objective

Establish a secure, documented, and validated remote access foundation for the Abbey Root lab using Tailscale.

## Definition of Done

- Establish secure remote connectivity to the Abbey lab.
- Document the remote access architecture.
- Integrate remote access validation into `abbey doctor`.
- Improve host reachability validation.
- Capture future work without expanding into operator onboarding or Ansible migration.

## Summary

This session established the first complete remote access architecture for Abbey Root.

Rather than simply enabling remote connectivity, the work focused on designing a reproducible and secure operational model that can support future collaboration, remote development, and multi-operator workflows.

Tailscale was adopted as the standard remote access platform, providing encrypted connectivity without exposing infrastructure management interfaces directly to the Internet.

During implementation, an existing assumption in the host reachability checks was discovered. The original implementation attempted to reach inventory hostnames directly, which failed when local DNS resolution was unavailable. The check was updated to use the Ansible inventory's `ansible_host` values as the source of truth.

The session also clarified an important architectural distinction within Abbey Root. `ubuntu-dev01` now serves as the Remote Access & Operations Node, while `rocky-ansible01` continues to function as the dedicated Ansible Control Node.

## Accomplishments

### Remote Access

- Successfully implemented secure remote connectivity using Tailscale.
- Verified remote SSH access to `ubuntu-dev01`.
- Established Tailscale as the Abbey Root remote access standard.

### Architecture

Created:

- `docs/architecture/REMOTE_ACCESS.md`

The document defines:

- Remote access principles
- Security model
- Tailscale standard
- Operator workflow
- Future enhancements

### Abbey Doctor

Added:

- `tools/doctor/checks/08-remote-access.sh`

The new doctor check validates:

- Remote access node
- Tailscale installation
- `tailscaled` service
- Tailnet connectivity
- Assigned Tailscale IP
- SSH availability

Support was added for Ubuntu's socket-activated OpenSSH implementation.

Example output:

```text
Remote Access
----------

OK   Remote access node: ubuntu-dev01
OK   Tailscale client installed
OK   tailscaled service running
OK   Tailscale connected: 100.80.32.82
OK   SSH socket active
```

### Host Reachability

Updated:

- `tools/doctor/checks/05-hosts.sh`

The host reachability check now:

- Reads `ansible_host` from the inventory.
- Uses the inventory as the source of truth.
- Displays both the inventory hostname and tested IP address.
- Eliminates false failures caused by missing local name resolution.

Example:

```text
OK   Host reachable: ai-worker01 (192.168.1.87)
OK   Host reachable: rocky-ansible01 (192.168.1.88)
OK   Host reachable: ubuntu-dev01 (192.168.1.86)
```

### Planning

Added a backlog item to develop lightweight architecture diagrams and establish a standard diagram style for Abbey documentation.

## Validation

Validated:

- Shell syntax
- `git diff --check`
- `abbey doctor`

Final doctor status:

```text
Status: HEALTHY WITH WARNINGS
```

Warnings were expected:

- Working tree contained current session changes.
- Backup checks were skipped because execution was not on `pve`.

No failures remained.

## Lessons Learned

- Architecture should be defined before implementation.
- Ubuntu's default OpenSSH configuration uses socket activation.
- Health checks should validate capabilities rather than implementation details.
- The Ansible inventory should remain the source of truth for host connectivity.
- Remote access architecture and automation architecture are separate concerns.

## Future Work

- Continue refining `REMOTE_ACCESS.md`.
- Create lightweight architecture diagrams.
- Develop a Remote Operator Guide.
- Validate remote access from an external network.
- Design `abbey operator add`.
- Evaluate whether the Ansible Control Node should eventually be consolidated onto `ubuntu-dev01`.

## Outcome

Abbey Root now has a documented, secure, and validated remote access foundation.

Remote access is standardized on Tailscale, integrated into Abbey Doctor, and supported by architecture documentation.

The session also improved the reliability of infrastructure validation by aligning host reachability checks with the Ansible inventory, reinforcing the principle that the inventory serves as the authoritative source of infrastructure state.
