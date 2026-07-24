---
title: Fact-Lock Review CLI
date: 2026-07-24
session: fact-lock-review-cli
status: complete
reviewed: false
type: session-update
tags:
  - abbey-root
  - research
  - voice-analysis
  - fact-lock
  - cli
  - review
---

# Fact-Lock Review CLI

## Objective

Make a validated fact-lock proposal understandable to a human reviewer without
requiring direct inspection of raw JSON or creating an approval shortcut.

## Definition of Done

- Add `abbey research fact-lock review`.
- Validate the suite and proposal before display.
- Print stable hashes and source-hash agreement.
- Show every fact, anchor mode, creative slot, and constraint.
- Highlight scenarios requiring extra attention.
- Make no filesystem changes.
- Preserve explicit human review and approval boundaries.

## Work Completed

Added:

```text
abbey research fact-lock review \
  --suite FILE \
  --proposal FILE
```

The command delegates to
`summarize_voice_fact_lock_review.py`.

The summary includes:

- suite, proposal, manifest, status, and Voice Model identity,
- suite and proposal SHA-256 hashes,
- recorded source-hash match or mismatch,
- aggregate scenario, fact, slot, literal, number, and pattern counts,
- all immutable propositions,
- `required_any` alternatives and `required_all` groups,
- protected literals and allowed numbers,
- style and sentence-count constraints,
- forbidden patterns,
- creative-slot boundaries and cardinality,
- extraction notes,
- and targeted review-attention labels.

The decision section always states that human review is required and that the
command did not create, modify, approve, or promote an artifact.

## Validation

Regression suite:

```text
Passed: 80
Failed: 0
```

Tests verify:

- CLI help and routing,
- proposal hash display,
- scenario detail,
- authorized-invention attention,
- the mandatory human decision,
- the explicit read-only boundary,
- and unchanged proposal checksum after execution.

A real review of `VOICE-FACT-LOCK-PROPOSAL-001-REVISION-009` displayed five
scenarios, thirteen immutable facts, one creative slot, matching source
hashes, and the expected sensitive, callback, numeric, and format warnings.

## Decision

The read-only review summary is ready for use.

It is not an approval command. Review findings still belong in a
machine-readable review manifest, and promotion remains an explicit separate
step.

## Suggested Next Step

Define a `fact-lock review-init` command that creates an empty,
hash-bound review manifest scaffold from the exact proposal. It should never
pre-approve facts or constraints.
