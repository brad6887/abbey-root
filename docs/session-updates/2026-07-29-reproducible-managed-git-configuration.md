---
title: "Reproducible Managed Git Configuration"
description: "Established one Ansible-owned Git policy and explicit host audit and synchronization workflow."
date: 2026-07-29
status: complete
reviewed: false
session: reproducible-managed-git-configuration
tags:
  - Abbey Root
---

# Reproducible Managed Git Configuration

## Objective

Make routine Git pulls reproducible across Abbey-managed servers without
per-repository identity, transport, or pull-policy repair.

## Definition of Done

- Ansible owns the global Git identity
  `Brad Cooke <brad6887@gmail.com>`.
- Managed hosts use fast-forward-only pulls and automatic remote pruning.
- GitHub HTTPS URLs resolve through SSH transport.
- Existing Abbey Root and Bread Pitt checkouts can be audited and normalized.
- Synchronization does not clone, pull, push, commit, change branches, modify
  working files, or distribute private keys.
- Focused regression tests cover routing, safety, configuration, and Ansible
  invocation.

## Summary

Abbey now has one declared Git policy and a bounded way to inspect or apply it
across managed hosts. This replaces the previous mix of repository-local
identity, rebase aliases, HTTPS and SSH remotes, and manually repaired pull
behavior.

## Accomplishments

- Added the dedicated `git_config` Ansible role.
- Declared the canonical user identity and managed repository remotes in
  inventory.
- Replaced rebase/autostash defaults with `pull.ff=only`.
- Added automatic fetch pruning and GitHub HTTPS-to-SSH URL rewriting.
- Added `abbey git audit` for policy, remote, override, and GitHub SSH checks.
- Added `abbey git sync [--check]` to install policy and normalize existing
  checkouts without altering repository contents or history.
- Updated the `gl` alias to use the same fast-forward-only policy.
- Added generated CLI documentation and planning status.

## Impact

New servers receive the same Git behavior through the common Ansible playbook.
Existing servers can be previewed, synchronized, and audited from the Ansible
control host with explicit scope.

## Validation

- `tests/test-abbey-git.sh` — 16 passed.
- `tests/test-abbey-doctor-git.sh` — 10 passed.
- `tests/test-abbey-ssh.sh` — 12 passed.
- `tests/test-abbey-docs.sh` — 23 passed.
- `tests/test-abbey-backlog.sh` — 18 passed.
- `tests/test-abbey-portability.sh` — 29 passed.
- Generated documentation and backlog checks passed.
- YAML parsing, shell syntax, and `git diff --check` passed.
- The first live `ubuntu-dev01` canary correctly identified global-policy drift
  but exposed skipped repository command tasks in Ansible check mode.
- Check-mode repository reads and explicit change previews were added before
  permitting live synchronization.

## Lessons Learned

The earlier Ansible baseline was itself a source of drift: it overwrote the
global Git configuration with rebase behavior while omitting identity. A
reproducible workflow needs one declared policy plus a separate, reviewable
normalization step for existing repositories.

Ansible command tasks do not automatically provide useful check-mode previews.
Read operations must explicitly run without mutation, while prospective writes
must be represented separately and marked as predicted changes.

## Next Steps

- From `rocky-ansible01`, run `abbey git audit`.
- Preview all changes with `abbey git sync --check`.
- Synchronize only after reviewing the host-by-host output.
- Re-run the audit and validate an ordinary `git pull` on at least two hosts.

## Notes

Live infrastructure mutation was intentionally excluded from this implementation
session. GitHub SSH authentication remains dependent on each host having a
public key registered with GitHub; the audit reports that boundary instead of
copying private credentials.
