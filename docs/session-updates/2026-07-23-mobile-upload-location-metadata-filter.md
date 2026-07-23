---
artifact_id: SESSION-2026-07-23-MOBILE-UPLOAD-LOCATION-METADATA-FILTER
artifact_type: session-update
title: Mobile Upload Location Metadata Filter
version: 1
status: completed
reviewed: false

created:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted platform improvement
---

# Mobile Upload Location Metadata Filter

## Objective

Close the residual platform-artifact gap discovered during recurring-narrative review without modifying CORPUS-001 or invalidating retained Voice Analysis evidence.

## Definition of Done

- Reproduce the residual artifact pattern.
- Add a narrow deterministic exclusion.
- Add positive and boundary regression tests.
- Rebuild the derived corpus and chronological batches in a new working directory.
- Audit every canonical evidence citation.
- Update affected canonical metadata.
- Run complete repository validation.

## Change

The eligibility filter now classifies records beginning with `Mobile uploads Place:` as:

- `excluded`
- `location_metadata`

The pattern is anchored. An authored sentence that mentions "mobile uploads" or "place" elsewhere remains eligible.

Two focused tests preserve both boundaries.

## Rebuild Result

| Measure | Previous | Corrected |
|---|---:|---:|
| Eligible | 1,502 | 1,469 |
| Review | 18 | 18 |
| Excluded | 1,519 | 1,552 |
| Unflagged eligible posts | 1,375 | 1,342 |
| Batches | 11 | 11 |
| Final batch size | 125 | 92 |

All 33 newly excluded records have reason `location_metadata`.

The corrected derived CSV fingerprint is:

    f796ad73cfd2dee20f26c24c7fe9876fc3430d2801fbbac65eb07a7ec0e32d27

Eight batch fingerprints changed; the first three batches were unaffected.

## Evidence Audit

EVID-001 through EVID-003 contain 51 unique source citations.

None belongs to the 33 newly excluded records. No evidence selection, validation outcome, or confidence level changed.

Model retrieval was not rerun because:

- Every remaining authored record was already present in the reviewed input.
- Only deterministic platform metadata was removed.
- No retained citation was affected.

## Canonical Updates

EVID-001 through EVID-003 and VAL-001 through VAL-003 advance to Version 3.

The revisions update corpus counts, batch-view size, citation-integrity findings, and the resolved limitation. Research conclusions remain unchanged.

## Validation

- Eleven focused corpus-filter and batching tests pass.
- Twenty-six Abbey Research regression tests pass.
- Research Python files compile.
- Abbey command syntax and help checks pass.
- Git whitespace validation passes.
- Abbey review recognizes the session update and journal entry.
- Corrected batches contain no `Mobile uploads Place:` records.
- CORPUS-001 remains unchanged.

## Next Step

Review and commit the filter, tests, session capture, and Version 3 metadata revisions as one platform-improvement increment.
