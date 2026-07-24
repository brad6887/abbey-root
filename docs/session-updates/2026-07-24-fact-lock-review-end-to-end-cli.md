---
title: Fact-Lock Review End-to-End CLI
date: 2026-07-24
session: fact-lock-review-end-to-end-cli
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

# Fact-Lock Review End-to-End CLI

## Objective

Complete the public fact-lock review workflow from a filled review manifest
through either revision or hash-bound approval.

## Definition of Done

- Validate completed approval and revision reviews deterministically.
- Reject incomplete, hash-mismatched, or internally inconsistent reviews.
- Route revision through a fixed Abbey prompt and the existing research runner.
- Permit promotion only after an exact completed approval review.
- Exercise both decision branches with real five-scenario artifacts.
- Preserve human approval as an explicit boundary.

## Work Completed

Added:

```text
abbey research fact-lock review-validate
abbey research fact-lock revise
abbey research fact-lock approve
```

`review-validate` verifies canonical proposal and source-request hashes,
proposal identity, exact scenario order and coverage, completed facts and
constraints decisions, nonblank notes, the overall decision, and
decision-specific fact-lock ID rules.

`revise` accepts only a valid `revise` review. It uses the generalized
`revise-voice-fact-lock.md` prompt with the suite, rejected proposal, and
review as explicit inputs. The generated replacement remains a proposal and
must pass validation and a new human review.

`approve` accepts only a valid `approve` review in which every scenario's
facts and constraints are approved. It then promotes the exact hash-bound
proposal without rewriting its factual content.

The revision prompt no longer embeds evaluation-specific manifest, suite,
model, or scenario-count identifiers.

## Validation

Regression suite:

```text
Passed: 102
Failed: 0
```

Tests cover completed review validation, undecided-review rejection, approval
and revision decision rules, approval metadata, incompatible branch rejection,
CLI help, and existing research behavior.

A real revision branch ran with `gpt-oss:20b` against the accepted
five-scenario proposal. The replacement proposal passed deterministic
validation and remained unapproved.

A real approval branch validated a completed five-scenario review and produced
an `approved_human_reviewed` lock preserving the supplied review ID and
fact-lock ID.

## Decision

The fact-lock review process is functional end to end through public Abbey
commands for both revision and approval.

Voice generation from the resulting approved lock remains a separate workflow
stage and is not performed by these commands.

## Suggested Next Step

Run the workflow on the first new writing-request suite outside the original
evaluation. Use that run to assess reviewer usability before adding more
automation.
