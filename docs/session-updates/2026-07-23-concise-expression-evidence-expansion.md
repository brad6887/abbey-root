---
artifact_id: SESSION-2026-07-23-CONCISE-EXPRESSION-EVIDENCE-EXPANSION
artifact_type: session-update
title: Concise Expression Evidence Expansion
version: 1
status: completed
reviewed: false

created:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted research
---

# Concise Expression Evidence Expansion

## Objective

Apply the validated voice-eligible corpus workflow to EVID-002 and VAL-002 without modifying CORPUS-001.

## Definition of Done

- Reuse the deterministic 1,375-post unflagged voice-eligible view.
- Retrieve candidates across all eleven chronological batches.
- Correct pilot prompt failures before the full run.
- Verify retained identifiers and quotations.
- Human-review supporting, contradictory, provisional, and rejected candidates.
- Revise EVID-002 and VAL-002 proportionally to the evidence.

## Work Completed

Added `concise-expression-candidate-retrieval.md` and ran it with `gpt-oss:20b` across all eleven existing chronological batches.

The first pilot exposed two classification errors:

- Missing-context fragments were treated as contradictions.
- Generic short statements were treated as strong support.

The prompt was corrected to distinguish semantic compression from word count, reader inference from unavailable context, and unnecessary elaboration from necessary detail.

## Human Review

Human review retained:

- 16 supporting candidates.
- 3 contradictory candidates.
- 2 provisional contradictory candidates.

Supporting evidence spans 2009 through 2020. Clear contradictions were uncommon because most longer posts required their detail; two format-driven long posts remain provisional.

## Canonical Revision

- Revised EVID-002 from Version 1 to Version 2.
- Revised VAL-002 from Version 1 to Version 2.
- Retained the validation outcome `Provisionally Supported`.
- Increased confidence from `Low` to `Medium` within Facebook writing.

Frequency, post-2020 continuity, other formats, and unfamiliar audiences remain unvalidated.

## Validation

- All eleven candidate retrieval runs completed.
- Retained identifiers and quotations match deterministic source batches.
- CORPUS-001 remains unchanged.
- Working model outputs remain under ignored `working/research/`.

## Next Step

Run repository validation, review the complete diff, and commit this as a separate concise-expression research increment.
