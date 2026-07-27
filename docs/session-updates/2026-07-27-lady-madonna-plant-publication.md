---
title: "Lady Madonna Plant Publication"
description: "Prepared and published Lady Madonna from the supplied care log and photographs as a complete Orchid Rescue profile."
date: 2026-07-27
status: complete
reviewed: true
session: lady-madonna-plant-publication
tags:
  - Abbey Root
  - BradCooke.com
  - Orchid Rescue
  - Plant Model
---

# Lady Madonna Plant Publication

## Objective

Create Lady Madonna's Orchid Rescue page through the canonical Abbey plant
workflow using the supplied PDF log, photographs, and XMP sidecars without
turning uncertain acquisition details into facts.

## Definition of Done

- Lady Madonna has a complete canonical Plant Model workspace.
- The page tells the documented rescue, spike, bloom, move, and recovery story.
- Acquisition date, price, and retailer remain explicitly uncertain.
- Published history uses only dates and observations supported by the source
  package.
- Photographs have verified timeline placement and useful captions.
- The canonical workspace passes Abbey plant validation and publication.
- The production site builds with a generated Lady Madonna route and resolving
  image references.
- Work is captured and reviewed without committing, pushing, or deploying.

## Summary

Built Lady Madonna's canonical plant workspace from the exported care
conversation and numbered photo package, then used the Abbey plant publisher
to replace the placeholder with a complete public profile.

The story follows the visible recovery arc: a stressed orchid at the first
January assessment, a new flower spike and April bloom, a setback during the
June move, and strong July root growth followed by a possible new leaf.

## Accomplishments

- Preserved the 17-page PDF, all 28 supplied photographs, and all 30 XMP
  sidecars in `working/plants/lady-madonna/`.
- Established canonical metadata, a January-through-July history, current
  inventory, photo provenance, and a concise public story.
- Recorded the likely $5 Lowe's clearance purchase in late 2025 as my
  recollection rather than file-confirmed metadata.
- Corrected the PDF's apparent `6/28/06` typo to 2026-06-28 using the weekly
  chronology.
- Documented the absent numbered photographs associated with sidecars 15 and
  21 instead of implying that they were supplied.
- Selected 19 public photographs covering the initial condition, spike, bloom,
  move, and root-led recovery.
- Generated the public content and selected image set through the canonical
  Abbey publisher.

## Impact

Lady Madonna is now a complete Orchid Rescue profile generated from a
canonical Plant Model workspace. The page adds a long-form recovery with two
distinct turning points: blooming after the original rescue and rebuilding
after the move.

## Validation

- `abbey plant validate lady-madonna`: passed with expected warnings for the
  unknown optional species and acquisition date.
- `abbey plant publish lady-madonna`: passed.
- Astro production build: passed; 115 pages generated.
- Generated route check: `/orchid-rescue/lady-madonna/` exists.
- Rendered index check: Lady Madonna links directly to its profile.
- Rendered content check: uncertain acquisition details remain qualified.
- Published image check: all Lady Madonna image references resolve to files.

## Lessons Learned

A numbered source package can contain sidecars without their matching images.
The canonical workspace should preserve that evidence gap explicitly rather
than silently closing the sequence or guessing at missing content.

The PDF log and photo chronology also support different levels of certainty.
Visible plant changes and weekly dates can be published directly, while
remembered purchase details belong in qualified narrative until stronger
evidence appears.

## Next Steps

- Review the Lady Madonna story, timeline, and photo choices before commit.
- Continue moving the remaining draft orchids through the canonical Plant
  Model workflow.

## Notes

No commit, push, deployment, or live-site publication was performed.
