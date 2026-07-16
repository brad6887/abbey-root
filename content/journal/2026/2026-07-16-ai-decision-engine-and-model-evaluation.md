---
title: "AI Decision Engine and Model Evaluation"
description: "Built a metadata-driven AI decision framework with reusable decision definitions, model comparison, and structured execution history."
date: 2026-07-16
draft: false
tags:
  - Abbey Root
  - AI
  - Ollama
  - GPT-OSS
  - Qwen
  - Abbey Framework
---

# AI Decision Engine and Model Evaluation

## Summary

Today marked a major shift in the direction of Abbey AI. What began as an effort to ask local AI models practical engineering questions evolved into a reusable decision framework capable of evaluating structured engineering decisions across multiple models.

Rather than embedding prompts directly into the CLI, AI reasoning is now described through metadata-driven decision definitions consisting of a decision description, prompt, and response schema. The execution engine reads these definitions, submits them to Ollama, validates the structured response, records the results, and enables comparison across different models.

## Accomplishments

- Built the `abbey ai decide` framework.
- Created metadata-driven decision definitions using:
  - `decision.json`
  - `prompt.md`
  - `schema.json`
- Added configurable models, context sizes, and temperatures.
- Connected directly to the Ollama API running on `ai-worker01`.
- Added support for model overrides.
- Implemented `abbey ai models` to discover installed local models.
- Added structured execution history with runtime and token statistics.
- Implemented `abbey ai history`.
- Implemented `abbey ai compare`.
- Generalized the decision renderer to support multiple decision schemas.
- Validated the architecture by creating a second decision without modifying the execution engine.

## Decision Validation

Two independent engineering decisions were evaluated across multiple models.

### Time Saver

Both GPT-OSS and Qwen independently selected `abbey-review` as the project most likely to save recurring engineering time.

Although they reached the same conclusion, each model emphasized different supporting evidence and implementation priorities.

### Next Project

The second decision intentionally produced different recommendations.

GPT-OSS prioritized continuing execution of the current BradCooke.com objectives by recommending implementation of the Contact page.

Qwen instead prioritized designing `abbey init`, emphasizing long-term framework leverage and project bootstrapping.

The disagreement demonstrated that different models genuinely prioritize the same planning information differently, providing insight into engineering tradeoffs rather than simply producing identical answers.

## Lessons Learned

The most important realization from today's work was that the true value lies not in asking AI questions, but in defining reusable engineering decisions.

Once decision definitions became metadata-driven, the execution engine no longer needed to know anything about individual decisions. New capabilities could be added simply by creating new decision definitions rather than modifying code.

Structured history also transformed AI output from disposable conversation into reproducible engineering artifacts that can be reviewed, compared, benchmarked, and improved over time.

## Looking Ahead

This session established the first version of the Abbey AI Decision Framework.

Future work will focus on evaluating decisions across every installed local model, identifying areas of agreement and disagreement, and eventually allowing higher-level Abbey AI agents to consume reusable decision definitions rather than embedding reasoning directly into agent workflows.

The long-term vision is for Abbey Root to treat AI reasoning the same way it treats infrastructure, documentation, and automation: as structured, reproducible engineering artifacts managed under version control.
