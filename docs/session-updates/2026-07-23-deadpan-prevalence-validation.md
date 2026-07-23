---
artifact_id: SESSION-2026-07-23-DEADPAN-PREVALENCE-VALIDATION
artifact_type: session-update
title: Deadpan Prevalence Validation
version: 1
status: completed
reviewed: false

created:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted research with human-reviewed annotation
---

# Deadpan Prevalence Validation

## Objective

Determine whether "frequently" is supported for deadpan delivery using a representative sample and explicit denominators.

## Definition of Done

- Define the frequency threshold before annotation.
- Draw a deterministic representative sample.
- Preserve the population and sample fingerprints.
- Annotate every sampled post.
- Human-review all annotations.
- Calculate overall and conditional rates with confidence intervals.
- Update the canonical deadpan chain proportionally.

## Operational Decision

Primary rate:

    deadpan delivery
    ÷
    posts with a discernible absurd-humorous premise

Secondary rate:

    deadpan delivery
    ÷
    all sampled eligible posts

Before annotation, "frequently" required the lower conditional 95% Wilson bound to be at least 20%.

## Sample

- Population: 1,342 unflagged eligible posts.
- Method: deterministic stratified hash sample.
- Rate: approximately 10% from each chronological batch.
- Sample size: 140.
- Seed: `deadpan-prevalence-v1`.
- Sample SHA-256: `0aedfe7eda30391d46f687e50246b1e3721908e774d5f4d53e63e8423b29b84d`.

## Annotation

The sample was divided into three bounded model requests.

Every row received:

- Premise label.
- Delivery label where applicable.
- Confidence.
- Review note.

All 140 rows were then reviewed. Thirteen model classifications were corrected.

Reviewed annotation SHA-256:

`2a439267aae399e0fb9efff8c71400f67749991ebff2d283c76f9bdbac532ce8`

## Result

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

The 44.40% lower bound exceeds the predeclared 20% threshold.

## Canonical Revisions

- OBS-001 advances to Version 2.
- HYP-001 advances to Version 2.
- EVID-001 advances to Version 4.
- VAL-001 advances to Version 4.
- Added REPORT-001, Deadpan Delivery Prevalence.

"Frequently" is now scoped to Facebook posts that contain a discernible absurd, impossible, fictional, or strongly exaggerated humorous premise.

The validation outcome remains `Provisionally Supported`, with medium confidence. Only sixteen sampled posts entered the conditional denominator, and other writing formats remain untested.

## Validation

- Four prevalence-tool tests pass.
- Nineteen existing focused research tests pass.
- Twenty-nine Abbey Research regression tests pass.
- Sample and reviewed-annotation fingerprints are recorded.
- Annotation identifiers exactly match sample order.
- All 140 sampled posts have valid final labels.

## Next Step

Run final repository checks and commit the prevalence tools, prompt, report, scoped artifact revisions, and session capture as one research increment.
