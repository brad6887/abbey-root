---
title: "BradCooke.com Automation Architecture"
description: "Selected a staged GitHub-hosted automation architecture for BradCooke.com without weakening explicit production safeguards."
date: 2026-07-26
status: complete
reviewed: false
session: bradcooke-com-automation-architecture
tags:
  - Abbey Root
  - BradCooke.com
  - Architecture
  - Automation
  - Publishing
---

# BradCooke.com Automation Architecture

## Objective

Evaluate GitHub Actions, self-hosted automation, and the existing explicit
publishing workflow; select an implementation-ready BradCooke.com automation
architecture.

## Definition of Done

- The current two-repository publishing contract and safeguards are documented.
- GitHub-hosted and self-hosted automation are compared against the actual
  project architecture.
- Build validation and production deployment have separate trigger and trust
  boundaries.
- Cross-repository authentication, approval, verification, and rollback
  requirements are defined.
- `abbey site publish` has a clear role during and after staged automation.
- Broad backlog entries are replaced with implementation-ready outcomes.

## Summary

Selected staged GitHub-hosted Actions. Stage 1 adds path-scoped Astro build
validation without production credentials. Stage 2 adds a separate manually
dispatched, environment-approved production workflow only after equivalent
publication safeguards are implemented.

Automatic publication on every push to `main` was rejected because it would
collapse build validation and public release, publish unrelated repository
changes, and bypass the current preview and confirmation boundary.

## Accomplishments

- Documented the current `abbey site publish` contract.
- Compared hosted Actions, self-hosted automation, and retaining only the
  current workflow.
- Defined exact Stage 1 build requirements.
- Defined exact Stage 2 trigger, credential, approval, synchronization,
  revision, verification, and rollback requirements.
- Preserved the local command as the supported and recovery publication path.
- Replaced three vague backlog entries with one completed architecture decision
  and two bounded implementation outcomes.

## Impact

The project can gain early build feedback without immediately exposing
production credentials or weakening the deliberate release boundary. The
decision also prevents parallel publishing implementations from drifting apart.

## Validation

- Reviewed `tools/bin/abbey-site` end to end.
- Reviewed the original site-publish session architecture and validation.
- Confirmed the production site is generated into a separate GitHub Pages
  repository.
- Confirmed no GitHub Actions workflow currently exists in Abbey Root.
- `abbey backlog check`.
- `git diff --check`.

## Lessons Learned

The backlog wording made existing guided automation look like a missing build
and deployment mechanism. The actual gap is hosted validation and
workstation-independent publication, not the absence of build or publish
commands.

Separating CI from release preserves a small trust boundary: pull requests can
prove the site builds without receiving any production credential.

## Next Steps

- Implement Stage 1 path-scoped hosted build validation as the next bounded
  session.
- Evaluate Stage 1 through normal pull-request use before implementing
  production deployment.

## Notes

This session changes architecture and planning only. It does not alter the
current production workflow or publish the site.
