# Experiment 001 – Facebook Corpus

## Objective

Validate the Voice Analysis methodology using a normalized Facebook corpus and establish a reproducible baseline for future writing analysis experiments.

## Corpus

**Source**

- Facebook HTML Archive

**Normalization Script**

- `scripts/build_clean_corpus.py`

**Final Corpus Counts**

| Status | Count |
| --- | ---: |
| Parsed | 3,039 |
| Clean | 1,752 |
| Excluded | 1,287 |
| Review | 0 |

## Normalization

The corpus was produced from the raw Facebook archive using a deterministic normalization process.

Normalization steps included:

- Extraction of final `_2pin` post content
- Duplicate removal
- Facebook metadata removal
- Manual adjudication of seven review posts

The resulting corpus is intended to be reproducible from the original archive using the normalization script.

## Corpus Fingerprint

The evidence phase of Experiment 001 is based on the following corpus.

```text
File:
output/clean_corpus.csv

SHA-256:
b5dc53ffc11c19a18fd0b2fe9450ff91de03a24f905cd503d21c6a2daabdf07e
```

This fingerprint uniquely identifies the corpus used throughout the observation, evidence, hypothesis, and validation phases of the experiment.

## Source Identifiers

Each parsed Facebook record is assigned a numeric `source_id` during corpus construction.

Evidence documents reference posts using the display format:

```text
FB-NNNNNN
```

For example:

```text
source_id: 2631
display:   FB-002631
```

The display identifier is derived as:

```python
f"FB-{int(source_id):06d}"
```

The identifier represents the parser-assigned source identifier within the frozen corpus. It is **not**:

- the chronological position of the post,
- the position within the clean corpus,
- or the original Facebook platform identifier.

## Corpus Sampling

The sampling utility presents posts chronologically while displaying their stable source identifier.

Example output:

```text
1. [FB-002631] 2009-01-08T13:28:31

is updating his status
```

Where:

- `1` is the post's position within the displayed sample.
- `FB-002631` is the stable source identifier used for research citations.
- The timestamp determines chronological ordering.

## Evidence Citation Format

Evidence documents reference posts using the following format:

```markdown
**Source ID:** FB-002631
**Date:** 2009-01-08
**Score:** +2
```

This citation format provides stable references across observations, hypotheses, validation, and future experiments.
