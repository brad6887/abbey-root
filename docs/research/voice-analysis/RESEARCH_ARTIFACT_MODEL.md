# Research Artifact Model

## Purpose

This document defines the common identity, provenance, execution, and validation requirements shared by all Voice Analysis research artifacts.

The purpose of research artifact metadata is to make every artifact:

- Traceable
- Reproducible
- Explainable
- Reviewable

Metadata describes how an artifact relates to its source material, methodology, and previous research stages.

---

# Design Principles

## 1. Every Artifact Has Identity

Every research artifact should have a stable identity independent of its filename or location.

An artifact should answer:

- What is this?
- When was it created?
- What version is it?
- What research stage does it represent?

---

## 2. Preserve the Chain of Evidence

Every artifact should maintain traceability back to the original corpus.

The research chain is:

```text
Raw Source Material
        |
        v
Corpus
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
Derived Outputs
        |
        v
```text

Each stage should identify the artifacts that produced it.

---

## 3. Separate Artifact Identity From Creation Method

An artifact is defined by what it represents, not how it was created.

AI is one possible research tool.

Human-created and AI-assisted artifacts should follow the same metadata model.

Example:

    artifact_type: observation

    created_by:
      type: ai
      model: gpt-oss:20b

or:

    artifact_type: observation

    created_by:
      type: human

Both represent the same research artifact type.

---

# Artifact Identity

Every artifact should define:
