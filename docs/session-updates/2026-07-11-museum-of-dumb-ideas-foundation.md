---
date: 2026-07-11
title: Museum of Dumb Ideas Foundation
status: pending
session: standard
journal: 2026-07-11-museum-of-dumb-ideas-foundation
reviewed: false
---

# Session Update

## Summary

Established the initial Museum of Dumb Ideas section for BradCooke.com.

The Museum provides a dedicated home for humorous projects, abandoned concepts, purchased domains, questionable experiments, and ideas that unexpectedly become worthwhile. The section intentionally uses a distinct museum-inspired visual style while remaining integrated with the existing BradCooke.com navigation and layout.

The first completed exhibit documents OmeletYouFinish.com, an abandoned idea for an omelet-themed travel blog. The exhibit introduces a reusable presentation pattern based on museum accession numbers, exhibit plaques, curator notes, ratings, artifacts, and lessons learned.

## Objectives Completed

- Created the Museum of Dumb Ideas landing page.
- Created the first exhibit for OmeletYouFinish.com.
- Established museum-specific visual styling.
- Added the Museum to the primary site navigation.
- Added the Museum to the homepage links.
- Introduced a reusable exhibit structure for future entries.
- Validated the Astro production build.
- Reviewed the Museum and exhibit pages in a browser.
- Confirmed desktop presentation and navigation behave as expected.

## Files Added

- `site/src/pages/museum/index.astro`
- `site/src/pages/museum/omelet-you-finish.astro`
- `site/src/styles/museum.css`
- `docs/session-updates/2026-07-11-museum-of-dumb-ideas-foundation.md`

## Files Updated

- `docs/planning/IDEAS.md`
- `site/src/components/Nav.astro`
- `site/src/pages/index.astro`

## Design Decisions

The first version uses dedicated Astro pages rather than introducing a new content collection.

This keeps the implementation simple while there is only one complete exhibit. The exhibit structure was still designed consistently enough that it can later become a reusable component or data-driven content model once additional exhibits are ready.

The Museum uses its own stylesheet instead of changing the global site theme. This allows the section to feel like a distinct wing of BradCooke.com without affecting the technical, project, journal, or plant pages.

## Initial Museum Structure

The first version introduces the following conceptual wings:

- Hall of Purchased Domains
- Half-Baked Projects
- Questionable Experiments
- Unexpected Successes

Current and proposed exhibits include:

- OmeletYouFinish.com
- The Jeep Incident
- Bread Pitt

## Validation

The Astro production build completed successfully.

Generated routes include:

- `/museum/`
- `/museum/omelet-you-finish/`

Both pages were reviewed through the local development server and no visual or navigation problems were identified.

## Future Work

- Configure OmeletYouFinish.com through Hostinger.
- Redirect the domain to the published exhibit.
- Locate and scan the 1980s Jeep photograph.
- Create the Jeep Incident exhibit.
- Continue documenting Bread Pitt.
- Decide when the number of exhibits justifies a content collection or reusable exhibit component.
- Consider adding exhibit images and museum artifacts as source material becomes available.

## Notes

The unfinished Bungalow Bill publishing work was stored separately in the Git stash named:

`WIP Bungalow Bill publishing`

This kept the Museum changes isolated from the plant publishing session.
