---
title: Observation Discovery Automation
date: 2026-07-23
session: observation-discovery-automation
status: complete
reviewed: false
type: session-update
tags:
  - abbey-root
  - research
  - voice-analysis
  - automation
  - deterministic-validation
---

# Observation Discovery Automation

## Objective

Convert the proven full-corpus discovery session into a repository-owned,
resumable Abbey workflow.

## Definition of Done

- Provide one command for batch execution, normalization, and validation.
- Preserve raw AI-worker output.
- Resume safely without rerunning valid batches.
- Aggregate all validated candidates.
- Create a machine-readable human-review scaffold.
- Keep clustering and promotion decisions explicitly human-controlled.
- Add regression coverage and workflow documentation.

## Work Completed

Added:

```text
abbey research discover
```

The command accepts:

- model,
- prompt,
- frozen corpus,
- deterministic batch manifest,
- output directory,
- generation budget,
- resume mode,
- and validation-only mode.

The Python orchestrator:

1. reads the deterministic batch manifest,
2. renders batch and corpus metadata into the prompt,
3. runs each batch through `abbey research run`,
4. preserves the raw response,
5. attaches corpus-authoritative citation text by source identifier,
6. validates the normalized manifest,
7. stops safely on a failed batch,
8. aggregates validated candidates,
9. and creates a pending review scaffold.

`--resume` validates existing results before skipping them.

`--validate-only` performs no model calls and rebuilds aggregate outputs from
existing validated results.

The workflow does not automatically cluster candidates, classify findings, or
promote formal observations.

## Real-Run Verification

The command was run in validation-only mode against the completed Facebook
discovery:

```text
Validated batches: 11
Candidates:         33
Exact citations:    92
Review items:       33
Pending decisions:  33
```

## Testing

The research regression fixture now verifies:

- command visibility,
- validation-only execution,
- validated batch reuse,
- candidate-index generation,
- and review-scaffold generation.

Result:

```text
Passed: 40
Failed: 0
```

## Suggested Next Step

Use the generated review scaffold as the input to a separate interactive
review command. That command should enforce complete decisions while leaving
the decisions themselves to the reviewer.

