---
title: "Abbey Next Parsing and Validation"
description: "Completed canonical NEXT.md parsing, validation, and template generation while reducing the Abbey Root backlog by one item."
date: 2026-07-29
status: completed
reviewed: false
session: abbey-next-parsing-and-validation
tags:
  - Abbey Root
---

# Abbey Next Parsing and Validation

## Objective

Complete the existing `abbey next` NEXT.md parsing and validation backlog item
without adding follow-up work.

## Definition of Done

- The canonical required NEXT.md structure is documented.
- Normal Markdown heading and body formatting is parsed reliably.
- Every missing required section produces a clear error.
- `abbey next init` creates a valid template and never overwrites an existing
  NEXT.md.
- `abbey init` creates NEXT.md files that satisfy the same canonical contract.
- Abbey Next and Abbey Init regression suites pass.
- The existing parent backlog item is completed with no new backlog entries.

## Summary

Established the six-section planning schema as the executable NEXT.md contract,
updated Abbey Next to parse either body text or lower-level subheadings, added
complete missing-section validation, and introduced a guarded template command.
The session also removed the Abbey Next test suite's dependence on mutable live
planning documents so the focused validation is deterministic.

## Accomplishments

- Added required-section validation for Current Theme, Primary Objective,
  Current Priorities, Success Criteria, Future Direction, and Guiding Principle.
- Generalized section parsing across normal Markdown heading levels and body
  formats.
- Added `abbey next init` with canonical project-aware output and overwrite
  protection.
- Synchronized `abbey init`, Abbey Root's NEXT.md, CLI metadata, generated CLI
  reference, and the planning schema.
- Replaced mutable Abbey Next planning fixtures with self-contained test data.
- Added regression coverage for every required section, normal body text,
  generated templates, and overwrite refusal.
- Completed the existing backlog parent and refreshed its generated statistics
  from 93 complete / 267 pending to 94 complete / 266 pending.

## Impact

Abbey projects now receive one consistent NEXT.md contract at bootstrap and can
recover a missing file with `abbey next init`. Invalid planning files fail before
recommendation generation with actionable errors. The net backlog reduction is
one item, and this session created no new backlog entries.

## Validation

- `bash -n tools/bin/abbey-next`
- `bash -n tests/test-abbey-next.sh`
- `python3 -m py_compile scripts/abbey_init.py`
- `tests/test-abbey-next.sh` — 39 passed, 0 failed
- `tests/test-abbey-init.sh` — 25 passed, 0 failed
- `abbey docs generate`
- `abbey backlog refresh`
- Live `abbey next` recommendation generation
- `git diff --check`

## Lessons Learned

Backlog reduction must be measured at the checkable parent-item level. The
recommendation described three benefits, but the parent contained a fourth
existing template subtask; omitting it would have completed useful work without
changing the backlog count. Focused regression suites also need self-contained
fixtures because live planning documents evolve independently of their expected
scenarios.

## Next Steps

- No follow-up work is required for this backlog item.

## Notes

The pre-existing Abbey Next suite started with six failures caused by its
mutable planning fixture. That validation blocker was repaired within this
session rather than recorded as new backlog work.
