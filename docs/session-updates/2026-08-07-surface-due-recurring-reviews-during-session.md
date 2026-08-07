---
title: "Surface due recurring reviews during abbey session"
description: "Added recurring review due-state evaluation and surfaced due reviews during Abbey session startup."
date: 2026-08-07
status: complete
reviewed: false
session: surface-due-recurring-reviews-during-session
tags:
  - Abbey Root
---

# Surface due recurring reviews during abbey session

## Objective

Surface recurring reviews that are due during `abbey session` startup.

## Definition of Done

- Calculate recurring review due status from frequency and latest occurrence.
- Support active reviews with no completed occurrence.
- Keep recurring review due evaluation in the existing recurring review implementation.
- Surface due recurring reviews during `abbey session`.
- Use the active Abbey project root.
- Keep due review reporting informational and non-blocking.
- Validate both due and not-due behavior.

## Summary

Implemented recurring review due-state evaluation and integrated it into `abbey session`.

The recurring review implementation now evaluates active review definitions against their latest completed occurrence and calculates when each review is next due.

`abbey session` now includes a Recurring Reviews section during startup.

## Accomplishments

- Added due-date evaluation to `scripts/abbey_review_recurring.py`.
- Added support for:
  - daily
  - weekly
  - monthly
  - quarterly
  - yearly
- Added calendar-aware month calculations.
- Normalized YAML date values before occurrence comparison.
- Added `--due` mode for concise due-review output.
- Added `--root` support so recurring review evaluation can use the active Abbey project.
- Updated `abbey session` to display recurring review due status.
- Preserved the existing full `abbey review recurring` output.
- Validated a review that is not yet due.
- Validated session startup with recurring review status included.

## Impact

Abbey sessions now provide awareness of recurring responsibilities that require attention.

Recurring review scheduling remains centralized in the recurring review implementation, while `abbey session` consumes the result without duplicating scheduling logic.

Due reviews remain informational and do not prevent normal Abbey work.

## Validation

- `python3 -m py_compile scripts/abbey_review_recurring.py`
- `python3 scripts/abbey_review_recurring.py`
- `python3 scripts/abbey_review_recurring.py --root "$PWD" --due`
- `bash -n tools/bin/abbey-session`
- `abbey review recurring`
- `abbey session`

## Lessons Learned

Recurring review scheduling should remain centralized so commands such as `abbey review recurring` and `abbey session` share one source of truth.

Passing the active project root explicitly also keeps recurring review behavior compatible with Abbey external projects.

## Next Steps

- Begin implementing specific recurring review types.
- Use the recurring review framework to support real documentation, infrastructure, dependency, backup, security, and AI review workflows.

## Notes

The first active recurring review, Documentation Audit, was not due during validation because its latest occurrence was completed on 2026-08-06 with a monthly frequency.
