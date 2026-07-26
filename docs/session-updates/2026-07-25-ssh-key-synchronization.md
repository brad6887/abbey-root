---
title: "SSH Key Synchronization Workflow"
description: "Added an Abbey-managed workflow for auditing and synchronizing SSH public keys across managed lab nodes."
date: 2026-07-25
status: complete
reviewed: true
session: primary
tags:
  - Abbey Root
  - Infrastructure
  - Ansible
  - SSH
  - Developer Toolkit
---

# SSH Key Synchronization Workflow

## Objective

Create a safe, repeatable Abbey workflow for auditing and synchronizing SSH public keys across managed lab nodes so each node can authenticate to the others without manually maintaining `authorized_keys` files.

## Definition of Done

- Abbey provides commands for auditing and synchronizing managed SSH keys.
- Public keys are collected from the managed nodes.
- Each node receives the authorized public keys through an Ansible-managed block.
- Existing unrelated `authorized_keys` content is preserved.
- Synchronization is idempotent.
- Node-to-node SSH authentication is validated across the managed lab hosts.
- Focused regression tests cover command routing and safety behavior.
- The session is documented and reconciled.

## Summary

Implemented an Abbey-managed SSH key synchronization workflow for the current lab inventory.

The workflow separates read-only auditing from synchronization. `abbey ssh audit` reports SSH key authorization state, while `abbey ssh sync` collects node public keys and maintains an Abbey-owned block in each managed account's `authorized_keys` file.

The implementation uses focused Ansible playbooks and preserves SSH configuration outside the managed block. Final validation confirmed successful node-to-node SSH authentication across all four managed hosts.

## Accomplishments

- Added the `abbey ssh` command group.
- Added `abbey ssh audit` for read-only SSH key authorization reporting.
- Added `abbey ssh sync` for controlled key synchronization.
- Added `tools/bin/abbey-ssh`.
- Added `ansible/playbooks/ssh-audit.yml`.
- Added `ansible/playbooks/ssh-sync.yml`.
- Integrated SSH commands into Abbey CLI dispatch and metadata.
- Added `tests/test-abbey-ssh.sh`.
- Collected public keys from the managed lab nodes.
- Installed the collected keys through an Abbey-managed `authorized_keys` block.
- Preserved unrelated existing authorized keys.
- Validated node-to-node SSH connectivity across:
  - `ai-worker01`
  - `edge01`
  - `rocky-ansible01`
  - `ubuntu-dev01`
- Confirmed repeated synchronization produced no additional changes.

## Impact

SSH trust between managed Abbey nodes can now be reviewed and maintained through a repository-owned workflow instead of one-off shell commands or manual edits.

The managed-block approach gives Abbey clear ownership of synchronized node keys while preserving keys and configuration maintained for other purposes.

The workflow also provides a reusable foundation for future infrastructure automation that requires secure node-to-node SSH access.

## Validation

- Shell syntax validation passed for the new Abbey SSH tooling.
- Focused Abbey SSH regression tests passed.
- The SSH audit playbook completed successfully across all managed hosts.
- The synchronization playbook completed without unreachable or failed hosts.
- Final Ansible recap:
  - `ai-worker01`: `ok=4`, `changed=0`, `unreachable=0`, `failed=0`
  - `edge01`: `ok=4`, `changed=0`, `unreachable=0`, `failed=0`
  - `rocky-ansible01`: `ok=4`, `changed=0`, `unreachable=0`, `failed=0`
  - `ubuntu-dev01`: `ok=4`, `changed=0`, `unreachable=0`, `failed=0`
- Node-to-node SSH authentication succeeded across the managed host set.
- A repeated synchronization run was idempotent with `changed=0` on every host.

## Lessons Learned

Separating audit and synchronization behavior makes the workflow safer and easier to understand. Operators can inspect the current state before making changes.

An Ansible-managed block is preferable to replacing complete `authorized_keys` files because it establishes clear ownership without removing unrelated access.

End-to-end SSH validation is necessary after key installation. A successful file update alone does not prove that authentication works between every required pair of systems.

Idempotence provides an important operational check. The final zero-change run confirmed that the synchronized state was stable and reproducible.

## Next Steps

- Evaluate the SSH audit and synchronization commands through normal lab use.
- Expand the managed inventory only when additional Abbey nodes require node-to-node SSH access.
- Consider broader SSH policy validation separately if repeated operational needs justify it.

## Notes

The session review found no required changes to the authoritative planning documents. The completed workflow was already represented in the current project state, and no unfinished work from this session needs to be added to the backlog.
