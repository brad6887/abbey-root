---
title: "Project-Aware AI Context"
description: "TODO: Add a short summary."
date: 2026-07-05
draft: false
tags:
  - Abbey Root
  - AI
  - Architecture
  - Automation
  - Open WebUI
---

## Summary

Today's development focused on taking the first major step toward making Abbey AI aware of the Abbey Root project rather than functioning as a generic chatbot.

The goal was to give AI access to the current state of the project so it can make recommendations based on documentation, recent work, and project priorities.

This establishes the foundation for future AI-assisted development throughout the lab.

---

## Accomplishments

### Created `abbey-context`

Developed a new `abbey-context` tool responsible for generating focused context bundles for AI.

Current supported modes include:

- brief
- next
- website
- full

Each mode assembles only the information needed for a particular type of question.

---

### Refactored `abbey-ai`

Refactored the `abbey-ai` command into smaller functions.

Responsibilities are now separated into:

- information
- connectivity testing
- model listing
- context generation
- AI requests

This provides a cleaner foundation for future enhancements.

---

### Project-Aware AI

Integrated the context builder with `abbey ai ask`.

Rather than sending only the user's prompt, Abbey AI now includes project context generated from documentation and repository state.

The AI can now answer questions using information such as:

- Project Status
- NEXT
- Roadmap
- Git history
- Current repository status
- Journal entries

---

### Context Architecture

Designed the long-term architecture for AI context generation.

Rather than maintaining a single large knowledge file, context is generated dynamically for specific tasks.

This approach will allow future routing based on question type while minimizing unnecessary context sent to the model.

---

## Lessons Learned

Sending too much project context significantly increases response time on CPU-based local models.

A focused context produces much better performance while still giving the model the information it needs.

The architecture should favor small, purpose-built context bundles over a single monolithic knowledge snapshot.

---

## Next Steps

- Improve the `brief` context mode.
- Add additional context types for infrastructure and AI development.
- Create shared libraries for Open WebUI interactions.
- Continue refactoring the Abbey toolkit into reusable components.
- Review and consolidate project documentation during Documentation Day.
