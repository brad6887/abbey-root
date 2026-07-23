---
artifact_id: SESSION-2026-07-23-EXACT-CITATION-REVIEW-MANIFESTS
artifact_type: session-update
title: Exact Citation Validation and Review Manifests
version: 1
status: completed
reviewed: false

created:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted platform improvement
---

# Exact Citation Validation and Review Manifests

## Objective

Add deterministic exact-citation validation and a machine-readable human-review record for Voice Analysis evidence.

## Definition of Done

- Define a minimal reusable JSON review schema.
- Validate corpus fingerprints.
- Validate source identifiers and complete exact text.
- Validate review decisions, evidence roles, item identifiers, notes, and citation groups.
- Expose validation through Abbey Research.
- Add positive and failure-path regression tests.
- Create manifests for EVID-001, EVID-002, and EVID-003.
- Validate all migrated citations against CORPUS-001.

## Implementation

Added:

- `tools/research/validate_review_manifest.py`
- `tests/test-review-manifest.py`
- `docs/research/voice-analysis/REVIEW_MANIFEST.md`
- `docs/research/voice-analysis/reviews/REVIEW-001.json`
- `docs/research/voice-analysis/reviews/REVIEW-002.json`
- `docs/research/voice-analysis/reviews/REVIEW-003.json`

Added the command:

    abbey research validate-review \
      --manifest FILE \
      --corpus FILE

The command is deterministic and does not call an AI model.

## Exact Validation

Validation fails when:

- The corpus fingerprint differs.
- A source identifier is missing or malformed.
- Citation text differs from the complete corpus text.
- A review-item identifier is duplicated.
- A decision or evidence role is invalid.
- A review note or citation group is empty.
- Required corpus, method, or scope metadata is absent.

No whitespace, punctuation, quotation, or Unicode normalization is applied during citation comparison.

## Review Scope

The schema distinguishes:

- `canonical_evidence_selection`
- `complete_candidate_review`

The three migrated manifests use `canonical_evidence_selection`. They preserve every reviewed example used in the canonical Version 3 evidence artifacts without claiming that every discarded exploratory model suggestion has been enumerated.

## Migration Result

| Manifest | Evidence | Review items | Citations |
|---|---|---:|---:|
| REVIEW-001 | EVID-001 | 15 | 15 |
| REVIEW-002 | EVID-002 | 16 | 16 |
| REVIEW-003 | EVID-003 | 12 | 25 |
| Total |  | 43 | 56 |

All three manifests pass exact validation against CORPUS-001.

## Validation

- Eight focused review-manifest tests pass.
- Twenty-nine Abbey Research regression tests pass.
- All 56 migrated citations match the frozen corpus exactly.
- The three corpus fingerprints match.
- Existing research status and artifact-chain behavior remain unchanged.

## Next Step

Run final repository checks and commit the exact-citation validator, review manifests, tests, schema documentation, and session capture as one platform increment.
