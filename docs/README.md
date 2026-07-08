# Abbey Root Documentation

Welcome to the Abbey Root documentation.

Abbey Root is the reference implementation of the Abbey Framework—a reusable engineering framework for building self-documenting, AI-assisted development platforms.

The project combines infrastructure, automation, documentation, publishing, and AI into a single cohesive engineering environment. While Abbey Root is itself a working project, its larger purpose is to develop reusable engineering practices that can be adopted by future repositories.

This documentation is organized by purpose so that both developers and automation can reliably locate and consume project information.

---

# Recommended Reading Order

If you are new to Abbey Root, read the documentation in this order.

1. Guide
2. Planning
3. Framework
4. Architecture
5. Reference
6. Runbooks
7. Generated Documentation

Each section answers a different question about the project.

---

# Documentation Organization

The documentation is organized into several categories.

## Guide

The Guide provides the starting point for anyone new to the project.

Begin here before reading the technical documentation.

Typical guide documents include:

- Start Here
- Using the CLI
- Workflow
- Philosophy

The Guide explains how to work with Abbey Root rather than how it is implemented.

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

Planning documents answer the question:

> **What are we building next?**

---

## Framework

Framework documents define the reusable engineering standards shared across Abbey-style projects.

These documents describe how projects should be organized rather than how Abbey Root itself is implemented.

Examples include:

- Project Standard
- CLI Standard

As the framework evolves, additional standards will define common engineering practices, documentation, workflows, and AI integration.

Framework documents answer the question:

> **How should every Abbey-style project be built?**

---

## Architecture

Architecture documents describe how Abbey Root itself is designed and implemented.

These documents define the internal engineering frameworks and reusable technical components that make the project work.

Examples include:

- Architecture Principles
- Engineering Framework
- Documentation Framework
- CLI Framework
- Session Framework
- Workflow Engine
- Workflow Contract
- Reporting Framework

Architecture documents answer the question:

> **How does Abbey Root work?**

---

## Reference

Reference documentation describes the environment, standards, and implementation details.

Examples include:

- Planning Schema
- Hardware
- Backup Strategy
- External Services

Reference documents answer the question:

> **What information do I need while working on the project?**

---

## Runbooks

Runbooks describe repeatable operational procedures.

Examples include:

- Network Interface Migration

Runbooks document proven procedures that should be followed consistently.

---

## Generated Documentation

Generated documentation is produced automatically from authoritative project metadata.

Generated documents should **never** be edited manually.

If generated documentation is incorrect, update the automation that produces it rather than editing the generated files.

Examples include:

- CLI Reference
- Environment Summaries
- Generated Reports

---

## Session Updates

Session updates capture completed work during development sessions.

Unlike planning documents, they are temporary operational records that summarize what was accomplished, why it matters, and what should happen next.

Completed session updates become input for future review and planning updates.

---

## Journal

The project journal preserves the historical record of Abbey Root.

Journal entries document:

- Accomplishments
- Design decisions
- Lessons learned
- Problems encountered
- Significant milestones

The journal provides the historical narrative of Abbey Root and serves as published content for BradCooke.com.

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
Planning Review
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
- Build reusable frameworks before one-off solutions.
- Design documentation for both humans and AI.

---

# Regenerating Documentation

Generated documentation should be rebuilt through the Abbey CLI whenever practical.

Examples include:

```bash
abbey build
abbey site build
```

As Abbey Root evolves, additional documentation will be generated directly from project metadata rather than maintained manually.

The long-term objective is for the repository to become increasingly self-documenting through metadata-driven tooling and automation.
