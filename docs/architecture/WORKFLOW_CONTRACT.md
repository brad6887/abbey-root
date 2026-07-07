# Workflow Contract

## Purpose

Defines the standard interface implemented by every workflow.

The Workflow Contract allows workflows to plug into the Workflow Engine while keeping workflow-specific logic separate from orchestration.

## Scope

The Workflow Contract specifies the lifecycle stages, required metadata, and expected outputs for workflows that execute within the Workflow Engine.

## Contract Model

Every workflow should provide:

- metadata
- preparation
- validation
- planning
- execution
- verification
- reporting
- documentation

## Required Metadata

Each workflow should define:

- workflow name
- workflow description
- owner or maintainer
- supported environment
- required inputs
- expected outputs
- validation requirements
- reporting capabilities
- documentation targets

## Lifecycle Stages

```text
metadata
    ↓
prepare
    ↓
validate
    ↓
plan
    ↓
execute
    ↓
verify
    ↓
report
    ↓
document
```

## Stage Responsibilities

### Metadata

Describes the workflow and its requirements.

### Prepare

Collects inputs and prepares the environment for execution.

### Validate

Confirms that prerequisites, inputs, tools, and environment assumptions are correct.

### Plan

Determines what actions will be taken before execution begins.

### Execute

Performs the workflow-specific work.

### Verify

Confirms that the workflow completed successfully.

### Report

Produces structured report data for the Reporting Framework.

### Document

Identifies documentation updates, generated artifacts, or archive records created by the workflow.

## Design Principle

The Workflow Engine orchestrates.

The Workflow Contract defines the interface.

The workflow implementation provides the business logic.

## Open Questions

- Which stages should be required for every workflow?
- Which stages may be optional?
- What format should workflow metadata use?
- Should workflow contracts be represented as shell functions, YAML, JSON, Python classes, or structured directories?
- How should workflow input validation be standardized?
- How should workflows declare report outputs?

## Related Documents

- Workflow Engine
- Reporting Framework
- Session Framework
- CLI Framework
- Engineering Framework
- Architecture Principles

## Status

Draft
