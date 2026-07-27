---
title: "Abbey Status Planning Fallthrough Fix"
description: "Prevented the Planning status check from stopping abbey status when NEXT.md has no open task."
date: 2026-07-26
status: complete
reviewed: true
session: abbey-status-planning-fallthrough-fix
tags:
  - Abbey Root
  - Developer Toolkit
  - Regression Fix
---

# Abbey Status Planning Fallthrough Fix

## Objective

Allow `abbey status` to continue through all checks when the current `NEXT.md`
contains no unchecked task.

## Definition of Done

- The Planning check treats an absent open task as an informational state.
- `abbey status` continues to later checks, including Project Metrics.
- Regression coverage reproduces the failure under strict shell settings.
- Existing focused status, documentation, and backlog checks pass.

## Summary

Made the optional open-task lookup failure-tolerant. Added an integration-style
status regression that sources Planning and Project Metrics in their real order
with strict error handling enabled.

## Accomplishments

- Preserved the existing warning when `NEXT.md` has no open task.
- Prevented the unsuccessful optional search from terminating `abbey status`.
- Extended status regression coverage from nine to eleven passing checks.

## Impact

Completed planning files no longer hide subsequent status sections. Project
Metrics and future numbered checks remain visible even when no next-session task
has been selected.

## Validation

- `tests/test-abbey-status.sh` — 11 passed.
- Shell syntax checks for the changed check and regression suite.
- `abbey docs check`.
- `abbey backlog check`.
- `git diff --check`.

## Lessons Learned

Strict shell behavior propagates into sourced check files. Optional searches
must explicitly tolerate a no-match result when that result represents valid
project state.

## Next Steps

- Consider extending full-sequence coverage as additional status checks are
  added.

## Notes

This fixes the early exit observed on `ubuntu-dev01` after the initial project
metrics change was merged.
