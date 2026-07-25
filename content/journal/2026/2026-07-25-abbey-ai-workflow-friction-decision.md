---
title: "Abbey AI Workflow-Friction Decision"
description: "Added an evidence-backed AI decision strategy for reducing costly recurring workflow friction."
date: 2026-07-25
draft: false
tags:
  - Abbey Root
  - AI
  - Developer Toolkit
  - Planning
---

# Abbey AI Workflow-Friction Decision

## Summary

Added `abbey ai decide workflow-friction`, a metadata-driven strategy for
finding repeated manual work, awkward handoffs, duplicate entry, and recurring
verification burdens that warrant a bounded Abbey improvement.

The strategy requires evidence of recurrence, separates recommendation
confidence from implementation confidence, and requires repository review
before implementation.

## Accomplishments

- Added the `workflow-friction` decision metadata, prompt, and result schema.
- Prioritized cumulative recurring friction over one-time annoyances.
- Distinguished evidence from assumptions and prohibited invented
  implementation details.
- Required a bounded, maintainable improvement with a retained human boundary.
- Classified the result as an Abbey command, standardized workflow, or local
  fix.
- Extended the shared terminal report for workflow-friction results.
- Added focused metadata-discovery and decision-contract regression coverage.
- Captured the new decision as completed Abbey AI backlog work.

## Lessons Learned

Not every repeated inconvenience should become a command. A useful friction
decision must also judge the proportionate shape of the improvement.

Planning documents can support a strong recommendation while revealing little
about implementation. The decision makes that mismatch visible through
separate confidence values and required repository review.

## Next Steps

- Validate a completed local-model recommendation from the canonical Ubuntu
  environment.
- Evaluate the classification boundary through normal use before expanding the
  rubric.
