---
title: "Abbey Init Default Project Bootstrap"
description: "Implemented and validated the first safe default Abbey project bootstrap."
date: 2026-07-26
status: complete
reviewed: true
session: abbey-init-default-project-bootstrap
tags:
  - Abbey Root
---

# Abbey Init Default Project Bootstrap

## Objective

Create a safe, default `abbey init PATH` bootstrap that generates a minimal
Abbey project, initializes Git unless disabled, supports dry runs, refuses
unsafe destinations, reports created files, validates the result, and keeps
framework code shared.

## Definition of Done

- One default project template generates metadata and minimal workflow files.
- Git initializes on `main` unless `--no-git` is selected.
- `--dry-run` remains read-only.
- Nonempty destinations and existing projects are not overwritten.
- No commit, remote, framework copy, or Bread Pitt domain model is created.
- Core project-aware commands operate from the generated repository.
- Focused regressions and a real temporary Bread Pitt initialization pass.

## Summary

Added the first usable Abbey project initializer and separated the installed
toolkit location from the active project location. Generated projects now carry
only project identity, planning, session guidance, and empty workflow
directories; shared commands continue to run from the Abbey installation.

## Accomplishments

- Registered `abbey init` in the dispatcher and CLI metadata.
- Added project-root discovery through `.abbey/project.yml`.
- Added deterministic generation, destination safety, rollback, dry-run,
  optional Git initialization, validation, and created-file reporting.
- Made version, doctor, status, session, and session context project-aware.
- Corrected portable session-context timestamps and Git untracked-file health
  detection uncovered during acceptance testing.
- Added 13 focused initializer regressions.
- Regenerated the authoritative CLI reference.

## Impact

Abbey can now bootstrap an independent repository without copying Abbey Root
implementation code. Bread Pitt proved the default project boundary while
remaining free of premature sourdough-specific structure.

## Validation

- Shell syntax checks passed for changed shell commands and tests.
- Python compilation passed for the initializer and CLI metadata renderer.
- `tests/test-abbey-init.sh`: 13 passed, 0 failed.
- `tests/test-abbey-status.sh`: 11 passed, 0 failed.
- `tests/test-abbey-doctor-git.sh`: 6 passed, 0 failed.
- `tests/test-abbey-session-update.sh`: 26 passed, 0 failed.
- `tests/test-abbey-session-metadata.sh`: 9 passed, 0 failed.
- `tests/test-abbey-docs.sh`: 23 passed, 0 failed.
- A real temporary Bread Pitt repository successfully ran `abbey version`,
  `abbey doctor`, `abbey status`, `abbey session context`, and `abbey session`.
- `git diff --check` passed.

## Lessons Learned

Project-aware dispatch requires two roots: the installed toolkit root and the
active repository root. Keeping those concepts explicit avoids copying command
implementations and exposes optional Abbey Root features as warnings rather
than bootstrap requirements.

## Next Steps

- Reconcile broader planning documentation in a separate review step if the
  completed bootstrap changes current priorities.
- Review the session and commit when ready.
- Begin Bread Pitt domain modeling in its own first project session.

## Notes

No commit, push, Git remote, project type, adoption workflow, upgrade workflow,
or Bread Pitt-specific domain model was created.
