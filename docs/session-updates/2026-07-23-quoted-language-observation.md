---
title: Quoted Language Observation
date: 2026-07-23
session: quoted-language-observation
status: complete
reviewed: false
type: session-update
tags:
  - abbey-root
  - research
  - voice-analysis
  - observation
  - quoted-language
---

# Quoted Language Observation

## Objective

Review the highest-priority discovery cluster, quoted language as comic
framing, across the complete discovery corpus and decide whether it warrants
OBS-004.

## Definition of Done

- Build the complete deterministic quote-bearing candidate set.
- Match the original discovery population.
- Distinguish comic framing from ordinary quotation functions.
- Review supporting and comparison examples across time.
- Record an explicit observation decision.
- Do not create evidence, a hypothesis, or validation prematurely.

## Work Completed

Created `build_quoted_language_candidates.py`.

The script selects quote-bearing posts from the same population used by the
full-corpus discovery:

- `research_status` equals `eligible`
- `platform_context` is empty

The detector includes double quotation marks and paired single quotation
marks. Ordinary curly apostrophes in contractions are excluded.

Results:

```text
Source rows:   3039
Eligible rows: 1342
Candidates:    165
ASCII double:  136
Curly double:   13
ASCII single:   19
```

Signal counts overlap.

Created QUOTED-LANGUAGE-REVIEW-001 with:

- discovery context,
- deterministic candidate construction,
- cross-period supporting examples,
- ordinary title and direct-quotation comparisons,
- boundaries,
- and an explicit decision.

Created OBS-004, Quoted Language as Comic Framing, as a draft observation.

The observation is deliberately incomplete:

```text
OBS-004
```

No EVID-004, HYP-004, or VAL-004 was created.

## AI Classification Failure

The local worker did not complete a reliable classification of all 165
candidates.

- The verbose format exhausted 10,000 output tokens and truncated mid-item.
- The compact format returned an incomplete map containing an ellipsis.

Both outputs were rejected. The observation decision uses deterministic
candidate construction and explicit human source review.

## Research Status

```text
Formal artifacts:  15
Complete chains:    3
Incomplete chains:  1
```

The incomplete chain is OBS-004 and is expected.

## Suggested Next Step

Complete the functional review of all 165 candidates, decide whether the three
provisional subtypes should remain together, and then select the canonical
supporting and comparison set for EVID-004.

