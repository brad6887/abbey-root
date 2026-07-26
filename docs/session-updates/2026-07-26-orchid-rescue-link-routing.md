---
title: "Orchid Rescue Link Routing"
description: "Routed complete Orchid Rescue entries to their profiles and incomplete entries to one shared Coming Soon page."
date: 2026-07-26
status: complete
reviewed: false
session: orchid-rescue-link-routing
tags:
  - Abbey Root
  - BradCooke.com
  - Orchid Rescue
  - Astro
---

# Orchid Rescue Link Routing

## Objective

Update the BradCooke.com Orchid Rescue index so complete orchids link to their
published profiles and incomplete orchids link to one shared Coming Soon page.

## Definition of Done

- Doctor Robert and Helter Skelter link to their existing profile pages.
- Every incomplete orchid links to the shared Coming Soon page.
- Incomplete orchids do not generate standalone placeholder profile routes.
- The Coming Soon page preserves the current site's layout and visual style.
- The production Astro build and focused rendered-link checks pass.
- The session is captured without committing the changes.

## Summary

Used the existing plant `draft` field to distinguish complete profiles from
incomplete entries. The Orchid Rescue index now sends draft entries to a shared
Coming Soon route and derives complete-profile URLs from Astro collection IDs.
The dynamic route excludes draft plants, so incomplete placeholder pages are no
longer emitted.

## Accomplishments

- Marked the seven incomplete Orchid Rescue content entries as drafts.
- Added a shared `/orchid-rescue/coming-soon/` page using the existing layout
  and page spacing.
- Updated the Orchid Rescue index to route by draft state.
- Fixed the existing index link bug that used unavailable `orchid.slug` data,
  producing `/orchid-rescue/undefined/` links for complete profiles.
- Limited dynamic Orchid Rescue profile generation to non-draft orchids.

## Impact

Orchid names now lead to an intentional destination: complete rescue journals
open their real profiles, while upcoming journals share a clear holding page.
The draft flag remains the single source of truth, so publishing a future
profile only requires changing its content state through the established plant
workflow.

## Validation

- Astro production build: passed; 101 pages generated.
- Generated routes: only Coming Soon, Doctor Robert, Helter Skelter, and the
  Orchid Rescue index were emitted under `/orchid-rescue/`.
- Rendered-link assertion: passed for two complete profile links and seven
  shared Coming Soon links.
- Draft-route absence assertion: passed for all seven incomplete orchids.
- `git diff --check`: passed.

## Lessons Learned

Astro's glob content loader exposes the source filename through `id`, not
`slug`. Focused assertions against generated HTML caught the previously
rendered `/orchid-rescue/undefined/` links even though the site build itself
succeeded.

## Next Steps

- Publish Bungalow Bill through `abbey plant publish bungalow-bill` when Brad
  decides its completed canonical workspace is ready for a public profile.
- Move each remaining orchid through the canonical Plant Model workflow before
  clearing its draft state.

## Notes

No commit or production publication was performed.
