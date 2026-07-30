---
title: "Managed macOS Git Workstation"
description: "Extended Abbey's reproducible Git policy to a separately managed macOS workstation."
date: 2026-07-29
draft: false
tags:
  - Abbey Root
---

# Managed macOS Git Workstation

## Summary

The Mac is now modeled as a workstation rather than being treated like another
Linux server. Only the Git workflow loads its inventory, and all user paths and
ownership are platform-aware.

## Accomplishments

- Added separate workstation inventory with the Mac's Tailscale address.
- Made managed Git home, group, repository, and SSH paths inventory-driven.
- Preserved the Linux-only scope of existing Abbey Ansible playbooks.
- Added regression coverage for Mac inventory and Git workflow routing.
- Enabled Remote Login, authorized Rocky's verified public key, and validated
  passwordless control-host access over the LAN.

## Lessons Learned

- A workstation should share portable policy without inheriting server roles.
- Separate inventory sources create a clear operational boundary.
- A Tailscale address is not a management address when the control host is not
  on the tailnet; reachable addressing must be validated from the controller.

## Next Steps

- Validate Rocky-to-Mac reachability.
- Preview, synchronize, and audit the Mac Git policy.
- Complete an inventory-wide six-host audit.
