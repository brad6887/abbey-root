# Abbey Root Next

Last Reviewed: 2026-07-23

# Current Theme

## Build with the Framework

# Primary Objective

Implement the first controlled Abbey Research artifact-creation workflow using the completed Voice Analysis chains as reference fixtures.

# Definition of Done

The first implementation phase is complete when:

- `abbey research create --type observation` orchestrates generation, normalization, sanitization, and validation.
- Each run records model, prompt, parent, input, and fingerprint provenance before generation.
- Raw model output remains immutable and inspectable.
- Generated candidates remain outside canonical research directories.
- Failed stages retain their outputs and report a clear state.
- Regression tests prove source citations survive the complete candidate workflow.

## Current Objective

Implement Phase 1 of the approved Abbey Research artifact-creation architecture.

## Definition of Done

The implementation is complete when:

- The observation candidate workflow has one safe entry point.
- Run workspaces and manifests are deterministic and inspectable.
- Existing component commands are reused rather than duplicated.
- Canonical promotion is explicitly out of scope for this phase.
- Focused regression tests and existing Abbey Research tests pass.

---

# Completed Foundation

## Corpus Foundation

Completed:

- CORPUS-001 formalizes the Facebook source corpus.
- Source locations, normalization, identifiers, limitations, and provenance are documented.

## Experiment Alignment

Completed:

- EXP-001 formalizes Experiment 001.
- EXP-001 references CORPUS-001.
- Existing experiment outputs remain traceable.

## Artifact Workflow Validation

Three complete formal artifact chains now exist:

### Deadpan Delivery

- OBS-001
- EVID-001
- HYP-001
- VAL-001

### Concise Expression

- OBS-002
- EVID-002
- HYP-002
- VAL-002

### Recurring Narrative Elements

- OBS-003
- EVID-003
- HYP-003
- VAL-003

These reference fixtures demonstrate the expected artifact lifecycle:

Observation

↓

Evidence

↓

Hypothesis

↓

Validation

---

# Current Phase — Artifact Creation Phase 1

## Objective

Implement a controlled observation-candidate workflow before automating canonical promotion or downstream research stages.

## Implementation Scope

### Run Initialization

Create a dedicated run workspace and record:

- Project.
- Artifact type.
- Corpus and experiment.
- Model and prompt version.
- Input paths and fingerprints.
- Initial run state.

### Candidate Pipeline

Orchestrate the existing:

- `abbey research run`
- `abbey research normalize --type observation`
- `abbey research sanitize`
- Observation validation

### Safety Boundary

The creation command must:

- Preserve raw output.
- Retain failed candidates.
- Refuse canonical output paths.
- Avoid assigning an OBS identifier.
- Report the run state and review-ready candidate path.

### Tests

Prove:

- Provenance is written before generation.
- Source identifiers survive the pipeline.
- Failure states preserve artifacts.
- Existing outputs are protected.
- Voice Analysis conclusions are not hard-coded into orchestration.

---

# Future Phases

## Canonical Promotion

After observation candidate orchestration is stable:

- Add explicit human review records.
- Allocate canonical identifiers at promotion time.
- Add `abbey research promote`.
- Protect canonical directories from every other creation command.

## Evidence Creation

After promotion is safe:

- Add evidence-specific candidate structure.
- Verify corpus identifiers, dates, and exact quotations.
- Verify score ranges and summary arithmetic.
- Validate against EVID-001, EVID-002, and EVID-003.

## Hypothesis and Validation Creation

After evidence creation is validated:

- Add stage-specific candidate schemas.
- Require promoted parent artifacts.
- Preserve human authority over confidence and outcome.

## Research Status

The deterministic `abbey research status` architecture is complete.

Implementation remains useful, but artifact creation is the current human-directed priority.

## Voice Analysis Expansion

After creation, promotion, and validation tooling is stable:

- Review additional time periods.
- Review additional writing formats.
- Search systematically for counterexamples.
- Increase or reduce hypothesis confidence based on evidence.

## Voice Model Development

Create the first Voice Model only after:

- Multiple hypotheses have broader validation.
- Counterexamples are documented.
- Confidence levels are meaningful.
- Shared higher-level characteristics can be justified.
