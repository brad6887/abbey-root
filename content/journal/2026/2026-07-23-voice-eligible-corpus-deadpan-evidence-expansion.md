---
artifact_id: JOURNAL-2026-07-23-VOICE-ELIGIBLE-CORPUS-DEADPAN-PILOT
artifact_type: journal-entry
title: Voice-Eligible Corpus and Deadpan Evidence Expansion
version: 1
status: draft

date: 2026-07-23
category: research
tags:
  - voice-analysis
  - corpus
  - deadpan-delivery
  - validation

created:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted research
---

# Voice-Eligible Corpus and Deadpan Evidence Expansion

## Summary

Voice Analysis moved from broad exploratory sampling to full-corpus evidence retrieval.

The frozen corpus remains unchanged. A deterministic derived view now separates authored voice candidates from automated check-ins, link-only records, ambiguous platform syntax, and Facebook status-prompt influence.

## Research Input

The derived view contains 1,502 eligible posts.

After omitting platform-context flags, 1,375 posts were divided into eleven chronological batches of 125 posts each.

This provides full temporal coverage without placing the entire corpus into one model request.

## Deadpan Pilot

The first retrieval pilot used the most recent batch, covering 2020 through 2026.

The model returned five supporting candidates and one contradictory candidate. Every quotation matched the frozen corpus, and deterministic validation passed.

Human review retained three supporting candidates, two provisionally, and one contradictory candidate. Two plausible-looking results were rejected because they demonstrated wordplay rather than deadpan delivery.

## Lesson

Removing platform artifacts materially improves the input, but it does not replace semantic review.

The productive workflow is:

    deterministic eligibility
    → chronological batching
    → AI candidate retrieval
    → citation validation
    → human semantic review
    → evidence aggregation

This is now a practical research loop rather than another architecture exercise.

## Full Evidence Expansion

The deadpan retrieval process was completed across all eleven chronological batches.

Human review retained sixteen supporting candidates, seven provisional supporting candidates, thirteen contradictory candidates, and one provisional contradictory candidate.

The reviewed evidence spans 2009 through 2021 and shows that deadpan delivery is recurring but selective rather than universal.

The bulk run also exposed why deterministic citation checks and human semantic review are both required:

- One model run invented a corpus identifier range.
- Two generated quotations were attached to the wrong identifiers.
- Several ordinary complaints, puns, cultural references, real events, and image-dependent posts were misclassified as deadpan.
- A faster model comparison preserved quotations but produced substantially worse classifications.

## Canonical Revision

The reviewed aggregate was used to revise EVID-001 and VAL-001 to Version 2.

EVID-001 now presents representative supporting and contradictory examples across multiple writing periods and explicitly documents the retrieval workflow's integrity limits.

VAL-001 remains provisionally supported. Confidence increases from low to medium within Facebook writing because the pattern recurs across 2009 through 2021 and the counterexample search is now systematic. Frequency, post-2021 continuity, and use outside Facebook remain unvalidated.

## Next Step

Review and commit the completed corpus workflow and canonical evidence revision.
