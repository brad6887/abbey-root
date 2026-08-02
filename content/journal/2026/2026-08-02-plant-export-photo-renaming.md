---
title: "Plant Export Photo Renaming"
description: "Turned iPhone photo captions into a safe bulk-renaming workflow for exported plant images."
date: 2026-08-02
draft: false
tags:
  - Abbey Root
---

# Plant Export Photo Renaming

## Summary

Plant photo intake no longer needs Mac-only title edits or one-album-at-a-time
exports. A new Abbey command reads each iPhone caption from the exported XMP
sidecar and combines it with the photo's original capture date to create a
descriptive filename.

## Accomplishments

- Added `abbey plant rename-exports <directory> [--dry-run]`.
- Kept every image paired with its renamed XMP sidecar.
- Added deterministic numbering when one plant has several photos on the same
  date.
- Made the operation validate the entire batch and reject collisions before
  renaming anything.
- Covered successful renames and metadata failures with focused tests.

## Lessons Learned

- The caption already entered during phone review is the right source of truth;
  Abbey should consume that metadata instead of asking for duplicate titles.
- Safe batch automation needs a complete preview and validation boundary before
  the first file changes.

## Next Steps

- Preview a real Apple Photos export with
  `abbey plant rename-exports ~/incoming/photos --dry-run`, then run the same
  command without `--dry-run` after reviewing the proposed names.
