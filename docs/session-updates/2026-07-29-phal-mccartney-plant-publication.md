---
title: Phal McCartney Plant Publication
description: Published Phal McCartney's complete bloom, move, and recovery history.
date: 2026-07-29
status: complete
reviewed: true
session: phal-mccartney-plant-publication
tags:
  - Abbey Root
  - Plant Model
  - BradCooke.com
  - Phalaenopsis
journal: 2026-07-29-phal-mccartney-plant-publication
---

# Session Update

## Objective

Publish Phal McCartney as a complete Orchid Rescue profile from the supplied
story, timeline, photographs, and metadata.

## Definition of Done

- Preserve the supplied photographs and available XMP sidecars.
- Build a canonical Plant Model workspace.
- Use photo 20 as the hero image.
- Replace the public placeholder with the complete profile.
- Validate the plant workspace and production site.
- Commit, push, and verify the live route.

## Summary

Published Phal McCartney as a complete Plant Model profile and replaced the
original placeholder page.

The profile documents the two-spike bloom from January through April, the
month-long packed move from Florida to Texas, and the new center leaf that
matured through July.

## Accomplishments

- Created the canonical workspace under `working/plants/phal-mccartney/`.
- Preserved all 23 supplied photographs and 22 available XMP sidecars.
- Recorded the dated photo history from January 5 through July 26.
- Preserved the approximate Mid-2025 acquisition and unconfirmed Publix source
  without inventing a precise date.
- Configured photo 20 as the owner-selected hero image.
- Configured photo 23 as the current image.
- Published every timeline photograph through stable generated paths.
- Replaced the draft placeholder with a thriving Phalaenopsis profile.

## Impact

Phal McCartney is now a complete Orchid Rescue profile with a reproducible
canonical source package, public narrative, dated timeline, and stable images.

## Validation

The following checks completed successfully:

```text
abbey plant validate phal-mccartney
abbey plant publish phal-mccartney
abbey site build
git diff --check
```

The generated route is:

`/orchid-rescue/phal-mccartney/`

The plant validator reports the expected warnings for the unknown hybrid
species and undocumented exact acquisition date.

## Lessons Learned

The photo numbering, embedded dates, and XMP sidecars were sufficient to map
the complete supplied timeline without creating unsupported facts. Photo 2
retained its embedded January 5 date but had no matching XMP sidecar.

## Next Steps

- Continue weekly updates when new growth or bloom milestones occur.

## Notes

The publication was completed in the normal `/home/bcooke/git/abbey-root`
working copy on `ubuntu-dev`; no clone repository was created.
