---
title: Quoted Language Validation
date: 2026-07-23
session: quoted-language-validation
status: complete
reviewed: false
type: session-update
tags:
  - abbey-root
  - research
  - voice-analysis
  - validation
  - quoted-language
---

# Quoted Language Validation

## Objective

Validate HYP-004 against an exact holdout that excludes canonical EVID-004
examples and rejected matches.

## Work Completed

Created:

- VAL-004-definition.json
- `calculate_quoted_language_validation.py`
- VAL-004-result.json
- VAL-004.md

Updated HYP-004 to Version 2.

## Holdout

```text
Complete candidates:             165
Canonical support excluded:       15
Canonical comparisons excluded:    7
Rejected matches excluded:          4
Holdout:                          139
```

All exclusion sets were disjoint.

## Results

```text
Core cases:       61
Core rate:        43.88%
Wilson 95%:       35.91%–52.19%
Distancing:       36
Renaming:         25
Comparisons:      60
Passing bands:     4 of 4
Integrity errors:  0
```

Every HYP-004 threshold passed.

No holdout core case occurs after 2021, so the validation remains scoped to
Facebook writing from 2009 through 2021.

## Outcome

Provisionally Supported

Confidence is medium within the tested quote-bearing Facebook population and
low outside it.

## Artifact State

```text
OBS-004 -> EVID-004 -> HYP-004 -> VAL-004
```

The fourth formal research chain is complete.

## Suggested Next Step

Pause chain creation and synthesize OBS-001 through OBS-004 into a first
bounded Voice Model draft, explicitly separating validated Facebook
characteristics from untested cross-format claims.

