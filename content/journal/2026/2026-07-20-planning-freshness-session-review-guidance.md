---
title: "Planning Freshness and Session Review Guidance"
description: "Improved Abbey's reconciliation guidance and defined the difference between planning documents being updated and deliberately reviewed."
date: 2026-07-20
draft: false
tags:
  - Abbey Root
  - Session Workflow
  - Planning
  - Documentation
---

# Planning Freshness and Session Review Guidance

## Summary

Improved Abbey's session-reconciliation workflow so planning documents retain accurate freshness information when Codex applies recommended changes.

The session also completed the remaining historical reconciliation work and defined separate meanings for when a planning document was last updated and when its priorities were last reviewed by a human.

## Work Completed

Updated the read-only `abbey session review` prompt so that a recommended substantive change to a planning document also requires updating an existing `Last Updated:` field.

The new rule explicitly prevents:

- Updating dates in otherwise unchanged files.
- Creating date-only edits.
- Inventing freshness fields for documents that do not use them.

Added regression coverage for the new guidance and validated it through a real historical session reconciliation.

The real review correctly required `PROJECT_STATUS.md` to receive `Last Updated: 2026-07-20` alongside substantive changes. It did not recommend date changes for unrelated or unchanged files.

Completed the final historical session reconciliation by:

- Marking the historical reconciliation completion update as reviewed.
- Updating `PROJECT_STATUS.md` to reflect that historical reconciliation is complete.
- Removing completed reconciliation work from `NEXT.md`.
- Revising the existing backlog entry to retain only unfinished review refinement.

After applying those changes, `abbey session review` reported no remaining unreviewed historical session updates.

## Planning Freshness

The session established two distinct planning concepts.

### Last Updated

`Last Updated:` records when a document's substantive content changed.

`PROJECT_STATUS.md` uses this field because it describes factual project state and completed capabilities.

### Last Reviewed

`Last Reviewed:` records when a human deliberately confirmed that a document still reflects current intent, even if its wording did not change.

`NEXT.md` now uses this field because it remains a human-directed priority document.

Document-level freshness metadata was not added to `BACKLOG.md`, `ROADMAP.md`, or `IDEAS.md`. These documents are intentionally long-lived, and a recent edit to one item should not make their entire contents appear current.

## Design Direction

Future `abbey next` behavior may warn when `NEXT.md` has not been reviewed within a defined period.

Age alone should not cause Abbey to:

- Discard `NEXT.md`.
- Reduce its authority.
- Change recommendation scores.
- Override human direction.

Freshness reporting should make uncertainty visible and prompt human review rather than silently changing project priorities.

## Workflow Validation

Validated the work with:

- Shell syntax validation for `tools/bin/abbey-session`.
- Nine passing session-review prompt regression checks.
- `git diff --check`.
- A complete real-world `abbey session review` reconciliation cycle.
- A read-only noninteractive Codex review inside the Linux sandbox.
- `abbey doctor`, which reported no failures.

The noninteractive Codex workflow initially failed because the host did not have a system Bubblewrap installation. Installing the Ubuntu `bubblewrap` package restored reliable sandboxed `codex exec` operation.

## Lessons Learned

Read-only review tools can preserve metadata integrity through precise implementation guidance without modifying authoritative files themselves.

The last time a document changed and the last time a human confirmed it are different facts. Treating them as one timestamp produces misleading freshness signals.

Practical workflow use continues to expose more valuable Abbey improvements than speculative framework design. The missing date maintenance became visible only after real historical reconciliation changed planning content without changing its recorded date.

`abbey review` also revealed that it currently treats any changed session-update file as current session documentation, even when that file belongs to an earlier reconciliation. That behavior remains an observation for future practical evaluation.

## Next Steps

- Implement stale-`NEXT.md` warning behavior in a separate focused session.
- Evaluate whether `abbey review` should distinguish current-session documentation from historical session updates changed during reconciliation.
- Continue refining Abbey's review workflows only where practical usage demonstrates a need.
