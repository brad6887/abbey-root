---
title: "BradCooke.com Hosted Build Validation"
description: "BradCooke.com pull requests now prove the Astro site builds without receiving production access."
date: 2026-07-26
draft: false
tags:
  - Abbey Root
  - BradCooke.com
  - GitHub Actions
  - CI
---

# BradCooke.com Hosted Build Validation

## Summary

Stage 1 of the BradCooke.com automation architecture is live. A path-scoped
GitHub-hosted workflow now installs the locked dependencies, builds Astro, and
verifies the generated site entry point.

## Accomplishments

- Added credential-free hosted build validation for pull requests and `main`.
- Limited repository permissions to read-only content access.
- Added deterministic installation, Node 22, caching, timeout, and concurrency
  behavior.
- Proved the workflow in its own draft pull request in 24 seconds.

## Lessons Learned

- A workflow should prove itself before its backlog item is marked complete.
- Separating build validation from deployment produces useful CI without
  expanding the production trust boundary.

## Next Steps

- Evaluate Stage 1 through normal pull-request use before implementing the
  manually approved production workflow.
