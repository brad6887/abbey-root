---
title: "Ansible Managed Bashrc"
description: "Made the Abbey-owned portion of the managed Linux user's Bash configuration reproducible through Ansible."
date: 2026-07-30
status: complete
reviewed: true
session: ansible-managed-bashrc
tags:
  - Abbey Root
  - Ansible
  - Shell
  - Configuration Management
---

# Ansible Managed Bashrc

## Objective

Make the Abbey-owned portion of the managed Linux user's `.bashrc`
reproducible through Ansible without replacing distribution-specific or
host-specific shell configuration.

## Definition of Done

- Ansible manages a clearly bounded block in the `admin_user` account's
  existing `.bashrc`.
- Debian and Rocky Linux distribution defaults remain intact.
- Abbey aliases and PATH initialization have one authoritative repository
  source.
- Known legacy Abbey fragments are removed from existing `.bashrc` files.
- `~/.bashrc.local` remains available for untracked host-local customization.
- Hosts with an Abbey toolkit checkout activate Abbey aliases and commands.
- Hosts without the toolkit do not expose inactive Abbey commands.
- The registered `tools/bin/abbey` dispatcher is available through PATH.
- PATH initialization is idempotent.
- Check mode, deployment, live-shell validation, and a second Ansible run pass.
- The backlog and session documentation are reconciled.

## Summary

The `common` role now manages a bounded Abbey shell block in the existing
`.bashrc` for the configured `admin_user`.

The complete `.bashrc` is intentionally not templated because Ubuntu and Rocky
Linux provide materially different default files and some hosts contain valid
local behavior such as NVM initialization, completion setup, prompt choices,
and operating-system-specific aliases.

The managed block sources the Ansible-owned Abbey aliases and shell
initialization files when the user has an Abbey Root toolkit checkout. It also
sources `~/.bashrc.local` when present.

## Accomplishments

- Added Ansible inspection and validation of the managed user's existing
  `.bashrc`.
- Added a bounded `blockinfile` section for Abbey shell initialization.
- Added syntax validation with `bash -n`.
- Removed known legacy Abbey helper, alias, and PATH fragments.
- Preserved Ubuntu, Rocky Linux, edge-service, and sensor shell defaults.
- Added the `ans` shortcut to the authoritative Abbey alias file.
- Made Abbey PATH initialization idempotent.
- Added both `tools` and `tools/bin` to PATH so legacy tools and the registered
  dispatcher remain available.
- Guarded Abbey aliases and PATH setup so they activate only when the user's
  toolkit checkout exists.
- Added optional `~/.bashrc.local` support.
- Removed duplicate shell sources under `scripts/bash`.
- Added focused regression coverage.
- Marked the backlog item complete.

## Impact

Shell configuration is now reproducible across all managed Linux hosts without
forcing a single cross-distribution `.bashrc` template.

Toolkit hosts receive consistent aliases and the registered Abbey command.
Appliance-style hosts retain a managed local-extension point without exposing
commands that cannot work there.

## Validation

Repository validation passed:

- `tests/test-ansible-managed-bashrc.sh`
- `tests/test-abbey-git.sh`
- Bash syntax validation for both managed shell files
- YAML parsing through the existing Git regression suite
- `git diff --check`

Ansible validation passed:

- Playbook syntax check
- Check-mode preview across all five managed Linux hosts
- Canary deployment to `ubuntu-dev01`
- Full deployment to all five hosts
- Existing `.bashrc` content preserved
- Legacy Abbey fragments removed
- Managed block present on all five hosts
- Abbey aliases inactive on `edge01` and `sensor01`
- Abbey aliases active on `ubuntu-dev01`, `rocky-ansible01`, and `ai-worker01`
- `command -v abbey` resolves to
  `/home/bcooke/git/abbey-root/tools/bin/abbey`
- `tools` and `tools/bin` each appear exactly once in PATH
- Second Ansible run reported `changed=0` for every host

## Lessons Learned

- Ansible ad-hoc commands using privilege escalation inspect root's home unless
  the managed user and home directory are explicitly selected.
- A complete shared `.bashrc` template would erase valid distribution and host
  differences.
- `/etc/profile.d` files must protect themselves because login shells can
  source them independently of the managed `.bashrc` block.
- The current Abbey dispatcher lives in `tools/bin`, while legacy standalone
  tools still live under `tools`.
- Check-mode output from sequential replace and block tasks can display an
  intermediate state because later tasks do not see simulated earlier changes.
- Live-shell validation is necessary even when static tests and Ansible check
  mode pass.

## Next Steps

- Review the remaining shell responsibilities when the broader `common` role
  split is undertaken.
- Use `~/.bashrc.local` for genuinely host-local customization rather than
  editing the managed block.

## Notes

This session intentionally did not replace the complete `.bashrc` and did not
perform the broader backlog item to split package, Git, and shell
responsibilities out of the `common` role.
