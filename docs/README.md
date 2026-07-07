# Abbey Root Documentation

Welcome to the Abbey Root documentation.

Abbey Root is a self-documenting, project-aware development platform that combines infrastructure, documentation, automation, and AI into a single cohesive system.

This documentation is organized by purpose so that both developers and automation can reliably locate and consume project information.

---

# Documentation Organization

The documentation is organized into several categories.

## Guides

Guides explain how to use and contribute to Abbey Root.

Examples include:

- Getting Started
- Environment Overview
- Session Workflow
- Documentation Standards

---

## Planning

Planning documents describe the current state and future direction of the project.

These documents are intentionally structured and follow stable schemas so they can be consumed by both developers and the Abbey toolkit.

Planning documents include:

- Vision
- Roadmap
- Project Status
- Next
- Backlog
- Ideas

---

## Architecture

Architecture documents describe the reusable engineering frameworks and design principles that underpin Abbey Root.

These documents define how the project is organized internally and provide the reference architecture for reusable engineering components.

Examples include:

- Architecture Principles
- Engineering Framework
- Documentation Framework
- CLI Framework
- Session Framework
- Workflow Engine
- Workflow Contract
- Reporting Framework

---

## Reference

Reference documentation describes the environment, standards, and implementation details.

Examples include:

- Planning Schema
- Hardware
- Backup Strategy
- External Services

---

## Runbooks

Runbooks describe repeatable operational procedures.

Examples include:

- Network Interface Migration

---

## Generated Documentation

Generated documentation is produced automatically from authoritative project metadata.

Generated documents should **never** be edited manually.

If generated documentation is incorrect, update the automation that produces it rather than editing the generated files.

---

## Session Updates

Session updates capture completed work during development sessions.

Unlike planning documents, they are temporary operational records.

Completed session updates become input for `abbey-review`, which reconciles completed work into the long-term planning documents.

---

## Journal

The project journal preserves the historical record of Abbey Root.

Journal entries document:

- Accomplishments
- Design decisions
- Lessons learned
- Problems encountered
- Significant milestones

The journal provides the historical narrative of the project and serves as published content for BradCooke.com.

---

# Information Flow

Project information moves through the documentation system rather than being duplicated.

```text
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

This workflow captures project knowledge once and allows long-term documentation to evolve through structured review.

---

# Documentation Principles

Abbey Root documentation follows several guiding principles.

- Write information once.
- Generate whenever practical.
- Maintain a single source of truth.
- Keep planning documents machine-readable.
- Prefer small, focused documents.
- Preserve stable document structures.
- Record significant architectural decisions.
- Preserve project history through journal entries.

---

# Regenerating Documentation

Generated documentation can be rebuilt from the repository root:

```bash
./scripts/ansible-docs.sh
```

As Abbey Root evolves, additional documentation will be generated directly from project metadata rather than maintained manually.
