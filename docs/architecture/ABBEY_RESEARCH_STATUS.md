---
artifact_id: ARCH-ABBEY-RESEARCH-STATUS
artifact_type: architecture
title: Abbey Research Status
version: 1
status: draft

created:
  date: 2026-07-22
  author: Brad Cooke
  method: AI-assisted design
---

# Abbey Research Status

## Purpose

Define a deterministic, read-only workflow for discovering formal research artifacts and reporting their current relationships, completeness, and health.

The initial implementation target is:

    abbey research status

The command will use the completed Voice Analysis artifact chains as reference implementations while remaining reusable across future Abbey research projects.

## Scope

The initial design covers:

- Discovery of formal research artifacts.
- Parsing required artifact metadata.
- Mapping artifact relationships.
- Identifying complete and incomplete research chains.
- Reporting duplicate identifiers.
- Reporting missing or unresolved references.
- Presenting research status in a readable command-line format.

The initial design does not cover:

- Generating research artifacts.
- Interpreting evidence.
- Creating observations or hypotheses.
- Assigning confidence.
- Changing artifact status.
- Modifying files.
- Performing semantic validation of research conclusions.

## Design Principles

### Deterministic

The command must produce the same result from the same repository state.

It must not depend on:

- AI interpretation.
- Network services.
- External APIs.
- Non-version-controlled state.

### Read Only

The command must not modify research artifacts, planning documents, or repository state.

### Metadata Driven

Artifact discovery and relationship mapping must rely on formal metadata rather than assumptions based only on filenames or prose.

### Project Aware

The command should operate within the current Abbey repository and discover supported research projects under the established documentation structure.

### Reusable

The implementation must not encode Voice Analysis-specific titles, hypotheses, conclusions, or identifiers.

Voice Analysis is the first reference implementation, not the permanent boundary of Abbey Research.

### Human Authority

The command reports research state.

It does not decide whether an observation is valid, evidence is persuasive, or a hypothesis is correct.

## Research Project Discovery

Research projects are discovered beneath:

    docs/research/

Each immediate subdirectory represents a potential research project.

Example:

    docs/research/voice-analysis/

The initial command may operate across all discovered projects or accept a future project selector.

Possible future usage:

    abbey research status
    abbey research status voice-analysis

Project selection is outside the minimum initial implementation unless required by repository scale.

## Artifact Discovery

Formal research artifacts are discovered from supported directories beneath each research project.

Supported artifact locations:

    corpus/
    experiments/
    observations/
    evidence/
    hypotheses/
    validation/

Expected patterns:

    docs/research/*/corpus/*.md
    docs/research/*/experiments/*.md
    docs/research/*/observations/*.md
    docs/research/*/evidence/*.md
    docs/research/*/hypotheses/*.md
    docs/research/*/validation/*.md

A Markdown file is considered a formal artifact only when its YAML frontmatter contains the required artifact metadata.

Directory placement alone does not make a file a formal artifact.

This prevents supporting documents such as the following from being interpreted as artifacts:

    README.md
    EVIDENCE.md
    HYPOTHESES.md
    methodology notes
    experiment summaries

## Required Metadata

Every formal research artifact must contain:

    artifact_id
    artifact_type
    title
    version
    status

Example:

    artifact_id: OBS-001
    artifact_type: observation
    title: Deadpan Delivery
    version: 1
    status: draft

The initial status command should report an artifact as invalid when one or more required fields are missing.

## Supported Artifact Types

The initial supported artifact types are:

| Artifact Type | Expected Identifier |
|---|---|
| corpus | CORPUS-* |
| experiment | EXP-* |
| observation | OBS-* |
| evidence | EVID-* |
| hypothesis | HYP-* |
| validation | VAL-* |

Identifier prefixes provide a consistency check but do not replace the `artifact_type` field.

An artifact whose identifier and declared type disagree should be reported as invalid or inconsistent.

Example:

    artifact_id: OBS-004
    artifact_type: evidence

## Directory and Type Consistency

Artifact type should agree with the containing directory.

Examples:

| Directory | Expected Type |
|---|---|
| corpus | corpus |
| experiments | experiment |
| observations | observation |
| evidence | evidence |
| hypotheses | hypothesis |
| validation | validation |

A mismatch should be reported without preventing other valid artifacts from being discovered.

## Research Context

Artifacts may identify their research context through:

    source:
      corpus: CORPUS-001
      experiment: EXP-001

The `source.corpus` field should resolve to a discovered artifact whose type is `corpus`.

The `source.experiment` field should resolve to a discovered artifact whose type is `experiment`.

Context references should be validated separately from direct parent relationships.

## Relationship Resolution

Direct dependencies are declared through:

    source:
      parent_artifacts:
        - OBS-001
        - EVID-001

Each parent reference is compared with the complete index of discovered formal artifact identifiers.

When a parent reference matches a discovered artifact identifier, it becomes a formal dependency edge.

Example:

    OBS-001 → EVID-001
    EVID-001 → HYP-001
    HYP-001 → VAL-001

The internal model must preserve all declared parent relationships.

It must not assume that the research graph is always a simple linear chain.

For example:

    HYP-001

may depend on both:

    OBS-001
    EVID-001

And:

    VAL-001

may depend on both:

    HYP-001
    EVID-001

## Provenance References

Current Voice Analysis artifacts also contain references to earlier informal experiment files.

Examples:

    OBSERVATION004-deadpan-delivery
    EVIDENCE004-deadpan-delivery

These references currently appear in `parent_artifacts` even though they are not formal artifact identifiers.

The initial command should classify non-resolving parent entries as unresolved provenance references rather than automatically treating them as broken formal dependencies.

Example output:

    INFO Provenance reference: OBSERVATION004-deadpan-delivery

This distinction preserves historical traceability while avoiding false failures.

## Provenance Ambiguity

The current metadata model does not explicitly distinguish:

- Formal parent artifacts.
- Historical or legacy source artifacts.

A possible future metadata structure is:

    source:
      corpus: CORPUS-001
      experiment: EXP-001

      parent_artifacts:
        - OBS-001

      legacy_artifacts:
        - OBSERVATION004-deadpan-delivery

The initial `abbey research status` implementation should not require migration to this structure.

The ambiguity should be documented and reported conservatively.

## Artifact Index

The command should build an in-memory index keyed by `artifact_id`.

Each index entry should include at least:

- Artifact identifier.
- Artifact type.
- Title.
- Status.
- Version.
- File path.
- Research project.
- Corpus reference.
- Experiment reference.
- Parent references.
- Parsed metadata validity.

The index is the source of truth for relationship resolution during a command run.

## Duplicate Identifiers

Artifact identifiers must be unique across the discovery scope.

If multiple files declare the same `artifact_id`, the command should report all conflicting paths.

Example:

    FAIL Duplicate artifact identifier: OBS-001
         docs/research/voice-analysis/observations/OBS-001.md
         docs/research/other-project/observations/OBS-001.md

The initial implementation must decide whether identifier uniqueness is:

- Global across all Abbey research projects.
- Scoped to an individual research project.

The recommended initial rule is global uniqueness.

Global identifiers make cross-project references possible and avoid ambiguity in future reporting.

## Chain Model

The status command should internally model a dependency graph rather than forcing artifacts into a predetermined sequence.

The expected Voice Analysis lifecycle is:

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

However, actual dependency edges may include multiple parents.

The command may display a simplified chain for readability while retaining the complete graph internally.

## Expected Relationship Rules

The initial lifecycle expectations are:

### Corpus

- Has no required parent artifact.
- May serve as the source corpus for one or more experiments.

### Experiment

- Should reference one corpus.
- Has no required formal parent artifact unless a future workflow defines one.

### Observation

- Should reference one corpus.
- Should reference one experiment.
- May include legacy provenance references.
- Does not require a formal observation parent.

### Evidence

- Should reference one corpus.
- Should reference one experiment.
- Should reference at least one observation.
- May include legacy provenance references.

### Hypothesis

- Should reference one corpus.
- Should reference one experiment.
- Should reference at least one observation or evidence artifact.
- The current reference implementation uses both.

### Validation

- Should reference one corpus.
- Should reference one experiment.
- Should reference at least one hypothesis.
- May also reference supporting evidence.

These rules describe expected lifecycle relationships without evaluating research quality.

## Chain States

### Complete

A chain is complete when it includes:

- A valid corpus.
- A valid experiment referencing that corpus.
- An observation referencing that experiment and corpus.
- Evidence referencing the observation.
- A hypothesis referencing the relevant observation or evidence.
- Validation referencing the hypothesis.

Example:

    CORPUS-001
      EXP-001
        OBS-001
          EVID-001
            HYP-001
              VAL-001

### Incomplete

A chain is incomplete when valid artifacts exist but an expected later lifecycle artifact is absent.

Examples:

    OBS-004
      EVID-004
      Missing hypothesis
      Missing validation

or:

    OBS-005
      Missing evidence

Incomplete chains are not necessarily errors.

They may represent legitimate work in progress.

### Broken

A chain is broken when a formal reference appears intended to resolve to another formal artifact but does not.

Example:

    HYP-004
      parent_artifacts:
        - EVID-999

The command should distinguish broken formal references from unresolved legacy provenance where possible.

### Orphaned

An artifact is orphaned when it is not connected to the expected research context or lifecycle.

Examples:

- Evidence with no observation parent.
- Hypothesis with no evidence or observation parent.
- Validation with no hypothesis parent.
- Experiment referencing a missing corpus.

An artifact may still be valid Markdown with complete metadata while being orphaned in the dependency graph.

### Duplicate

A duplicate state occurs when multiple files declare the same artifact identifier.

Duplicate identifiers prevent reliable relationship resolution.

### Invalid

An artifact is invalid when:

- Required metadata is missing.
- YAML frontmatter cannot be parsed.
- Artifact type is unsupported.
- Identifier prefix conflicts with artifact type.
- Directory conflicts with artifact type.
- Required source metadata is missing.

### Provenance Only

A reference is provenance-only when it does not resolve to a formal artifact but appears to refer to historical research material.

This state should be informational unless future metadata rules make the distinction explicit.

## Status Severity

Suggested severity levels:

| Severity | Meaning |
|---|---|
| OK | Valid and complete |
| INFO | Valid, informational, or provenance-related |
| WARN | Incomplete, inconsistent, or unresolved |
| FAIL | Invalid metadata, duplicate identifiers, or broken required relationships |

The command should continue reporting other artifacts after encountering warnings or failures.

## Command Output

Initial output should follow existing Abbey command conventions.

Example:

    ========================================
     Abbey Research Status
    ========================================

    Date: Wed Jul 22 08:30:00 PM CDT 2026
    Repo: /home/bcooke/git/abbey-root

    Research Projects
    -----------------
    OK   voice-analysis

    Artifacts
    ---------
    OK   Corpus:      1
    OK   Experiments: 1
    OK   Observations: 3
    OK   Evidence:     3
    OK   Hypotheses:   3
    OK   Validations:  3

    Artifact Chains
    ---------------
    OK   OBS-001 → EVID-001 → HYP-001 → VAL-001
    OK   OBS-002 → EVID-002 → HYP-002 → VAL-002
    OK   OBS-003 → EVID-003 → HYP-003 → VAL-003

    Provenance References
    ---------------------
    INFO OBS-001 → OBSERVATION004-deadpan-delivery
    INFO EVID-001 → EVIDENCE004-deadpan-delivery

    Summary
    -------
    Complete chains:   3
    Incomplete chains: 0
    Broken references: 0
    Invalid artifacts: 0

## Detailed Output

The initial command may provide concise default output and reserve expanded artifact detail for a future option.

Possible future usage:

    abbey research status --verbose
    abbey research status --project voice-analysis
    abbey research status --json

These options are not required for the first implementation.

## Exit Status

Suggested exit behavior:

| Result | Exit Status |
|---|---:|
| All artifacts valid; complete or legitimately incomplete | 0 |
| Warnings such as incomplete chains or unresolved provenance | 1 |
| Invalid metadata, duplicate identifiers, or broken required references | 2 |

This follows the broader Abbey pattern of distinguishing healthy, warning, and failure states.

The exact convention should be reviewed against existing Abbey commands before implementation.

## Error Handling

The command should be failure tolerant.

A malformed artifact must not prevent valid artifacts from being reported.

For each unreadable or invalid file, report:

- Path.
- Error category.
- Relevant field when known.
- Whether relationship resolution was affected.

Example:

    FAIL Invalid YAML frontmatter
         docs/research/voice-analysis/evidence/EVID-004.md

## Determining Formal Versus Legacy References

The first implementation should use this conservative rule:

1. If a parent reference matches a discovered formal `artifact_id`, treat it as a formal dependency.
2. If it does not match, report it as an unresolved provenance reference.
3. Do not classify an unresolved reference as broken solely from its spelling.
4. Report expected formal relationships separately when lifecycle rules require them.

Example:

An evidence artifact with:

    parent_artifacts:
      - OBSERVATION004-deadpan-delivery

has provenance, but no formal observation dependency.

The evidence artifact may therefore be:

    INFO Provenance reference present
    WARN Missing formal observation parent

This preserves both facts.

## Migration Progress

Migration progress should only be reported when a deterministic source count exists.

The command must not infer total migration work from arbitrary prose or filenames.

Possible future sources include:

- Explicit migration metadata.
- Experiment manifests.
- Registered expected artifacts.
- Structured project configuration.

Until such a source exists, the command should report discovered formal artifacts and chains without claiming a percentage complete.

## Configuration

The initial implementation should prefer convention over configuration.

Possible future configuration location:

    config/research/research.yml

Potential configuration could define:

- Artifact directories.
- Supported artifact types.
- Identifier prefixes.
- Lifecycle expectations.
- Project scopes.
- Legacy provenance patterns.

Configuration should not be added until practical usage demonstrates a need.

## Implementation Boundary

This document defines design behavior only.

Implementation should begin only after reviewing:

- Artifact discovery rules.
- Metadata requirements.
- Relationship rules.
- Chain-state definitions.
- Command output.
- Exit behavior.

The first implementation should remain small and deterministic.

A likely implementation structure is:

    tools/bin/abbey-research
    scripts/abbey_research_status.py
    tests/test-abbey-research-status.sh

The exact structure should follow existing Abbey CLI registration and testing conventions.

## Validation Strategy

The implementation should be tested against fixtures representing:

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

The existing three Voice Analysis chains provide the initial real-world validation case.

Synthetic fixtures should be used for failures and edge cases rather than corrupting real research artifacts.

## Recommendation Engine Finding

During planning reconciliation for this design session, practical use of `abbey next` showed that broad token overlap can assign equal scores to several loosely related research backlog items.

This caused backlog order to determine the selected recommendation even though `NEXT.md` named a specific current objective.

This is outside the scope of `abbey research status`, but it provides evidence for the existing backlog item:

    Continue replacing broad token matching with stronger project-state relationships.

Human direction in `NEXT.md` remains authoritative.

## Future Extensions

Potential future capabilities include:

- `abbey research validate`
- `abbey research scaffold`
- Dependency graph output.
- JSON output.
- Project filtering.
- Artifact detail views.
- Migration manifests.
- Research dashboards.
- Integration with the Abbey Wallboard.
- Research history reporting.
- Provenance-specific metadata.
- Artifact status transitions.
- Corpus fingerprint reporting.

Future automation must preserve the principle:

> Humans record observations and make research judgments; automation manages structure, relationships, and state.
