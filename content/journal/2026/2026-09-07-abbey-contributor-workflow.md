---
title: "Abbey Contributor Workflow"
description: "Abbey gains a reusable, explicitly managed contributor account lifecycle, validated with real accounts in disposable Linux containers."
date: 2026-09-07
session_update: "docs/session-updates/2026-09-07-abbey-contributor-workflow.md"
draft: false
tags:
  - Abbey Root
  - Ansible
  - Linux
---

# Abbey Contributor Workflow

## Summary

Abbey now has a dedicated workflow for contributor accounts. A small definition
records which hosts a contributor may access, their approved groups, and each
host's sudo policy. The public commands cover planning, applying, inspecting,
revoking, and purging that access.

The first intended contributor is the reason to build the workflow, but the
implementation does not depend on that person's username or key. Those details
can be supplied when the first real account is ready.

## Accomplishments

- Built an explicit account lifecycle with saved desired state and per-host
  entitlements.
- Kept private SSH keys on the contributor's own computer; Abbey manages only
  the public key and its authorization.
- Made sudo an explicit, password-required host policy.
- Separated reversible revocation from confirmed account deletion.
- Documented the focused procedure and captured its validation boundaries.

## Lessons Learned

Disposable Linux containers made it possible to test real account behavior
without provisioning anyone on the lab. The tests exercised SSH login, sudo,
revocation, restoration, and deletion on Ubuntu and Rocky Linux.

Those tests found details that a syntax check could not: Linux account comments
reject colons, and Ansible and the shadow file express expiry in different
units. Repeated no-change runs and read-only snapshots were equally useful
evidence.

Preserving a home after account deletion also deserves an explicit recovery
decision. The workflow refuses to reuse that directory automatically, keeping
the ownership question visible to the administrator.

## Next Steps

Prepare the first real contributor's public key and host entitlements, then
preview and deliberately apply the definition. The wider introduction to the
lab and its projects remains a separate onboarding session.
