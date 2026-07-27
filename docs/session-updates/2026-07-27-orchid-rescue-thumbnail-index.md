---
title: "Orchid Rescue Thumbnail Index"
description: "Redesigned the Orchid Rescue index as a responsive photo gallery with consistent Coming Soon placeholders."
date: 2026-07-27
status: complete
reviewed: true
session: orchid-rescue-thumbnail-index
tags:
  - Abbey Root
  - BradCooke.com
  - Orchid Rescue
---

# Orchid Rescue Thumbnail Index

## Objective

Replace the text-only Orchid Rescue cards with a responsive thumbnail gallery
that shows each published orchid's photograph and a consistent Coming Soon
thumbnail for unpublished profiles.

## Definition of Done

- Every published orchid has a photographic thumbnail.
- Every draft orchid has a same-sized Coming Soon placeholder.
- Each orchid name appears directly beneath its thumbnail.
- Published cards retain direct profile links and drafts retain the shared
  Coming Soon route.
- The gallery works at desktop and mobile widths.
- The production site build and final repository checks pass.

## Summary

Reworked the Orchid Rescue index into a compact visual gallery. Published
profiles use their current photograph with a hero-image fallback, while drafts
use a styled placeholder that occupies the same thumbnail frame.

## Accomplishments

- Added image-backed, fully linked cards for the five published orchids.
- Added consistent Coming Soon thumbnails for the four draft orchids.
- Positioned each orchid name directly beneath its thumbnail.
- Added responsive four-across desktop and two-across mobile behavior.
- Added fixed thumbnail proportions, image cropping, focus/hover feedback, and
  accessible image alt text and link labels.
- Ensured the small gallery loads its five real thumbnails immediately.

## Impact

The Orchid Rescue landing page now works as a visual collection rather than a
metadata list, making the published profiles easier to recognize and the
remaining profiles visibly part of the same collection.

## Validation

- Astro production build: passed; 118 pages generated.
- `git diff --check`: passed.
- Desktop visual review: passed.
- Mobile two-column visual review: passed.
- DOM review confirmed five image cards and four Coming Soon cards.
- All five thumbnail images loaded successfully from their published paths.

## Lessons Learned

For a small above-the-fold gallery, eager image loading gives a more complete
first impression than deferring all thumbnails to browser lazy-loading.

## Next Steps

- Review and publish the redesigned Orchid Rescue index.

## Notes

No plant metadata or individual orchid profile content was changed.
