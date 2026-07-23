---
artifact_id: JOURNAL-2026-07-23-MOBILE-UPLOAD-LOCATION-METADATA-FILTER
artifact_type: journal-entry
title: Mobile Upload Location Metadata Filter
version: 1
status: draft

date: 2026-07-23
category: platform
tags:
  - voice-analysis
  - corpus
  - platform-artifacts
  - regression-testing

created:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted platform improvement
---

# Mobile Upload Location Metadata Filter

## Summary

Recurring-narrative review exposed thirty-three generated `Mobile uploads Place:` records that had passed through the first voice-eligibility filter.

A narrow anchored exclusion now classifies them as location metadata.

## Result

The corrected derived view contains:

- 1,469 eligible posts.
- 18 review records.
- 1,552 excluded records.
- 1,342 unflagged eligible posts across eleven chronological batches.

The final batch contains 92 posts. The first three batch fingerprints are unchanged; eight later fingerprints changed because the removed records occurred later in the timeline.

## Evidence Integrity

None of the 51 unique citations across EVID-001 through EVID-003 was removed.

The six evidence and validation artifacts advance to Version 3 to preserve the corrected counts and resolved limitation. Their outcomes and confidence levels do not change.

## Lesson

Platform cleanup should use observed, regression-tested patterns rather than broad guesses.

The anchored rule removes the generated prefix while preserving authored sentences that happen to mention similar words.

## Next Step

Validate and commit the completed platform-improvement increment.
