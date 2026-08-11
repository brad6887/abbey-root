---
title: "Generated Documentation Index"
description: "Added a deterministic, project-aware documentation index to the existing Abbey docs generation and freshness workflow."
date: 2026-08-10
status: complete
reviewed: true
session: generated-documentation-index
tags:
  - Abbey Root
---

# Generated Documentation Index

## Objective

Generate one canonical index of durable project documentation through the
existing `abbey docs generate` and `abbey docs check` lifecycle without
replacing the human-oriented documentation guide or adding another subcommand.

## Definition of Done

- Durable Markdown documents under `docs/` are discovered recursively.
- Session updates and research collections are excluded at any depth.
- Titles come from the first H1 with a deterministic filename fallback.
- Categories, entries, and relative links are stable and deterministic.
- The generated index never indexes itself.
- `abbey docs check` detects a missing or stale index without modifying files.
- Repeated generation is idempotent.
- Initialized external projects generate their own index through the shared
  toolkit implementation.
- Focused documentation and portability regression suites pass.

## Summary

Added `docs/generated/DOCUMENTATION_INDEX.md` as a third output owned by the
bounded Abbey docs workflow. A small project-aware generator discovers durable
documents, extracts titles, groups them by stable top-level categories, and
writes relative Markdown links. Overlay inputs let freshness checks model the
new CLI and command references in temporary files, preserving read-only check
behavior even when generated outputs are missing or stale.

## Accomplishments

- Added deterministic recursive document discovery and title extraction.
- Added stable category ordering, alphabetical entry ordering, link encoding,
  fallback titles, and self-exclusion.
- Excluded session updates and research artifacts at any directory depth.
- Integrated index generation and freshness detection into `abbey docs`.
- Expanded fixtures for generated output, help, links, title fallback,
  exclusions, self-exclusion, freshness, idempotence, and external projects.
- Documented the generated index in the documentation guide and durable project
  capabilities.
- Completed the bounded documentation-index backlog item.

## Impact

New durable documentation now appears automatically after `abbey docs generate`,
and removal or title changes are reflected without editing a second navigation
file. The human-curated `docs/README.md` remains the orientation and reading
guide, while the generated index provides complete navigational discovery for
the bounded durable-document scope.

## Validation

- `tests/test-abbey-docs.sh`: 34 passed, 0 failed.
- `tests/test-abbey-portability.sh`: 30 passed, 0 failed.
- `abbey docs generate` completed all three deterministic outputs.
- `abbey docs check` reported every managed output current.
- Nested research and session-update paths are absent from the generated index.
- Python and shell syntax checks passed.
- `git diff --check` passed.

## Lessons Learned

The repository did not contain evidence of a frequently hand-maintained file
index, so the AI recommendation overstated the measured recurring time savings.
The backlog direction was still sound once framed as a deterministic discovery
capability rather than a replacement for `docs/README.md`.

Generated-output freshness needs to model the result of the complete generation
pipeline. Overlaying temporary upstream outputs into index discovery avoids
mutating tracked files during `abbey docs check` and correctly handles missing
managed documents.

## Next Steps

- Validate the index through normal navigation and refine scope only when real
  usage demonstrates a missing durable document class.
- Evaluate the separate ADR and framework-index backlog items after the general
  index has been used; avoid duplicate generated navigation without evidence.

## Notes

This session completes only the general documentation-index backlog item. It
does not create a separate `abbey docs index` command, index session history or
research artifacts, replace the documentation guide, or claim completion of
ADR- and framework-specific index ideas. No commit was created.
