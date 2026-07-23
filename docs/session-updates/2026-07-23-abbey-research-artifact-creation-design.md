---
artifact_id: SESSION-2026-07-23-ABBEY-RESEARCH-ARTIFACT-CREATION-DESIGN
artifact_type: session-update
title: Abbey Research Artifact Creation Design
version: 1
status: completed
reviewed: false

created:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted design
---

# Abbey Research Artifact Creation Design

## Objective

Design the controlled process that creates canonical observation, evidence, hypothesis, and validation artifacts without manually converting additional legacy Experiment 001 files.

## Definition of Done

- Candidate creation and canonical promotion are separate operations.
- Observation, evidence, hypothesis, and validation stage contracts are defined.
- Human research decisions remain explicit review gates.
- Identifier, provenance, relationship, and citation rules are documented.
- The first implementation slice is small enough to validate before expanding.
- Existing Voice Analysis chains are treated as fixtures rather than migration work.

## Work Completed

Created:

- `docs/architecture/ABBEY_RESEARCH_ARTIFACT_CREATION.md`

The architecture defines:

- A persistent run workspace and state model.
- Immutable raw model output.
- Candidate generation, normalization, sanitization, and validation.
- Human review and explicit canonical promotion.
- Canonical identifier allocation at promotion time.
- Stage-specific contracts for OBS, EVID, HYP, and VAL artifacts.
- Structured corpus citation verification for evidence artifacts.
- Provenance for model, prompt version, inputs, fingerprints, and parents.
- Failure retention and retry behavior.
- A phased implementation sequence.

## Direction Correction

The completed Voice Analysis artifact chains were previously described in a way that could imply continued manual migration.

Brad clarified that their purpose is to validate the desired output and guide tooling design.

This session therefore does not create a fourth formal chain or repair another legacy evidence file. It designs the process that will create future canonical artifacts.

## Key Decisions

### Candidate and Canonical Artifacts Are Different

AI-generated or normalized output remains under:

    working/research/runs/<run-id>/

Only an explicit promotion command may write to canonical research directories.

### Each Research Stage Has a Human Gate

Abbey automates mechanics and deterministic checks.

Humans retain authority over:

- Research questions.
- Evidence relevance and scoring.
- Hypothesis approval.
- Validation outcomes.
- Confidence.

### Canonical Identifiers Are Assigned During Promotion

Run identifiers track executions.

OBS, EVID, HYP, and VAL identifiers track accepted canonical artifacts. Candidate generation does not reserve canonical identity.

### Evidence Integrity Is a First-Class Validation Layer

Evidence creation must verify:

- Source identifiers.
- Dates.
- Exact quotations.
- Corpus status.
- Duplicate citations.
- Score ranges.
- Summary arithmetic.

These checks address the integrity failures discovered in legacy Experiment 001 evidence documents without requiring manual migration of those documents.

## Initial Implementation Target

Implement:

    abbey research create --type observation

The command will orchestrate the already-proven component workflow:

    run
    → normalize
    → sanitize
    → validate

It will add:

- A run manifest.
- Input fingerprints.
- Immutable raw output.
- Safe working paths.
- A review-ready candidate.

Canonical promotion and downstream artifact creation remain later phases.

## Validation

The design was reviewed against:

- The three existing Voice Analysis artifact chains.
- The current `abbey research run`, `normalize`, `sanitize`, and `validate` commands.
- Existing observation validation behavior.
- The formal artifact metadata and relationship model.
- The deterministic research-status architecture.

Documentation validation passed:

- `git diff --check`
- Shell syntax checks
- Abbey help smoke test

The existing Abbey Research regression suite reported 16 passes and one failure on macOS. The `run` command expands an empty optional input array while `set -u` is active, causing an `unbound variable` failure before overwrite protection is reported.

This documentation-only session did not introduce the failure. Phase 1 must correct and test the portable no-input path because the new orchestration command will reuse `abbey research run`.

## Next Step

Implement and test Phase 1 from `ABBEY_RESEARCH_ARTIFACT_CREATION.md`.
