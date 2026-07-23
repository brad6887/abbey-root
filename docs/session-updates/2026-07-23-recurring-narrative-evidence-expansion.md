---
artifact_id: SESSION-2026-07-23-RECURRING-NARRATIVE-EVIDENCE-EXPANSION
artifact_type: session-update
title: Recurring Narrative Evidence Expansion
version: 1
status: completed
reviewed: false

created:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted research
---

# Recurring Narrative Evidence Expansion

## Objective

Apply the corpus workflow to EVID-003 and VAL-003 while treating relationships between posts, rather than individual posts, as the evidence unit.

## Definition of Done

- Require at least two verified posts per recurring cluster.
- Run candidate retrieval across all eleven batches.
- Expand cluster labels through deterministic search.
- Reject false recurrence and preserve isolated comparisons.
- Revise EVID-003 and VAL-003 proportionally.
- Leave CORPUS-001 unchanged.

## Work Completed

Added `recurring-narrative-candidate-retrieval.md`.

The first prompt exhausted the model output budget before returning findings, so it was shortened without changing the two-post requirement. Batch 008 required a separate retry after one empty length-limited response.

## Human Review

Retained five recurring clusters:

- Time machine.
- Overheard at work.
- Pay it forward.
- GrandBrad.
- National Daughters Day failure.

Fred and Suzypalooza remain provisional. Same-event posting, real organizations, ordinary repeated activities, duplicated uploads, and image-dependent relationships were rejected.

The retained evidence spans 2009 through 2024.

## Integrity Findings

- A model-generated identifier was corrected from FB-002359 to the verified FB-002357.
- Thirty-three residual `Mobile uploads Place:` records were discovered in the unflagged batches and excluded from evidence.
- The residual records reveal an eligibility-filter gap but do not invalidate the human-reviewed clusters.
- CORPUS-001 remains unchanged.

## Canonical Revision

- Revised EVID-003 from Version 1 to Version 2.
- Revised VAL-003 from Version 1 to Version 2.
- Retained `Provisionally Supported`.
- Increased confidence from `Low` to `Medium` within Facebook writing.

Reader recognition, deliberate planning, frequency, and non-Facebook formats remain unvalidated.

## Next Step

Validate and commit the recurring-narrative increment, then decide whether residual `Mobile uploads Place:` metadata should become a new deterministic exclusion rule.
