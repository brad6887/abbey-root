---
title: "Single-Plant Weekly Update Workflow"
description: "Added and proved a safe single-plant weekly observation workflow with dry-run support."
date: 2026-08-01
status: complete
reviewed: true
session: single-plant-weekly-update-workflow
tags:
  - Abbey Root
  - Developer Toolkit
  - Plant Model
  - BradCooke.com
---

# Single-Plant Weekly Update Workflow

## Objective

Implement the first focused single-plant weekly update workflow while
preserving the Plant Model's separate hero, current, and history roles.

## Definition of Done

- One command accepts a photo, short narrative, optional care note, optional
  status change, and observation date.
- Dry-run mode validates and previews the complete update without writing.
- Applying an update copies the source photograph into the canonical plant
  workspace using a deterministic dated filename.
- Only `photos.current` changes; the hero photo and prior history remain intact.
- The status remains unchanged unless explicitly supplied.
- Duplicate weekly dates and invalid inputs are rejected.
- The resulting workspace is validated automatically.
- Focused and existing plant regression tests pass.
- A real orchid dry run and production site build pass.

## Summary

Added `abbey plant update <slug>` as the first weekly observation workflow.
The command uses explicit inputs so it can be scripted today and wrapped in a
more guided selector or editor later without changing the canonical data
contract. It previews every important role change, supports a no-write dry run,
and validates a real update immediately after applying it.

No new orchid photograph was available in the repository. The workflow was
therefore proved safely against Martha My Dear using an existing canonical
photo in dry-run mode. The preview used clearly marked placeholder prose and
made no plant-content changes. The real apply path was proved in an isolated
test workspace.

## Accomplishments

- Added photo, narrative, care, status, date, and dry-run options.
- Added deterministic `<slug>-<date>.<extension>` photograph naming.
- Added a canonical dated history section with observations and optional care.
- Preserved hero metadata and append-only historical content.
- Kept status unchanged by default and updated `status.updated` on apply.
- Added supported status and ISO date validation.
- Added duplicate weekly-date and destination collision protection.
- Ran Plant Model validation automatically after a real update.
- Preserved unrelated `facts.yaml` formatting through surgical scalar updates.
- Kept an existing status tag synchronized when the plant status changes.
- Added 18 focused regression assertions covering dry-run and apply behavior.
- Registered the command in authoritative CLI metadata and regenerated the CLI
  reference.
- Completed a successful 140-page Astro production build.

## Impact

Plant day now has a small, reviewable command that updates the established
source of truth instead of requiring coordinated manual edits. Dry-run support
makes it safe to prepare or verify an update before committing an observation.

## Validation

- `bash tests/test-abbey-plant-update.sh`: 18 assertions passed.
- `bash tests/test-abbey-plant.sh`: 67 assertions passed.
- Shell syntax validation passed for `tools/bin/abbey-plant`.
- Martha My Dear dry run completed and reported no files changed.
- Dry run preserved hero and status while previewing the new current photo and
  history entry.
- `abbey docs generate` completed successfully.
- Direct Astro production build completed successfully with 140 pages.
- `git diff --check` passed.

## Lessons Learned

The repository should not pretend that an older photograph is today's
observation. A real-plant dry run plus an isolated apply test proved the workflow
without introducing false history.

Explicit command options are the right first implementation boundary. Photo
gallery selection and editor-driven narrative entry can be layered on after
normal plant-day use proves where interaction is actually valuable.

The first real apply exposed two defects that fixture-only validation had not:
PyYAML rewrote unrelated source formatting, and the old status remained in
`tags`. Surgical field replacement now preserves the human-maintained file,
while status-tag replacement keeps the two representations consistent when a
status tag already exists.

## Next Steps

- Use the command with one newly taken photograph and real observation during
  the next plant-day update.
- Evaluate interactive photo selection and editor entry only after the explicit
  workflow has been used normally.
- Consider bulk weekly mode after the single-plant workflow is stable.

## Notes

The Martha My Dear proof used `Martha - 6.JPG` only as a dry-run input. No dated
photo, history entry, status, or current-photo change was written to the plant
workspace.
