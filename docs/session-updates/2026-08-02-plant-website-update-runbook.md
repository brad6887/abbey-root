---
title: "Plant Website Update Runbook"
description: "Documented the proven individual, batch, and manual plant website update procedures in one operational runbook."
date: 2026-08-02
status: complete
reviewed: true
session: plant-website-update-runbook
tags:
  - Abbey Root
---

# Plant Website Update Runbook

## Objective

Capture the complete plant website maintenance workflow proven through the real
August 2 multi-plant update before concluding the development session.

## Definition of Done

- Individual plant updates are documented.
- Multi-plant photo renaming, worksheet preparation, review, and apply are
  documented.
- Manual fact, prose, and observation-date corrections are documented.
- Validation, publication, site build, review, and session completion are
  documented.
- Canonical and generated content boundaries are explicit.

## Summary

Added a single operational runbook for maintaining existing plant profiles.
The procedure combines established Abbey commands with the safety and review
lessons learned during the first real batch update.

## Accomplishments

- Documented the one-photo `abbey plant update` workflow.
- Documented caption-based export renaming and paired XMP handling.
- Documented date-scoped batch worksheets, warning/skip behavior, current-photo
  decisions, complete-batch validation, and apply.
- Documented direct canonical edits for species, rescue dates, history prose,
  and coordinated observation-date corrections.
- Documented single and multi-plant validation and publishing commands.
- Documented sanitized derivative behavior, site builds, visual review, session
  capture, and recovery rules.
- Linked the runbook from the documentation overview.

## Impact

Plant website maintenance now has one repeatable procedure rather than relying
on conversation history or memory. The runbook preserves canonical-source
discipline and makes both routine updates and corrections safer.

## Validation

- `abbey docs check`: passed.
- `git diff --check`: passed.
- Commands and warning behavior were grounded in the successful real August 2
  seven-plant update, validation, publication, and 149-page site build.

## Lessons Learned

The operational workflow needs to document absence and correction paths, not
only the successful path. Explicit rules for unknown plants, existing updates,
incoming originals, generated outputs, and coordinated date changes prevent
the most likely maintenance mistakes.

## Next Steps

- Use the runbook for the next individual and batch plant update.
- Refine it only when normal use demonstrates a changed or missing procedure.

## Notes

The runbook intentionally does not invent automation for historical backfill or
revision; those remain manual until their behavior is separately designed and
validated.
