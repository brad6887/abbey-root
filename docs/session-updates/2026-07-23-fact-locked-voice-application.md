---
title: Fact-Locked Voice Application
date: 2026-07-23
session: fact-locked-voice-application
status: complete
reviewed: false
type: session-update
tags:
  - abbey-root
  - research
  - voice-analysis
  - voice-model
  - validation
---

# Fact-Locked Voice Application

## Objective

Build and validate an application workflow that prevents VOICE-MODEL-001 from
changing supplied facts while it performs stylistic transformation.

## Definition of Done

- Represent the eight existing scenarios as immutable propositions.
- Separate authorized fictional invention into explicit creative slots.
- Reject missing facts, unauthorized literals, numbers, times, relationships,
  device agency, and scenario-boundary violations.
- Run the same eight scenarios through the local AI worker.
- Require deterministic validation, a separate semantic verification pass,
  human proposition review, and the original scoring rubric.
- Record the result without approving free generation.

## Work Completed

Created:

- `VOICE-MODEL-001-FACT-LOCK.json`
- `fact-locked-voice-application.md`
- `fact-locked-voice-verification.md`
- `validate_fact_locked_voice_output.py`
- `validate_fact_locked_voice_verification.py`
- evaluation Run 003 and its machine-readable verification record

The output validator accepts raw JSON or exactly one fenced JSON object and can
emit canonical JSON. It checks:

- exact scenario coverage and order,
- complete fact-ID declarations,
- lexical anchors for immutable propositions,
- protected literals,
- unauthorized numeric and temporal details,
- scenario-specific forbidden patterns,
- creative-slot authorization and cardinality,
- characteristic requirements and prohibitions,
- and exact sentence counts where required.

The semantic-verification validator checks the verifier record's coverage,
field types, per-item result consistency, and overall result.

## Evaluation

The local `gpt-oss:20b` worker processed the same eight scenarios used in the
two failed free-generation runs.

Final Run 003:

```text
Deterministic validation: 8 / 8 passed
Semantic verification:    8 / 8 passed
Human fact review:         8 / 8 passed
Rubric score:              78 / 80
Result:                    Passed
```

Two restraint points were deducted for unnecessary hashtags and visible
quote-escape artifacts.

## Development Findings

The rejected intermediate attempts materially improved the workflow:

- A creative-slot schema mismatch showed that generated metadata must be
  validated.
- A truncated JSON response showed that normalization cannot repair partial
  output.
- A change from `assembling` to `assembled` showed that lexical coverage alone
  does not preserve grammatical aspect.
- The semantic verifier missed that tense change, confirming that it is
  advisory.
- A device described as `refusing` added agency; semantic review caught it and
  the deterministic rules now reject the pattern.

## Decision

VOICE-MODEL-001 version 3 is approved only for fact-locked application within
the tested Facebook scope.

It remains unapproved as a free-generation prompt. The fact lock,
deterministic gate, semantic verification, and human proposition review are
all required parts of the accepted method.

## Limitations

- Lexical anchors and forbidden patterns cannot prove semantic equivalence.
- The semantic verifier can miss proposition changes and cannot replace human
  review.
- The current fact lock covers the eight evaluation scenarios; a production
  workflow still needs a validated method for deriving locks from new user
  tasks.
- This evaluation does not expand the Voice Model beyond Facebook writing.

## Suggested Next Step

Design and evaluate the upstream fact-extraction step that converts a new
writing request into a reviewable fact-lock manifest before generation.
