---
title: Fact-Lock Review Init CLI
date: 2026-07-24
session: fact-lock-review-init-cli
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

# Fact-Lock Review Init CLI

## Objective

Create a blank, hash-bound review manifest for a validated fact-lock proposal
without inferring any human decision.

## Definition of Done

- Add `abbey research fact-lock review-init`.
- Validate suite and proposal before writing.
- Bind the scaffold to canonical suite and proposal hashes.
- Create exactly one entry per proposal scenario.
- Leave all identifiers, decisions, and notes unfilled or undecided.
- Protect an existing output.
- Confirm the scaffold cannot represent approval unchanged.

## Work Completed

Added:

```text
abbey research fact-lock review-init \
  --suite FILE \
  --proposal FILE \
  --output FILE
```

The command delegates to `init_voice_fact_lock_review.py`.

The generated schema contains:

```text
review_id: null
fact_lock_id: null
decision: undecided
proposal_sha256: canonical proposal hash
source_request_sha256: canonical request-suite hash
items[].facts: undecided
items[].constraints: undecided
items[].note: empty
```

Before writing, the generator:

- runs the existing proposal validator,
- verifies a recorded source hash when present,
- checks output nonexistence,
- and preserves proposal scenario order.

## Validation

Regression suite:

```text
Passed: 86
Failed: 0
```

Tests verify:

- CLI help and routing,
- all-undecided scaffold content,
- null review and fact-lock IDs,
- canonical proposal-hash binding,
- exact scenario coverage,
- blank notes,
- and overwrite protection.

A real smoke test against the accepted five-scenario proposal produced five
undecided items with the expected proposal and source hashes.

## Decision

The blank review scaffold is ready for normal use.

It cannot approve a proposal unchanged. A human must supply review identity,
the future fact-lock ID, every facts and constraints decision, every note, and
the overall decision.

## Suggested Next Step

Add a deterministic `fact-lock review-validate` command for completed review
manifests. It should support both `approve` and `revise` decisions, require
notes, verify proposal hashes and scenario coverage, and perform no promotion.
