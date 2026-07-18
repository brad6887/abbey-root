# Evidence Format Standard

## Purpose

Evidence documents provide reproducible support for observations made during voice analysis.

Each evidence document evaluates a single observation using examples drawn from a normalized corpus.

The objective is not to prove an observation correct. The objective is to measure how well the available evidence supports or contradicts the observation.

---

# Document Structure

Every evidence document follows the same structure.

```text
Observation

Scoring

Evidence Log

Summary

Current Assessment
```

---

# Observation

Restate the observation being evaluated.

Example:

> Observation 004 proposes that the author frequently presents absurd or impossible situations using an ordinary, matter-of-fact tone.

---

# Scoring

Every evidence item receives a score.

| Score | Meaning |
|------:|---------|
| +2 | Strongly supports the observation |
| +1 | Mildly supports the observation |
| 0 | Neutral / not applicable |
| -1 | Mildly contradicts the observation |
| -2 | Strongly contradicts the observation |

A score of **0** is expected to occur frequently.

Evidence should only receive a negative score when it genuinely contradicts the observation, not simply because it does not demonstrate the characteristic being evaluated.

---

# Evidence Log

Each evidence item uses the following format.

```markdown
### FB-002631

**Date:** 2009-01-08

**Score:** +2

**Post**

> is updating his status

**Analysis**

Explain why this post supports, contradicts, or is neutral with respect to the observation.
```

## Evidence Identifier

The heading is always the stable corpus identifier.

Example:

```text
FB-002631
```

The identifier remains stable regardless of document edits or evidence ordering.

Evidence entries are never numbered.

---

# Summary

Summarize the distribution of scores.

Example:

| Score | Count |
|------:|------:|
| +2 | 5 |
| +1 | 2 |
| 0 | 7 |
| -1 | 1 |
| -2 | 0 |

Include the weighted score calculation.

Example:

```text
Weighted Score: +11

Calculation:

(5 × +2)
+ (2 × +1)
+ (7 × 0)
+ (1 × -1)
+ (0 × -2)
=
+11
```

---

# Current Assessment

Summarize what the evidence demonstrates.

The assessment should describe:

- the current strength of the observation,
- notable counterexamples,
- limitations,
- whether additional evidence is needed.

Assessments should describe the current state of the evidence rather than reaching permanent conclusions.

---

# Evidence Selection

Evidence should be selected from across the corpus.

Avoid selecting only supporting examples.

Strong evidence includes:

- supporting examples,
- neutral examples,
- contradictory examples when present.

The objective is to accurately characterize the observation rather than maximize its score.

---

# Citation Policy

Every evidence entry must reference the stable corpus identifier.

Example:

```text
FB-002631
```

These identifiers provide reproducible references across:

- observations,
- evidence,
- hypotheses,
- validation,
- future publications.

---

# Revision Policy

Evidence documents are living research artifacts.

They may be revised when:

- additional corpus evidence is discovered,
- observations are refined,
- contradictory evidence is identified,
- the scoring methodology evolves.

Every revision should improve the reproducibility and explanatory power of the evidence without changing historical corpus identifiers.
