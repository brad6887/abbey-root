---
date: 2026-07-11
title: Museum of Dumb Ideas Foundation
status: complete
session: standard
journal:
reviewed: true
---

# Session Update

## Summary

Established and published the initial Museum of Dumb Ideas section for BradCooke.com.

The Museum provides a dedicated home for humorous projects, abandoned concepts, purchased domains, questionable experiments, and ideas that unexpectedly become worthwhile. The section uses a distinct museum-inspired visual style while remaining integrated with the existing BradCooke.com navigation and layout.

The first completed exhibit documents OmeletYouFinish.com, an abandoned idea for an omelet-themed travel blog. The exhibit introduces a repeatable presentation pattern based on accession numbers, exhibit plaques, curator notes, ratings, artifacts, and lessons learned.

The session also completed the missing production publishing workflow for BradCooke.com. The new `abbey site publish` command safely builds the Astro site, previews production changes, preserves the custom-domain configuration, updates the separate GitHub Pages repository, commits the generated site, and pushes it live.

## Objectives Completed

- Created the Museum of Dumb Ideas landing page.
- Created the first exhibit for OmeletYouFinish.com.
- Established museum-specific visual styling.
- Added the Museum to the primary site navigation.
- Added the Museum to the homepage links.
- Introduced a reusable exhibit structure for future entries.
- Corrected responsive title overflow on the OmeletYouFinish.com exhibit.
- Configured a permanent Hostinger redirect for OmeletYouFinish.com.
- Published the complete Astro site to GitHub Pages.
- Added `abbey site publish`.
- Added a safe `--dry-run` publishing mode.
- Validated the complete publishing workflow end to end.

## Files Added

- `site/src/pages/museum/index.astro`
- `site/src/pages/museum/omelet-you-finish.astro`
- `site/src/styles/museum.css`
- `docs/session-updates/2026-07-11-museum-of-dumb-ideas-foundation.md`

## Files Updated

- `docs/planning/IDEAS.md`
- `site/src/components/Nav.astro`
- `site/src/pages/index.astro`
- `tools/bin/abbey-site`
- `config/cli/cli.yml`
- `docs/generated/CLI_REFERENCE.md`

## Museum Design

The first version uses dedicated Astro pages rather than introducing a new content collection.

This keeps the implementation simple while there is only one complete exhibit. The page structure is consistent enough to become a reusable component or data-driven content model after additional exhibits have been created.

The Museum uses its own stylesheet rather than changing the global site theme. This allows it to feel like a distinct wing of BradCooke.com without affecting the technical, project, journal, or plant sections.

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

## Publishing Architecture

BradCooke.com is built from the Abbey Root repository but served from the separate GitHub Pages repository.

- Abbey Root repository
  - Astro source and content
  - Runs `abbey site publish`
- `brad6887.github.io` repository
  - Receives the generated production site
- GitHub Pages
  - Serves `bradcooke.com`

The publishing command performs the following workflow:

1. Requires a clean Abbey Root repository.
2. Requires a clean production repository.
3. Validates the production `CNAME`.
4. Builds the Astro site.
5. Shows an `rsync` publication preview.
6. Supports a non-destructive `--dry-run`.
7. Requires confirmation before changing production.
8. Copies `site/dist/` into the GitHub Pages repository.
9. Preserves the custom-domain configuration.
10. Validates and displays the staged production changes.
11. Requires confirmation before committing and pushing.
12. Commits the generated site with the Abbey Root source revision.

## Domain Redirect

Hostinger permanently redirects:

`https://omeletyoufinish.com/`

to:

`https://bradcooke.com/museum/omelet-you-finish/`

The domain remains managed through Hostinger while BradCooke.com continues to be served through GitHub Pages.

## Validation

The Astro production build completed successfully with 44 generated pages.

Generated Museum routes include:

- `/museum/`
- `/museum/omelet-you-finish/`

The pages were reviewed locally and after publication.

Live validation confirmed:

- `https://bradcooke.com/museum/omelet-you-finish/` returned `HTTP 200`.
- `https://omeletyoufinish.com/` returned `HTTP 301`.

Both the Abbey Root source repository and the production GitHub Pages repository were clean after publication.

## Future Work

- Reduce noise in the publish preview so it emphasizes files whose content actually changed.
- Add live-site verification directly to `abbey site publish`.
- Locate and scan the 1980s Jeep photograph.
- Create the Jeep Incident exhibit.
- Continue documenting Bread Pitt.
- Invite nominations for future Museum exhibits once the collection is more established.
- Decide when the number of exhibits justifies a content collection or reusable exhibit component.
- Add exhibit images and physical artifacts as source material becomes available.

## Result

The Museum of Dumb Ideas is now a live section of BradCooke.com, OmeletYouFinish.com redirects directly to its first exhibit, and future website changes can be published through a documented Abbey command rather than a manual sequence of repository operations.
