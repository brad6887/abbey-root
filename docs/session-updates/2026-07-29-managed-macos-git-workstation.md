---
title: "Managed macOS Git Workstation"
description: "Added platform-aware Mac workstation inventory to the managed Git workflow."
date: 2026-07-29
status: complete
reviewed: true
session: managed-macos-git-workstation
tags:
  - Abbey Root
---

# Managed macOS Git Workstation

## Objective

Add the Mac as a managed Git workstation without exposing it to Linux-only
Abbey playbooks.

## Definition of Done

- Mac inventory metadata does not enter the Linux server inventory.
- Git paths use a host-specific home directory.
- File ownership supports the Mac's `bradcooke:staff` account.
- The Mac's canonical Abbey Root and Bread Pitt checkouts are audited.
- `abbey git sync --check` previews Mac changes from Rocky.
- The Mac uses managed identity, pull, pruning, SSH transport, and host trust.
- Inventory-wide Git audit passes across five Linux hosts and the Mac.

## Summary

The Git workflow now loads a separate workstation inventory while every other
Ansible workflow continues to load only the Linux server inventory.

## Accomplishments

- Added `mac-workstation` at its stable Tailscale address.
- Added native macOS home, group, and known-hosts mode variables.
- Replaced hard-coded `/home` repository and SSH paths with inventory-driven
  paths.
- Loaded workstation inventory only from `abbey git`.
- Confirmed canonical Mac Abbey Root and Bread Pitt checkouts already use SSH
  origins.
- Added focused inventory, routing, path, and YAML regression coverage.
- Enabled macOS Remote Login and authorized Rocky's fingerprint-verified
  control-host public key.
- Replaced the unreachable Tailscale inventory address with the proven LAN
  management address `192.168.1.70`.

## Impact

The same Git policy can now cover Linux and macOS without broadening the scope
of infrastructure, update, SSH-trust, or common Linux playbooks.

## Validation

- `tests/test-abbey-git.sh` — 27 passed.
- Backlog generation and freshness checks passed.
- YAML parsing, shell syntax, and `git diff --check` passed.
- Rocky-to-Mac passwordless SSH succeeded as `bradcooke`.
- The first Mac check-mode preview exposed removal of unrelated GitHub CLI
  credential helpers; Mac inventory now preserves those helpers and pins the
  system Python interpreter.
- Mac synchronization completed without repository content or history changes.
- Abbey Root and Bread Pitt pulled normally from their canonical Mac checkouts.
- The final six-host audit completed with zero changes, failures, or
  unreachable hosts.

## Lessons Learned

Separate inventory sources provide a smaller safety boundary than adding a
workstation to the universal Ansible `all` group consumed by Linux playbooks.

Rocky is not a Tailscale node, so the Mac's Tailscale address is not a usable
control path. The LAN address works, but it must remain reserved to be a durable
inventory identity.

Platform policy should preserve intentional host-specific integration. Using
SSH for repository remotes does not justify silently removing GitHub CLI's
existing HTTPS credential helpers.

## Next Steps

- Confirm or create the Mac's `192.168.1.70` DHCP reservation.
- Run `abbey git audit` after changing Mac network identity or adding a managed
  workstation.

## Notes

The Mac's canonical repositories live under `/Users/bradcooke/git`. The Codex
workspace checkout remains outside the managed repository list.

The final checkout comparison confirmed `/Users/bradcooke/git/abbey-root` is
the clean, synchronized canonical Mac checkout.
