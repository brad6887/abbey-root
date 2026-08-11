---
title: "Framework Adoption Guide"
description: "Created an evidence-based guide for safely adopting the Abbey Framework in new and existing repositories."
date: 2026-08-10
status: complete
reviewed: true
session: framework-adoption-guide
journal: "content/journal/2026/2026-08-10-framework-adoption-guide.md"
tags:
  - Abbey Root
---

# Framework Adoption Guide

## Objective

Create a practical framework adoption guide based on the validated Abbey Root,
Power Infrastructure, and Bread Pitt workflows without expanding into legacy
repository migration or new automation.

## Definition of Done

- Define a safe new-project bootstrap and an explicit established-project boundary.
- Distinguish universal framework requirements from optional project capabilities.
- Document project metadata, planning, session, validation, CLI, and documentation adoption.
- Ground the guidance in evidence from all three validated projects.
- Provide a finite adoption-certification checklist.
- Link authoritative standards instead of duplicating their full contracts.
- Complete the backlog item and pass documentation validation.

## Summary

Added `docs/guide/FRAMEWORK_ADOPTION.md` as the task-oriented path from an
unadopted repository to a certified Abbey project. The guide begins with
project ownership decisions, uses `abbey init` for safe empty-project
bootstrapping, and keeps established-repository migration separate.

## Accomplishments

- Documented the expected adoption outcome and project boundary.
- Defined the metadata decisions each project must own.
- Explained documentation and session-workflow adoption.
- Documented shared-toolkit versus active-project responsibilities.
- Added incremental capability guidance for infrastructure, DNS, sites, media,
  image roles, and AI context.
- Added an eleven-point adoption certification checklist.
- Summarized the distinct evidence supplied by Abbey Root, Power
  Infrastructure, and Bread Pitt.
- Linked the guide from the documentation landing page and generated index.
- Completed the framework-adoption backlog item.

## Impact

Future projects now have one bounded adoption path that preserves familiar
Abbey behavior without copying Abbey Root's domain configuration or enabling
capabilities by accident.

## Validation

- `abbey docs check` passed.
- `abbey backlog check` passed.
- `abbey validate` passed.
- `tests/test-abbey-docs.sh`: 34 passed, 0 failed.
- Every relative link in the adoption guide resolves.
- `git diff --check` passed.

## Lessons Learned

The three projects validate different parts of the adoption contract. Abbey
Root defines framework behavior, Power Infrastructure demonstrates a domain
CLI and production workflow, and Bread Pitt proves that the installed toolkit
can remain separate from project-owned data and configuration.

Adoption and migration need separate guides. A safe initializer can define the
target contract for a new repository, but applying that contract over legacy
content requires conflict analysis and evidence from a completed migration.

## Next Steps

- Use the guide during the next real framework adoption and revise it only when
  observed friction exposes a missing step.

## Notes

No migration workflow, new project template, command implementation, commit,
push, or external-project mutation was included.
