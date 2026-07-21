---
artifact_id: CORPUS-001
artifact_type: corpus
created:
  author: Brad Cooke
  date: 2026-07-20
  method: AI-assisted research
status: draft
title: Brad Facebook Writing Corpus
version: 1
---

# Corpus

## Description

CORPUS-001 represents the normalized Facebook writing corpus used for
Voice Analysis Experiment 001.

The corpus contains a reproducible collection of Facebook posts
extracted from the original Facebook HTML archive and processed through
a deterministic normalization workflow.

## Source

Source Material:

- Facebook HTML Archive

Original source material is maintained separately from the normalized corpus.

The normalized corpus should be reproducible from the original archive using the documented normalization process.

## Collection

Collection Method:

-   Facebook data export

## Normalization

Normalization Process:

-   Script: scripts/build_clean_corpus.py

Normalization steps included:

-   Extraction of final `_2pin` post content.
-   Duplicate removal.
-   Facebook metadata removal.
-   Manual review of seven ambiguous posts.

## Corpus Statistics

  Status       Count
  ---------- -------
  Parsed       3,039
  Clean        1,752
  Excluded     1,287
  Review           0

## Corpus Fingerprint

Normalized Corpus:

output/clean_corpus.csv

SHA-256:

b5dc53ffc11c19a18fd0b2fe9450ff91de03a24f905cd503d21c6a2daabdf07e

## Source Identifiers

Research citations use:

FB-NNNNNN

Example:

FB-002631

The identifier represents the parser-assigned source identifier within
the frozen corpus.

## Quality Assessment

Current Assessment:

Representative sample.

Strengths:

-   Large historical range.
-   Authentic personal writing.
-   Multiple topics and contexts.

Limitations:

-   Limited to Facebook writing.
-   May not represent all writing formats.
-   Audience and platform influence may affect style.

## Relationship to Experiments

Experiments using this corpus:

-   EXP-001 --- Facebook Corpus

## Future Expansion

Future corpus versions may include:

-   Abbey Root journals
-   Technical documentation
-   Blog articles
-   Other writing formats
