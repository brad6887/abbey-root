---
title: "Abbey AI Workflow-Friction Decision"
description: "Added a structured decision strategy for finding costly recurring workflow friction and choosing a proportionate Abbey improvement."
date: 2026-07-25
status: complete
reviewed: true
session: abbey-ai-workflow-friction-decision
tags:
  - Abbey Root
  - AI
  - CLI
  - planning
journal: 2026-07-25-abbey-ai-workflow-friction-decision
---

# Abbey AI Workflow-Friction Decision

## Objective

Add `abbey ai decide workflow-friction` so Abbey can identify the most costly
recurring manual step or awkward handoff that can be reduced through one
bounded, maintainable improvement.

## Definition of Done

- The decision is discoverable through metadata-generated help.
- The prompt prioritizes repeated friction over one-off annoyances.
- Evidence and assumptions are explicitly separated.
- Unsupported implementation details are prohibited.
- Recommendation confidence is distinct from implementation confidence.
- Repository review requirements are explicit.
- The result classifies the improvement as an Abbey command, standardized
  workflow, or local fix and explains why.
- Shared terminal reporting presents the workflow-friction fields.
- Focused regression coverage, syntax checks, JSON parsing, and
  `git diff --check` pass.
- A practical local-model run is attempted.
- The completed decision-library backlog work is captured.

## Summary

Added the `workflow-friction` decision package to the metadata-driven Abbey AI
decision library. The strategy uses the existing decision engine and canonical
planning documents rather than adding a strategy-specific command path.

The decision contract requires one recurring workflow, its friction point,
evidence of recurrence, cumulative cost, a bounded improvement, the retained
human boundary, separate recommendation and implementation confidence, and
repository review required before implementation.

## Accomplishments

- Added decision metadata, a workflow-friction prompt, and a structured JSON
  schema under `config/ai/decisions/workflow-friction/`.
- Required evidence of repeated work or an explicit assumption when recurrence
  is not established.
- Rejected one-off annoyances, premature automation, duplicate capabilities,
  and machinery disproportionate to the friction.
- Prohibited unsupported implementation details and exact savings claims.
- Capped implementation confidence at 50 percent because the decision receives
  planning documents rather than repository implementation files.
- Required a nonempty repository-review checklist.
- Required classification as `abbey-command`, `standardized-workflow`, or
  `local-fix`, with a reason the other scopes are premature or excessive.
- Extended the shared decision report with recurring workflow, friction point,
  bounded improvement, human boundary, classification, recurrence evidence,
  and cumulative cost.
- Added focused discovery, prompt-contract, schema-contract, and report-label
  assertions.
- Captured the completed addition as a specific Abbey AI backlog item.

## Impact

Abbey can now ask a local model where repeated manual work or awkward handoffs
create the greatest cumulative friction without assuming that every annoyance
deserves a new command.

The classification boundary supports proportionate improvements: stable
operations can become Abbey commands, shared handoffs can become standardized
workflows, and repository-specific friction can remain a local fix.

## Validation

- `bash -n tools/bin/abbey-ai tests/test-abbey-ai.sh`
- JSON parsing for the new `decision.json` and `schema.json`
- `ABBEY_ROOT="$PWD" tools/bin/abbey-ai decide --help`
- `git diff --check`
- All focused workflow-friction discovery, prompt, schema, and report
  assertions passed.
- The remainder of `tests/test-abbey-ai.sh` reached the documented pre-existing
  macOS portability failures in the knowledge-fixture section.
- A real `gpt-oss:20b` request reached the configured Ollama service, but it
  did not complete after several minutes and was interrupted. No model result
  is claimed as validated.

## Lessons Learned

The risk-reducer decision provided a strong reusable contract for evidence,
confidence separation, and repository review. Workflow friction needed one
additional judgment boundary: whether the improvement warrants a command, a
shared workflow, or only a local repair.

Recurrence cannot be inferred merely because a backlog item describes an
annoyance. The prompt therefore requires documentary evidence or an explicit
assumption rather than allowing the model to manufacture frequency and time
savings.

The local-model request demonstrated that reachability alone is not a complete
practical validation. The implementation is structurally validated, while
behavioral evaluation should occur from the canonical Ubuntu environment where
the same model has completed prior decision runs.

## Next Steps

- Run `abbey ai decide workflow-friction` from the canonical Ubuntu checkout
  and review the recommendation through normal use.
- Evaluate whether classification and recurrence evidence remain useful across
  several real recommendations before expanding the rubric.
- Fix the documented macOS Abbey AI test portability failures separately.

## Notes

No repository implementation files are supplied to the decision. Repository
review remains mandatory before acting on its recommendation.
