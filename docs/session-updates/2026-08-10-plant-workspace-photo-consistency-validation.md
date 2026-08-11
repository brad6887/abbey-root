---
title: "Plant Workspace Photo Consistency Validation"
description: "Expanded Plant Model validation with canonical photo-reference checks and orphaned-photo detection across real workspaces."
date: 2026-08-10
status: complete
reviewed: false
session: plant-workspace-photo-consistency-validation
journal: "content/journal/2026/2026-08-10-plant-workspace-photo-consistency-validation.md"
tags:
  - Abbey Root
---

# Plant Workspace Photo Consistency Validation

## Objective

Expand `abbey plant validate` with one coherent media-consistency layer that
validates canonical photo references and reports undocumented or orphaned
supported photographs without changing plant content.

## Definition of Done

- Photo roles in `facts.yaml` must reference direct children of `photos/`.
- History photo list and heading entries, Markdown image links, and
  photo-metadata table filenames are discovered deterministically.
- Missing referenced photographs fail validation with document and line
  evidence.
- Undocumented/orphaned supported photographs produce warnings rather than
  failures so intentionally preserved source material remains allowed.
- JPG, JPEG, PNG, and WebP photographs are covered; XMP, AppleDouble, and
  unsupported artifacts are excluded.
- Focused fixtures and every real plant workspace validate without new false
  missing-reference failures.

## Summary

Extended the existing Plant Model validator rather than creating another
command. It now builds one index of supported files under each workspace's
`photos/` directory and one index of canonical references from structured facts
and Markdown documents, then reports missing and unreferenced set differences.

## Accomplishments

- Added deterministic supported-photo discovery.
- Added role-path containment and reference collection from facts.
- Added history list/heading, Markdown image, and photo-metadata table parsing.
- Added evidence-backed failures for references that do not resolve.
- Added warning-level orphan detection and clean-workspace completion output.
- Added fixtures for missing history photos, metadata-documented photos,
  orphaned photos, ignored sidecars, and ignored AppleDouble artifacts.
- Validated all eleven real plant workspaces.
- Documented the Plant Model contract and updated durable capability status.
- Completed the three bounded plant consistency backlog items.

## Impact

Plant publication now has an earlier, read-only consistency gate for photo
relationships. Broken historical or role references cannot silently survive to
publication, while unused canonical photographs become visible for human
classification without being deleted or treated as invalid automatically.

## Validation

- All validation-section assertions in `tests/test-abbey-plant.sh` passed; the
  broader script then reached its existing ImageMagick publication dependency,
  which is unavailable on this Mac.
- `tests/test-abbey-plant-update.sh`: 18 passed, 0 failed.
- `tests/test-abbey-plant-update-batch.sh`: 31 passed, 0 failed.
- All eleven real workspaces reported zero missing canonical photo references.
- Nine real workspaces reported no orphaned supported photos.
- Doctor Robert reported two genuine undocumented/orphaned photographs:
  `IMG_93B6D73C-0134-4EF1-AB5C-9ABFCE0B6128.jpeg` and
  `IMG_C7758B54-F0A7-45E2-84EE-3C76C3852B6E.jpeg`.
- The real run also retained pre-existing missing `sources/` failures for Phal
  McCartney and Something; these were not introduced or repaired here.
- `tests/test-abbey-site.sh` passed 41 checks before two pre-existing
  environment failures caused by unavailable PyYAML in its minimal NVM test.
- Shell syntax and `git diff --check` passed.

## Lessons Learned

Backlog proximity and a shared plant domain did not make eight proposed items
one session. Facts/history reference consistency and orphan detection share one
data model and validation pass; multi-photo mutation, revision semantics, AI
review, inventory generation, and content maintenance do not.

An unreferenced photograph is evidence requiring classification, not automatic
corruption. Warning-level reporting preserves the Plant Model principle that
original source material should not be discarded. Missing references are
different: they break a declared canonical relationship and must fail.

## Next Steps

- Review and either document or intentionally classify Doctor Robert's two
  newly detected orphaned photographs in a focused content-maintenance change.
- Reconcile the pre-existing missing `sources/` directories for Phal McCartney
  and Something separately from photo consistency.

## Notes

This session does not modify plant workspaces, delete photographs, implement
multi-photo updates or revisions, generate inventory, or add AI review. The
existing reviewed-metadata change for the preceding reciprocal session was
preserved. No commit was created.
