# Workflow Engine

## Purpose

Defines the generic workflow execution engine for Abbey Root.

The Workflow Engine provides orchestration for repeatable engineering workflows while keeping project-specific business logic separate from the framework.

## Scope

The Workflow Engine is responsible for coordinating workflow execution from request intake through reporting and documentation.

It does not define the business logic for individual workflows. That logic belongs in workflow implementations that conform to the Workflow Contract.

## Execution Model

```text
Request
    ↓
Prepare
    ↓
Validate
    ↓
Plan
    ↓
Execute
    ↓
Verify
    ↓
Report
    ↓
Document
    ↓
Archive
```

## Engine Responsibilities

The Workflow Engine provides:

- standard workflow lifecycle
- stage orchestration
- status tracking
- validation hooks
- reporting hooks
- documentation hooks
- consistent execution output
- common error handling
- future integration with request tracking

## Workflow Responsibilities

Individual workflows provide:

- metadata
- workflow-specific preparation
- workflow-specific validation
- execution logic
- verification logic
- report data
- documentation updates

## Design Direction

The Workflow Engine should be separated into reusable framework components rather than embedded in individual scripts.

Potential components:

- Workflow Runtime
- Workflow Contract
- Stage Definitions
- Report Interface
- Documentation Interface
- Archive Interface

## Relationship to Sessions

Sessions provide the human-facing development workflow.

The Workflow Engine provides the automation-facing execution workflow.

The two should remain aligned, but they are not the same thing.

## Relationship to Reporting

Workflows should produce structured report data.

The Reporting Framework should handle rendering and delivery.

This keeps workflows focused on results instead of presentation or transport.

## Open Questions

- Should the engine be implemented as shell scripts, Python, or a hybrid?
- Should workflows be implemented as command modules, plug-ins, or structured directories?
- How much state should the engine manage?
- Should request intake be represented as files, GitHub Issues, or another tracking system?
- Which workflow stages are required, and which are optional?
- How should workflow failures be captured and reported?

## Related Documents

- Engineering Framework
- Workflow Contract
- Session Framework
- Reporting Framework
- CLI Framework
- Architecture Principles

## Status

Draft
