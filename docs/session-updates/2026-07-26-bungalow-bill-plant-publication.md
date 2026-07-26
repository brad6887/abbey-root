---
title: "Bungalow Bill Plant Publication"
description: "Published Bungalow Bill from its canonical Plant Model workspace as a complete Orchid Rescue profile."
date: 2026-07-26
status: complete
reviewed: false
session: bungalow-bill-plant-publication
tags:
  - Abbey Root
  - BradCooke.com
  - Orchid Rescue
  - Plant Model
---

# Bungalow Bill Plant Publication

## Objective

Publish Bungalow Bill as a complete Orchid Rescue profile using the canonical
Plant Model workspace and the established Abbey publishing workflow.

## Definition of Done

- The canonical Bungalow Bill workspace passes plant validation.
- The public placeholder is replaced by the generated story and history.
- Only selected public photographs are copied into the site.
- The Orchid Rescue index links to the generated Bungalow Bill profile.
- The production Astro build and focused rendered-output checks pass.
- The completed work is captured without committing or deploying it.

## Summary

Ran the existing plant publisher against Bungalow Bill's validated canonical
workspace. The generated public content now contains the rescue story, complete
dated timeline, published metadata, and selected timeline photographs. Clearing
the generated draft state also moved the Orchid Rescue index link from the
shared Coming Soon page to Bungalow Bill's profile.

## Accomplishments

- Validated `working/plants/bungalow-bill/` with the canonical Plant Model
  validator.
- Generated `content/plants/bungalow-bill.md` from `facts.yaml`, `story.md`, and
  `history.md`.
- Published the configured hero and current images plus all 19 photographs
  referenced by the public history.
- Confirmed the dynamic profile route is generated and the Orchid Rescue index
  links to it.

## Impact

Bungalow Bill is now the third complete Orchid Rescue profile generated through
the canonical Plant Model workflow. The page remains reproducible from its
working source, while supporting source documents, sidecars, and unreferenced
working material remain private.

## Validation

- `abbey plant validate bungalow-bill`: passed with one expected warning for an
  unknown optional species value.
- `abbey plant publish bungalow-bill`: passed.
- Astro production build: passed; 102 pages generated.
- Generated route check: `/orchid-rescue/bungalow-bill/` exists.
- Rendered index check: Bungalow Bill links to its profile and no longer links
  to Coming Soon.
- Rendered image check: all 21 unique Bungalow Bill image references resolve to
  published files.

## Lessons Learned

The previous Orchid Rescue routing work made publication intentionally small:
the canonical publisher owns the content and asset transformation, while the
generated `draft` field controls both route generation and index routing.

## Next Steps

- Continue moving the remaining draft orchids through the canonical Plant Model
  workflow before publishing their profiles.

## Notes

No commit, push, deployment, or live-site publication was performed.
