---
title: "Plant Weekly Update Workflow Validation"
description: "Tested Abbey's plant update workflow through historical updates, a status change, and a two-photo observation."
date: 2026-08-02
draft: false
tags:
  - Abbey Root
  - plants
---

# Plant Weekly Update Workflow Validation

## Summary

I ran several real orchid updates through the Abbey plant workflow to see what
works well and where updating several plants at once will become annoying.

The basic command is solid. It previews changes, protects existing dates,
updates the current photograph, handles care notes and status changes, and
validates the plant after writing. Most of the friction happens before the
command is run.

## Accomplishments

- Added three historical updates for Bungalow Bill.
- Recorded a fertilizer care note.
- Moved Something from recovering to thriving.
- Added Doctor Robert's first clearly developing new leaf using an overall
  photograph and a close-up.
- Confirmed the publisher already supports multiple photographs in one dated
  observation.
- Fixed plant dates displaying one day early on the website.
- Published all three plants and completed a successful 143-page site build.

## Lessons Learned

- Detailed plant logs should remain the source of truth for public updates.
- Several plant updates should be reviewed together before anything is written.
- Publishing once after a group of updates is cleaner than publishing after
  every observation.
- Repeating `--photo` currently keeps only the last photograph without warning.
- Existing observations cannot yet be revised through the plant command.
- The eventual multi-plant workflow should manage discovery, preparation,
  approval, application, and publication as separate steps.

## Next Steps

- Add safe multi-photo support.
- Add a supported revision path.
- Improve incoming-photo discovery.
- Design a reviewable multi-plant update workflow before automating it.
