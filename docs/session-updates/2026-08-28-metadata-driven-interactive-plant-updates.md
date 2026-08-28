---
title: "Metadata-Driven Interactive Plant Updates"
description: "Added a metadata-driven interactive workflow for safe, titled single-plant observations."
date: 2026-08-28
status: complete
reviewed: true
session: metadata-driven-interactive-plant-updates
journal: "content/journal/2026/2026-08-28-metadata-driven-interactive-plant-updates.md"
tags:
  - Abbey Root
  - plants
  - CLI
  - metadata
---

# Metadata-Driven Interactive Plant Updates

## Objective

Make the normal single-plant observation workflow interactive and driven by
the existing photo/XMP metadata while preserving explicit options for scripts
and recovery.

## Definition of Done

- `abbey plant update` scans the incoming photo directory without requiring a
  slug or option list.
- XMP captions and image capture dates identify the canonical plant and
  observation date without renaming first.
- The operator supplies status, update title, observation, and optional care.
- A complete dry-run preview and separate confirmation precede every write.
- Applying the update renames the selected image/XMP pair, updates the
  canonical workspace, and validates the plant.
- Scripted updates remain compatible and support special titles.
- Focused plant tests and repository validation pass.

## Summary

Implemented a new interactive helper behind `abbey plant update` with
`~/incoming/photos` as the default intake directory and `--incoming` as an
override. Explicit `<slug> --photo ...` usage remains available. Added
`--title`, defaulting to `Weekly Update`, and changed duplicate protection to
allow only one dated update regardless of title.

## Accomplishments

- Matched metadata-complete image/XMP pairs to canonical plant workspaces.
- Added numbered selection, plant confirmation, guided data entry, preview,
  apply confirmation, paired rename, canonical update, and validation.
- Kept metadata mismatches visible as warnings rather than guessing identity.
- Added custom history titles for special observations such as a flower spike.
- Added end-to-end interactive regression coverage and extended scripted
  update coverage.
- Updated CLI metadata, generated command documentation, the Plant Model, and
  plant update runbooks.

## Impact

Single-plant observations no longer require assembling a long option list or
renaming the photo before Abbey can identify it. The existing metadata remains
the source of truth, and the workflow retains explicit preview and human
confirmation boundaries.

## Validation

- `tests/test-abbey-plant-update.sh`: 18 passed, 0 failed.
- `tests/test-abbey-plant-update-interactive.sh`: 9 passed, 0 failed.
- `tests/test-abbey-plant-rename-exports.sh`: 24 passed, 0 failed.
- `tests/test-abbey-plant-update-batch.sh`: 44 passed, 0 failed.
- `tests/test-abbey-plant.sh`: 127 passed, 0 failed.
- `abbey docs check`: passed.
- `abbey validate`: passed.
- `git diff --check`: passed.

## Lessons Learned

The interactive command should consume the same caption and capture-date
contract as batch renaming, but it should only mutate the pair the operator
selected. Keeping the scripted command intact provides a clear recovery path
and avoids turning an interactive convenience into a new automation boundary.

## Next Steps

- Exercise the interactive workflow with the next real single-plant photo.
- Keep batch updates worksheet-driven.

## Notes

No plant workspace, public site content, push, or deployment was changed by
the implementation session.
