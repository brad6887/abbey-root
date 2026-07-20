---
title: "Abbey Next Session Update Freshness Layer"
description: "Extended abbey next to use unreconciled session updates as deterministic freshness evidence."
date: 2026-07-17
status: complete
reviewed: true
session: primary
tags:
  - Abbey Root
  - Developer Toolkit
  - Recommendation Engine
  - Session Workflow
  - Automation
---

# Abbey Next Session Update Freshness Layer

## Objective

Add unreconciled session updates as a deterministic freshness layer for `abbey next`.

## Definition of Done

- Read session updates marked `reviewed: false`.
- Normalize completed statuses such as `complete` and `completed`.
- Suppress backlog work already completed in unreconciled session updates.
- Use explicit session-update Next Steps to strengthen matching backlog candidates.
- Report conflicts between recent completion evidence and stale planning state.
- Avoid promoting candidates from generic planning language.
- Preserve planning documents as the authoritative source of valid work.
- Keep the recommendation workflow deterministic and explainable.
- Add regression coverage for the new behavior.
- Validate the updated command against the live repository.

## Accomplishments

### Session Update Evidence

Extended `scripts/abbey_next_candidates.py` to read unreconciled session updates from `docs/session-updates/`.

Updates marked `reviewed: false` are treated as recent project evidence rather than authoritative planning sources.

The recommendation model now distinguishes between:

- `NEXT.md` and `PROJECT_STATUS.md` as current human direction.
- `BACKLOG.md` and `ROADMAP.md` as valid planned work.
- Unreconciled session updates as recent completion and follow-up evidence.
- The Git working tree as active implementation evidence.

### Completed Work Suppression

Added support for recognizing completed session updates with either of these status values:

- `complete`
- `completed`

When strong session-level evidence matches an incomplete backlog item, the item is suppressed from recommendation ranking.

Completion matching intentionally uses conservative evidence:

- Session title.
- Objective section.

Detailed accomplishment prose is not used for suppression because broad token overlap produced false matches.

### Next-Step Evidence

Added extraction of explicit `## Next Steps` entries from unreconciled session updates.

Matching Next Steps strengthen existing backlog candidates but do not create standalone candidates.

This preserves the backlog as the source of valid work while allowing recent session discoveries to influence ranking.

### Stronger Matching

Initial matching incorrectly treated generic planning language as evidence for unrelated candidates.

Added a stricter session-update matcher requiring:

- At least two matching meaningful tokens.
- At least 75 percent coverage of the candidate's meaningful tokens.

This prevents broad phrases about planning, documentation, or reconciliation from incorrectly affecting recommendations.

### Planning Conflict Reporting

Added conflict reporting when:

- A backlog item remains incomplete.
- A completed unreconciled session update provides strong evidence that the work is already finished.

The live repository now reports that `Build deterministic project recommendation engine` remains unchecked in `BACKLOG.md` even though the July 16 session update records its completion.

### Abbey Next Output

Updated `tools/bin/abbey-next` to display:

- Session-update evidence under `Why This?`.
- Session-update paths under `Supporting Evidence`.
- Matching follow-up text.
- A `Planning Conflicts` section.
- Confirmation when recently completed work was suppressed.

### Regression Tests

Expanded `tests/test-abbey-next.sh` to validate:

- Suppression of completed work from unreconciled updates.
- Use of session-update Next Steps as recommendation evidence.
- Detection of stale planning state.
- Identification of stale backlog items.
- Rejection of generic planning language as candidate evidence.
- Preservation of pending updates as non-completion evidence.
- Existing recommendation and missing-document behavior.

Final result:

- Passed: 16
- Failed: 0

## Validation

Completed validation included:

- Python source compilation using `compile()`.
- Shell syntax validation.
- `git diff --check`.
- Full `abbey next` regression suite.
- Live execution of `abbey next`.
- Live execution of `abbey review`.

The final live recommendation was:

`Generate Definitions of Done`

The recommendation was supported by the explicit July 16 Next Step:

`Generate recommendation-specific Definitions of Done for candidates outside the Recommendation Engine workflow`

The command also correctly reported the stale deterministic-engine backlog item as a planning conflict.

## Lessons Learned

### Authority and Freshness Are Different

Planning documents define official direction and valid work.

Session updates provide fresher evidence about completed work and newly discovered follow-up tasks.

The Recommendation Engine should use both while preserving their different levels of authority.

### Completion Evidence Must Be Conservative

Accomplishment sections contain many related terms and can easily create false completion matches.

Suppression should rely on strong session-level evidence rather than broad prose similarity.

### Session Prose Requires Stronger Matching

Curated planning documents can tolerate broader matching.

Free-form session updates require stronger token coverage before they should influence ranking.

### Tests Should Validate Behavior

A suppressed backlog item may still appear in the `Planning Conflicts` section.

Tests should confirm that the item is not selected as the recommendation rather than asserting that its text never appears anywhere in the output.

## Next Steps

- Reconcile completed session updates with planning documents.
- Mark reconciled session updates consistently.
- Normalize older session-update formatting where useful.
- Generate recommendation-specific Definitions of Done.
- Generate focused session objectives from planning documents.
- Continue replacing broad token matching with stronger project relationships.
