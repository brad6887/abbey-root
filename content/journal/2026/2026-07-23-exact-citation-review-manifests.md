---
artifact_id: JOURNAL-2026-07-23-EXACT-CITATION-REVIEW-MANIFESTS
artifact_type: journal-entry
title: Exact Citation Validation and Review Manifests
version: 1
status: draft

date: 2026-07-23
category: platform
tags:
  - research
  - citations
  - review-manifest
  - validation

created:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted platform improvement
---

# Exact Citation Validation and Review Manifests

## Summary

Abbey Research can now validate that a reviewed `FB-######` citation and its complete quoted text refer to the same frozen-corpus record.

Human decisions are preserved in JSON review manifests rather than existing only in prose aggregates.

## Why

Earlier Voice Analysis runs produced plausible-looking failures:

- A valid identifier paired with text from another post.
- An invented identifier.
- Shortened generated quotations.
- Correct candidate retrieval followed by manual decisions that were difficult to validate automatically.

Identifier-presence validation alone could not detect all of these failures.

## Result

Three canonical-selection manifests preserve:

- 43 review items.
- 56 exact citations.
- Supporting, contradictory, and comparison roles.
- Retained and provisional decisions.
- Human-review notes.
- Model, prompt, reviewer, date, corpus identity, and corpus fingerprint.

All three manifests pass deterministic validation against CORPUS-001.

## Lesson

Citation integrity requires validating the relationship between identifier and text, not merely checking that both appear somewhere.

Review coverage must also be explicit. A canonical evidence selection is useful and verifiable, but it is not the same claim as a complete accounting of every generated candidate.

## Next Step

Validate and commit the completed research-platform increment.
