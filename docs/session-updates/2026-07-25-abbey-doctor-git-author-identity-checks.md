---
title: "Abbey Doctor Git Author Identity Checks"
description: "Added Git author identity and effective configuration source checks to Abbey Doctor."
date: 2026-07-25
status: pending
reviewed: false
session: primary
tags:
  - Abbey Root
---

# Abbey Doctor Git Author Identity Checks

## Objective

Add a small, deterministic Abbey Doctor check that detects missing Git author
identity before commit workflows fail or create incorrectly attributed commits.

## Definition of Done

- `abbey doctor` checks the effective `user.name` and `user.email`.
- Missing identity values produce failures.
- Configured identity values report their effective configuration source.
- Focused regression tests cover configured and missing identities.

## Summary

Abbey Doctor now validates both Git author identity fields as part of its
existing repository checks. Configured values and their effective Git
configuration sources are visible in normal doctor output; missing values
contribute failures to the existing health summary.

## Accomplishments

- Added `user.name` and `user.email` validation to the repository doctor check.
- Reported the effective value and source returned by Git for each configured
  identity field.
- Added isolated regression fixtures for locally configured and entirely
  missing Git identities.

## Impact

Developers receive an early, actionable failure when Git author identity is
missing, reducing commit interruption and ambiguous attribution risk without
introducing a new output mode or command path.

## Validation

- `tests/test-abbey-doctor-git.sh`
- `tests/test-abbey-doctor-platform.sh`
- Shell syntax validation for the changed check and new regression test.
- `git diff --check`
- Full Abbey Doctor integration run on the main macOS checkout reported both
  configured identity values and their local configuration sources, with no
  failures.

## Lessons Learned

Git's `--show-origin` output provides both the effective value and its source,
so the check can remain small and avoid duplicating Git's configuration
precedence rules.

## Next Steps

- Reconcile the completed Abbey Doctor Git identity backlog items during the
  next session review.

## Notes

The full integration run completed with only expected host-specific backup
warnings on macOS.
