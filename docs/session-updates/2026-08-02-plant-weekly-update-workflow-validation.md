---
title: "Plant Weekly Update Workflow Validation"
description: "Validated the single-plant weekly update workflow through historical, status-changing, and multi-photo plant updates and documented requirements for a future multi-plant process."
date: 2026-08-02
status: completed
reviewed: false
session: plant-weekly-update-workflow-validation
tags:
  - Abbey Root
  - plants
  - workflow-validation
  - publishing
---

# Plant Weekly Update Workflow Validation

## Objective

Exercise the existing `abbey plant update` workflow through several real plant
updates, identify practical friction, and define the requirements for a future
multi-plant update process without prematurely implementing batch automation.

## Definition of Done

- Process several dated observations through `abbey plant update`.
- Exercise optional care notes and an explicit status transition.
- Validate a same-date observation containing more than one photograph.
- Publish every affected plant and complete one successful site build.
- Record workflow strengths, limitations, and concrete follow-up work.
- Keep future multi-plant automation outside the implementation scope of this
  validation session.

## Summary

The weekly plant update workflow was validated through real updates for
Bungalow Bill, Something, and Doctor Robert.

The core `abbey plant update` command provides a useful dry-run preview,
protects existing observation dates, updates canonical plant state, and
automatically validates the resulting workspace. The Plant Model and publisher
also support multiple photographs within one observation.

The session identified that most multi-plant friction occurs before updates are
written: discovering incoming photographs, matching them to plants and dates,
retrieving detailed journal notes, preparing public narratives, selecting the
current photograph, and reviewing several proposed changes together.

## Accomplishments

- Added Bungalow Bill observations for July 12, July 19, and July 26.
- Recorded Bungalow Bill's July 12 fertilizer application as a care note.
- Published the three accumulated Bungalow Bill updates with one plant publish.
- Added Something's August 2 observation.
- Changed Something's status from `recovering` to `thriving`.
- Added Doctor Robert's August 2 observation using an overall photograph and a
  supporting close-up of the emerging leaf.
- Preserved Doctor Robert's overall photograph as the current image while
  publishing both photographs in the same timeline entry.
- Fixed Orchid Rescue acquisition and last-updated dates displaying one day
  early by routing them through the existing UTC-aware `formatDate` helper.
- Confirmed generated public plant derivatives remove private metadata while
  preserving canonical source photographs.

## Workflow Findings

### Existing Strengths

- `--dry-run` provides a clear approval preview before files are changed.
- Applied updates automatically run plant validation.
- Hero images remain unchanged during weekly updates.
- Current images and observation dates advance correctly.
- Optional care notes and explicit status changes work correctly.
- Existing observation dates are protected from accidental duplication.
- Multiple accumulated updates can be published together.
- Plant publishing creates sanitized current and timeline derivatives.
- The Plant Model and publisher already support multiple photographs per
  history entry.

### Identified Limitations

- Repeated `--photo` arguments are silently accepted while only the final value
  is used.
- `abbey plant update` supports creating observations but not revising existing
  dated observations.
- Multi-photo observations require manual workspace changes.
- The current command has no explicit way to select which photograph becomes
  `photos.current`.
- Incoming photographs live in a shared directory containing AppleDouble,
  XMP, temporary, and unrelated files.
- Long command lines must be assembled repeatedly for each plant.
- Detailed journal notes and the shorter public narrative are currently joined
  manually.
- `status.updated` advances with every observation even when the status value
  itself does not change; its intended semantics should remain explicit.

## Validated Workflow

The practical workflow established by this session is:

1. Locate the incoming photograph and detailed plant journal entry.
2. Derive a concise public narrative from the journal rather than diagnosing
   the plant from the photograph alone.
3. Run `abbey plant update ... --dry-run`.
4. Review the proposed date, photograph, narrative, care note, and status.
5. Apply the approved update and rely on its automatic plant validation.
6. Repeat for other observations without publishing after every write.
7. Publish each affected plant once.
8. Build the site once after the complete update set.
9. Review generated content, public derivatives, repository status, and diff
   validation.

## Future Multi-Plant Process

A future process should use a reviewable proposal or manifest containing:

- Plant slug.
- Observation date.
- One or more photographs.
- Explicit current-photograph selection.
- Public narrative.
- Optional care note.
- Optional status change.

The workflow should separate preparation and approval from writing:

1. Discover and group incoming material.
2. Prepare proposed updates.
3. Review the complete batch.
4. Apply only approved updates.
5. Validate each affected plant.
6. Publish affected plants.
7. Build and review once.

## Validation

- `abbey plant validate bungalow-bill` — passed with one expected optional
  species warning.
- `abbey plant publish bungalow-bill` — passed.
- `abbey plant validate something` — passed with one expected optional species
  warning.
- `abbey plant publish something` — passed.
- `abbey plant validate doctor-robert` — passed with one expected optional
  species warning.
- `abbey plant publish doctor-robert` — passed.
- `abbey site build` — passed with 143 generated pages.
- Built-page inspection confirmed Something displays August 2, 2026.
- Built-page inspection confirmed Martha My Dear displays August 1, 2026.
- Generated Doctor Robert content contains both August 2 photographs.
- `git diff --check` — passed.

## Lessons Learned

The existing update command is a solid single-observation primitive. The future
multi-plant workflow should orchestrate preparation, review, and publication
around it rather than replace its validated behavior.

The most important safety improvement is preventing repeated `--photo`
arguments from silently discarding earlier photographs.

## Next Steps

- Make repeated `--photo` arguments fail clearly until full multi-photo support
  is implemented.
- Add multi-photo observation support with explicit current-photo selection.
- Add a supported revision workflow for existing dated observations.
- Add configured incoming-photo discovery with noise filtering.
- Design a reviewable multi-plant prepare, review, apply, and publish workflow.
- Consider focused regression coverage for UTC-safe plant date formatting.

## Notes

No multi-plant batch command was implemented during this session. The objective
was to validate the existing workflow and establish requirements from observed
usage.
