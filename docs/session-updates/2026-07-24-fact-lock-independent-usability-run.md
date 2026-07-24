---
title: Fact-Lock Independent Usability Run
date: 2026-07-24
session: fact-lock-independent-usability-run
status: complete
reviewed: true
type: session-update
tags:
  - abbey-root
  - research
  - voice-analysis
  - fact-lock
  - usability
---

# Fact-Lock Independent Usability Run

## Objective

Exercise the public fact-lock proposal and review workflow on a new
four-scenario Facebook writing suite outside the original extraction
evaluation.

## Definition of Done

- Create an independent request suite in the working research area.
- Generate and deterministically validate a proposal.
- Produce the read-only review summary and hash-bound review scaffold.
- Exercise the revision branch using substantive reviewer findings.
- Preserve the human approval boundary.
- Capture reusable platform issues instead of silently repairing artifacts.

## Work Completed

Created `VOICE-FACT-LOCK-USABILITY-001` with:

- an ordinary observational Facebook post,
- a fact-preserving edit with quoted stance and numeric content,
- a callback with exactly one bounded invention,
- and a privacy-sensitive two-sentence announcement.

The first generated proposal exposed misleading proposal-prompt details:

- a hardcoded original evaluation ID,
- no instruction to restart fact IDs for each scenario,
- and no valid creative-slot example.

The reusable proposal prompt now copies suite identity, resets fact numbering
per scenario, shows the exact creative-slot schema, and requires raw JSON.
Regeneration from the unchanged suite then passed deterministic validation.

Human-style review found omitted source facts, weak compound anchors, changed
grammatical state, ineffective privacy patterns, and missing protected
literals. Three hash-bound revision reviews exercised the public revision
command. One replacement also exposed excess `required_all` nesting.

The reusable revision prompt now contrasts valid and invalid grouped-anchor
nesting and requires raw JSON without Markdown fences.

## Result

`proposal-v6-normalized.json` passes deterministic validation and incorporates
the recorded findings:

- discovery framing is explicit,
- all edit-source facts are retained,
- callback state remains an attempt,
- callback anchors cover the project, attempt, lamp, signal, meeting, and
  unproductive state,
- `Project Lighthouse` is protected,
- exactly one new callback sign remains the only creative slot,
- and the sensitive message has explicit privacy notes plus a bounded
  no-invitation pattern.

The proposal remained `proposed_human_review_required` until the user
explicitly approved all four scenarios. A fresh approval review was created
against the exact final proposal hash and promoted to:

```text
fact_lock_id: VOICE-FACT-LOCK-USABILITY-001
review_id: VOICE-FACT-LOCK-USABILITY-REVIEW-APPROVAL-001
status: approved_human_reviewed
scenarios: 4
```

## Validation

The final proposal:

```text
Result: PASS
Scenarios: 4
Immutable facts: 11
Creative slots: 1
Protected literals: 1
Forbidden patterns: 1
```

The run also confirmed that local model generation is the slow stage, ranging
from roughly three to five minutes per proposal or revision, while
deterministic validation is effectively immediate.

## Decision

The process works on an independent suite and correctly prevents structural
or semantic shortcomings from becoming an approved lock. Promotion occurred
only after explicit user approval of all four final scenarios.

Repeated model revision can require several cycles. Precise reviewer notes and
deterministic revalidation remain necessary controls.

## Suggested Next Step

Exercise voice generation and deterministic output validation with the
approved usability fact lock. Keep semantic verification and final human
proposition review as separate gates.
