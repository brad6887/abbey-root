---
title: "Project-Aware Image Configuration"
description: "Migrated Abbey image selection to validated, fail-closed active-project configuration with explicit toolkit fallback."
date: 2026-08-08
status: complete
reviewed: false
session: project-aware-image-configuration
tags:
  - Abbey Root
---

# Project-Aware Image Configuration

## Objective

Make `abbey image` consume the shared project-context foundation so one Abbey
project cannot silently use another project's image roles.

## Definition of Done

- Validate the active project's `.abbey/project.yml` before image selection.
- Prefer the active project's `.abbey/image-roles.yml`.
- Fail closed when local image-role configuration is absent.
- Use toolkit image roles only after explicit project opt-in.
- Report resolved project, configuration, image source, and metadata target
  before any metadata mutation.
- Prove project isolation and explicit fallback through regression tests.
- Preserve existing interactive, non-interactive, and plant-wrapper behavior.

## Summary

Hardened the existing portable image selector around the shared Session 1
project contract. The selector now validates project identity, applies a
default-deny configuration policy, and displays its resolved context before
selection. Cross-project tests prove a project without local roles does not
inherit Abbey Root's roles, while a separate fixture proves explicit toolkit
fallback remains available.

## Accomplishments

- Added strict active-project validation through the shared project resolver.
- Added local-first image-role configuration resolution.
- Added explicit `configuration.allow_toolkit_defaults: true` handling.
- Added actionable missing-configuration and disabled-fallback errors.
- Added preflight reporting for project root, toolkit root, configuration path
  and source, image source, metadata target, entity, item, role, and current
  value.
- Preserved interactive standard input while retaining the embedded Python
  selection engine.
- Expanded the image suite with project isolation, explicit fallback,
  malformed project metadata, preflight, and normalized-path coverage.
- Updated the Project Standard, project status, CLI metadata, and generated
  CLI reference.

## Impact

Image selection now follows the same toolkit-versus-project boundary as the
shared project context. Bread Pitt-style projects cannot accidentally use
Abbey Root's plant roles, and operators can verify all important paths before
confirming a change.

## Validation

- `tests/test-abbey-image.sh`: 70 passed, 0 failed.
- `tests/test-abbey-portability.sh`: 29 passed, 0 failed.
- `tests/test-abbey-project.sh`: 14 passed, 0 failed.
- `tests/test-abbey-plant.sh`: all 88 validation assertions passed before the
  publishing section stopped because ImageMagick is not installed in this
  environment.
- Shell syntax validation passed for the image command and test suite.
- `abbey docs generate`: passed.
- `abbey docs check`: passed.
- `git diff --check`: passed.

## Lessons Learned

- Reading `$ABBEY_ROOT` is insufficient by itself when a command can be invoked
  directly; project metadata must also be validated.
- The absence of fallback configuration is an important safety control and
  deserves direct regression coverage.
- Preflight output makes path resolution reviewable without adding a separate
  dry-run concept to an already confirm-before-write selector.
- An embedded Python program must not consume standard input when the workflow
  also uses standard input for interactive selection.

## Next Steps

- Generalize the proven `rename-exports` workflow into project-aware
  `abbey media` tooling.
- Revisit the plant publishing suite in an environment with ImageMagick when
  broader end-to-end publication validation is needed.

## Notes

No commit, push, image selection in a real workspace, site publication, or
infrastructure change was performed. The existing Python-version warning in
recurring-review evaluation remains outside this session.
