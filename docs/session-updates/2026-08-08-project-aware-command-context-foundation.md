---
title: "Project-Aware Command Context Foundation"
description: "Established one fail-closed project-context contract and diagnostic command for reusable Abbey workflows."
date: 2026-08-08
status: complete
reviewed: false
session: project-aware-command-context-foundation
tags:
  - Abbey Root
---

# Project-Aware Command Context Foundation

## Objective

Establish the shared project-resolution foundation required to make Abbey
commands reusable across unrelated projects without inheriting Abbey Root
configuration.

## Definition of Done

- `.abbey/project.yml` is the canonical project marker.
- Project discovery works from project roots and nested directories.
- An explicit project root can be selected for diagnostics.
- Toolkit and active-project roots remain separate.
- Malformed project metadata and unsafe configuration paths fail closed.
- Toolkit configuration defaults require explicit project permission.
- `abbey project show` reports the resolved context.
- New projects adopt the default-deny configuration policy.
- Focused and portability regression tests pass.

## Summary

Added a common project-discovery and safe-path layer, exposed it through
`abbey project show`, and documented the runtime contract. New Abbey projects
now explicitly disable toolkit configuration defaults. Focused tests prove
nested discovery, explicit selection, configuration containment, malformed
metadata handling, and missing-project behavior.

## Accomplishments

- Added reusable upward project discovery and project-relative path validation
  to `tools/lib/project.sh`.
- Replaced duplicate dispatcher discovery logic with the shared library.
- Added `scripts/abbey_project.py` for strict metadata validation and context
  reporting.
- Added the `abbey project show [--project PATH] [--config PATH]` command.
- Registered the command in the canonical CLI metadata and regenerated the CLI
  reference.
- Added `configuration.allow_toolkit_defaults: false` to Abbey Root and the
  default `abbey init` project metadata.
- Documented the project marker, root responsibilities, configuration policy,
  and path-containment rules.
- Added a focused project-context regression suite and canonicalized macOS
  temporary paths in existing portability assertions.

## Impact

Abbey now has one explicit context contract that image, media, site, and other
project-aware commands can adopt. Diagnostic output makes configuration
resolution reviewable before mutating work, while default-deny behavior
prevents future commands from silently borrowing toolkit configuration.

## Validation

- `bash -n` passed for the dispatcher, project wrapper, shared library, and
  focused test suite.
- Python compilation passed for the project resolver and initializer.
- `tests/test-abbey-project.sh`: 14 passed, 0 failed.
- `tests/test-abbey-init.sh`: 43 passed, 0 failed.
- `tests/test-abbey-portability.sh`: 29 passed, 0 failed.
- `tests/test-abbey-cli-context.sh`: 12 passed, 0 failed.
- `abbey docs generate`: passed.
- `abbey docs check`: passed.
- `git diff --check`: passed.

## Lessons Learned

- The repository already separated toolkit and project roots, so the right
  first step was consolidating proven behavior rather than replacing it.
- Project discovery and project metadata validation are related but distinct:
  discovery locates a marker, while strict consumers validate its contents.
- Canonical path reporting removes macOS `/var` versus `/private/var`
  ambiguity and requires tests to compare normalized paths.
- Default-deny policy belongs in generated project metadata so every new
  project states its intent explicitly.

## Next Steps

- Migrate `abbey image` to the shared project context and require a local
  `.abbey/image-roles.yml` unless the project explicitly permits a toolkit
  default.
- Extend project-context preflight reporting as additional mutating commands
  adopt the shared contract.

## Notes

No commit, push, site publication, or infrastructure change was performed.
The session command also surfaced the existing Python-version incompatibility
in `abbey_review_recurring.py`; that unrelated issue remains outside this
session.
