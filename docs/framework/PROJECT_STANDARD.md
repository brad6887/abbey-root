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

Project-owned Abbey behavior is declared in `.abbey/project.yml`. Reusable
toolkit commands must resolve their implementations from the installed Abbey
toolkit while reading and writing project artifacts under the active project
root.

The `.abbey/project.yml` file is also the canonical Abbey project marker.
Project-aware commands discover it by walking upward from the current working
directory, or use an explicitly supplied project root when supported. They do
not infer the active project from the toolkit installation directory.

Project discovery and configuration follow these safety rules:

* A discovered marker must contain valid schema-version-1 project metadata.
* Project-relative configuration paths must remain inside the active project.
* Missing project configuration fails closed for commands that require it.
* Toolkit defaults are unavailable unless the project explicitly declares
  `configuration.allow_toolkit_defaults: true`.
* `abbey project show` reports the active project, project root, toolkit root,
  project configuration, and toolkit-default policy before project-aware
  workflows are run.

The standard project metadata supports:

* `configuration.allow_toolkit_defaults`, which defaults to `false` and must
  be explicitly enabled before a command may use toolkit-owned configuration
  as a project default.
* `capabilities.infrastructure`, which enables infrastructure-specific health
  checks only for projects that own infrastructure.
* `capabilities.internal_dns`, which independently enables checks for
  project-owned internal DNS.
* `workflow.journal.policy`, with `required`, `event-driven`, and `optional`
  policies.
* `validation.commands`, an ordered list of project-appropriate commands shown
  by `abbey review`.
* `site.source` and `site.build`, which explicitly define the project-owned
  source directory and either an `npm` build artifact or a direct `static`
  artifact.
* `site.publish`, which must explicitly define the deployment `method`,
  `target`, and `domain` before `abbey site publish` will make changes. Site
  publishing never inherits a target or domain from the Abbey toolkit.

Project-aware image selection uses `.abbey/image-roles.yml` from the active
project. `abbey image` validates `.abbey/project.yml`, reports its resolved
project, configuration source, image source, and metadata target before a
selection can change metadata, and fails when local image-role configuration
is absent or malformed. It may use the toolkit's image-role configuration only
when the active project explicitly declares
`configuration.allow_toolkit_defaults: true`.

Project-aware media preparation uses `.abbey/media.yml` from the active
project. `abbey media rename-exports` validates the complete image/XMP batch
before changing files, derives filenames from configured caption and capture
date metadata, uses staged renames to keep each pair synchronized, and writes
an original-to-published filename manifest after success. Intake directories
may live outside the project because they commonly originate in temporary
export locations, but the workflow configuration remains project-owned. The
plant-specific rename command is a compatibility wrapper for this shared media
workflow. Toolkit media defaults require the same explicit project opt-in as
other project-aware configuration.

---

# Reference Implementation

Abbey Root is the reference implementation of the Abbey Project Standard.

Other repositories adopt the standard while extending it for their own domain.

The goal is that every Abbey-style repository shares the same engineering philosophy, documentation structure, workflow, and developer experience.
