---
title: Full-Corpus Observation Discovery
date: 2026-07-23
session: full-corpus-observation-discovery
status: complete
reviewed: false
type: session-update
tags:
  - abbey-root
  - research
  - voice-analysis
  - ai-worker
  - deterministic-validation
---

# Full-Corpus Observation Discovery

## Objective

Build and run the missing open-ended workflow that lets the local AI worker
inspect the complete eligible Facebook corpus for observations beyond the
three existing formal chains.

## Definition of Done

- Define a bounded batch-discovery artifact.
- Require machine-readable candidates and exact citations.
- Validate corpus identity, batch membership, and citation text.
- Run discovery across all corrected chronological batches.
- Review and cluster the resulting candidates.
- Produce a prioritized backlog without automatic promotion.
- Capture reusable platform improvements and regression coverage.

## Work Completed

Added:

- `full-corpus-observation-discovery.md`, an open-ended batch prompt.
- `validate_discovery_manifest.py`, a deterministic discovery validator.
- `abbey research validate-discovery`.
- `abbey research run --max-tokens N`.
- `DISCOVERY_WORKFLOW.md`.
- `CANDIDATE_BACKLOG.md`.
- `DISCOVERY-REVIEW-001.json`.

The existing generation limit of 6,144 tokens caused difficult batches to
return an empty response after using the full allowance for model reasoning.
The new `--max-tokens` option preserves 6,144 as the default while allowing
larger, explicit budgets for discovery runs.

## Discovery Run

The local `gpt-oss:20b` worker reviewed:

- 1,469 voice-eligible posts,
- 11 deterministic chronological batches,
- and the frozen corpus fingerprint
  `b5dc53ffc11c19a18fd0b2fe9450ff91de03a24f905cd503d21c6a2daabdf07e`.

Results:

- 33 provisional batch candidates,
- 92 retained exact citations,
- 11 of 11 batch manifests passing validation.

Four initial manifests contained citation issues. Review removed two
ID-and-text mismatches, corrected one transcribed source identifier, and
replaced quotation or character-copy differences with corpus-authoritative
text. All corrected manifests then passed.

## Review Result

The strongest new candidates are:

- quoted language as a comic framing device,
- and hashtags as punchlines or closing commentary.

Reusable first-person openings and wordplay were retained for targeted review.

Other candidates were related to OBS-001, OBS-002, or OBS-003; classified as
topic or platform context; or held for more evidence.

No candidate was automatically promoted.

## Validation

Regression suite:

```text
Passed: 35
Failed: 0
```

Discovery validation:

```text
Batch manifests passed: 11
Batch manifests failed: 0
```

## Suggested Next Step

Start with the highest-priority new cluster, quoted language as a comic
framing device. Build a complete corpus candidate set and decide whether it
warrants OBS-004.

