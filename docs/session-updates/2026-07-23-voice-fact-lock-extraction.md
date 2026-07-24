---
title: Voice Fact-Lock Extraction
date: 2026-07-23
session: voice-fact-lock-extraction
status: complete
reviewed: false
type: session-update
tags:
  - abbey-root
  - research
  - voice-analysis
  - voice-model
  - fact-lock
---

# Voice Fact-Lock Extraction

## Objective

Build and validate the upstream process that converts new writing requests
into reviewed fact locks before VOICE-MODEL-001 generation.

## Work Completed

Created:

- a five-request extraction evaluation,
- initial-proposal and review-revision prompts,
- a generic application prompt,
- a generic semantic-verification prompt,
- proposal validation and normalization,
- hash-bound approval promotion,
- grouped lexical anchors for compound propositions,
- quote-aware lexical comparison,
- eight machine-readable human review records,
- an accepted proposal, approved lock, generation result, and semantic result,
- and a reusable workflow guide.

## Evaluation Requests

The suite covered:

1. Ordinary Facebook post
2. Edit with factual preservation
3. Callback with one authorized invented milestone
4. Sensitive cancellation message
5. Two-sentence factual notice

## Review History

The AI proposal required multiple review cycles. Rejections caught:

- style targets and prohibitions not copied,
- missing callback context,
- an unspecified milestone treated as an existing fact,
- brittle full-sentence anchors,
- output constraints represented as facts,
- numeric format values incorrectly treated as content,
- schema-key regressions,
- compound relationships changed by over-splitting facts,
- overbroad case-insensitive regex behavior,
- and natural quote punctuation rejected by lexical checks.

An initially approved lock then failed end-to-end generation. That failure
correctly reopened upstream review instead of being repaired after generation.

## Final Result

VOICE-FACT-LOCK-002:

```text
Proposal structural validation:  PASS
Human proposal review:            PASS
Hash-bound promotion:             PASS
Generation deterministic gate:    5 / 5 PASS
Semantic verification:            5 / 5 PASS
Human proposition review:         5 / 5 PASS
```

## Decision

The upstream process is operational as a review-gated workflow.

Fully automatic extraction is not approved. Structural validation cannot
prove that facts are complete or relationships are preserved, and semantic
verification remains advisory.

## Suggested Next Step

Expose this workflow through an Abbey command that creates a scoped working
directory, runs proposal validation, and prints the exact artifact requiring
human review. Approval must remain an explicit separate action.
