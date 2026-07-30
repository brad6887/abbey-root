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
- Preserved the Mac's GitHub CLI credential helpers after check mode identified
  them as intentional host-specific configuration.
- Synchronized and audited the Mac without changing repository contents or
  history.
- Pulled Abbey Root and Bread Pitt normally from their canonical Mac checkouts.
- Completed a clean inventory-wide audit across five Linux hosts and the Mac.

## Lessons Learned

- A workstation should share portable policy without inheriting server roles.
- Separate inventory sources create a clear operational boundary.
- A Tailscale address is not a management address when the control host is not
  on the tailnet; reachable addressing must be validated from the controller.
- A shared policy should not erase unrelated platform integration merely
  because the primary repository transport uses SSH.

## Next Steps

- Reserve the Mac's LAN management address in DHCP if it is not already fixed.
- Re-run the Git audit after adding a workstation or changing its management
  address.
