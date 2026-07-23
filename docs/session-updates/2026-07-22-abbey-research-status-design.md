---
artifact_id: SESSION-2026-07-22-ABBEY-RESEARCH-STATUS-DESIGN
artifact_type: session-update
title: Abbey Research Status Design
version: 1
status: draft

created:
  date: 2026-07-22
  author: Brad Cooke
  method: AI-assisted design
---

# Abbey Research Status Design

## Objective

Design a deterministic, read-only `abbey research status` workflow using the completed Voice Analysis artifact chains as reference implementations.

## Definition of Done

The session is complete when:

- Existing research artifacts can be discovered deterministically.
- Corpus, experiment, observation, evidence, hypothesis, and validation relationships are defined.
- Complete, incomplete, broken, orphaned, duplicate, and invalid states are distinguishable.
- Expected `abbey research status` output is documented.
- Research status reporting remains read-only and does not generate research conclusions.
- Planning documents reflect the current research-status direction.
- The design is reviewed before implementation begins.

## Work Completed

Created:

- `docs/architecture/ABBEY_RESEARCH_STATUS.md`

Updated:

- `docs/planning/NEXT.md`
- `docs/planning/PROJECT_STATUS.md`
- `docs/planning/BACKLOG.md`

The planning documents now identify deterministic research status reporting as the current human-directed objective.

## Planning Reconciliation

The previous `NEXT.md` objective still described the completed Voice Analysis corpus-foundation phase.

The document was updated to reflect:

- Completion of CORPUS-001.
- Completion of EXP-001.
- Completion of three formal research artifact chains.
- The transition from manual artifact migration to research tooling design.
- The future order of research validation, scaffolding, Voice Analysis expansion, and Voice Model development.

`PROJECT_STATUS.md` was updated so its immediate priorities and near-term milestones align with the new objective.

`BACKLOG.md` was reorganized and the research-status design work was added under:

- Developer Toolkit
- Abbey Research
- Status and Visibility

## Backlog Cleanup

The backlog received a limited organizational cleanup while preserving its existing content and intent.

Changes included:

- Normalizing actionable entries as Markdown checkboxes.
- Moving the research-status item into the Abbey Research section.
- Correcting the Project-Aware Recommendations heading level.
- Organizing Abbey Research work into:
  - Status and Visibility
  - Validation and Workflow
  - Provenance and Methodology
- Converting the Request Intake Framework objective into a trackable backlog item.
- Cleaning inconsistent spacing and separators.

## Artifact Discovery Design

Formal research artifacts will be discovered beneath:

- `docs/research/*/corpus/`
- `docs/research/*/experiments/`
- `docs/research/*/observations/`
- `docs/research/*/evidence/`
- `docs/research/*/hypotheses/`
- `docs/research/*/validation/`

A Markdown file will be considered a formal artifact only when its frontmatter contains the required metadata:

- `artifact_id`
- `artifact_type`
- `title`
- `version`
- `status`

Directory placement alone will not make a Markdown file a formal artifact.

This prevents supporting files such as `README.md`, `EVIDENCE.md`, and `HYPOTHESES.md` from being treated as research artifacts.

## Relationship Model

Research context is declared through:

- `source.corpus`
- `source.experiment`

Direct dependencies are declared through:

- `source.parent_artifacts`

Relationship resolution will use the complete index of discovered formal `artifact_id` values.

The implementation must preserve all declared dependency edges rather than assuming every research chain is strictly linear.

The expected lifecycle remains:

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

However, hypotheses and validations may contain multiple formal parents.

## Provenance References

The completed Voice Analysis artifacts include historical references such as:

- `OBSERVATION004-deadpan-delivery`
- `EVIDENCE004-deadpan-delivery`

These references currently appear in `parent_artifacts`, but they do not resolve to formal artifact identifiers.

The design distinguishes:

- Formal artifact dependencies.
- Historical or legacy provenance references.

The initial command will report unresolved legacy references conservatively rather than automatically treating them as broken.

Recommended behavior:

- Report unresolved legacy provenance as informational.
- Report a separate warning when a required formal lifecycle parent is missing.
- Do not require immediate metadata migration.

A future metadata model may introduce a separate field such as `legacy_artifacts`.

## Artifact States

The architecture defines the following deterministic states:

### Complete

A valid chain contains corpus, experiment, observation, evidence, hypothesis, and validation relationships.

### Incomplete

Valid artifacts exist, but one or more later lifecycle artifacts have not yet been created.

Incomplete work is not automatically an error.

### Broken

A required formal reference does not resolve to a discovered formal artifact.

### Orphaned

An artifact is not connected to its expected research context or lifecycle.

### Duplicate

Multiple files declare the same artifact identifier.

### Invalid

Required metadata is missing, malformed, unsupported, or inconsistent with the artifact directory or identifier prefix.

### Provenance Only

A reference appears to identify historical research material but does not resolve to a formal artifact.

## Status Severity

The proposed status levels are:

- `OK` for valid and complete state.
- `INFO` for valid informational or provenance-related state.
- `WARN` for incomplete, inconsistent, or unresolved state.
- `FAIL` for invalid metadata, duplicate identifiers, or broken required relationships.

The command should remain failure tolerant and continue reporting valid artifacts after encountering warnings or failures.

## Command Output Design

The proposed command is:

    abbey research status

Initial output should report:

- Discovered research projects.
- Artifact counts by type.
- Formal artifact chains.
- Chain completeness.
- Provenance references.
- Broken references.
- Invalid artifacts.
- A final summary.

Potential future options include:

    abbey research status --verbose
    abbey research status --project voice-analysis
    abbey research status --json

These options are outside the initial implementation scope.

## Migration Progress

The design explicitly avoids inventing migration percentages.

Migration progress should only be reported when Abbey has a deterministic source for the expected artifact count, such as:

- A structured experiment manifest.
- Explicit migration metadata.
- Registered expected artifacts.
- Project configuration.

Until then, the command should report discovered artifacts and chains without claiming a percentage complete.

## Implementation Boundary

This session completed architecture and planning only.

No command implementation was started.

A likely future implementation structure is:

- `tools/bin/abbey-research`
- `scripts/abbey_research_status.py`
- `tests/test-abbey-research-status.sh`

The exact structure should follow existing Abbey CLI registration and testing conventions.

## Validation Strategy

Future implementation should use synthetic fixtures for:

- One complete chain.
- Multiple complete chains.
- Missing evidence.
- Missing hypothesis.
- Missing validation.
- Broken corpus reference.
- Broken experiment reference.
- Missing parent artifact.
- Legacy provenance reference.
- Duplicate artifact identifier.
- Invalid YAML.
- Missing required metadata.
- Directory and type mismatch.
- Identifier and type mismatch.
- Non-artifact Markdown files in artifact directories.

The existing three Voice Analysis chains will serve as the first real-world validation case.

## Recommendation Engine Finding

Practical use of `abbey next` during planning reconciliation exposed a recommendation-engine limitation.

The current primary objective was correctly parsed from `NEXT.md`, but broad token overlap assigned the same score to several loosely related research backlog items.

The research-status candidate, research normalization work, provenance work, and unrelated artifact-export work all received equal support from the same project-status phrase.

Backlog order then determined the selected recommendation.

This confirms the need for the existing backlog item:

- Continue replacing broad token matching with stronger project-state relationships.

The finding does not change the authority of `NEXT.md`.

Human direction remained the basis for this session.

## Validation

Completed:

- Reviewed formal metadata for CORPUS-001.
- Reviewed formal metadata for EXP-001.
- Reviewed the OBS-001, EVID-001, HYP-001, and VAL-001 dependency chain.
- Confirmed the same metadata pattern across all three formal Voice Analysis chains.
- Confirmed that the dependency graph can be constructed from frontmatter.
- Ran `git diff --check`.
- Reviewed planning changes.
- Reviewed repository status and change scope.
- Ran `abbey next` after planning reconciliation.
- Inspected raw recommendation candidate scores.

## Files Changed

Created:

- `docs/architecture/ABBEY_RESEARCH_STATUS.md`

Modified:

- `docs/planning/BACKLOG.md`
- `docs/planning/NEXT.md`
- `docs/planning/PROJECT_STATUS.md`

## Outcome

The design phase is complete.

Abbey now has a documented architecture for deterministic research status reporting based on real artifact relationships rather than a hypothetical workflow.

The design preserves human authority over research judgments while assigning discovery, relationship mapping, and state reporting to deterministic automation.

## Next Steps

Implement the first deterministic `abbey research status` command from the approved architecture.

The next implementation session should:

- Register the command through existing Abbey CLI conventions.
- Build artifact discovery and frontmatter parsing.
- Create the artifact index.
- Resolve formal relationships.
- Report the three existing Voice Analysis chains.
- Add synthetic regression fixtures for invalid and incomplete states.
- Validate output and exit behavior before expanding scope.
