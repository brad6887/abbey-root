# Reporting Framework

## Purpose

Defines how structured report data is rendered and delivered.

The Reporting Framework allows workflows to produce reusable report data without embedding presentation or delivery logic into individual workflows.

## Scope

The Reporting Framework separates report data, report rendering, and report delivery into reusable components.

## Reporting Model

```text
Workflow
    ↓
Report Data
    ↓
Report Model
    ↓
Renderer
    ↓
Delivery Method
```

## Framework Responsibilities

The Reporting Framework provides:

- standard report data structure
- reusable report models
- rendering interfaces
- delivery interfaces
- report archive patterns
- common report metadata
- consistent report output formats

## Workflow Responsibilities

Workflows provide:

- structured report data
- report status
- summary information
- findings
- errors or warnings
- links to generated artifacts
- recommended follow-up actions

## Renderers

Potential renderers include:

- Markdown
- HTML
- CSV
- XLSX
- PDF

## Delivery Methods

Potential delivery methods include:

- email
- Markdown archive
- CSV export
- HTML output
- XLSX output
- PDF output
- website publication
- Git repository
- file share
- API or webhook

## Initial Implementation Direction

Email delivery should be tested first in the Abbey Root lab.

The goal is not to create a one-off email report feature.

The goal is to prove a reusable report delivery pattern that can later be adopted by Power Infrastructure.

## Design Principle

Workflows should produce data.

Renderers should produce presentation.

Delivery methods should transport or publish output.

Each layer should remain independent where practical.

## Open Questions

- What should the standard report data structure look like?
- Should report data be stored as JSON, YAML, Markdown front matter, or another format?
- Which renderer should be implemented first?
- Should delivery configuration be global, per workflow, or per report?
- How should failed deliveries be captured?
- Should reports be archived automatically after delivery?

## Related Documents

- Engineering Framework
- Workflow Engine
- Workflow Contract
- CLI Framework
- Architecture Principles

## Status

Draft
