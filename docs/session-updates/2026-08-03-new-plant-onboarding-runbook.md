---
title: "New Plant Onboarding Runbook"
description: "Added the Rocky Raccoon-proven new-plant onboarding and publication verification process to the authoritative plant runbook."
date: 2026-08-03
status: complete
reviewed: true
session: new-plant-onboarding-runbook
tags:
  - Abbey Root
  - Plant Toolkit
  - Documentation
---

# New Plant Onboarding Runbook

## Objective

Add the complete, proven `abbey plant new` workflow to the authoritative plant
website runbook without duplicating the Plant Model or existing update guidance.

## Definition of Done

- Document initial photo and XMP preparation and correction.
- Document guarded workspace creation through `abbey plant new`.
- Explain verified facts, explicit unknowns, and scaffold replacement.
- Distinguish actionable placeholder warnings from honest optional-field warnings.
- Document canonical source and public derivative verification.
- Validate the documentation and review the final diff.

## Summary

Expanded `PLANT_WEBSITE_UPDATES.md` from an existing-plant maintenance runbook
into the complete plant lifecycle runbook. The new onboarding section follows
the exact sequence validated through Rocky Raccoon, from incoming photo metadata
through workspace creation, canonical content completion, validation, publishing,
privacy verification, capture, and commit.

## Accomplishments

- Added caption correction and dry-run rename guidance with recoverable XMP backups.
- Added the full `abbey plant new` command contract and resulting workspace behavior.
- Documented full location names, `null` for unknown facts, and standard rescue tags.
- Added guidance for inventory, history, story, and photo-metadata completion.
- Added direct placeholder detection before publication.
- Expanded publication verification with generated-page and manifest inspection.
- Added byte-for-byte canonical JPG/XMP comparisons and direct public metadata checks.

## Impact

New plants and existing updates now share one operational source of truth. The
runbook captures the safety boundaries and verification steps learned through
normal use, reducing reliance on conversation history or memory.

## Validation

- `abbey docs check` passed.
- `git diff --check` passed.
- Commands and warning behavior are grounded in Rocky Raccoon's successful onboarding.

## Lessons Learned

The runbook needed to distinguish workspace initialization from publication
readiness. It also needed to define preservation as both canonical-source
integrity and safe public derivatives rather than treating a successful site
build as sufficient verification.

## Next Steps

- Use the onboarding section for the next new plant.
- Refine the runbook only when another real run exposes changed or missing behavior.

## Notes

The journal entry records the runbook as the reusable outcome of the already
completed Rocky Raccoon onboarding.
