---
title: "Project-Aware Media Export Renaming"
description: "Generalized plant export renaming into project-aware Abbey media tooling with transactional manifests."
date: 2026-08-08
status: complete
reviewed: true
session: project-aware-media-export-renaming
tags:
  - Abbey Root
---

# Project-Aware Media Export Renaming

## Objective

Generalize the proven plant photo export workflow into reusable,
project-configured media tooling for plant, Bread Pitt, and future Abbey
projects.

## Definition of Done

- Add `abbey media rename-exports <directory> [--dry-run]`.
- Resolve behavior from the active project's `.abbey/media.yml`.
- Fail closed when local media configuration is absent.
- Permit toolkit defaults only through explicit project opt-in.
- Preserve image/XMP pairing and full-batch validation.
- Generate deterministic caption-derived filenames and sequence suffixes.
- Write an original-to-published rename manifest after success.
- Roll back filenames if renaming or manifest creation fails.
- Preserve `abbey plant rename-exports` as a compatibility wrapper.
- Validate plant and Bread Pitt-style fixtures.

## Summary

Promoted the caption-and-capture-date rename workflow into the generic Abbey
media command. Projects now own supported extensions, metadata tags, filename
format, and manifest name through `.abbey/media.yml`. The plant interface
delegates to the shared command, while a Bread Pitt-style fixture proves the
implementation is no longer plant-specific.

## Accomplishments

- Added the tracked Abbey Root `.abbey/media.yml` configuration.
- Added the `abbey media` dispatcher and CLI metadata.
- Added a reusable Python rename engine with configuration validation.
- Preserved deterministic grouping by caption slug and capture date.
- Preserved chronological sequence assignment and AppleDouble filtering.
- Preserved complete validation before any file changes and staged two-phase
  renaming with rollback.
- Added an atomic JSON manifest containing project, configuration, captions,
  capture data, and original-to-published image and sidecar names.
- Extended rollback across manifest creation so a manifest failure restores
  original filenames.
- Kept the plant command as a compatibility wrapper with a fallback for
  partial older toolkit installations.
- Added Bread Pitt-style, isolation, explicit-fallback, dry-run, manifest, and
  manifest-failure regression coverage.
- Updated the Project Standard, project status, CLI reference, and ignore
  policy for tracked media configuration.

## Impact

Caption-driven export preparation is now a reusable Abbey capability rather
than plant-domain logic. Bread photography, documentation screenshots, plant
photos, and future gallery workflows can share one validated pipeline while
retaining project-owned policy and a reviewable publishing manifest.

## Validation

- `tests/test-abbey-media.sh`: 22 passed, 0 failed.
- `tests/test-abbey-plant-rename-exports.sh`: 24 passed, 0 failed.
- `tests/test-abbey-portability.sh`: 29 passed, 0 failed.
- `tests/test-abbey-project.sh`: 14 passed, 0 failed.
- `tests/test-abbey-cli-context.sh`: 12 passed, 0 failed.
- Shell syntax validation passed for dispatchers, wrappers, and tests.
- Python compilation passed for the generic rename engine.
- `abbey docs check`: passed.
- `git diff --check`: passed.

## Lessons Learned

- The stable abstraction was metadata-driven pairing and staged renaming, not
  the original plant vocabulary.
- Import directories must be allowed outside the project because real exports
  commonly arrive in temporary or home-directory locations; configuration
  still belongs to the active project.
- A generated manifest is part of the operation's integrity. Failure to write
  it must roll the file rename back rather than leave an undocumented result.
- Compatibility wrappers make domain workflows discoverable without creating
  a second implementation.

## Next Steps

- Use the generic media manifest as an input when a higher-level image
  derivative publishing wrapper is implemented.
- Remove the plant command's legacy partial-install fallback after normal
  installations and external projects have adopted `abbey media`.

## Notes

No real media directory was renamed, and no commit, push, publication, or
infrastructure change was performed. Test fixtures used a controlled ExifTool
stub and temporary directories.
