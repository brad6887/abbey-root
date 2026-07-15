---
title: "Repository-Defined AI Session Guidance"
description: "Added version-controlled AI session guidance that travels with Abbey session context and defines the repository's preferred engineering workflow."
date: 2026-07-15
status: pending
reviewed: false
session: primary
tags:
  - Abbey Root
  - Abbey Framework
  - AI
  - Session Workflow
  - Developer Toolkit
---

# Repository-Defined AI Session Guidance

## Objective

Allow each Abbey repository to define its preferred AI collaboration workflow through a version-controlled guidance document that is automatically included in generated session context.

## Definition of Done

- Create a repository-defined AI session guidance document.
- Automatically include the guidance in `abbey session context`.
- Keep the implementation read-only and failure-tolerant.
- Gracefully handle repositories that do not define guidance.
- Version-control the repository guidance while continuing to ignore other local `.abbey` content.

## Summary

This session introduced the concept of **repository-defined AI session guidance**.

Rather than repeatedly instructing AI assistants how to work with Abbey Root, the repository now contains an authoritative guidance document that is automatically included whenever `abbey session context` generates an upload-ready session snapshot.

The implementation intentionally keeps the command simple. The session context generator merely assembles authoritative repository information, including the guidance document when present, instead of embedding project-specific instructions directly into the command.

This establishes a portable working agreement that can be consumed by ChatGPT, Codex, Claude, Gemini, or future AI assistants without depending on model-specific memory or custom prompts.

## Accomplishments

- Created `.abbey/session-guidance.md` as the repository's authoritative AI collaboration guidance.
- Updated `abbey session context` to include repository-defined AI session guidance automatically.
- Implemented the feature using the existing `context_file` helper to preserve consistent behavior.
- Confirmed that missing guidance files are reported without causing command failure.
- Updated `.gitignore` to version-control the repository guidance while continuing to ignore other `.abbey` content.
- Validated the generated session context with and without the guidance file present.
- Preserved the command's read-only and failure-tolerant design.

## Lessons Learned

- Repository workflow guidance should be treated as authoritative project metadata rather than embedded prompt text.
- `abbey session context` is evolving into an assembler of authoritative repository information rather than a collection of hardcoded output.
- Repository-defined AI guidance is portable across AI platforms and reduces repeated session setup instructions.
- Version-controlled collaboration guidance benefits both human contributors and AI assistants by establishing a shared working agreement.

## Next Steps

- Adopt repository-defined session guidance in other Abbey-style repositories.
- Evaluate support for optional local user guidance layered on top of repository guidance.
- Continue identifying recurring manual workflows that should become Abbey commands.
- Investigate expanding `abbey session context` to assemble additional repository metadata from authoritative sources.
