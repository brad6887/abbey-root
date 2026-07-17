---
title: "Abbey Session Context Generation"
description: "Added an upload-ready session context command that replaces repetitive manual repository-state collection at the start of Abbey Root sessions."
date: 2026-07-15
status: pending
reviewed: true
session: primary
tags:
  - Abbey Root
  - Abbey Framework
  - Developer Toolkit
  - Session Workflow
  - Automation
---

# Abbey Session Context Generation

## Objective

Create an upload-ready `abbey session context` command that gathers the repository and project information normally collected manually at the beginning of an Abbey Root work session.

## Definition of Done

- `abbey session context` gathers the standard session-start repository context.
- The command writes one readable Markdown file under `working/session-context/`.
- Context collection is read-only and failure-tolerant.
- The generated file records repository, branch, commit, timestamp, hostname, Git state, planning documents, recent session activity, and Abbey health.
- Missing optional inputs are reported without stopping generation.
- `--stdout` and `--output FILE` are supported.
- Generated default files are excluded from Git.
- CLI metadata and generated CLI documentation include the new subcommand.
- The generated output is validated against the information normally collected manually.

## Summary

Abbey Root now provides an automated session-start context workflow through:

```text
abbey session context
