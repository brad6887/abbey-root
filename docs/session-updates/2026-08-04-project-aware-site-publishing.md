---
title: "Project-Aware Site Publishing"
description: "Made Abbey site builds and publishing resolve explicit active-project configuration and fail closed."
date: 2026-08-04
status: complete
reviewed: false
session: project-aware-site-publishing
tags:
  - Abbey Root
---

# Project-Aware Site Publishing

## Objective

Make `abbey site build` and `abbey site publish` project-aware and prevent an
external project from inheriting Abbey Root's BradCooke.com deployment path.

## Definition of Done

- Resolve the active Abbey project and its site paths from project metadata.
- Support generated npm artifacts and direct static artifacts.
- Require explicit project publishing configuration before deployment.
- Report the resolved project, source, target, domain, and method before work.
- Prove Bread Pitt cannot enter the BradCooke.com publishing workflow.
- Validate Abbey Root and external-project workflows independently.

## Summary

Added a project-owned site configuration contract, migrated Abbey Root's site
settings into that contract, and made the site command reject missing or unsafe
configuration before it invokes build or publishing tools.

## Accomplishments

- Added `site.source`, `site.build`, and `site.publish` metadata to Abbey Root.
- Implemented `npm` and direct `static` artifact handling.
- Removed target and domain fallbacks from the publishing command.
- Added path containment checks for project-owned site artifacts.
- Expanded site regression coverage with an independent Bread Pitt fixture.
- Updated the project standard, CLI metadata, and generated CLI reference.

## Impact

External Abbey projects can safely use the shared site command without risking
publication to BradCooke.com. Projects with a checked-in static `site/`
artifact can validate it without adopting an npm build.

## Validation

- `bash tests/test-abbey-site.sh` — 33 passed.
- `bash tests/test-abbey-cli-context.sh` — 12 passed.
- `bash tests/test-abbey-portability.sh` — 29 passed.
- `tools/bin/abbey docs check` — generated references current.
- `bash tests/test-abbey-init.sh` — 41 passed; one unrelated macOS
  `/var` versus `/private/var` path-normalization assertion failed.
- `git diff --check` — passed.

## Lessons Learned

Deployment safety depends on the absence of implicit defaults as much as on
validating configured values. Direct static artifacts also need an explicit
build mode so a shared tool does not guess how a project is built.

## Next Steps

- Add project-owned `site.build` metadata to Bread Pitt when adopting the new
  command there; leave `site.publish` absent until a deployment is deliberately
  configured.

## Notes

No commit or deployment was performed.
