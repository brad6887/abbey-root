# Project Standard

## Purpose

The Project Standard defines the common structure, workflows, and conventions expected of every Abbey-style repository.

The objective is to create repositories that feel familiar from the first day of development through long-term maintenance. A developer should be able to move between projects without relearning repository layout, documentation organization, command structure, or engineering workflow.

Abbey Root serves as the reference implementation of this standard.

---

# Principles

Every Abbey-style project should:

* Be self-documenting.
* Be automation-friendly.
* Prefer metadata over duplicated information.
* Generate documentation whenever practical.
* Follow a consistent engineering workflow.
* Keep documentation synchronized with implementation.
* Favor reusable frameworks over one-off solutions.

---

# Repository Layout

Every project should follow a common high-level structure.

```text
config/
docs/
inventory/
roles/
scripts/
tools/
generated/
```

Projects may omit directories that are not applicable, but should avoid inventing new top-level layouts unless there is a clear architectural reason.

---

# Documentation Layout

Documentation should follow a consistent organization.

```text
docs/
├── architecture/
├── design/
├── generated/
├── guide/
├── planning/
├── reference/
├── runbooks/
├── session-updates/
└── standards/
```

Not every project will use every directory immediately, but the layout should remain recognizable across repositories.

---

# Planning Documents

Planning documents describe the current state and future direction of a project.

Expected planning documents include:

```text
PROJECT_STATUS.md
NEXT.md
BACKLOG.md
ROADMAP.md
VISION.md
IDEAS.md
```

Projects may introduce additional planning documents where appropriate, but should preserve the purpose of these core documents.

---

# Session Workflow

Engineering work should follow a repeatable session workflow.

```text
1. Review
2. Define
3. Build
4. Validate
5. Document
6. Capture
7. Commit
8. Review
```

Every project should support this workflow through its documentation and CLI.

---

# CLI

Project CLIs should follow the Abbey CLI Standard.

Universal commands should be available in every project.

Project-specific commands extend the framework without changing the meaning of universal commands.

---

# Documentation Standards

Documentation should emphasize:

* One source of truth.
* Generated content where practical.
* Consistent terminology.
* Clear separation between planning, architecture, implementation, and reference material.

Generated documentation should never become the authoritative source.

---

# Generated Content

Generated artifacts should live under:

```text
docs/generated/
```

Examples include:

* CLI reference
* Inventory summaries
* Reports
* Charts
* Environment summaries

Generated files should not be edited manually.

---

# Session Updates

Each engineering session should conclude with a session update describing:

* Summary
* Completed work
* Impact
* Lessons learned
* Next steps

Session updates provide the engineering history of the repository.

---

# Publishing

Projects should support publishing documentation whenever practical.

Publishing may include:

* Static websites
* Generated documentation
* Reports
* Reference material

Publishing should be automated through the project CLI whenever possible.

---

# AI Integration

Projects should be designed so AI can understand and contribute effectively.

Examples include:

* Metadata-driven documentation.
* Predictable repository layout.
* Consistent naming.
* Session history.
* Generated context.
* Structured planning documents.

AI should assist engineering work rather than replace engineering judgment.

---

# Extensibility

Projects are expected to evolve.

The framework should provide stable foundations while allowing project-specific capabilities to grow independently.

Examples:

* Power Infrastructure adds request management, reporting, and playbooks.
* Website projects add deployment and content management.
* Secret Shopper projects may add scheduling, reporting, and earnings analysis.

Project-specific capabilities should build on the standard rather than replace it.

---

# Reference Implementation

Abbey Root is the reference implementation of the Abbey Project Standard.

Other repositories adopt the standard while extending it for their own domain.

The goal is that every Abbey-style repository shares the same engineering philosophy, documentation structure, workflow, and developer experience.

