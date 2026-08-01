---
title: "Project-Aware External Session Certification"
description: "Made final Abbey certification honor external project policy and capabilities."
date: 2026-07-29
status: complete
reviewed: true
session: project-aware-external-session-certification
tags:
  - Abbey Root
---

# Project-Aware External Session Certification

## Objective

Make final session certification project-aware for external Abbey projects.

## Definition of Done

- `abbey end` reads `workflow.journal.policy`.
- Journals are required only when the policy is `required`.
- `event-driven` and `optional` policies pass without a journal.
- `abbey doctor` skips infrastructure and internal-DNS checks unless the active
  project declares those capabilities.
- Git identity inherited from global configuration is recognized correctly.
- Regression tests cover Bread Pitt as an external project.
- Running `abbey doctor` and `abbey end` from Bread Pitt succeeds.

## Summary

Final certification now follows project-owned metadata. External projects can
finish ordinary sessions without adopting Abbey Root's infrastructure, DNS, or
journal requirements.

## Accomplishments

- Loaded the active project's journal policy in `abbey end`.
- Preserved the required-policy exception for reconciliation-only commits.
- Split internal DNS into an explicit project capability.
- Added `internal_dns: false` to newly initialized external projects.
- Added inherited global Git identity regression coverage.
- Extended the Bread Pitt initialization fixture through a committed external
  session and successful Doctor and End runs.
- Updated the project standard and session workflow guidance.

## Impact

Abbey's shared toolkit now applies common certification logic without assuming
that every consuming project owns Abbey Root's operational environment or
publishing policy.

## Validation

- `tests/test-abbey-end.sh` — 17 passed.
- `tests/test-abbey-doctor-git.sh` — 10 passed.
- `tests/test-abbey-init.sh` — 37 passed, including Bread Pitt certification.
- `tests/test-abbey-portability.sh` — 29 passed.
- All remaining shell regression suites passed.
- `tests/test-abbey-next.sh` — 39 passed with Python 3.13; the macOS system
  Python 3.7 cannot run that existing suite because it uses `str.removeprefix`.
- `git diff --check` passed.

## Lessons Learned

Capabilities that represent distinct external dependencies should be declared
independently. Treating internal DNS as merely part of infrastructure would
still allow an infrastructure-owning external project to inherit a DNS check it
never requested.

## Next Steps

- Use Bread Pitt as the reference external-project certification fixture when
  adding future final-session checks.

## Notes

The default behavior remains compatible with Abbey Root and legacy projects
without `.abbey/project.yml`: infrastructure, internal DNS, and required journal
certification remain enabled.
