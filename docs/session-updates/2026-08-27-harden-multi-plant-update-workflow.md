---
title: "Harden Multi-Plant Update Workflow"
description: "Made multi-plant worksheets safer to edit, added validation and slug discovery, and made repeat application recovery-aware."
date: 2026-08-27
status: complete
reviewed: true
session: harden-multi-plant-update-workflow
journal: "content/journal/2026/2026-08-27-harden-multi-plant-update-workflow.md"
tags:
  - Abbey Root
  - plants
  - workflow
---

# Harden Multi-Plant Update Workflow

## Objective

Harden the proven multi-plant observation workflow after the August 23 update
exposed worksheet-editing friction and unclear recovery behavior.

## Definition of Done

- Prepared worksheets are visibly structured and safe for prose with apostrophes.
- Worksheet syntax and structure can be validated without applying changes.
- Reviewed worksheet slugs can populate validation and publishing loops.
- Fully applied batches are recognized and left unchanged.
- Partial or inconsistent batches fail with focused diagnostics.
- CLI metadata, reference documentation, generated documentation, and tests agree.

## Summary

The batch helper now emits indented photo lists and folded narrative
placeholders, provides `validate` and `slugs` subcommands, and distinguishes
new, already-applied, and inconsistent updates. The real August 23 worksheet
validated successfully and its eleven canonical updates were recognized as
complete without changing files.

## Accomplishments

- Added human-oriented YAML output with a required folded narrative placeholder.
- Added structural worksheet validation independent of canonical apply state.
- Added one-slug-per-line worksheet output for shell arrays.
- Made repeat application idempotent when canonical photos, history, current
  photo, and status date agree.
- Added focused diagnostics for partially applied or inconsistent workspaces.
- Expanded the batch workflow test suite and regenerated deterministic CLI docs.

## Impact

Recurring plant updates require less manual shell editing and have a clear,
safe recovery path. The workflow can reuse the reviewed worksheet as the source
of batch membership instead of rescanning intake files or typing slugs.

## Validation

- `python3 -m py_compile scripts/abbey_plant_update_batch.py` passed.
- `bash -n tools/bin/abbey-plant` passed.
- `tests/test-abbey-plant-update-batch.sh`: 44 passed, 0 failed.
- Real August 23 worksheet validation passed for 11 updates.
- Real worksheet slug output matched all 11 reviewed plants.
- Real recovery dry-run reported 0 ready and 11 already applied.
- `abbey docs generate` and `abbey docs check` passed.

## Lessons Learned

A syntactically valid generated worksheet can still be easy to damage during
manual editing. Human-oriented formatting, explicit structural validation, and
recovery-aware state reporting are complementary safeguards.

## Next Steps

- Use the updated workflow for the next multi-plant observation batch.
- Revisit the worksheet schema only if another real update reveals additional
  editing or recovery friction.

## Notes

The pre-existing August 23 canonical plant changes were preserved throughout.
No commit, push, website publication, or deployment was performed in this
tooling session.
