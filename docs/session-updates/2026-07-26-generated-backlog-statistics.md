---
title: "Generated Backlog Statistics"
description: "Added deterministic backlog completion statistics and integrated freshness checks into the Abbey session workflow."
date: 2026-07-26
status: complete
reviewed: false
session: generated-backlog-statistics
tags:
  - Abbey Root
  - Abbey Framework
  - Developer Toolkit
  - Planning
---

# Generated Backlog Statistics

## Objective

Add deterministic complete, pending, and total counts to the top of the Abbey
Root backlog without making the generated summary a competing source of truth.

## Definition of Done

- `abbey backlog refresh` derives counts from the backlog's Markdown task-list
  conventions.
- The command updates only a clearly bounded generated block.
- Refresh is deterministic and idempotent.
- Missing blocks are inserted, while malformed or duplicate markers fail
  without modifying the backlog.
- `abbey review` reports stale statistics before commit.
- `abbey end` certifies current statistics without violating its read-only,
  post-commit role.
- CLI metadata, generated reference documentation, planning documentation, and
  regression tests are synchronized.

## Summary

Implemented `abbey backlog refresh` and its read-only companion,
`abbey backlog check`. The generated block reports complete, pending, and total
checkbox counts while leaving all human-maintained backlog content untouched.

Integrated the check into both workflow boundaries: `abbey review` warns and
points to the refresh command before commit, while `abbey end` treats stale or
malformed statistics as a certification failure after commit. This preserves
`abbey end` as a read-only command.

## Accomplishments

- Added the `abbey backlog` command group and CLI metadata.
- Added bounded generated status markers at the top of `BACKLOG.md`.
- Counted checked and unchecked Markdown task-list items, including nested
  backlog entries.
- Added safe missing, malformed, duplicate, stale, and idempotent behavior.
- Added review-time warning and end-of-session certification checks.
- Documented the generated block in the planning schema.
- Added focused shell regression coverage.

## Impact

The backlog now exposes an immediately useful inventory summary derived from
the entries themselves. Both normal review and final session certification can
detect drift without duplicating the counting logic or silently changing
planning documents.

## Validation

- `tests/test-abbey-backlog.sh`
- Shell syntax checks for the dispatcher and affected commands.
- CLI metadata parsing and reference generation.
- Existing focused Abbey workflow regression suites.
- `git diff --check`
- `abbey backlog check`
- `abbey review`
- `tests/test-abbey-next.sh`: blocked by the repository's documented pre-existing
  macOS `sed` and `mapfile` portability failures.

## Lessons Learned

The current Abbey workflow places `abbey end` after the final commit and
requires a clean working tree. Refreshing the backlog from that command would
contradict its certification role, so the reusable command performs mutation
and the workflow commands consume its read-only check.

Passing a multiline generated block through `awk -v` is not portable to the
macOS `awk` implementation. Rendering the three bounded lines individually
keeps the command portable and the output deterministic.

## Next Steps

- Evaluate the generated status and workflow messages through normal Abbey
  sessions before generalizing this into broader planning refresh automation.

## Notes

No commit was created during implementation.
