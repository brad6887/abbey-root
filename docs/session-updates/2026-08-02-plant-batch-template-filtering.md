---
title: "Plant Batch Template Filtering"
description: "Excluded the reusable plant template from batch update missing-photo warnings after real workflow validation."
date: 2026-08-02
status: complete
reviewed: true
session: plant-batch-template-filtering
tags:
  - Abbey Root
---

# Plant Batch Template Filtering

## Objective

Correct the false `_template` missing-photo warning exposed by the first real
multi-plant worksheet preparation.

## Definition of Done

- Template directories are omitted from the plant update roster.
- Unknown photo slugs remain blocking to catch caption errors or missing plant
  workspaces.
- Focused regression coverage passes.

## Summary

The real 2026-08-02 preparation correctly grouped nine plant updates and
warned for an existing plant without photos, but also warned for the reusable
`_template` directory. Plant discovery now excludes underscore-prefixed
template directories.

## Accomplishments

- Filtered `_template` out of plant workspace discovery.
- Added a regression fixture proving it produces no warning.
- Retained strict validation for photos whose slugs have no plant workspace.

## Impact

Missing-update warnings now describe actual plants only, keeping the worksheet
review concise without weakening protection against misspelled captions.

## Validation

- `tests/test-abbey-plant-update-batch.sh`: 29 passed, 0 failed.
- `git diff --check`: passed.

## Lessons Learned

Directory existence alone does not make an entry a domain object. Workspace
discovery must respect the repository's underscore-prefixed template convention.

## Next Steps

- Pull the fix before the next worksheet preparation.
- Continue reviewing and dry-running the already generated worksheet; it is
  valid and does not need to be regenerated solely for this warning fix.

## Notes

The nine-update worksheet already prepared on the Linux host remains usable.
