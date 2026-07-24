---
title: Fact-Lock Propose and Validate CLI
date: 2026-07-24
session: fact-lock-propose-validate-cli
status: complete
reviewed: false
type: session-update
tags:
  - abbey-root
  - research
  - voice-analysis
  - fact-lock
  - cli
---

# Fact-Lock Propose and Validate CLI

## Objective

Expose the proven upstream proposal and validation workflow through Abbey
commands without automating approval or application.

## Definition of Done

- Add `abbey research fact-lock propose`.
- Add `abbey research fact-lock validate`.
- Reuse the existing extraction prompt, research runner, and deterministic
  validator.
- Preserve overwrite protection and configurable generation budgets.
- State clearly that validation is not approval.
- Add CLI regression coverage.
- Run one real proposal and validation smoke test.

## Work Completed

Added:

```text
abbey research fact-lock propose \
  --model MODEL \
  --suite FILE \
  --output FILE \
  [--max-tokens N] \
  [--force]
```

The command:

- uses the repository's canonical `propose-voice-fact-lock.md` prompt,
- delegates generation to the existing Abbey research runner,
- defaults to 16,000 output tokens,
- preserves output overwrite protection,
- and prints the exact validation command as the next step.

Added:

```text
abbey research fact-lock validate \
  --suite FILE \
  --proposal FILE \
  [--normalized-output FILE]
```

The command:

- validates through `validate_voice_fact_lock_proposal.py`,
- can emit canonical normalized JSON,
- protects an existing normalized output,
- and explicitly reports that human review remains required.

Approval and application commands were intentionally excluded.

## Validation

Regression suite:

```text
Passed: 72
Failed: 0
```

Real CLI smoke test:

```text
fact-lock propose:  PASS
fact-lock validate: PASS
normalization:      PASS
approval boundary: preserved
```

The smoke-test proposal remains under the untracked working directory and is
not a research conclusion or approved lock.

## Decision

The proposal and validation commands are ready for normal review-gated use.

Do not add approval to the same command path. The next increment should first
evaluate an explicit `fact-lock review` experience or a read-only review
summary before exposing approval.

## Suggested Next Step

Design `abbey research fact-lock review` as a read-only summary that identifies
the proposal, its source hash, scenario count, fact count, creative slots, and
constraints requiring human attention.
