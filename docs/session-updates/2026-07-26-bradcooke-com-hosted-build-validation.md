---
title: "BradCooke.com Hosted Build Validation"
description: "Implemented credential-free, path-scoped GitHub-hosted Astro build validation for BradCooke.com."
date: 2026-07-26
status: complete
reviewed: true
session: bradcooke-com-hosted-build-validation
tags:
  - Abbey Root
  - BradCooke.com
  - GitHub Actions
  - Automation
  - CI
---

# BradCooke.com Hosted Build Validation

## Objective

Implement Stage 1 of the accepted BradCooke.com automation architecture:
hosted build validation without production credentials or deployment behavior.

## Definition of Done

- Pull requests and pushes to `main` run hosted validation for site-affecting
  paths.
- The workflow installs the locked dependency graph with `npm ci`.
- The workflow builds the Astro site on Node 22.
- The generated `dist/index.html` entry point is verified.
- Repository permissions remain read-only and no production credential is
  available.
- Superseded runs for the same ref are cancelled.
- The workflow proves itself successfully in its draft pull request.

## Summary

Added the `BradCooke.com Build` GitHub Actions workflow. It is deliberately
limited to build validation and cannot publish or write repository content.

The workflow runs for relevant pull requests and `main` changes, uses current
official checkout and Node setup actions, installs from the committed lockfile,
builds Astro, and checks the generated entry point.

## Accomplishments

- Added site, canonical content, publishing-tool, and self-workflow path
  filters.
- Added explicit read-only repository permissions.
- Pinned the Node runtime to the supported Node 22 major.
- Enabled npm caching keyed by `site/package-lock.json`.
- Added a ten-minute job timeout and superseded-run cancellation.
- Verified the complete hosted job in draft pull request 10.

## Impact

BradCooke.com changes now receive early, durable build feedback without
receiving a production credential or changing the explicit release boundary.
Stage 1 validates the staged architecture before any deployment automation is
introduced.

## Validation

- Workflow YAML parsed locally.
- `git diff --check`.
- GitHub Actions run `30234264085`, job `89878873347`:
  - `npm ci` passed.
  - `npm run build` passed.
  - `dist/index.html` verification passed.
  - Overall `BradCooke.com build` check passed in 24 seconds.
- `abbey backlog check`.
- `abbey docs check`.

## Lessons Learned

The workflow itself is the only reliable environment for the exact hosted
build, so the pull request was opened as a draft before planning was marked
complete. This preserves an evidence-first completion boundary.

Build validation needs no production access. Keeping it credential-free makes
pull-request execution substantially safer than combining build and deploy.

## Next Steps

- Evaluate the stable check and path filters through normal pull-request use.
- Implement Stage 2 only after Stage 1 behavior is accepted.

## Notes

This session does not publish BradCooke.com. `abbey site publish` remains the
supported production workflow.
