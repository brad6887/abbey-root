---
title: "Easy Win Backlog Closure Tuning"
description: "Tuned easy-win to select finite parent-checkbox closures with conservative, review-gated implementation claims."
date: 2026-07-29
status: completed
reviewed: false
session: easy-win-backlog-closure-tuning
tags:
  - Abbey Root
---

# Easy Win Backlog Closure Tuning

## Objective

Make `abbey ai decide easy-win` optimize for verified net backlog reduction
rather than partial advancement or speculative feature expansion.

## Definition of Done

- At least one exact pending parent checkbox is required.
- Every required nested child is included in session scope.
- Open-ended and partial-advancement items are rejected.
- New backlog items expected is structurally fixed at zero.
- Expected net reduction is a required positive integer.
- Literal pending-checkbox syntax is preserved in accounting output.
- Implementation details remain unknown until repository review.
- Implementation confidence cannot exceed 25 percent.
- The local model completes a live decision under the final contract.
- No new backlog entry is created by this tuning session.

## Summary

Reworked the easy-win prompt and schema around checkable parent-level backlog
closure. The report now separates exact completion accounting from required
child work and optional exclusions, exposes net reduction directly, and prevents
the planning-only decision from presenting an undocumented implementation plan
as settled scope.

## Accomplishments

- Replaced material advancement with full pending-parent completion as the
  selection threshold.
- Added explicit rejection of recurring and open-ended backlog wording without
  finite completion criteria.
- Added required fields for parents closed, completion checkboxes, required
  subtasks, optional work excluded, new items expected, and net reduction.
- Enforced literal `- [ ]` syntax for both checkbox-accounting arrays.
- Closed the schema to unrecognized fields and removed unconstrained summary,
  priority-reason, and assumptions output.
- Required an unknown implementation approach, empty documented-details list,
  repository review, and implementation confidence at or below 25 percent.
- Improved report rendering for exact checkboxes and explicit empty scope.
- Expanded the Abbey AI regression suite from 84 to 107 passing checks.
- Validated the final contract through a live `gpt-oss:20b` decision.

## Impact

`easy-win` now recommends a candidate for a backlog-closing session without
pretending that planning documents establish its implementation. Users can see
the exact checkbox, expected net change, excluded scope, and review boundary
before deciding to begin work.

## Validation

- `bash -n tools/bin/abbey-ai`
- `bash -n tests/test-abbey-ai.sh`
- `python3 -m json.tool config/ai/decisions/easy-win/decision.json`
- `python3 -m json.tool config/ai/decisions/easy-win/schema.json`
- `tests/test-abbey-ai.sh` — 107 passed, 0 failed
- `git diff --check`
- Final live `abbey ai decide easy-win` using `gpt-oss:20b`
- Live result preserved exact pending checkboxes, expected zero new items,
  reported net reduction 1, rejected open-ended work as an alternative, and
  capped implementation confidence at 25 percent.

## Lessons Learned

Prompt instructions alone did not reliably prevent the local model from
inventing commands, flags, paths, or seemingly easy implementation details.
Important decision boundaries need schema enforcement and live evaluation.
Backlog accounting also needs literal checkbox evidence because descriptive
child bullets and open-ended work do not represent countable one-session
closures.

## Next Steps

- Use the tuned decision for future candidate selection and perform its listed
  repository review before defining any implementation session.

## Notes

One live validation attempt encountered a transient Ollama connection close and
was retried successfully. An initial checkbox regex was rejected by Ollama's
schema converter until both anchors were supplied; the final anchored pattern
was accepted and validated.
