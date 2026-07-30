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
- Used the first Ubuntu canary to repair check-mode repository previews before
  any live normalization.
- Used the Rocky canary to make optional, absent repository checkouts safe.
- Added GitHub's published ED25519 host key after the remaining-host audit
  identified missing non-interactive trust on Edge and Sensor.
- Fingerprint-verified and registered the Edge and Sensor public keys with
  GitHub.
- Completed a clean inventory-wide audit across all five managed hosts.

## Lessons Learned

- Configuration drift can originate in automation as easily as in manual
  commands; the old common role was reinstalling incomplete Git defaults.
- Global policy and repository normalization should be separate so host setup
  remains reproducible without making normal repository changes implicitly.
- Private-key distribution is not an acceptable shortcut for GitHub access;
  authentication should be audited explicitly.
- Ansible command tasks need separate read and preview operations to make check
  mode trustworthy.
- Skipped loop results are data too; optional repositories must not be treated
  like failed command executions.
- Non-interactive SSH needs managed host identity trust as well as a registered
  user key.

## Next Steps

- Run the Git audit whenever a managed host or repository is added.
- Continue using per-host public keys rather than distributing private
  credentials.
