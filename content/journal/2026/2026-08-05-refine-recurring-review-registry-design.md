---
title: "Refine Recurring Review Registry Design"
description: "Refined the recurring review registry architecture and separated future implementation work."
date: 2026-08-05
tags:
  - Abbey Root
  - Architecture
  - Workflow
---

# Refine Recurring Review Registry Design

Continued the recurring review registry design session by moving from architecture concepts into implementation boundaries.

The main decision was that recurring review definitions should be stored as individual Markdown documents with YAML frontmatter. A separate registry index is unnecessary until future scale requires one.

This keeps the model aligned with Abbey principles:

- documentation remains part of the workflow
- metadata can support future automation
- the source of truth remains human-readable
- automation can be added after the workflow is validated

The backlog was refined during this session. The original "Create recurring review registry" item represented several different pieces of work. It was separated into architecture, storage, discovery, and session integration tasks.

The architecture phase is complete. Future work can now focus on implementation without mixing design decisions with execution.
