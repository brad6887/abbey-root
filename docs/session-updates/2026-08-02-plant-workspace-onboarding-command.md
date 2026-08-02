---
title: "Plant Workspace Onboarding Command"
description: "Implemented and validated a safe, template-backed abbey plant new workflow through a Rocky Raccoon trial onboarding."
date: 2026-08-02
status: complete
reviewed: false
session: plant-workspace-onboarding-command
tags:
  - Abbey Root
  - Plant Toolkit
  - Developer Toolkit
---

# Plant Workspace Onboarding Command

## Objective

Implement the smallest maintainable `abbey plant new` command and validate it
through a trial creation of Rocky Raccoon's canonical workspace.

## Definition of Done

- Review the Plant Model, reusable template, Doctor Robert, and validator.
- Define a non-overwriting command contract for verified initial facts and photos.
- Create canonical plant files and directories through the command.
- Add focused regression coverage for success and safety behavior.
- Create and validate a Rocky Raccoon trial workspace through the command.
- Synchronize CLI metadata, generated references, and Plant Model guidance.
- Review the final Git status and diff before commit.

## Summary

Added `abbey plant new <slug> --name NAME --type TYPE` with optional initial
status, date, and repeatable photo imports. The command creates its workspace
atomically from the canonical template, excludes template-only instructions,
preserves unknown facts as `null`, refuses overwrites, and runs Plant Model
validation before reporting success.

Rocky Raccoon was onboarded in a trial run as an orchid with a recovering
status and a 2026-08-02 onboarding date. The trial workspace validated with
expected warnings for unset hero and current images, then was removed so the
real onboarding could be performed by the user on `ubuntu-dev01` with the
original photograph.

## Accomplishments

- Reviewed the Plant Model and template against Doctor Robert's reference workspace.
- Added guarded slug, status, date, required-option, photo-type, and collision validation.
- Added atomic workspace creation and initial photo import with first-photo role assignment.
- Added tracked markers so required empty photo and source directories survive Git clones.
- Added regression coverage for creation, structure, initialized facts, imports, invalid input, missing photos, and overwrite refusal.
- Added the command to authoritative CLI metadata and regenerated CLI documentation.
- Documented the onboarding workflow in the Plant Model and reconciled its backlog items.
- Created and validated `working/plants/rocky-raccoon/` through the new command.

## Impact

Plant onboarding is now reproducible and reviewable instead of relying on a
manual recursive template copy. New workspaces begin with the canonical model,
verified identity fields, explicit unknowns, and an immediate validator result.

## Validation

- `tests/test-abbey-plant.sh` — 93 passed, 0 failed.
- `abbey docs generate` — deterministic CLI references regenerated.
- `abbey plant validate rocky-raccoon` — 16 OK, 4 expected warnings, 0 failures.
- Final `abbey docs check`, focused regression, and `abbey review` remain part of closeout.

## Lessons Learned

The reusable template should remain the structural source of truth, but its
instructional `README.md` is not plant data and should not be copied into real
workspaces. Tracked markers are required for empty model directories to survive
a commit and clone. Atomic creation also makes a multi-file onboarding command safer:
invalid inputs or failed imports cannot leave behind a partial plant directory.

## Next Steps

- Import Rocky Raccoon's real photographs with a future plant photo workflow or a fresh onboarding retry before publication.
- Replace the generated story, history, inventory, and photo-metadata guidance with verified plant-specific content.

## Notes

Publishing Rocky Raccoon is out of scope until the real photograph and narrative
facts are available. The command implementation is being committed and pushed
before the user-driven onboarding run on `ubuntu-dev01`.
