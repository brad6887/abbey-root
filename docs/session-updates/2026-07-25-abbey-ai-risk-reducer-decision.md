---
title: "Abbey AI Risk-Reducer Decision"
description: "Added a structured decision strategy for selecting bounded work that materially reduces operational or workflow risk."
date: 2026-07-25
status: complete
reviewed: true
session: abbey-ai-risk-reducer-decision
tags:
  - Abbey Root
  - AI
  - CLI
  - planning
journal: 2026-07-25-abbey-ai-risk-reducer-decision
---

# Abbey AI Risk-Reducer Decision

## Objective

Add `abbey ai decide risk-reducer` so Abbey can identify the smallest
practical, one-session change that materially reduces operational or workflow
risk.

## Definition of Done

- The decision is discoverable through metadata-generated help.
- The prompt requires a concrete, evidence-backed failure mode and bounded
  one-session work.
- The prompt prohibits unsupported implementation details.
- Recommendation confidence is distinct from implementation confidence.
- Repository review requirements are explicit.
- The structured terminal report presents risk reduction, residual risk, both
  confidence values, and required repository review.
- Focused regression coverage and syntax checks pass.
- A practical local-model run is reviewed.
- The completed backlog item is reconciled.

## Summary

Added the `risk-reducer` decision package to the metadata-driven Abbey AI
decision library. The strategy uses the existing decision engine and canonical
planning documents rather than adding a strategy-specific command path.

The decision contract requires one bounded recommendation, its supported
failure mode, risk reduction, residual risk, evidence, separate recommendation
and implementation confidence, and repository review required before work
begins.

## Accomplishments

- Added decision metadata, a risk-focused prompt, and a structured JSON schema
  under `config/ai/decisions/risk-reducer/`.
- Required candidates to materially reduce a documented operational or
  workflow risk within one focused session.
- Added rejection criteria for broad, blocked, duplicate, documentation-only,
  and already-completed work.
- Prohibited code-level implementation claims not established by the supplied
  planning documents.
- Capped implementation confidence at 50 percent because this decision reads
  planning documents rather than repository implementation files.
- Required a nonempty repository-review checklist.
- Extended the generic decision report with failure mode, risk reduction,
  residual risk, separate confidence values, and repository review sections.
- Added focused discovery, prompt-contract, and schema-contract assertions.
- Completed the corresponding Abbey AI backlog item.

## Impact

Abbey can now ask a local model for the smallest practical change that reduces
a concrete project risk without confusing urgency with value or pretending
planning documents reveal the implementation.

The separate confidence measures make a useful distinction: choosing the right
risk reducer can be well supported even when the code path and test approach
still require repository inspection.

## Validation

- `bash -n tools/bin/abbey-ai tests/test-abbey-ai.sh`
- JSON parsing for `decision.json` and `schema.json`
- `ABBEY_ROOT="$PWD" tools/bin/abbey-ai decide --help`
- `git diff --check`
- All focused risk-reducer discovery, prompt, and schema assertions passed.
- The remainder of `tests/test-abbey-ai.sh` reached the same pre-existing
  macOS portability failures recorded by the easy-win session: Bash 3.2 lacks
  `readarray`, and BSD `sed -i` is incompatible with the GNU invocation.
- Three real `gpt-oss:20b` runs completed against the configured Ollama
  service, including a final run from the canonical Ubuntu checkout.
- The canonical run selected bounded `abbey next` NEXT.md validation, reported
  80 percent recommendation confidence and 30 percent implementation
  confidence, and included repository-review requirements.

## Lessons Learned

The first real run reproduced the easy-win strategy's main weakness: it gave
an uninspected implementation 85 percent confidence. Capping implementation
confidence and strengthening the prompt reduced that figure to 40 percent and
made the review boundary visible.

One model output still described a "single source-file edit" even though the
planning documents do not establish that boundary. The canonical run also
suggested a specific presence check while correctly listing the parser and
required headings as repository-review questions. Prompt constraints and
structured confidence improve honesty but do not provide deterministic
semantic enforcement. A future metadata-validation or response-review feature
could address that limitation across all decision strategies.

The recommendation itself was grounded more strongly than it first appeared:
the backlog explicitly names checks for Git `user.name`, `user.email`, and the
effective configuration source.

## Next Steps

- Evaluate future risk-reducer runs through normal use before expanding the
  rubric.
- Consider semantic response review across decision strategies rather than
  adding strategy-specific output filtering.
- Address the pre-existing macOS AI test portability failures in a separate
  focused session.

## Notes

No repository implementation files are supplied to the decision. Repository
review remains mandatory before acting on its recommendation.
