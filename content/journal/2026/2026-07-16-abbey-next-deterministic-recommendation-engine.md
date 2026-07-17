---
title: "Abbey Next Deterministic Recommendation Engine"
description: "Designed and validated the first deterministic project-aware recommendation engine for Abbey Root and identified the next architectural direction."
date: 2026-07-16
draft: false
tags:
  - Abbey Root
  - Developer Toolkit
  - Recommendation Engine
  - Workflow
---

# Abbey Next Deterministic Recommendation Engine

## Summary

Implemented the first working version of `abbey next`, establishing a deterministic recommendation engine that combines project planning documents with current repository state to recommend the next focused engineering session.

The implementation introduced a dedicated recommendation engine, comprehensive regression testing, and an explainable recommendation workflow while revealing that unreconciled session updates should become the next major information source.

## Accomplishments

- Created `abbey next` as a first-class Abbey command.
- Added Recommendation Engine architecture and algorithm documentation.
- Built a deterministic recommendation engine separated from the shell interface.
- Integrated planning documents and Git working-tree awareness.
- Implemented active-session detection so current work is completed before unrelated work is recommended.
- Added structured recommendation output including objectives, supporting evidence, and suggested first steps.
- Created a regression test suite covering recommendation selection and failure scenarios.
- Added tests for active work, completed work promotion, and missing planning documents.
- Reconciled planning documents so `abbey init` remains future work instead of an immediate priority.
- Identified repetitive CLI discovery as a candidate for future `abbey session context` automation.

## Lessons Learned

The project demonstrated that recommendation quality depends more on modeling project state than on increasingly sophisticated text matching. Current work, planning documents, and session history each provide different kinds of evidence that should be combined intentionally rather than inferred through keyword overlap.

Another important discovery was the distinction between authority and freshness. Planning documents represent the authoritative project direction, while unreconciled session updates contain the newest information until planning is reconciled. Future versions of `abbey next` should treat unreconciled session updates as a freshness layer rather than relying exclusively on planning documents.

## Next Steps

- Incorporate unreconciled session updates into recommendation generation.
- Detect recently completed work from session updates.
- Promote follow-up work identified during recent sessions.
- Report conflicts between planning documents and unreconciled session updates.
- Continue replacing heuristic text matching with structured project-state information.
- Expand regression coverage as additional recommendation behaviors are implemented.
