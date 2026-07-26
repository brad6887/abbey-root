---
title: "Plant Validate Regression Coverage"
description: "Added focused regression coverage for every current abbey plant validate rule."
date: 2026-07-26
status: complete
reviewed: false
session: plant-validate-regression-coverage
tags:
  - Abbey Root
  - Abbey Framework
  - Developer Toolkit
  - Testing
---

# Plant Validate Regression Coverage

## Objective

Add focused regression coverage for every validation rule currently exercised
by `abbey plant validate`.

## Definition of Done

- Argument and workspace structure failures are covered.
- YAML parsing, mapping, and read failures are covered.
- Required and optional facts fields are covered.
- Slug and photo-reference validation are covered.
- Missing dependency and validator execution failures are covered.
- Warning-only and fully valid workspaces are covered.
- Relevant and practical broader regression checks pass.
- The accepted backlog item and project status are updated.

## Summary

Added an isolated shell regression suite for `abbey plant validate`. The suite
constructs temporary plant workspaces and exercises every current validation
branch without relying on canonical plant content or modifying production code.

## Accomplishments

- Covered missing slug and plant-directory behavior.
- Covered all five required files and both required directories.
- Covered invalid, unreadable, and non-mapping `facts.yaml` inputs.
- Covered all four required fields and all four optional fields.
- Covered matching and mismatched slugs.
- Covered set, unset, existing, and missing hero and current photo references.
- Covered missing PyYAML and unexpected validator execution failure handling.
- Covered warning-only and zero-warning success behavior.
- Kept production code unchanged because the tests exposed no implementation
  defects.

## Impact

Future changes to the Plant Model validator can now be checked against its
complete current behavior in one isolated, repeatable test suite.

## Validation

- `tests/test-abbey-plant.sh`: 58 assertions passed.
- Shell syntax validation for the new regression suite.
- Existing shell suites passed for backlog, doctor Git, doctor platform,
  journal, session review, session update, site, and SSH.
- The existing AI, knowledge, next, and research shell suites retain unrelated
  macOS portability failures involving BSD `sed`, unavailable Bash `mapfile`,
  and fixture behavior.
- Two standalone Python suites passed; the voice-corpus suite requires a newer
  Python than the available Python 3.7 because it uses built-in generic type
  annotations.
- Backlog generated-statistics freshness check.
- `git diff --check`
- `abbey review`

## Lessons Learned

Testing command-line validators through temporary `ABBEY_ROOT` workspaces keeps
canonical content out of the fixture contract. Small Python shims also make
otherwise environment-dependent dependency and execution failures deterministic.

## Next Steps

- Consider shared validator test helpers only after another model validator
  demonstrates the same fixture patterns.

## Notes

No production-code change was required.
