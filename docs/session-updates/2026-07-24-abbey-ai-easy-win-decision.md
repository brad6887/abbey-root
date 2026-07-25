---
title: "Abbey AI Easy-Win Decision"
description: "Added a structured decision strategy for selecting low-risk, durable, one-session backlog improvements."
date: 2026-07-24
status: complete
reviewed: true
session: abbey-ai-easy-win-decision
tags:
  - Abbey Root
  - AI
  - CLI
  - planning
---

# Abbey AI Easy-Win Decision

## Objective

Add `abbey ai decide easy-win` so Abbey can identify low-risk work that fits
one focused session, delivers durable value, and meaningfully reduces the
backlog.

## Definition of Done

- The decision is discoverable through metadata-generated help.
- The prompt distinguishes durable easy wins from work that is merely small.
- The structured result records session fit, risk, durable value, and backlog
  reduction.
- The normal terminal report presents the new decision metrics.
- Regression coverage and syntax checks pass for the changed behavior.
- The completed backlog item is reconciled.

## Summary

Added the `easy-win` decision package to the metadata-driven Abbey AI decision
library. The strategy uses the existing decision engine and the canonical
planning documents, preserving one source of truth and avoiding a
strategy-specific command implementation.

## Accomplishments

- Added decision metadata, a focused evaluation prompt, and a structured JSON
  schema under `config/ai/decisions/easy-win/`.
- Required candidates to have low risk, a credible one-session boundary,
  durable value, and material backlog impact.
- Added reusable terminal rendering for risk, session fit, durable value, and
  backlog reduction fields.
- Added regression assertions proving metadata-driven help discovers and
  describes the strategy.
- Marked the corresponding Abbey AI backlog item complete.

## Impact

Abbey can now ask a local model for a bounded, evidence-backed backlog
recommendation optimized for durable progress rather than raw priority or
recurring time savings. The implementation also extends the generic decision
reporter for future strategies that use the same evaluation dimensions.

## Validation

- `bash -n tools/bin/abbey-ai tests/test-abbey-ai.sh`
- JSON parsing for both new JSON files
- `ABBEY_ROOT="$PWD" bash tools/bin/abbey-ai decide --help`
- `git diff --check`
- The focused discovery and help assertions pass.
- The remainder of `tests/test-abbey-ai.sh` reaches a pre-existing macOS Bash
  3.2 incompatibility in `abbey-knowledge` (`readarray`), followed by the
  test's GNU-style `sed -i` usage. No easy-win assertion fails.

## Lessons Learned

Decision-definition metadata remains the right extension point for distinct AI
planning strategies. An easy-win contract needs explicit rejection criteria;
otherwise a model can confuse small or cosmetic work with durable backlog
reduction.

## Next Steps

- Run `abbey ai decide easy-win` against the configured Ollama service and
  assess the first real recommendation before refining the rubric.
- Consider macOS portability of the AI regression harness as a separate,
  explicitly scoped session.

## Notes

No model invocation was attempted in this local macOS workspace because the
configured Abbey Ollama service belongs to the source development environment.
