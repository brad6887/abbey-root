# Artifact Metadata Standard

## Purpose

This document defines the metadata format used to identify and describe
Voice Analysis research artifacts.

Metadata provides machine-readable identity while keeping the research
content human-readable.

The metadata standard exists to support:

- Artifact discovery
- Traceability
- Validation
- Reproducibility
- Future automation

---

# Metadata Location

Artifact metadata should be stored with the artifact.

Possible implementations include:

- Markdown frontmatter
- Sidecar metadata files
- Generated manifests
- Research databases

The initial implementation uses Markdown frontmatter where practical.

---

# Required Metadata

Every artifact should define:

## Artifact Identity

```yaml
artifact_id: OBS-001
artifact_type: observation
title: Example Observation
version: 1
status: draft
```

Fields:

### artifact_id

A stable identifier assigned when the artifact is created.

The identifier should never change.

---

### artifact_type

The category of research artifact.

Allowed values:

- corpus
- experiment
- observation
- evidence
- hypothesis
- validation
- voice-model
- derived-output

---

### title

A human-readable description of the artifact.

---

### version

The current artifact revision.

---

### status

Current lifecycle state.

Suggested values:

- draft
- review
- validated
- superseded
- archived

---

# Provenance Metadata

Artifacts should identify their origin.

Example:

```yaml
source:
  corpus: CORPUS-001
  experiment: EXP-001
  parent_artifacts:
    - OBS-001
```

Fields:

### corpus

The source corpus used by the artifact.

---

### experiment

The experiment that produced the artifact.

---

### parent_artifacts

Other artifacts used to create this artifact.

---

# Creation Metadata

Artifacts should record how they were created.

Example:

```yaml
created:
  date: 2026-07-20
  author: Brad Cooke
  method: AI-assisted research
```

Fields:

### date

Creation date.

---

### author

Person or process responsible for creation.

---

### method

How the artifact was produced.

Examples:

- human-created
- AI-assisted
- automated-processing

---

# AI Metadata

AI metadata is optional.

It should only exist when AI assistance was used.

Example:

```yaml
ai:
  model: gpt-oss:20b
  tool: abbey research
  prompt: exploratory-observation.md
```

Possible fields:

- Model
- Tool
- Prompt
- Configuration

AI metadata records assistance, not authorship.

---

# Validation Metadata

Artifacts may record validation information.

Example:

```yaml
validation:
  status: passed
  validator: observation-validator
  date: 2026-07-20
```

Possible fields:

- Validation status
- Validator
- Date
- Results

---

# Example Artifact

```yaml
---
artifact_id: OBS-001
artifact_type: observation
title: Fragmented is Status Updates
version: 1
status: draft

source:
  corpus: CORPUS-001
  experiment: EXP-001

created:
  date: 2026-07-20
  author: Brad Cooke
  method: AI-assisted

ai:
  model: gpt-oss:20b
  tool: abbey research
  prompt: exploratory-observation.md

validation:
  status: passed
  validator: observation-validator
  date: 2026-07-20
---
```

---

# Design Rules

## Metadata Must Not Replace Content

Metadata identifies an artifact.

The research content remains the primary source of meaning.

---

## Metadata Must Be Stable

Artifact identifiers should not change because:

- Content is revised
- Formatting changes
- Tools change
- Models change

---

## Metadata Must Be Reproducible

A future researcher should be able to understand:

- What created this artifact
- What sources it used
- What process was followed
- What validation occurred

---

# Future Automation

This metadata model may later support:

- Artifact indexing
- Dependency graphs
- Automated validation
- Research dashboards
- AI-assisted research workflows
