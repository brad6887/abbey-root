---
title: "Metadata-Driven Interactive Plant Updates"
description: "A single plant update can now begin with the photo and its metadata instead of a long option list."
date: 2026-08-28
session_update: "docs/session-updates/2026-08-28-metadata-driven-interactive-plant-updates.md"
draft: false
tags:
  - Abbey Root
  - plants
  - automation
---

# Metadata-Driven Interactive Plant Updates

## Summary

Single-plant observations had a reliable command, but using it meant renaming
the photograph first and assembling the plant slug, photo path, date, status,
narrative, and care options by hand. The exported photo already carried most
of the identity needed to start that workflow.

`abbey plant update` can now scan the incoming photo directory, read the plant
name from the adjacent XMP caption, read the capture date from the image, and
match that evidence to an existing canonical plant workspace. The operator
chooses the photo, confirms the match, and supplies the observation details.

## Accomplishments

- Added a guided single-photo selection and metadata-matching flow.
- Added update titles so a special observation can say `New Flower Spike`
  instead of always saying `Weekly Update`.
- Kept the full dry-run preview and a separate apply confirmation.
- Renamed only the selected image/XMP pair and validated the plant after the
  canonical update.
- Preserved the explicit option-based command for scripts and recovery.

## Lessons Learned

- Metadata can remove repetitive typing without removing human review.
- A convenience workflow is safer when it composes the existing preview,
  update, and validation behavior instead of replacing those boundaries.
- Photo identity should fail visibly when metadata does not match a known
  plant; it should never be guessed from nearby files.

## Next Steps

- Use the interactive command for the next real one-photo observation.
- Continue using the worksheet workflow for multi-plant or multi-photo days.
