---
title: "Plant Export Photo Renaming"
description: "Added a safe Abbey command that names bulk-exported plant photos from iPhone captions and capture dates."
date: 2026-08-02
status: complete
reviewed: true
session: plant-export-photo-renaming
tags:
  - Abbey Root
---

# Plant Export Photo Renaming

## Objective

Create an Abbey-native intake command for bulk photo exports. Read the iPhone
caption from each adjacent XMP sidecar and the capture date from each photo,
then rename the paired files without changing the established publish-time
metadata sanitization workflow.

## Definition of Done

- `abbey plant rename-exports <directory>` derives lowercase, hyphenated names
  from `XMP-dc:Description` and `DateTimeOriginal`.
- Multiple photos for one plant and date receive deterministic sequence suffixes.
- Images and XMP sidecars remain paired under the same generated stem.
- The command validates the complete batch before writing and never overwrites
  an existing unrelated destination.
- Missing sidecars, captions, and capture dates fail with actionable messages.
- Focused regression coverage and generated CLI documentation are current.

## Summary

Implemented `abbey plant rename-exports <directory> [--dry-run]` as the reusable
bridge between Apple Photos bulk export and the existing plant update and
publishing workflows. The command treats the XMP caption as the plant-name
source of truth and leaves image metadata handling entirely to the existing
publisher.

## Accomplishments

- Added full-batch validation for supported JPG, JPEG, HEIC, PNG, TIFF, and TIF
  exports.
- Read captions from adjacent XMP sidecars and capture dates from image EXIF
  metadata through ExifTool.
- Normalized captions into filename-safe slugs.
- Ordered repeated plant/date photos by full capture timestamp and original
  filename, producing stable `-01`, `-02`, and later suffixes.
- Used staged two-phase renames so source and destination names can safely
  overlap while image/XMP pairs remain synchronized.
- Added a dry-run preview and idempotent behavior for already-renamed batches.
- Registered the command in Abbey CLI metadata and regenerated its reference.
- Added focused tests for sequencing, paired renames, dry runs, missing
  sidecars, missing captions, missing dates, and destination collisions.

## Impact

Plant photos from multiple albums can now be captioned on the iPhone and
exported together. Abbey converts the exported batch into descriptive,
chronological filenames without requiring Mac-only title edits or manual
renaming. The private XMP inputs remain paired with source images, while the
separate publish command continues producing sanitized public derivatives.

## Validation

- Shell syntax checks passed for the command and focused test suite.
- `tests/test-abbey-plant-rename-exports.sh`: 22 passed, 0 failed.
- `tests/test-abbey-plant-update.sh`: 18 passed, 0 failed.
- `tests/test-abbey-docs.sh`: 23 passed, 0 failed.
- `abbey docs check`: passed.
- `git diff --check`: passed.
- The broader `tests/test-abbey-plant.sh` validation cases passed until its
  publishing section stopped because ImageMagick is unavailable in this local
  environment.

## Lessons Learned

Batch validation must precede all file changes. This makes metadata mistakes
safe to correct and rerun, and it prevents a partially renamed export from
becoming another manual reconciliation task. Full timestamps provide a natural
stable ordering, with original filenames supplying a deterministic tie-breaker.

## Next Steps

- Exercise the command against the real exported photo directory on the Linux
  Abbey host where ExifTool and the source files are available.
- Continue into `abbey plant update` and `abbey plant publish` only after the
  rename preview has been reviewed.

## Notes

No publish code or metadata-stripping behavior changed. Planning reconciliation
remains part of the normal session review workflow.
