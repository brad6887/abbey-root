# Research Artifact Types

## Purpose

This document defines the standard artifact types used within the Voice Analysis methodology.

Artifact types provide a common vocabulary for research objects and define the purpose, inputs, and expected outputs of each stage.

---

# Artifact Lifecycle

Voice Analysis research follows this artifact lifecycle:

```text
Corpus
    |
    v
Experiment
    |
    v
Observation
    |
    v
Evidence
    |
    v
Hypothesis
    |
    v
Validation
    |
    v
Voice Model
    |
    v
Derived Output

```text

Each artifact should maintain traceability to the artifacts that produced it.

---

# Corpus

## Purpose

A Corpus represents the source material available for research.

## Inputs

- Original source material
- Collection metadata
- Import process

## Outputs

- Normalized corpus
- Corpus inventory
- Source references

## Examples

- Facebook posts
- Blog archives
- Technical documentation
- Personal writing collections

---

# Experiment

## Purpose

An Experiment defines a controlled application of the methodology.

An experiment answers a specific research question using a defined corpus and process.

## Inputs

- Corpus
- Research question
- Methodology

## Outputs

- Observations
- Evidence
- Research findings

## Examples

- Initial Facebook voice analysis
- Comparison of technical and personal writing

---

# Observation

## Purpose

An Observation records a pattern noticed in the corpus.

Observations describe what appears in the source material without attempting to explain why it occurs.

## Inputs

- Corpus
- Experiment results

## Outputs

- Candidate patterns
- Research questions
- Evidence candidates

## Requirements

Observations should include:

- Description
- Corpus references
- Supporting examples
- Limitations

---

# Evidence

## Purpose

Evidence documents specific source material supporting or contradicting an observation.

Evidence connects observations back to the corpus.

## Inputs

- Observation
- Corpus entries

## Outputs

- Evidence assessment
- Supporting examples
- Counterexamples

## Requirements

Evidence should include:

- Source identifier
- Date
- Excerpt
- Assessment

---

# Hypothesis

## Purpose

A Hypothesis proposes an explanation for an observed writing characteristic.

A hypothesis is testable and should be capable of being disproven.

## Inputs

- Observation
- Evidence

## Outputs

- Testable research claim

## Requirements

Hypotheses should include:

- Description
- Supporting evidence
- Contradicting evidence
- Confidence
- Open questions

---

# Validation

## Purpose

Validation evaluates whether a hypothesis continues to explain the available evidence.

Validation attempts to find evidence that challenges the hypothesis.

## Inputs

- Hypothesis
- Evidence
- Corpus

## Outputs

- Validation result
- Revised hypothesis
- Confidence assessment

## Possible Outcomes

- Validated
- Provisionally Supported
- Revised
- Split
- Rejected

---

# Voice Model

## Purpose

A Voice Model is the accumulated understanding of an author's writing characteristics.

It represents validated patterns rather than isolated observations.

## Inputs

- Validated hypotheses
- Evidence
- Validation history

## Outputs

- Writing characteristics
- Style guidance
- Derived outputs

---

# Derived Output

## Purpose

Derived Outputs are applications created from the Voice Model.

They should not introduce unsupported characteristics.

## Inputs

- Voice Model

## Examples

- Style guide
- Writing assistant prompt
- Editing guidelines
- Research report

---

# Artifact Relationships

Every artifact should identify:

- Parent artifacts
- Source corpus
- Creation method
- Validation status

The goal is that every conclusion can be traced back through the artifact chain.

---

# Success Criteria

A successful artifact model allows a researcher to understand:

- What type of artifact they are reviewing
- Where it came from
- How it was created
- What evidence supports it
- What stage of research it represents
