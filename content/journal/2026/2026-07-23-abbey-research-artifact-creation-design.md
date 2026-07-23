---
artifact_id: JOURNAL-2026-07-23-ABBEY-RESEARCH-ARTIFACT-CREATION-DESIGN
artifact_type: journal-entry
title: Abbey Research Artifact Creation Design
version: 1
status: draft

date: 2026-07-23
category: research
tags:
  - abbey-research
  - voice-analysis
  - architecture
  - provenance
  - validation

created:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted design
---

# Abbey Research Artifact Creation Design

## Summary

The three completed Voice Analysis artifact chains were never intended to establish a manual conversion queue.

They were prototypes that demonstrated the desired canonical lifecycle:

    OBS → EVID → HYP → VAL

The useful next step is to turn the lessons from those prototypes into a controlled creation process.

## Work Completed

Designed an Abbey Research workflow that separates:

- Candidate generation.
- Structural normalization.
- Deterministic sanitization.
- Metadata and citation validation.
- Human research review.
- Canonical promotion.

The design gives each research attempt a persistent run workspace containing its source fingerprints, model and prompt provenance, raw output, normalized output, candidate, validation results, and review record.

## Why the Separation Matters

AI output is useful for proposing research artifacts, but it should not become canonical merely because its Markdown is well formed.

The workflow therefore treats a candidate and an accepted artifact as different things.

Only explicit promotion may write to canonical research directories.

## Human Authority

Abbey can verify whether:

- A source identifier exists.
- A date and quotation match the corpus.
- Metadata is complete.
- Parent artifacts resolve.
- Scores and totals are internally consistent.

Abbey cannot deterministically decide whether:

- Evidence is representative.
- A score is persuasive.
- A hypothesis is the best explanation.
- Confidence is justified.
- A validation outcome should be accepted.

Those remain human review decisions.

## Initial Implementation

The first implementation should orchestrate the existing observation workflow:

    abbey research create --type observation

This vertical slice will prove run manifests, provenance, immutable raw output, safe working paths, and review-ready candidates before Abbey adds canonical promotion or downstream artifact stages.

Validation also found that the current `abbey research run` command fails on the Mac when no optional input files are supplied because its empty array is expanded under `set -u`. The first implementation phase must repair this portability issue before using the command as an orchestration primitive.

## Lesson

The completed chains are most valuable as executable expectations.

Their purpose is not to encourage more hand-built artifacts. Their purpose is to teach Abbey how to create future artifacts safely, consistently, and transparently.
