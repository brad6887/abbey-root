# Planning Document Schema

## Purpose

This document defines the planning architecture used by Abbey Root.

Planning documents serve two audiences:

- Developers, who need concise project information.
- Automation, which relies on stable document structures for reliable parsing.

Planning documents are not simply documentation—they are interfaces consumed by the Abbey toolkit and future AI workflows.

Changes to document structure should therefore be treated as interface changes.

---

# Planning Architecture

Abbey Root planning follows a layered model.

```
Ideas
        ↓
Backlog
        ↓
Next
        ↓
Development Session
        ↓
Session Update
        ↓
abbey-review
        ↓
Planning Documents
        ↓
Journal
```

Each document has a distinct purpose.

Information should move forward through the system rather than being duplicated.

---

# General Principles

Planning documents should be:

- Easy for people to read.
- Easy for automation to parse.
- Stable over time.
- Predictable in structure.
- Focused on facts rather than narrative.
- Derived from authoritative information whenever practical.

---

# Formatting Standards

Planning documents should:

- Use Markdown.
- Use consistent heading levels.
- Prefer lists over long paragraphs.
- Keep section names stable.
- Avoid tables unless they provide significant value.
- Use one bullet style consistently.
- Prefer concise, structured statements.

---

# Planning Documents

## PROJECT_STATUS.md

### Purpose

Provides a snapshot of the current state of the project.

### Primary Audience

Developers

Automation

### Required Sections

- Project Snapshot
- Current Session
- Overall Status
- Immediate Priorities
- Infrastructure
- Developer Toolkit
- Website
- AI Platform
- Documentation
- Recent Accomplishments
- Current Challenges
- Next Major Milestones
- Project Metrics
- Project Health

---

## NEXT.md

### Purpose

Defines the current execution plan.

Unlike the backlog, this document should remain intentionally small and focused on near-term work.

### Required Sections

- Primary Goal
- High Priority
- Abbey Toolkit
- Self-Documenting Platform
- BradCooke.com
- Infrastructure
- AI
- Stretch Goals
- Notes

---

## BACKLOG.md

### Purpose

Maintains the inventory of known work that has not yet been scheduled.

The backlog represents possibilities rather than commitments.

### Recommended Sections

- High Priority
- Infrastructure
- Developer Toolkit
- Self-Documenting Platform
- Recurring Reviews
- BradCooke.com
- AI
- Automation
- Communications
- Abbey Doctor Ideas

Additional sections may be added as the project evolves.

---

## ROADMAP.md

### Purpose

Describes long-term capabilities and major milestones.

Roadmap items should represent architectural progress rather than individual tasks.

---

## VISION.md

### Purpose

Defines the long-term architectural direction of Abbey Root.

The Vision should evolve slowly and describe enduring principles instead of implementation details.

---

## IDEAS.md

### Purpose

Captures brainstorming ideas before they are evaluated.

Typical lifecycle:

```
Ideas
        ↓
Backlog
        ↓
Next
        ↓
Development
        ↓
Session Update
        ↓
abbey-review
        ↓
Planning Documents
        ↓
Journal
```

---

# Session Updates

Session updates are operational documents.

Their purpose is to capture completed work once during a development session.

They become the primary input to `abbey-review`.

Planning documents summarize many session updates.

---

# Journal Entries

Journal entries are historical publications.

Unlike planning documents, they are intended primarily for people rather than automation.

---

# Generated Documentation

Generated documentation should never be edited manually.

Whenever practical, documentation should be regenerated from authoritative project metadata.

---

# Consumers

Planning documents are intended to be consumed by:

- Developers
- `abbey session`
- `abbey-end`
- `abbey-review`
- `abbey status`
- `abbey doctor`
- `abbey ai`
- Website generation
- Future automation

All consumers should rely on stable section names while allowing document content to evolve.

---

# Versioning

Changing document structure is an interface change.

When planning document schemas change:

- Update this document.
- Update affected toolkit commands.
- Update AI prompts.
- Update documentation generators.
- Update planning validation.

---

# Philosophy

Planning documents are the shared language of Abbey Root.

They provide a stable interface between developers, documentation, automation, and AI.

By writing structured information once and allowing multiple systems to consume it, Abbey Root reduces duplication, improves consistency, and becomes increasingly project-aware over time.
