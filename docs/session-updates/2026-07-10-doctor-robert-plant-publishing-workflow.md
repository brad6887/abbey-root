---
title: Doctor Robert Plant Publishing Workflow
description: "Completed the first end-to-end Plant Model publishing workflow using Doctor Robert as the reference implementation."
date: 2026-07-10
status: pending
reviewed: true
session: primary
tags:
  - Abbey Root
  - Plant Model
  - Publishing
  - BradCooke.com
journal: 2026-07-10-doctor-robert-plant-publishing-workflow
---

# Session Update

## Summary

Completed the first end-to-end publishing workflow for the Abbey Root Plant Model using Doctor Robert as the reference implementation.

The new workflow generates Astro content from the canonical plant workspace under `working/plants/`, copies only selected photographs into the website source, and keeps working notes, source documents, metadata sidecars, and unselected images outside the public website.

Doctor Robert is now generated into the Abbey Root Astro site from a single canonical source of truth. The page was built and reviewed through the development server; the production website was not updated during this session.

## Objective

Complete the end-to-end Plant publishing workflow by proving that the Plant Model can drive BradCooke.com from a canonical workspace.

## Accomplishments

- Added `abbey plant publish <slug>`.
- Kept `abbey plant validate <slug>` as a required publishing precheck.
- Generated `content/plants/doctor-robert.md` from:
  - `facts.yaml`
  - `story.md`
  - `history.md`
- Generated Astro front matter from Plant Model metadata.
- Removed duplicate top-level headings during Markdown assembly.
- Copied only the configured hero and current-condition photographs into the website source.
- Renamed published images to stable public filenames:
  - `hero.jpeg`
  - `current.png`
- Added `heroImage` and `currentImage` to the Astro plant collection schema.
- Updated the orchid detail route to display:
  - Hero image
  - Status
  - Species
  - Acquisition date
  - Story
  - Recovery history
  - Current-condition image
  - Last updated date
- Preserved private working material, including:
  - `inventory.md`
  - `photo-metadata.md`
  - Source PDFs
  - XMP sidecars
  - Unselected photographs
- Successfully validated the Doctor Robert workspace.
- Successfully built all Astro pages.
- Verified the generated story, history, and image references.
- Visually reviewed the generated page through the development server.

## Validation

The following checks completed successfully:

```text
abbey plant publish doctor-robert
abbey site build
git diff --check
```

`abbey plant publish doctor-robert` ran the required workspace validation precheck before generating the site content.

The generated page was reviewed at:

`http://192.168.1.86:4321/orchid-rescue/doctor-robert/`

The page displayed correctly, including the hero image, story, recovery history, current-condition image, and plant metadata.

## Design Decisions

- Plant source material remains under `working/plants/<slug>/`.
- Generated Astro content is written to `content/plants/<slug>.md`.
- Selected public photographs are copied to `site/public/images/plants/<slug>/`.
- Publishing remains separate from `abbey site build`.
- Public image filenames are stable and independent of original filenames.
- The existing Astro plant collection and dynamic route remain the website rendering layer.
- Working and source material are not copied into the public site.

## Lessons Learned

- The existing Astro architecture was flexible enough to consume generated Plant Model content without being replaced.
- A separate publishing step keeps source transformation explicit and reviewable.
- A real implementation exposed useful refinements without requiring a major redesign of the Plant Model.
- The publisher should handle presentation-oriented transformations while the canonical source files remain readable and independently useful.
- Only explicitly selected files should cross the boundary from the working workspace into the public site.

## Files Changed

- `tools/bin/abbey-plant`
- `content/plants/doctor-robert.md`
- `site/src/content.config.ts`
- `site/src/pages/orchid-rescue/[slug].astro`
- `site/public/images/plants/doctor-robert/hero.jpeg`
- `site/public/images/plants/doctor-robert/current.png`
- `content/journal/2026/2026-07-10-doctor-robert-plant-publishing-workflow.md`
- `docs/session-updates/2026-07-10-doctor-robert-plant-publishing-workflow.md`

## Follow-Up

- Update the Doctor Robert inventory checklist during the next documentation update.
- Remove the duplicate BradCooke.com priority from `docs/planning/NEXT.md` during the next documentation update.
- Use the same workflow for another plant before expanding the Plant Model.
- Consider additional publishing features only when another plant exposes a concrete need.
