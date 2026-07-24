---
title: "The Jeep Incident Museum Exhibit"
description: "Added the Jeep Incident as the Museum of Dumb Ideas' second complete exhibit."
date: 2026-07-24
status: complete
reviewed: true
session: primary
tags:
  - Abbey Root
  - BradCooke.com
  - Museum of Dumb Ideas
journal:
  - content/journal/2026/2026-07-24-the-jeep-incident-enters-the-museum.md
---

# The Jeep Incident Museum Exhibit

## Objective

Publish “The Jeep Incident” as the Museum of Dumb Ideas' second complete
exhibit.

## Definition of Done

- A matching `MDI-0002` exhibit follows the established museum organization,
  metadata, visual style, and tone.
- Both supplied photographs are imported under meaningful filenames and
  published with accurate alt text.
- The Museum index links to the complete exhibit.
- The authoritative `IDEAS.md` entry reflects the exhibit's completion.
- The Astro site builds successfully.
- A session update and journal entry capture the work.
- Brad reviews the complete diff before it is committed and published.

## Summary

Added a complete Museum of Dumb Ideas exhibit for the Jeep Incident, an early
example of confidence exceeding experience. The exhibit follows the established
plaque style, documents Brad burying a Jeep in mud at 15, and preserves the
outside assistance required to recover it.

The session also adds a reusable artifact gallery for photographic exhibits
and updates the Museum index and the authoritative ideas entry.

## Accomplishments

- Reviewed the Museum structure and the OmeletYouFinish.com exhibit.
- Added the Jeep Incident exhibit as accession `MDI-0002`.
- Added museum plaque metadata, narrative, ratings, artifacts, and lessons.
- Updated the Museum index to link the completed exhibit.
- Added meaningful image paths, alt text, captions, and reusable gallery styles.
- Updated the existing `IDEAS.md` entry to record completion.
- Created a matching journal entry.

## Impact

The Museum now has a second complete story and a reusable presentation pattern
for exhibits with photographic artifacts.

## Validation

- Imported and visually inspected both source photographs.
- Astro production build completed successfully with 104 generated pages,
  including `/museum/the-jeep-incident/`.
- Both published image files were present in the generated site output.
- `git diff --check` completed successfully.
- `git status` and `git diff` reviewed.
- `abbey doctor` reported four unreachable home-lab hosts from the temporary
  Mac workspace; all repository and documentation checks passed.
- Brad approved the reviewed source changes.
- Source commit `567b1e1` was pushed to Abbey Root.
- Production commit `fc2f9dc` was pushed through `abbey site publish`.
- The live exhibit, journal entry, and both image URLs returned HTTP 200.

## Lessons Learned

The journal helper currently derives Brad's normal checkout path instead of the
active repository path. In this temporary Codex checkout, the helper could not
create the journal entry, so the canonical entry was created directly.

## Next Steps

- Consider extracting an exhibit component or data model only after additional
  exhibits demonstrate that the current page pattern is becoming repetitive.

## Notes

Brad reviewed and approved the complete diff before commit and publication.

The photographs were imported with content-specific filenames after visual
inspection. Alt text describes the Jeep recovery scene and Brad posing on the
stuck Jeep rather than relying on the original opaque library filenames.
