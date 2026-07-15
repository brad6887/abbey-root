---
title: "Repository-Defined AI Session Guidance"
description: "Introduced version-controlled AI collaboration guidance so Abbey repositories can define their preferred engineering workflow for any AI assistant."
date: 2026-07-15
draft: false
tags:
  - Abbey Root
  - Abbey Framework
  - AI
  - Session Workflow
  - Developer Toolkit
---

# Repository-Defined AI Session Guidance

## Summary

This session introduced a new Abbey Framework concept: **repository-defined AI session guidance**.

Rather than relying on repeated prompts or model-specific memory, Abbey Root now stores its preferred engineering workflow in a version-controlled guidance document. The `abbey session context` command automatically includes this guidance whenever it generates an upload-ready session context, allowing any AI assistant to begin with the repository's own working agreement.

The implementation deliberately keeps the session context generator simple. Instead of embedding project-specific instructions directly into the command, it assembles authoritative repository information using the existing context generation framework. If repository guidance is present, it is included automatically. If it is absent, the command continues operating without failure.

Although the feature is small from an implementation standpoint, it establishes an important architectural direction for the Abbey Framework. Repositories can now define how AI collaborators should work using version-controlled project metadata rather than assistant-specific prompts, making AI collaboration portable across ChatGPT, Codex, Claude, Gemini, and future tools.

## Accomplishments

- Created a repository-defined AI session guidance document.
- Integrated AI session guidance into `abbey session context`.
- Reused the existing context generation infrastructure instead of introducing special-case logic.
- Validated graceful behavior when the guidance document is missing.
- Updated repository ignore rules to version-control the guidance while preserving `.abbey` as the location for repository metadata.
- Verified generated session context output with and without repository guidance.

## Lessons Learned

- Repository metadata provides a better home for AI collaboration guidance than assistant-specific prompts.
- Small extensions to existing abstractions often produce more reusable designs than introducing new mechanisms.
- The session context generator is evolving into an assembler of authoritative repository information rather than a static report.
- Repository-defined collaboration guidance is likely to become a reusable capability across future Abbey-style repositories.

## Next Steps

- Adopt repository-defined session guidance throughout other Abbey repositories.
- Investigate layered guidance that combines repository standards with optional local user preferences.
- Continue expanding `abbey session context` by assembling additional authoritative repository metadata instead of embedding project-specific behavior.
