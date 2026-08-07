---
title: "Support infrastructure reviews"
description: "Implemented and validated the recurring Infrastructure Review workflow using Abbey Doctor as the primary health check."
date: 2026-08-07
status: complete
reviewed: false
session: support-infrastructure-reviews
tags:
  - Abbey Root
---

# Support infrastructure reviews

## Objective

Implement the Infrastructure Review recurring review type and validate it through the public Abbey recurring review workflow.

## Definition of Done

- Add an active recurring Infrastructure Review definition.
- Reuse existing Abbey infrastructure health checks.
- Run the review through `abbey review recurring run infrastructure-review`.
- Keep the review read-only.
- Distinguish actionable findings from expected operational warnings.
- Preserve successful review execution even when infrastructure findings are present.
- Validate a real Infrastructure Review run.
- Mark Infrastructure Review support complete in the backlog.

## Summary

Implemented the Infrastructure Review recurring review type.

The review can now be run with:

`abbey review recurring run infrastructure-review`

The implementation reuses `abbey doctor` as the primary infrastructure health check and interprets Doctor output so expected operational warnings do not create unnecessary recurring review findings.

## Accomplishments

- Added `docs/reviews/recurring/infrastructure-review.md`.
- Added `infrastructure-review` execution support to `scripts/abbey_review_recurring.py`.
- Reused `abbey doctor` for:
  - repository health
  - required command checks
  - system health
  - host reachability
  - backup and storage checks
  - remote access
  - DNS resolution
- Added interpretation of Doctor exit codes.
- Added filtering for expected or non-infrastructure warnings.
- Ignored the working-tree warning during an active development session.
- Ignored host-specific backup checks when they are intentionally skipped on `ubuntu-dev01`.
- Preserved actionable warnings and failures as review findings.
- Validated a healthy Infrastructure Review result.
- Marked `Support infrastructure reviews.` complete in the backlog.

## Impact

Abbey now has a recurring infrastructure health review that builds on the existing Doctor framework instead of duplicating infrastructure checks.

Doctor remains conservative and reports complete operational context.

The Infrastructure Review interprets that output for recurring-review purposes and highlights only actionable infrastructure findings.

## Validation

- `python3 -m py_compile scripts/abbey_review_recurring.py`
- `abbey review recurring`
- `abbey review recurring run infrastructure-review`

Final Infrastructure Review result:

`OK   Infrastructure review completed`
`INFO Findings: 0`
`INFO Ignored warnings: 3`
`INFO Infrastructure status: healthy`

## Lessons Learned

Existing Abbey health checks can serve as authoritative inputs for recurring reviews.

Review-specific interpretation is useful when a general-purpose diagnostic command reports expected environmental warnings that should not create recurring-review findings.

## Next Steps

- Implement another recurring review type using the same pattern.
- Continue reusing existing Abbey commands as the source of truth where suitable.

## Notes

The validated run reported three Doctor warnings:

- working tree had uncommitted changes
- backup storage check was skipped on `ubuntu-dev01`
- backup freshness check was skipped on `ubuntu-dev01`

These were treated as expected or non-actionable for the Infrastructure Review, resulting in zero actionable findings.
