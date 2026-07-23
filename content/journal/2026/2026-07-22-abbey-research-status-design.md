---
artifact_id: JOURNAL-2026-07-22-ABBEY-RESEARCH-STATUS-DESIGN
artifact_type: journal-entry
title: Abbey Research Status Design
version: 1
status: draft

date: 2026-07-22
category: research
tags:
  - abbey-research
  - architecture
  - voice-analysis
  - metadata
  - workflow

created:
  date: 2026-07-22
  author: Brad Cooke
  method: AI-assisted design
---

# Abbey Research Status Design

## Summary

The Abbey Research workflow reached the point where additional manual Voice Analysis migrations were no longer the most useful next step.

Three complete artifact chains now exist:

- Deadpan Delivery
- Concise Expression
- Recurring Narrative Elements

Each chain follows the formal research lifecycle:

Corpus

↓

Experiment

↓

Observation

↓

Evidence

↓

Hypothesis

↓

Validation

These examples provided enough practical evidence to begin designing deterministic research tooling.

## Work Completed

Created:

- `docs/architecture/ABBEY_RESEARCH_STATUS.md`

Updated:

- `docs/planning/NEXT.md`
- `docs/planning/PROJECT_STATUS.md`
- `docs/planning/BACKLOG.md`

The planning documents now identify deterministic research status reporting as the current Abbey Research objective.

## Why Status Comes First

The manual migrations showed that artifact creation is not the difficult part of the research process.

The difficult work is deciding:

- What qualifies as an observation.
- Which examples constitute meaningful evidence.
- Whether a hypothesis is too broad.
- Whether validation has actually challenged the hypothesis.
- How much confidence the evidence justifies.

Those decisions should remain human-guided.

The first useful automation should therefore improve visibility and structural validation rather than generate research conclusions.

The proposed command is:

    abbey research status

Its role is to report the state of formal research artifacts without interpreting their content.

## Artifact Discovery

The design uses frontmatter as the authoritative source for artifact discovery.

Formal artifacts are expected beneath:

- `docs/research/*/corpus/`
- `docs/research/*/experiments/`
- `docs/research/*/observations/`
- `docs/research/*/evidence/`
- `docs/research/*/hypotheses/`
- `docs/research/*/validation/`

A file is considered a formal artifact only when it contains required metadata such as:

- `artifact_id`
- `artifact_type`
- `title`
- `version`
- `status`

This prevents general research documents such as `README.md`, `EVIDENCE.md`, and `HYPOTHESES.md` from being mistaken for formal artifacts.

## Relationship Model

The existing artifacts demonstrated that Abbey can construct the research dependency graph from frontmatter.

Research context is declared through:

- `source.corpus`
- `source.experiment`

Direct dependencies are declared through:

- `source.parent_artifacts`

The complete artifact index can therefore be used to resolve relationships deterministically.

The design does not assume every chain is strictly linear.

For example, a hypothesis may depend on both an observation and evidence, while a validation may depend on both a hypothesis and supporting evidence.

The command may display a simplified chain while retaining all relationships internally.

## Provenance and Legacy References

The Voice Analysis migration preserved references to earlier informal experiment artifacts.

Examples include:

- `OBSERVATION004-deadpan-delivery`
- `EVIDENCE004-deadpan-delivery`

These currently appear beside formal artifact identifiers under `parent_artifacts`.

The design treats unresolved historical references conservatively:

- A reference that matches a known formal `artifact_id` becomes a formal dependency.
- A reference that does not resolve is reported as provenance information.
- A missing required formal parent is reported separately.

This avoids treating intentional historical references as broken while still enforcing the formal lifecycle.

A future metadata revision may introduce a separate field for legacy artifacts, but the first implementation will not require immediate migration.

## Research States

The architecture defines several deterministic states.

### Complete

A valid chain includes the expected corpus, experiment, observation, evidence, hypothesis, and validation relationships.

### Incomplete

Valid work exists, but later lifecycle artifacts have not yet been created.

Incomplete work may simply represent normal research in progress.

### Broken

A required formal reference does not resolve.

### Orphaned

An artifact is not connected to its expected research context or lifecycle.

### Duplicate

More than one file declares the same artifact identifier.

### Invalid

Required metadata is missing, malformed, unsupported, or inconsistent.

### Provenance Only

A reference identifies historical research material but does not resolve to a formal artifact.

## Command Behavior

The proposed command will remain:

- Deterministic
- Read-only
- Metadata-driven
- Project-aware
- Reusable across research projects

It will not:

- Generate observations.
- Interpret evidence.
- Create hypotheses.
- Assign confidence.
- Modify artifact status.
- Edit repository files.

The command should report:

- Discovered research projects.
- Artifact counts by type.
- Formal artifact chains.
- Complete and incomplete states.
- Provenance references.
- Broken relationships.
- Duplicate identifiers.
- Invalid artifacts.
- A final summary.

## Planning Cleanup

The previous `NEXT.md` still described the completed corpus-foundation phase.

It was replaced with a current plan centered on research-status design.

The updated planning now records:

- Completion of CORPUS-001.
- Completion of EXP-001.
- Completion of three formal artifact chains.
- The current research-status design phase.
- Future validation, scaffolding, Voice Analysis expansion, and Voice Model phases.

The backlog also received a limited cleanup.

Actionable entries were normalized as checkboxes, heading levels were corrected, and Abbey Research work was grouped into:

- Status and Visibility
- Validation and Workflow
- Provenance and Methodology

## Recommendation Engine Finding

The session also exposed a practical limitation in `abbey next`.

The command correctly parsed the human-directed objective from `NEXT.md`, but broad token matching caused several loosely related research items to receive the same score.

Examples included:

- Research status reporting
- Research Markdown normalization
- Research provenance metadata
- Artifact export work

Because the scores were tied, backlog order determined the displayed recommendation.

This confirmed the value of the existing backlog item to replace broad token matching with stronger project-state relationships.

The result did not change the authority of `NEXT.md`.

The human-selected objective remained the basis for the session.

## Design Principle

The most important principle established during this work is:

> Humans record observations and make research judgments; automation manages structure, relationships, and state.

This keeps Abbey Research useful without allowing automation to quietly become the researcher.

## Outcome

The design phase for `abbey research status` is complete.

The architecture is based on actual formal artifacts rather than a theoretical workflow.

The next implementation can begin from:

- Proven artifact metadata.
- Three complete real-world chains.
- Defined relationship rules.
- Defined chain states.
- Defined command boundaries.
- A documented validation strategy.

## Next Steps

Implement the first deterministic `abbey research status` command.

The next session should focus on:

- CLI registration.
- Artifact discovery.
- YAML frontmatter parsing.
- Artifact indexing.
- Relationship resolution.
- Status output for the three existing Voice Analysis chains.
- Synthetic test fixtures for invalid, incomplete, duplicate, and broken states.
