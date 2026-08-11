---
title: "Canonical Repository Validation"
description: "Added a canonical, project-aware repository consistency validation workflow with focused regression coverage."
date: 2026-08-10
status: complete
reviewed: true
session: canonical-repository-validation
tags:
  - Abbey Root
---

# Canonical Repository Validation

## Objective

Implement one canonical, read-only `abbey validate` workflow that detects
repository consistency defects in Abbey Root and initialized external Abbey
projects without expanding into unrelated toolkit-wide standardization.

## Definition of Done

- `abbey validate` resolves and reports the active project.
- Project metadata, required identity, configured directories, planning files,
  the canonical `NEXT.md` contract, Git presence, and whitespace are checked.
- Abbey Root additionally verifies agreement among CLI metadata, dispatcher
  routes, command implementations, and generated command documentation.
- Failures are deterministic, actionable, and produce a nonzero exit status.
- The command works for initialized external projects and nested invocation
  through the shared dispatcher.
- Focused and related regression suites pass.

## Summary

Added the framework-level `abbey validate` command and registered it in the
metadata-driven CLI. The validator applies portable project checks to every
Abbey project and adds toolkit consistency checks only when Abbey Root is the
active project. The CLI standard now documents this contract, generated CLI
documentation is current, and the two completed backlog items reflect the
implemented behavior.

## Accomplishments

- Added a project-aware validation wrapper and deterministic Python validator.
- Validated required metadata, configured path containment and existence,
  planning-document presence, the six-section `NEXT.md` contract, Git
  repository presence, and whitespace consistency.
- Added Abbey Root checks for registered command dispatch, command
  implementations, and generated command-document freshness.
- Added external-project fixtures covering success, invalid planning state,
  actionable diagnostics, exit status, and argument handling.
- Documented the canonical workflow and regenerated the CLI reference.
- Marked canonical project validation and repository consistency checks
  complete in the backlog.

## Impact

Abbey now has one supported validation entry point that makes structural drift
visible before capture or commit. External projects receive only project-owned
checks, while Abbey Root also protects the shared toolkit’s metadata-driven
command architecture from silent divergence.

## Validation

- `tests/test-abbey-validate.sh`: 9 passed, 0 failed.
- `tests/test-abbey-docs.sh`: 23 passed, 0 failed.
- `tests/test-abbey-cli-context.sh`: 12 passed, 0 failed.
- `tests/test-abbey-init.sh`: 43 passed, 0 failed.
- `tests/test-abbey-portability.sh`: 29 passed, 0 failed.
- `abbey validate`: repository consistency checks passed.
- Shell syntax, Python compilation, and `git diff --check` passed.

## Lessons Learned

Backlog proximity is not evidence of implementation coupling. Repository
validation is a bounded command contract; tree rendering, presentation style,
artifact reporting, and an all-tool test runner affect different commands and
need separate inventories and acceptance criteria.

Reusing Abbey’s existing `NEXT.md` contract avoided creating a second planning
schema inside the validator. Toolkit-specific checks remain conditional so the
shared implementation does not impose Abbey Root’s internal structure on
external projects.

## Next Steps

- Consider `abbey-tree` as a separate navigation and visualization session.
- Inventory repeated output patterns before defining shared formatting or
  color helpers.
- Inventory artifact-producing commands before standardizing their result
  contract.
- Design a bounded test-runner policy separately from individual regression
  coverage, including dependency-heavy and environment-specific suites.

## Notes

The original AI recommendation grouped five adjacent Developer Toolkit backlog
items. This session accepted repository consistency validation and its focused
tests, but intentionally excluded `abbey-tree`, toolkit-wide output/colors,
artifact-output normalization, and a global regression runner as separate
outcomes. No commit was created.
