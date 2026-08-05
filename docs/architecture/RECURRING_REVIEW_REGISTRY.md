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

---

## Related Documents

- `docs/architecture/ARCHITECTURE_PRINCIPLES.md`
- `docs/architecture/SESSION_FRAMEWORK.md`
- `docs/architecture/WORKFLOW_ENGINE.md`
- `docs/planning/BACKLOG.md`
