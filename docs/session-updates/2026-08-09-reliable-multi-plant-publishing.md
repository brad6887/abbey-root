---
title: "Reliable Multi-Plant Publishing"
description: "Made multi-plant publication serialized, transactional, cache-aware, and reliable in non-interactive Abbey sessions."
date: 2026-08-09
status: complete
reviewed: true
session: reliable-multi-plant-publishing
tags:
  - Abbey Root
  - BradCooke.com
  - Orchid Rescue
  - Plant Model
---

# Reliable Multi-Plant Publishing

## Objective

Repair the workflow failures exposed by the August 9 orchid mass update so future weekly batches publish safely, build reliably, and display the newest photographs immediately.

## Definition of Done

- A supported command publishes several plants serially and stops on failure.
- Publication stages each plant independently and never deletes unrelated public artifacts.
- Overlapping publication of the same plant is rejected.
- Failed derivative generation preserves the previously published page and images.
- Published image URLs change when image content changes.
- PNG derivatives are deterministic across repeated publication.
- Site commands discover npm from NVM in non-interactive sessions.
- Regression tests, the real eleven-plant workflow, the site build, and the runbook are complete.

## Summary

Added `abbey plant publish-batch` as the supported multi-plant publication path. It invokes one isolated publication process per slug, reports serialized progress, and stops on the first failure.

Individual publication now builds content, manifests, and derivatives in a unique staging directory before committing them. Cleanup is manifest-owned instead of deleting the whole public plant directory, preserving proof images and other unrelated artifacts. A per-plant lock prevents overlapping publication of the same orchid.

Every published role and history image URL now includes the first twelve characters of its derivative SHA-256 hash. The image helper omits generated PNG timestamp chunks, making unchanged publication deterministic and keeping those cache keys stable.

Site build, start, and publish commands now discover npm from a standard NVM installation when it is absent from `PATH`, resolving non-interactive SSH builds.

## Accomplishments

- Added serialized multi-plant publication with explicit progress and completion output.
- Added unique per-plant staging and atomic replacement of generated artifacts.
- Limited cleanup to derivatives recorded by the prior publication manifest.
- Added a per-plant publication lock.
- Added content-hash query strings to hero, current, index, and history image URLs.
- Removed nondeterministic PNG date/time chunks from public derivatives.
- Added NVM npm discovery to site build, start, and publish workflows.
- Expanded plant, public-image, and site regression coverage.
- Updated the plant website runbook to use the supported batch command and describe its guarantees.
- Republished and built all eleven orchids from the August 9 update.

## Impact

Weekly updates now have one supported publication command and a clear completion boundary. A failed or overlapping publish cannot partially replace the visible plant page, unrelated proof assets survive republishing, non-interactive builds work without hand-crafted environment setup, and browsers receive a new URL whenever a current photograph changes.

## Validation

- `tests/test-abbey-plant.sh`: 116 passed, 0 failed.
- `tests/test-abbey-public-image.sh`: 10 passed, 0 failed.
- `tests/test-abbey-site.sh`: 43 passed, 0 failed.
- Real `abbey plant publish-batch` completed for all eleven August 9 orchids.
- Repeating the complete batch produced an identical repository diff.
- All eleven generated current-image URLs contain twelve-character content versions.
- Martha My Dear's unrelated proof image remained present and unchanged.
- A real site build succeeded with a minimal `PATH` and automatically selected npm from NVM.
- Astro built 170 pages and site artifact validation passed.
- Generated Doctor Robert HTML contains the versioned current-image URL.
- `git diff --check` passed.

## Lessons Learned

Temporary output must be unique, but isolation alone does not protect two publishers targeting the same final plant. The explicit per-plant lock makes that ownership boundary visible and testable.

Content hashing only works well as a cache key when derivative generation is deterministic. PNG's generated modification-time chunk was harmless visually but changed the file hash on every run; excluding date and time chunks removed that noise.

Long-running remote commands can outlive a tool response. A first-class batch command with serialized progress and a final completion line is a safer operator boundary than coordinating a shell loop externally.

## Next Steps

- Run the normal Abbey review and end-of-session checks.
- Commit and push the workflow repair after final review.

## Notes

This session implements the dedicated serialized publisher proposed by the August 9 multi-plant update session. No production deployment was performed as part of this repair session.
