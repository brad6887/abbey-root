---
title: Quoted Language Evidence
date: 2026-07-23
session: quoted-language-evidence
status: complete
reviewed: false
type: session-update
tags:
  - abbey-root
  - research
  - voice-analysis
  - evidence
  - quoted-language
---

# Quoted Language Evidence

## Objective

Complete the functional review of all 165 quote-bearing candidates and create
EVID-004 only after every source has a validated decision.

## Definition of Done

- Classify all 165 candidates.
- Fail incomplete or malformed model outputs.
- Preserve exact corpus citations for every decision.
- Separate strong distancing and renaming support from provisional quotation
  cases.
- Retain ordinary quotation as comparison evidence.
- Create EVID-004 and update OBS-004.

## Work Completed

The original 42-source batches were replaced with seventeen batches of no more
than ten sources.

Created:

- `normalize_quoted_language_classification.py`
- `build_quoted_language_review_manifest.py`
- `REVIEW-004.json`
- `EVID-004.md`

Every classification batch was required to contain:

- every expected source exactly once,
- no unexpected source,
- a valid category code,
- and a valid relevance code.

All seventeen batches passed without manual repair.

## Complete Review

```text
Candidates:               165
Supporting / retain:       76
Supporting / provisional:  20
Comparison / retain:       65
Comparison / reject:        4
```

The retained supporting core contains:

- 44 scare-or-distancing cases
- 32 invented-label-or-renaming cases

Direct quotations and reported speech marked as supporting remain provisional
pending case-specific framing review.

## Exact Citation Validation

REVIEW-004 contains:

```text
Review items: 165
Citations:    165
```

`abbey research validate-review` passed:

- manifest structure,
- corpus fingerprint,
- review decisions and roles,
- unique review identifiers,
- citation identifier resolution,
- and exact citation text.

## Artifact State

OBS-004 is now Version 2 and records the completed candidate distribution.

EVID-004 is draft evidence with a conservative cross-period canonical set and
ordinary quotation comparisons.

The formal chain remains incomplete:

```text
OBS-004 -> EVID-004
```

No hypothesis or validation was created.

## Suggested Next Step

Define HYP-004 around the narrowest supported claim: quotation marks function
as a stance marker that signals nonliteral, disputed, or deliberately renamed
wording. Keep direct quotation and reported speech outside the core claim.

