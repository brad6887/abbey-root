---
title: "Abbey AI Backlog-Leverage Decision"
description: "Added a structured Abbey AI decision for finding the focused session that clears the largest coherent set of backlog items."
date: 2026-07-26
status: complete
reviewed: false
session: abbey-ai-backlog-leverage-decision
tags:
  - Abbey Root
  - AI
  - CLI
  - planning
---

# Abbey AI Backlog-Leverage Decision

## Objective

Add `abbey ai decide backlog-leverage` so Abbey can identify one focused
development session whose shared outcome completes or materially advances the
largest coherent set of backlog items.

## Definition of Done

- The decision is discoverable through metadata-generated help.
- The prompt chooses one bounded outcome rather than a bundle of unrelated
  tasks.
- Every claimed backlog relationship requires planning-document evidence.
- Completion, material advancement, and direct enablement are distinguished.
- The confirmed coverage count is checked against the unique coverage map.
- Shared terminal reporting presents the outcome and coverage relationships.
- Focused regression assertions, syntax checks, JSON parsing, and
  `git diff --check` pass.

## Summary

Added the `backlog-leverage` decision package to the metadata-driven Abbey AI
decision library. The strategy favors work where one coherent outcome covers
several documented needs—the requested “do X and it also covers A, B, and C”
pattern—without rewarding vague benefits or artificial task bundling.

## Accomplishments

- Added decision metadata, an evidence-constrained prompt, and a structured
  JSON schema under `config/ai/decisions/backlog-leverage/`.
- Ranked candidate sessions by direct completions, material advancements,
  relationship strength, current-objective fit, and one-session confidence.
- Treated direct enablement as weaker than completion or material advancement.
- Required one primary backlog item and a coverage map containing the effect,
  relationship, and source document for every covered item.
- Required the model to reconcile its confirmed count with the unique coverage
  map before returning.
- Rejected unrelated task bundles, speculative relationships, completed work,
  prerequisite violations, and broad multi-session work without a useful
  bounded first slice.
- Extended the shared decision report with the shared outcome, primary backlog
  item, confirmed coverage count, and readable backlog coverage map.
- Added focused discovery, prompt-contract, schema-contract, and report-label
  assertions.
- Recorded the completed decision-library addition in the planning backlog.

## Impact

Abbey can now recommend work based on backlog leverage rather than only
priority, ease, risk reduction, time savings, or workflow friction. The
coverage map makes the reasoning reviewable: users can see exactly how the
same outcome affects each item and reject relationships that are merely
thematic.

## Validation

- `bash -n tools/bin/abbey-ai tests/test-abbey-ai.sh`
- JSON parsing for the new `decision.json` and `schema.json`
- `ABBEY_ROOT="$PWD" tools/bin/abbey-ai decide --help`
- All focused backlog-leverage discovery, prompt, schema, and report assertions
  passed.
- `git diff --check`
- The remainder of `tests/test-abbey-ai.sh` reached the documented pre-existing
  macOS portability failures in the knowledge-fixture section.

## Lessons Learned

Counting related backlog items is useful only when relationship quality is
visible. A raw score would reward broad wording and unrelated bundles, so the
decision contract makes the coverage map authoritative and uses the count as a
checked summary.

“Directly enables” remains useful for dependency-aware planning, but it must
not carry the same weight as work that actually completes or materially
advances an item.

## Next Steps

- Run `abbey ai decide backlog-leverage` from the canonical Ubuntu environment
  and review whether the coverage map remains conservative in normal use.
- Evaluate several real recommendations before adding numeric weighting or
  expanding the rubric.
- Fix the documented macOS Abbey AI test portability failures separately.

## Notes

No practical local-model run was attempted from this macOS project checkout.
The decision is structurally validated; behavioral evaluation should occur in
the canonical Ubuntu environment used for Abbey AI decision runs.
