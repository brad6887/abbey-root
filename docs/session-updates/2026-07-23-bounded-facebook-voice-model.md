---
title: Bounded Facebook Voice Model
date: 2026-07-23
session: bounded-facebook-voice-model
status: complete
reviewed: false
type: session-update
tags:
  - abbey-root
  - research
  - voice-analysis
  - voice-model
  - evaluation
---

# Bounded Facebook Voice Model

## Objective

Synthesize the four validated research chains into the first bounded Voice
Model and test whether an AI worker can apply it without copying source posts
or changing supplied facts.

## Work Completed

Created:

- VOICE-MODEL-001.md
- VOICE-MODEL-001.json
- VOICE-MODEL-001-EVALUATION.md
- VOICE-MODEL-001-EVALUATION.json
- application evaluation prompt
- evaluation Run 001 and Run 002 records

## Model Scope

VOICE-MODEL-001 includes four medium-confidence Facebook characteristics:

1. Deadpan contrast
2. Semantic compression
3. Selective continuity
4. Quoted stance marking

Interactions are marked provisional.

The model is not generalized to technical, professional, academic, long-form,
unfamiliar-audience, sensitive, or high-stakes writing.

## Evaluation

Eight invented scenarios tested:

- appropriate use of the four characteristics,
- callback boundaries,
- ordinary-title boundaries,
- sensitive communication,
- technical factual clarity,
- editing restraint,
- and originality without corpus access.

Run 001:

```text
71 / 80
Result: Failed
```

It invented a maintenance time and changed the editing premise.

The model was revised to prohibit invented facts, require factual preservation
during editing, and require self-report consistency.

Run 002:

```text
65 / 80
Result: Failed
```

It again invented or changed facts in four scenarios.

## Decision

VOICE-MODEL-001 is a bounded research draft.

It is not approved as a free-generation prompt.

The evaluation succeeded as a test because it prevented plausible but
factually altered outputs from being accepted.

## Suggested Next Step

Design a fact-locked application workflow:

1. Extract immutable propositions from the task.
2. Generate only stylistic transformations around those propositions.
3. Compare output propositions with the locked set.
4. Reject unsupported entities, times, causes, and system behaviors.
5. Rerun the same eight evaluation scenarios.
