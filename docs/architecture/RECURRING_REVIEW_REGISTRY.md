# Recurring Review Registry

## Purpose

Defines the architecture for a reusable recurring review registry within Abbey Root.

The Recurring Review Registry provides a consistent framework for defining, tracking, and surfacing recurring reviews across Abbey projects.

---

## Scope

The Recurring Review Registry standardizes:

- recurring review definitions
- review categories
- review scheduling metadata
- review evidence tracking
- integration points with Abbey workflows

The registry does not define the implementation details of individual reviews.

Individual reviews remain responsible for their specific purpose, validation criteria, and completion requirements.

---

## Status

Design

---

## Design Principles

The Recurring Review Registry follows the principles defined in:

- `docs/architecture/ARCHITECTURE_PRINCIPLES.md`

Key principles:

### Single Source of Truth

Recurring review definitions should exist in one authoritative location rather than being duplicated across planning documents, session notes, or external reminders.

### Separate Framework from Implementation

The registry defines the structure and lifecycle of recurring reviews.

Individual review implementations define the specific validation steps, evidence requirements, and outcomes.

### Validate Before Automating

The review model should be validated through real usage before introducing automated scheduling, notifications, or enforcement.

---

## Registry Responsibilities

The Recurring Review Registry provides:

- consistent review definitions
- review ownership
- review frequency tracking
- review history references
- evidence location tracking
- future workflow integration points

The registry does not:

- replace the Abbey backlog
- replace project task management
- automatically complete reviews
- enforce work completion

---

## Review Definition Model

A recurring review definition contains:

| Field | Purpose |
|---|---|
| Name | Human-readable review identifier |
| Category | Review classification |
| Purpose | Reason the review exists |
| Frequency | Expected review interval |
| Owner | Responsible person or team |
| Evidence | Expected completion records |
| Status | Current review definition state |

Initial review categories may include:

- Documentation
- Infrastructure
- Security
- Dependencies
- AI

Additional categories should be added only when a recurring need is identified.

---

## Review Occurrences

A recurring review definition represents an ongoing responsibility.

Individual review occurrences represent completed instances of that responsibility.

A review occurrence should capture:

- execution date
- findings
- resulting actions
- evidence references

Example evidence:

- session updates
- journal entries
- commits
- validation records

Lifecycle:

```text
Review Definition
        |
        v
Scheduled Occurrence
        |
        v
Review Execution
        |
        v
Evidence Captured
        |
        v
Next Occurrence Scheduled
```

---

## Relationship to Sessions

Sessions provide the human-facing workflow for completing engineering work.

The Recurring Review Registry identifies recurring work that may need attention.

Sessions provide the process for:

- performing the review
- documenting findings
- creating evidence
- capturing resulting changes

The registry should provide context to sessions without replacing the session workflow.

---

## Relationship to Backlog

Recurring reviews and backlog items represent different types of work.

Recurring reviews represent ongoing responsibilities.

Backlog items represent discrete work required to improve or change the system.

A recurring review may create backlog items when findings require implementation work.

---

## Review Definition Storage

Recurring review definitions should be stored as individual Markdown documents with YAML frontmatter.

The review definition documents are the authoritative source for recurring review metadata.

A separate registry index should only be introduced if future scale requires it.

---

## Review Occurrence Storage

Review occurrences represent completed executions of recurring review definitions.

Occurrence artifacts are stored separately from recurring definitions:

docs/reviews/occurrences/

Each occurrence is an individual Markdown document with YAML frontmatter.

The occurrence artifact records:

- review definition reference
- execution date
- completion status
- findings
- resulting actions
- evidence references

Recurring definitions remain stable while occurrences accumulate over time.

Example:

docs/reviews/
├── recurring/
│   └── documentation-audit.md
└── occurrences/
    └── 2026-08-06-documentation-audit.md

---

## Storage Decision

Recurring review definitions are stored under:

docs/reviews/recurring/

Each review definition is an individual Markdown document with YAML frontmatter.

Completed review occurrences are stored under:

docs/reviews/occurrences/

Review occurrences are separate artifacts from review definitions. Definitions describe the recurring responsibility; occurrences record completed executions and evidence.

A separate registry index should only be introduced if future scale requires it.

---

## Future Integration

Future Abbey commands may consume the registry to provide workflow awareness.

Potential integration:

```
abbey session
```

may display:

- reviews due now
- upcoming reviews
- recent review history

Automation should provide awareness and guidance without preventing normal work.

---

## Open Questions

- Should registry data be stored as Markdown, YAML, or another structured format?
- Should review occurrences be stored separately from review definitions?
- How should review frequency be calculated?
- How should completed reviews be associated with sessions and commits?
- Should external projects be able to define their own recurring reviews?
- Should occurrence artifacts require a standard template?
- Should occurrence discovery calculate next due dates automatically?

---

## Related Documents

- `docs/architecture/ARCHITECTURE_PRINCIPLES.md`
- `docs/architecture/SESSION_FRAMEWORK.md`
- `docs/architecture/WORKFLOW_ENGINE.md`
- `docs/planning/BACKLOG.md`
