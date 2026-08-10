---
title: "Reviewable Multi-Plant Update Workflow"
description: "Added a safe prepare, review, and apply workflow for date-scoped updates across multiple plant workspaces."
date: 2026-08-02
status: complete
reviewed: true
session: reviewable-multi-plant-update-workflow
tags:
  - Abbey Root
---

# Reviewable Multi-Plant Update Workflow

## Objective

Create a reviewable multi-plant workflow that derives photo groups from renamed
exports, warns and skips plants without an update for the selected date, and
applies completed observations as one validated batch.

## Definition of Done

- `prepare` creates a date-scoped worksheet from renamed image/XMP pairs.
- Plants without matching photos warn and are omitted rather than receiving
  placeholder updates.
- The worksheet captures narratives, optional care and status, and explicit
  current-photo selection for multi-photo observations.
- `apply --dry-run` validates the complete worksheet without changing files.
- `apply` copies all photos, populates history photo sections, and updates facts
  for every included plant.
- Focused and existing regression suites pass.

## Summary

Implemented `abbey plant update-batch prepare|apply` around a local YAML
worksheet. Filename metadata determines plant, date, and photos; the worksheet
holds only the human decisions that cannot be inferred safely. Apply validates
every update before using a staged, rollback-protected write process.

## Accomplishments

- Grouped renamed exports by plant slug and an explicitly selected date.
- Warned for every plant workspace without photos and omitted it from the plan.
- Ignored valid renamed photos from other dates while reporting their count.
- Required paired XMP sidecars during preparation and apply, while leaving
  sidecars in incoming after image import.
- Automatically selected a single photo as current and required an explicit
  choice when multiple photos exist.
- Required narratives and validated plant workspaces, dates, filenames,
  statuses, duplicate updates, source files, and destination collisions.
- Added complete history entries with all photos, observations, and optional
  care, then updated current-photo and status facts without altering unrelated
  formatting.
- Kept machine-specific worksheets under an ignored `working/plant-updates/`
  directory.
- Registered and documented the workflow through Abbey CLI metadata and the
  Plant Model reference.

## Impact

A full day of plant observations can now move from one Apple Photos export into
multiple canonical plant histories through a single reviewed plan. A plant
that was photographed the previous day, or simply has no update today, remains
unchanged without blocking the batch.

## Validation

- `tests/test-abbey-plant-update-batch.sh`: 28 passed, 0 failed.
- `tests/test-abbey-plant-update.sh`: 18 passed, 0 failed.
- `tests/test-abbey-plant-rename-exports.sh`: 24 passed, 0 failed.
- `tests/test-abbey-docs.sh`: 23 passed, 0 failed.
- `tests/test-abbey-cli-context.sh`: 12 passed, 0 failed.
- Python and shell syntax validation passed.
- Deterministic documentation generation and `git diff --check` passed.

## Lessons Learned

The renamed filename is sufficient for deterministic grouping, but not for
narrative or image-quality decisions. Keeping those choices in a worksheet
provides a useful human review boundary without duplicating canonical plant
history. Absence should be modeled explicitly as a warning and skip, not as an
empty update.

## Next Steps

- Exercise prepare and dry-run apply with the real 2026-08-02 export batch.
- Use the first normal batch to refine worksheet ergonomics before adding
  automatic publishing or historical backfill behavior.

## Notes

Publish-time metadata stripping is unchanged. Historical backfill and automatic
publishing remain outside this workflow.
