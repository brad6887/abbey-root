---
title: "Project-Aware Site Artifact Validation"
description: "Connected project-owned media provenance and route requirements to a read-only site publication gate."
date: 2026-08-08
draft: false
tags:
  - Abbey Root
---

# Project-Aware Site Artifact Validation

## Summary

Session 5 completed the portability path exposed by Bread Pitt. Abbey site
workflows now have an explicit, project-aware validation boundary between
generated media and deployment.

## Accomplishments

- Added `abbey site validate`.
- Verified publication-manifest ownership, safe destinations, file hashes,
  image facts, and privacy and source-integrity results.
- Verified project-configured generated routes.
- Integrated the validation gate into site build and publish.
- Added Bread Pitt-style success coverage plus stale and cross-project failure
  coverage.
- Captured the configuration contract in the Abbey Project Standard.

## Lessons Learned

- A project-relative path alone is not enough to prove artifact ownership; the
  manifest must also identify the active project.
- Media publication provenance is most useful when independently rechecked at
  the site boundary.
- Required routes must remain project configuration because Abbey sites may
  use different content models and URL structures.

## Next Steps

- Configure Bread Pitt's real manifest and route list when its media workflow
  moves from the portability fixture into that repository.
- Run the real Abbey Root Astro build in an environment with its npm
  dependencies installed.
