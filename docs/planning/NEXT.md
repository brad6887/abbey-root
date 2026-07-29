# Abbey Root Next

Last Reviewed: 2026-07-28

# Current Theme

## Build with the Framework

# Primary Objective

Validate the completed Abbey Research observation-candidate workflow through a
real non-canonical research run.

# Success Criteria

The workflow-validation session is complete when:

- One real observation-candidate run completes outside canonical research
  directories.
- Its manifest accurately records model, prompt, corpus, experiment, inputs,
  fingerprints, commands, timestamps, artifacts, and stage results.
- Raw output remains immutable and inspectable.
- Source citations survive normalization and sanitization.
- The candidate passes structural validation and is review-ready.
- Any workflow defects discovered through real use are fixed and
  regression-tested.
- No candidate is promoted into canonical research.
- The session records whether Phase 2 review-record and promotion design is
  ready to begin.

## Current Objective

Exercise `abbey research create --type observation` with a real,
non-canonical input.

## Definition of Done

The validation is complete when:

- A real run reaches `review-ready` or exposes a documented workflow defect.
- Provenance and output immutability are verified directly from the run
  workspace.
- Candidate citations and required observation sections are verified.
- Any blocking defect is corrected with focused regression coverage.
- Canonical promotion remains explicitly out of scope.

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

Four complete formal artifact chains now exist:

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

### Quoted Language

- OBS-004
- EVID-004
- HYP-004
- VAL-004

These reference fixtures demonstrate the expected artifact lifecycle:

Observation

↓

Evidence

↓

Hypothesis

↓

Validation

---

# Current Priorities

## Current Phase — Observation Workflow Validation

## Objective

Validate the completed observation-candidate workflow through normal Abbey
Research use before designing canonical promotion or downstream research
stages.

## Implementation Scope

### Real Candidate Run

Run `abbey research create --type observation` with:

- A real non-canonical research prompt.
- Declared project, corpus, and experiment context.
- At least one source input containing traceable citations.
- A configured local model.

### Workspace Inspection

Verify:

- Prompt and input snapshots match their recorded fingerprints.
- Stage commands, timestamps, results, and artifact paths are inspectable.
- Raw output is read-only.
- The normalized and sanitized candidate preserves citations.
- Structural validation produces a review-ready result.

### Safety Boundary

The validation session must:

- Keep every generated artifact outside canonical research directories.
- Avoid assigning an OBS identifier.
- Avoid creating review approval or promotion records.
- Retain the run workspace if a stage fails.

### Tests

If normal use exposes a defect:

- Fix only the demonstrated workflow blocker.
- Add focused regression coverage.
- Rerun the Abbey Research suite and `abbey review`.

---

# Future Direction

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

The initial deterministic, read-only `abbey research status` implementation is complete for the current repository happy path.

Refinement for invalid, incomplete, duplicate, and broken artifact states remains deferred. Artifact creation is the current human-directed priority.

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

---

# Guiding Principle

Validate framework workflows through real, non-canonical use before expanding
their automation or promoting generated artifacts into authoritative sources.
