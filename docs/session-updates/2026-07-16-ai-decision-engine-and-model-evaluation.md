---
title: "AI Decision Engine and Model Evaluation"
description: "Expanded Abbey AI into a metadata-driven decision engine with structured history and multi-model evaluation."
date: 2026-07-16
status: complete
reviewed: false
session: primary
tags:
  - Abbey Root
  - AI
  - Developer Toolkit
  - Ollama
---

# AI Decision Engine and Model Evaluation

## Summary

Expanded the Abbey AI platform from a simple prompt interface into a metadata-driven AI decision engine. Introduced reusable decision definitions, structured execution history, model comparison, and support for evaluating engineering decisions across multiple local AI models running on `ai-worker01`.

This session established the architectural foundation for AI-assisted engineering workflows by separating decision definitions from the execution engine and treating AI reasoning as reproducible engineering artifacts.

## Accomplishments

- Implemented `abbey ai decide` for structured engineering decisions.
- Introduced metadata-driven decision definitions consisting of:
  - `decision.json`
  - `prompt.md`
  - `schema.json`
- Added support for configurable:
  - default models
  - model overrides
  - context size
  - temperature
  - planning document inputs
- Integrated direct Ollama API access to the local AI worker.
- Configured `gpt-oss:20b` as the default structured decision model.
- Added `abbey ai models` to enumerate installed Ollama models.
- Added `abbey ai history` to preserve structured decision artifacts.
- Added `abbey ai compare` to compare recommendations across multiple models.
- Generalized the decision renderer to support multiple decision schemas.
- Validated the architecture by implementing a second decision (`next-project`) without requiring changes to the execution engine.

## Decision Validation

The framework was validated using two independent decision definitions.

### Time Saver

Both GPT-OSS and Qwen independently concluded that implementing `abbey-review` would provide the greatest recurring time savings, although each model reached that conclusion using different reasoning.

### Next Project

The second decision intentionally produced different recommendations.

- GPT-OSS recommended continuing work on BradCooke.com by implementing the Contact page, following the project's current execution priorities.
- Qwen recommended implementing `abbey init` as foundational framework work, emphasizing long-term platform leverage.

The disagreement demonstrated that the framework exposes genuine differences in model prioritization rather than simply reproducing deterministic responses.

## Lessons Learned

- AI decision definitions scale better than embedding prompts directly inside the execution engine.
- Structured AI output becomes significantly more valuable when stored as reproducible engineering artifacts.
- Comparing multiple models provides insight into different engineering perspectives rather than identifying a single "correct" answer.
- Execution history containing runtime, token counts, model identity, and structured results creates a valuable dataset for future benchmarking.
- Metadata-driven AI workflows fit naturally within the broader Abbey Framework philosophy.

## Architectural Direction

This session established the first version of the Abbey AI Decision Framework.

The architecture now consists of:

- Metadata-driven decision definitions
- Generic execution engine
- Structured execution history
- Cross-model comparison
- Reusable engineering decision workflows

Future AI agents should consume these decision definitions rather than embedding large prompts directly into agent logic.

## Next Steps

- Implement `abbey ai evaluate` to execute decisions across all installed local models.
- Add validation for decision metadata before execution.
- Add decision and engine versioning to history artifacts.
- Improve comparison output with consensus reporting.
- Continue expanding the decision library with additional engineering workflows.
