---
title: "Ansible Managed Bashrc"
description: "Moved Abbey shell initialization into a bounded, cross-distribution Ansible workflow."
date: 2026-07-30
draft: false
tags:
  - Abbey Root
  - Ansible
  - Shell
---

# Ansible Managed Bashrc

## Summary

The Abbey-owned portion of `.bashrc` is now managed through Ansible without
replacing the complete file.

Ubuntu and Rocky Linux keep their normal distribution defaults, while one
bounded managed block loads Abbey aliases, the registered command dispatcher,
and an optional host-local extension file.

## Accomplishments

- Added a validated Ansible-managed block to the existing `.bashrc`.
- Removed known hand-maintained Abbey fragments.
- Preserved distribution-specific prompts, completion, aliases, and NVM setup.
- Added `~/.bashrc.local` as the host-local extension point.
- Kept Abbey commands inactive on hosts without the toolkit checkout.
- Added `tools/bin` to PATH so `abbey` resolves correctly.
- Removed duplicate repository shell sources.
- Added regression coverage.
- Deployed to all five Linux hosts.
- Verified a fully idempotent second run.

## Lessons Learned

- Managing part of a file is sometimes safer than owning the entire file.
- Check mode cannot always show the final combined result of sequential edits.
- A command being on disk does not prove the correct directory is on PATH.
- Shell configuration needs live interactive-shell validation.

## Next Steps

- Keep host-local shell changes in `~/.bashrc.local`.
- Revisit role boundaries when the `common` role is split into focused
  responsibilities.
