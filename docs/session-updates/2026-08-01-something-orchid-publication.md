---
title: "Something Orchid Publication"
description: "Published Something's canonical orchid rescue workspace, timeline, photos, and generated site page."
date: 2026-08-01
status: completed
reviewed: true
session: something-orchid-publication
tags:
  - Abbey Root
  - plants
  - orchid-rescue
  - publishing
---

# Something Orchid Publication

## Objective

Publish Something's orchid rescue page from the supplied narrative, photo
captions, images, and metadata using the canonical Abbey plant workflow.

## Definition of Done

- Create one canonical `working/plants/something/` workspace using the existing plant model.
- Preserve the conversational, slightly goofy rescue narrative.
- Add all supplied photographs to a dated, captioned recovery timeline.
- Replace the public draft with publisher-generated content and image assets.
- Confirm the orchid index links to the published page through canonical front matter rather than duplicated index data.
- Pass focused plant validation and the complete Abbey site build.
- Review the final Git status and diff before committing only the scoped changes.

## Summary

Something now has a complete canonical plant workspace and a published orchid
rescue page covering her January rescue from Publix in Naples through her July
recovery in Texas. The public page is generated from the workspace, and the
orchid index discovers it from the generated plant front matter.

## Accomplishments

- Added canonical facts, story, history, inventory, and photo-provenance files.
- Added all 21 supplied photographs and their XMP sidecars without modifying the incoming source files.
- Preserved the supplied rescue narrative and photo-caption voice.
- Used embedded dates and XMP `DateCreated` values to build the complete timeline.
- Published hero, current, index, and 21 timeline images through `abbey plant publish`.
- Replaced the previous `draft: true` placeholder with the generated, published page.
- Verified the site generated `/orchid-rescue/something/` and included Something in the orchid matrix.

## Impact

Something is no longer a coming-soon card. Her story and full recovery timeline
are available through the same single-source plant publishing system used by
the rest of the orchid collection.

## Validation

- `abbey plant validate something` — passed with the expected warning for unknown optional species.
- `abbey plant publish something` — passed and generated the public page and image assets.
- `abbey site build` — passed; 141 pages built, including `/orchid-rescue/something/` and the orchid index.
- Generated page inspection confirmed all 21 timeline images and published front matter.
- Final `git status` and `git diff` reviewed before commit.

## Lessons Learned

XMP sidecars can preserve trustworthy `DateCreated` values when exported image
files do not retain normal embedded capture dates. The plant workspace remains
the right place to record that provenance once, allowing the publisher and
orchid index to stay derived.

## Next Steps

- Publish the committed site through the normal deployment workflow when desired.

## Notes

No readable Something PDF was present under `/home/bcooke/incoming` during the
session. The user-supplied narrative and captions, 21 photographs, and their
XMP sidecars provided the source material used for publication.
