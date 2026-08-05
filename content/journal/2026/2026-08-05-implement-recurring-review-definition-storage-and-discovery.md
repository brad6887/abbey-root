---
title: "Implement Recurring Review Definition Storage and Discovery"
description: "Created the first implementation of the Abbey Root recurring review workflow."
date: 2026-08-05
draft: false
tags:
  - Abbey Root
  - workflow
  - recurring reviews
---

# Implement Recurring Review Definition Storage and Discovery

Today the recurring review backlog item was broken into a clearer implementation path.

The initial goal was to create a recurring review registry. During implementation, the architecture was refined into a metadata-driven model where individual recurring reviews are stored as Markdown documents with YAML frontmatter.

The first review definition was created:

- Documentation Audit

Recurring review definitions are stored under:

docs/reviews/recurring/

Completed review occurrences remain separate from recurring definitions.

A discovery workflow was added:

abbey review recurring

The command reads the recurring review definitions and displays their metadata, including:

- title
- category
- frequency
- status
- source file

This provides the foundation for future workflow improvements, including surfacing due reviews during `abbey session`.

The session reinforced the Abbey Root design principle of validating the workflow structure before adding automation. Scheduling, reminders, and enforcement remain separate future work.
