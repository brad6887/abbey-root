---
artifact_id: REPORT-001
artifact_type: report
title: Deadpan Delivery Prevalence
version: 1
status: draft

source:
  corpus: CORPUS-001
  experiment: EXP-001
  parent_artifacts:
    - EVID-001

created:
  date: 2026-07-23
  author: Brad Cooke
  method: Deterministic sampling with AI-assisted and human-reviewed annotation
---

# Deadpan Delivery Prevalence

## Objective

Measure whether "frequently" is supported for deadpan delivery in the corrected Facebook research corpus.

## Operational Definition

Primary denominator:

- Sampled posts containing a discernible absurd, impossible, fictional, contradictory, or strongly exaggerated humorous premise.

Numerator:

- Qualifying posts using ordinary, literal, practical, procedural, or emotionally restrained delivery.

Secondary denominator:

- Every sampled eligible post.

Before annotation, frequency support required the lower 95% Wilson bound for the conditional rate to be at least 20%.

## Sample

- Population: 1,342 unflagged eligible Facebook posts.
- Method: deterministic stratified hash sample.
- Sampling rate: approximately 10% per chronological batch.
- Sample size: 140.
- Seed: `deadpan-prevalence-v1`.
- Sample SHA-256: `0aedfe7eda30391d46f687e50246b1e3721908e774d5f4d53e63e8423b29b84d`.

## Annotation

Every sampled post received:

- Premise classification.
- Delivery classification where applicable.
- Confidence.
- Review note.

Model annotations were checked for membership and order. Human review examined all 140 posts and corrected thirteen classifications.

Reviewed annotation SHA-256:

`2a439267aae399e0fb9efff8c71400f67749991ebff2d283c76f9bdbac532ce8`

## Results

| Measure | Result |
|---|---:|
| Sampled posts | 140 |
| Absurd-humorous premise | 16 |
| Deadpan delivery | 11 |
| Overt or explanatory delivery | 5 |
| Overall deadpan rate | 7.86% |
| Overall 95% Wilson interval | 4.44%–13.52% |
| Conditional deadpan rate | 68.75% |
| Conditional 95% Wilson interval | 44.40%–85.84% |

## Decision

The predeclared conditional-frequency test passes.

The 44.40% lower confidence bound exceeds the 20% threshold. The author frequently uses deadpan delivery among sampled Facebook posts with a qualifying absurd-humorous premise.

The result does not mean that most Facebook posts are deadpan. Only 7.86% of all sampled posts received the deadpan label.

## Limitations

- Only sixteen sampled posts entered the conditional denominator.
- One human reviewer made the final annotation decisions.
- The study measures Facebook posts, not other writing formats.
- Equal-rate stratification produced slightly different inclusion probabilities because the final batch is smaller.
- The threshold is an operational research decision, not a universal linguistic standard.

## Status

Draft report supporting EVID-001 Version 4 and VAL-001 Version 4.
