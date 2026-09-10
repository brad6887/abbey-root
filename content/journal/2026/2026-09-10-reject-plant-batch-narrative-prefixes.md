---
title: "Reject Plant Batch Narrative Prefixes"
description: "Prevent worksheet narrative markers from reaching plant histories."
date: 2026-09-10
session_update: "docs/session-updates/2026-09-10-reject-plant-batch-narrative-prefixes.md"
draft: false
tags:
  - Abbey Root
---

# Reject Plant Batch Narrative Prefixes

## Summary

The recent multi-plant walkthrough exposed a small validation gap: replacing a
worksheet prompt with a real observation could leave its `REQUIRED:` marker at
the beginning of the published prose. The earlier cleanup corrected the affected
histories; this session addressed the process that allowed the marker through.

Plant batch validation and apply now share one check that rejects the generated
prefix at the start of an included narrative. Normal prose can still contain
the word required.

## Accomplishments

- Added the shared prefix check without changing the generated worksheet format.
- Verified placeholder rejection and accepted prose with focused regression
  tests, including protection against partial batch writes.
- Updated the multi-plant runbook to explain prefix removal and validation.
- Clarified that plants skipped for no photos are omitted from the worksheet
  and need no placeholder entry.
- Preserved the existing canonical plant material and incoming photographs.

## Lessons Learned

A placeholder can be partly replaced and still look like completed input. A
prefix check catches that failure while leaving legitimate prose alone. Sharing
the rule between validation and apply keeps both paths consistent.

## Next Steps

Use the clarified runbook for the next plant batch. This session does not publish
either website; detailed validation results are recorded in the linked session
update.
