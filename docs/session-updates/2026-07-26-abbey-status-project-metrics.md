---
title: "Abbey Status Project Metrics"
description: "Added deterministic local project metrics to abbey status with safe missing-source behavior and regression coverage."
date: 2026-07-26
status: complete
reviewed: false
session: abbey-status-project-metrics
tags:
  - Abbey Root
  - Developer Toolkit
  - Project Metrics
---

# Abbey Status Project Metrics

## Objective

Add a bounded set of deterministic, locally derived project metrics to
`abbey status`.

## Definition of Done

- `abbey status` reports toolkit command, website page, journal entry, and
  documentation file counts.
- Every metric has an explicit repository source and file-selection rule.
- Missing source directories report an unavailable value without stopping the
  remaining status checks.
- Focused regression tests cover expected counts and missing-source behavior.
- CLI metadata and generated documentation are current.
- Planning documents record the completed capability without claiming broader
  future metrics are implemented.

## Summary

Added a modular Project Metrics status check that counts four repository-owned
artifact types without network access or external services. The check follows
the existing `tools/status/checks` architecture and remains informational when
one or more metric sources are absent.

## Accomplishments

- Counted executable `abbey-*` wrappers in `tools/bin` as toolkit commands.
- Counted Astro files under `site/src/pages` as website pages.
- Counted Markdown files under `content/journal` as journal entries.
- Counted Markdown files under `docs` as documentation files.
- Added regression coverage for filtering rules and safe missing-directory
  behavior.
- Updated CLI metadata, regenerated the CLI reference, and reconciled planning
  status.

## Impact

Abbey now provides a quick, repeatable view of repository growth from sources
already maintained by the project. The implementation establishes a small
metrics pattern that can be extended later without introducing network
dependencies or a competing metrics document.

## Validation

- `tests/test-abbey-status.sh`
- `abbey docs generate`
- `abbey docs check`
- `git diff --check`
- `abbey backlog check`

## Lessons Learned

The existing numbered status-check architecture already supplied the extension
point. A separate collector module would have added indirection without
improving reuse at this scope.

Metric names need precise definitions. Counting route source files is
deterministic and useful, but it is intentionally described as website pages
rather than deployed URLs.

## Next Steps

- Evaluate these four metrics through normal use before adding infrastructure,
  planning-summary, or AI-evaluation metrics.

## Notes

The broader Self-Documenting Platform backlog item for generated project
metrics remains open because this session implements only the first bounded
status view.
