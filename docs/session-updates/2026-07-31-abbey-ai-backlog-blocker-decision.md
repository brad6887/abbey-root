---
title: "Abbey AI Backlog Blocker Decision"
description: "Added a structured Abbey AI decision that detects pending backlog items blocked by unfinished prerequisite work."
date: 2026-07-31
status: complete
reviewed: false
session: abbey-ai-backlog-blocker-decision
tags:
  - abbey-root
  - abbey-ai
  - decision-engine
  - backlog
---

# Abbey AI Backlog Blocker Decision

## Objective

Add `abbey ai decide blocker` to identify backlog items that appear selectable
as standalone work but depend on unfinished prerequisite checkboxes.

## Definition of Done

- Register a metadata-driven `blocker` decision with the shared Abbey AI
  decision engine.
- Require exact pending-checkbox evidence for both the blocked item and its
  prerequisites.
- Reject adjacency-only, optional, or merely related work as blocker evidence.
- Preserve uncertainty through bounded implementation confidence and required
  repository review.
- Cover discovery, prompt boundaries, schema constraints, and output formatting
  with regression tests.
- Validate the decision through a real structured Ollama run.

## Summary

Added a reusable Backlog Blocker decision definition. It reports the clearest
pending item that should not be selected independently, explains the failure
mode, names exact unfinished prerequisites, and distinguishes planning evidence
from implementation assumptions.

## Accomplishments

- Added `config/ai/decisions/blocker` with decision metadata, a bounded prompt,
  and a strict JSON schema.
- Required pending-checkbox syntax for both the primary item and all blockers.
- Added safeguards against treating proximity or shared subject matter as a
  dependency.
- Limited implementation confidence to 25 percent when repository source has
  not been reviewed.
- Extended shared output formatting so blocking checkboxes render without an
  extra bullet.
- Added regression coverage for help discovery, prompt rules, schema rules, and
  checkbox presentation.
- Added the durable capability to `PROJECT_STATUS.md`.

## Impact

Abbey AI can now audit for dependency-shaped backlog traps before a planning
decision treats a downstream test, documentation, validation, deployment, or
adoption checkbox as an independent easy win.

## Validation

- `tests/test-abbey-ai.sh` — 127 passed, 0 failed.
- `abbey docs check` — deterministic documentation current.
- `abbey ai decide --help` — discovered `blocker` with the expected metadata.
- `abbey ai decide blocker` — returned schema-valid output and identified the
  framework adoption guide as blocked by the unfinished canonical validation
  workflow.
- `git diff --check` — passed.

## Lessons Learned

Planning adjacency is useful evidence only when wording or capability state
establishes a real dependency. The decision therefore requires exact checkbox
evidence and repository review rather than treating backlog order alone as a
dependency graph.

## Next Steps

- Use `abbey ai decide blocker` before accepting low-confidence easy-win
  recommendations whose completion wording presupposes unfinished work.

## Notes

The motivating example was regression coverage for journal-template selection,
which cannot be completed honestly while the template-selection capabilities
remain pending. The real validation run found a different valid blocker, which
confirmed the decision is general rather than hard-coded to that example.
