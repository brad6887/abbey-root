---
title: "Reproducible Managed Git Configuration"
description: "Abbey now defines and audits one predictable Git setup for every managed server."
date: 2026-07-29
draft: false
tags:
  - Abbey Root
---

# Reproducible Managed Git Configuration

## Summary

Git behavior across Abbey-managed servers is now defined by Ansible instead of
being repaired repository by repository. The policy uses the correct identity,
SSH GitHub transport, automatic pruning, and fast-forward-only pulls.

## Accomplishments

- Added an Ansible-owned global Git configuration.
- Added explicit Abbey Root and Bread Pitt SSH remotes.
- Added `abbey git audit` and previewable `abbey git sync`.
- Removed the old rebase/autostash policy and aligned the shell pull alias.
- Protected repository contents and history from the synchronization workflow.

## Lessons Learned

- Configuration drift can originate in automation as easily as in manual
  commands; the old common role was reinstalling incomplete Git defaults.
- Global policy and repository normalization should be separate so host setup
  remains reproducible without making normal repository changes implicitly.
- Private-key distribution is not an acceptable shortcut for GitHub access;
  authentication should be audited explicitly.

## Next Steps

- Validate the new workflow from `rocky-ansible01` in check mode.
- Apply it deliberately across the managed inventory and confirm ordinary pulls
  from multiple hosts.
