---
title: "Plant Export AppleDouble Filtering"
description: "Refined plant export renaming to ignore macOS AppleDouble metadata files."
date: 2026-08-02
draft: false
tags:
  - Abbey Root
---

# Plant Export AppleDouble Filtering

## Summary

The first real dry run proved the missing-caption protection worked and also
revealed that macOS `._*` companion files looked like photos to the importer.
Abbey now ignores those filesystem artifacts.

## Accomplishments

- Excluded AppleDouble files from photo and XMP discovery.
- Preserved all-or-nothing validation for genuine missing captions.
- Added regression checks that ignored files remain untouched.

## Lessons Learned

- Real export directories contain operating-system artifacts that focused
  fixtures should represent explicitly.

## Next Steps

- Repeat the dry run after pulling the fix; only genuine uncaptained photos
  should be reported.
