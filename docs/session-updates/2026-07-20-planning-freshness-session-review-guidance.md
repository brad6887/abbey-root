---
title: "Planning Freshness and Session Review Guidance"
description: "Improved Abbey session reconciliation guidance, completed historical planning reconciliation, and defined explicit planning freshness semantics."
date: 2026-07-20
status: complete
reviewed: true
session: primary
tags:
  - Abbey Root
  - Session Workflow
  - Planning
  - Documentation
  - Developer Toolkit
---

# Planning Freshness and Session Review Guidance

## Objective

Improve planning freshness integrity through practical use of `abbey session review` while preserving its read-only design.

Complete the remaining historical session reconciliation and define clear semantics for representing when authoritative planning documents were last changed or deliberately reviewed.

## Definition of Done

- Session-review guidance pairs substantive planning-document changes with updating an existing `Last Updated:` field.
- Unchanged planning files do not receive date-only updates.
- The new guidance has regression coverage.
- The behavior is validated through a real session reconciliation.
- The final historical session update is reconciled.
- Planning freshness semantics distinguish `Last Updated:` from `Last Reviewed:`.
- `NEXT.md` records when its human-directed priorities were last reviewed.
- Future stale-`NEXT.md` reporting is represented once in the backlog.
- Relevant syntax, regression, documentation, and repository validation passes.

## Summary

Improved the read-only `abbey session review` workflow so its reconciliation reports preserve planning-document date integrity.

The session began after `abbey next` produced a recommendation from planning sources whose apparent freshness did not accurately reflect recent reconciliation work. Practical review showed that `PROJECT_STATUS.md` had received substantive updates without its `Last Updated:` field being changed. It also showed that the human-directed priorities in `NEXT.md` needed a different freshness concept from substantive document modification.

The session-review prompt now requires an existing `Last Updated:` field to be updated whenever it recommends a substantive change to that planning document. It explicitly prevents date-only edits and does not assign new dates to otherwise unchanged files.

The behavior was validated through the final historical reconciliation session. The review correctly required a current date for the substantively changed `PROJECT_STATUS.md`, did not invent date requirements for files without freshness fields, and did not recommend date-only changes.

The remaining historical session update was then reconciled, bringing historical reconciliation to completion. Planning freshness semantics were documented, `NEXT.md` received explicit human-review metadata, and future stale-priority reporting was captured as separate backlog work.

## Accomplishments

- Updated the Codex reconciliation prompt in `tools/bin/abbey-session`.
- Added a rule requiring substantive planning-document changes to include an update to an existing `Last Updated:` field.
- Prevented date changes in otherwise unchanged files.
- Prevented date-only reconciliation edits.
- Added regression coverage to `tests/test-abbey-session-review.sh`.
- Increased the session-review prompt test suite to nine checks.
- Ran `abbey session review` against the final historical reconciliation update.
- Confirmed that the real review required `Last Updated: 2026-07-20` for the substantively changed `PROJECT_STATUS.md`.
- Confirmed that the review did not invent freshness metadata for `NEXT.md`, `BACKLOG.md`, or unchanged authoritative files.
- Marked the historical reconciliation completion update as reviewed.
- Updated `PROJECT_STATUS.md` to state that historical session reconciliation is complete.
- Removed completed historical reconciliation work from the relevant `NEXT.md` priority.
- Revised the existing backlog entry so it retains only unfinished session-review refinement.
- Reached zero unreviewed historical session updates before creating this session update.
- Added `Last Reviewed: 2026-07-20` to `NEXT.md`.
- Defined `Last Updated:` and `Last Reviewed:` in `PLANNING_SCHEMA.md`.
- Defined which planning documents currently use document-level freshness metadata.
- Added one backlog item for future stale-`NEXT.md` reporting.
- Installed the system Bubblewrap package on `ubuntu-dev01`.
- Confirmed that sandboxed, noninteractive `codex exec` could inspect the repository and run validation successfully.

## Impact

Abbey's reconciliation workflow now preserves the accuracy of planning-document freshness metadata without giving a read-only command permission to modify files.

Codex handoffs produced from session-review reports have clearer implementation requirements: substantive planning changes carry their required date maintenance, while untouched files remain untouched.

Planning freshness now distinguishes two separate concepts:

- A document's substantive content changed.
- A human deliberately reviewed the document and confirmed that it still reflects current intent.

This distinction provides a sound basis for future freshness reporting without allowing automation to override human-directed priorities.

Historical session reconciliation is complete, and the repository no longer carries an unreconciled historical session update.

## Planning Decisions

### Last Updated

`Last Updated:` represents the date a document's substantive content last changed.

`PROJECT_STATUS.md` uses this field because it summarizes factual project state and completed capabilities.

The field should change only when substantive content changes. Merely reading or evaluating the file must not make it appear fresher.

### Last Reviewed

`Last Reviewed:` represents the date a human deliberately confirmed that a document still reflects current intent, even when its substantive wording did not change.

`NEXT.md` uses this field because its priorities are human-directed and may remain valid without frequent edits.

### Other Planning Documents

Document-level freshness metadata is not currently required for:

- `BACKLOG.md`
- `ROADMAP.md`
- `IDEAS.md`

The backlog and ideas documents are intentionally long-lived. A recent edit to one item should not make every item appear current.

Roadmap freshness may be evaluated later if practical use demonstrates a need.

### Stale NEXT.md Behavior

Future `abbey next` behavior should warn when `NEXT.md` has not been reviewed within a defined period.

Age alone must not:

- Silently discard `NEXT.md`.
- Reduce its authority.
- Change recommendation scores.
- Allow automation to override human direction.

A stale date should make uncertainty visible and prompt human review.

## Validation

- `bash -n tools/bin/abbey-session` passed.
- `tests/test-abbey-session-review.sh` passed with 9 checks and 0 failures.
- `git diff --check` passed.
- `abbey session review` paired substantive `PROJECT_STATUS.md` changes with `Last Updated: 2026-07-20`.
- The review did not recommend date changes for otherwise unchanged files or invent freshness fields for files without them.
- After required reconciliation, `abbey session review` reported no unreviewed session updates.
- Planning freshness inspection confirmed that only `PROJECT_STATUS.md` and `NEXT.md` currently contain document-level freshness metadata.
- A read-only `codex exec` successfully inspected the changes and ran validation inside the Bubblewrap sandbox without modifying files.
- `abbey doctor` reported 23 successful checks, 0 failures, and 3 expected warnings related to the dirty working tree and skipped host-specific backup checks.

## Lessons Learned

Read-only review tools can preserve metadata integrity by including precise requirements in their generated implementation guidance.

A document's last substantive change and its last deliberate human review are different facts. Representing both concepts with a single date creates misleading freshness signals.

Freshness warnings should expose uncertainty rather than silently changing the authority of human-maintained planning.

Practical workflow use remains the best way to identify framework improvements. The date-maintenance gap became visible only after historical reconciliation changed authoritative planning content without changing its existing date.

`abbey review` currently treats any changed session-update file as current session documentation. During this session, it recognized the historical reconciliation update even though that file documented an earlier session. This is a framework observation rather than accepted backlog work.

The `codex exec` failure was environmental rather than prompt-related. Installing the system Bubblewrap package restored reliable sandboxed execution on `ubuntu-dev01`.

## Next Steps

- Implement and validate stale-`NEXT.md` warning behavior in a separate focused session.
- Evaluate through practical use whether `abbey review` should distinguish the current session update from historical session-update files changed during reconciliation.
- Continue refining `abbey session review` and planning reconciliation only where real workflows expose a demonstrated need.

## Notes

The incidental duplicated "Continue documenting Abbey Root and Power Infrastructure" priority in `NEXT.md` was intentionally left unchanged because it was unrelated to the required historical reconciliation.

No commit, push, publication, or deployment was performed during implementation and validation.
