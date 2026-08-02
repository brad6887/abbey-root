---
title: "Plant Export AppleDouble Filtering"
description: "Excluded macOS AppleDouble files from plant export photo discovery after real workflow testing."
date: 2026-08-02
status: complete
reviewed: false
session: plant-export-appledouble-filtering
tags:
  - Abbey Root
---

# Plant Export AppleDouble Filtering

## Objective

Correct the false missing-caption failures discovered while testing
`abbey plant rename-exports` against a real macOS-originated export directory.

## Definition of Done

- AppleDouble `._*` files are ignored without weakening validation of real
  exported photos.
- Focused regression coverage passes.

## Summary

The real dry run correctly rejected an intentionally uncaptained photo, but it
also treated macOS AppleDouble files as photos. The importer now excludes those
filesystem metadata files from image and sidecar discovery.

## Accomplishments

- Filtered `._*` entries before supported-image discovery.
- Filtered `._*` entries before XMP sidecar matching.
- Verified ignored files remain untouched while ordinary missing captions
  continue to fail the complete batch before any rename.

## Impact

Real Apple Photos exports copied through macOS can be processed without dozens
of false caption errors. The safety boundary remains unchanged for genuine
photos.

## Validation

- `tests/test-abbey-plant-rename-exports.sh`: 24 passed, 0 failed.
- Shell syntax validation passed.
- `git diff --check` passed.

## Lessons Learned

Real workflow validation exposed filesystem artifacts that synthetic fixtures
did not initially represent. Intake commands should distinguish exported
content from platform-specific companion files.

## Next Steps

- Pull the fix on the Linux Abbey host and repeat the dry run. The expected
  output should now contain only genuine missing-caption failures such as
  `IMG_9883.xmp`.

## Notes

Publish-time metadata stripping remains unchanged.
