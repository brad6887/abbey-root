# Abbey Root Next

Last Reviewed: 2026-07-22

# Current Theme

## Build with the Framework

# Primary Objective

Design a deterministic Abbey Research status workflow using the completed Voice Analysis artifact chains as reference implementations.

# Definition of Done

The research status design phase is complete when:

- Existing research artifacts can be discovered deterministically.
- Corpus, experiment, observation, evidence, hypothesis, and validation relationships are defined.
- Complete, incomplete, broken, and orphaned artifact chains are distinguishable.
- Expected `abbey research status` output is documented.
- Research status reporting remains read-only and does not generate conclusions.
- The design is reviewed before implementation begins.

## Current Objective

Design a deterministic Abbey Research status workflow using the completed Voice Analysis artifact chains as reference implementations.

## Definition of Done

The research status design phase is complete when:

- Existing research artifacts can be discovered deterministically.
- Corpus, experiment, observation, evidence, hypothesis, and validation relationships are defined.
- Complete, incomplete, broken, and orphaned artifact chains are distinguishable.
- Expected `abbey research status` output is documented.
- Research status reporting remains read-only and does not generate conclusions.
- The design is reviewed before implementation begins.

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

These migrations demonstrated that the artifact lifecycle is repeatable:

Observation

↓

Evidence

↓

Hypothesis

↓

Validation

---

# Current Phase — Research Status Design

## Objective

Define how Abbey discovers and reports the current state of formal research artifacts.

## Design Questions

### Artifact Discovery

Define:

- Supported artifact directories.
- Required metadata.
- Artifact identifier rules.
- Duplicate identifier behavior.
- Invalid or unreadable artifact behavior.

### Relationship Mapping

Define how Abbey maps:

- Corpus to experiment.
- Experiment to observation.
- Observation to evidence.
- Evidence to hypothesis.
- Hypothesis to validation.

Relationships should be derived from artifact metadata rather than filenames alone.

### Chain Status

Define deterministic states for:

- Complete chains.
- Incomplete chains.
- Broken references.
- Orphaned artifacts.
- Duplicate artifacts.
- Invalid metadata.

### Command Output

Design expected output for:

abbey research status

The command should report:

- Corpus artifacts.
- Experiment artifacts.
- Formal research chains.
- Chain completeness.
- Broken or missing relationships.
- Migration progress where it can be determined safely.

### Scope Boundary

The command must remain:

- Read-only.
- Deterministic.
- Project-aware.
- Independent of Voice Analysis-specific conclusions.

The command must not:

- Generate observations.
- Create hypotheses.
- Assign confidence.
- Interpret evidence.
- Modify research artifacts.

---

# Future Phases

## Research Validation

After status reporting is implemented:

- Add deterministic artifact validation.
- Detect missing metadata.
- Detect broken parent references.
- Detect duplicate identifiers.
- Evaluate a reusable `abbey research validate` workflow.

## Artifact Scaffolding

Only after status and validation workflows are stable:

- Evaluate `abbey research scaffold`.
- Generate empty artifact structure.
- Preserve human control of research conclusions.

## Voice Analysis Expansion

After tooling is stable:

- Continue formal artifact migration.
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
