---
title: "Revolution Plant Publication"
description: "Published Revolution’s rescue story and curated photo timeline, and added three Coming Soon orchids."
date: 2026-07-30
status: complete
reviewed: true
session: revolution-plant-publication
tags:
  - Abbey Root
---

# Revolution Plant Publication

## Objective

Publish Revolution as a complete Orchid Rescue profile using the established
Plant Model and add Coming Soon entries for Something, Golden Slumbers, and
Martha My Dear.

## Definition of Done

- Revolution has a validated plant workspace with story, history, inventory,
  metadata, sources, and selected photos.
- All photos before January 5, 2026 are grouped under Before Tracking.
- Repetitive photos are omitted in favor of strong representative images.
- Revolution generates a complete public profile.
- Something, Golden Slumbers, and Martha My Dear route to Coming Soon.
- The production site build passes.

## Summary

Built Revolution’s complete plant workspace from the supplied rescue history,
35-photo source set, and XMP dates. Selected 26 representative photos, rendered
the two oldest HEIC images into browser-compatible PNG files, generated the
public profile through Abbey tooling, and added the three requested draft
orchid entries.

## Accomplishments

- Added Revolution’s narrative, chronological history, inventory, metadata,
  and source-provenance note.
- Grouped the 2020–2025 photographs into one Before Tracking entry.
- Selected strong representative images while retaining the complete bloom,
  repot, and recovery sequence.
- Added Golden Slumbers and Martha My Dear as new Coming Soon entries.
- Corrected Something’s display capitalization while retaining draft routing.
- Generated Revolution’s public page and 26 timeline images.

## Impact

Revolution now has a complete, evidence-backed Orchid Rescue profile. The
Orchid Rescue index also accurately previews the next three planned profiles.

## Validation

- `abbey plant validate revolution` passed with only expected warnings for the
  unknown species and rescue date.
- `abbey plant publish revolution` completed successfully.
- `abbey site build` generated 130 pages, including Revolution’s profile and
  the shared Coming Soon route.
- Generated output contains Revolution’s Before Tracking, Peak Bloom, and Back
  in Growth Mode sections.
- The Orchid Rescue index contains Something, Golden Slumbers, and Martha My
  Dear.

## Lessons Learned

Quick Look can preserve historically important HEIC photographs as
browser-compatible PNG files without modifying the incoming originals.

## Next Steps

- Publish the committed site build.
- Develop the three Coming Soon profiles as their notes and photos are ready.

## Notes

The original files under `/home/bcooke/incoming/photos` were not modified.
