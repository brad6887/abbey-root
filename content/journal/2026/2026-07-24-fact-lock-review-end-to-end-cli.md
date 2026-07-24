---
title: Fact-Lock Review End-to-End CLI
date: 2026-07-24
type: journal
tags:
  - abbey-root
  - research
  - fact-lock
  - cli
  - review
---

# Fact-Lock Review End-to-End CLI

The fact-lock review workflow is now functional through public Abbey commands
for both possible human decisions.

`review-validate` checks that a completed review is bound to the exact request
suite and proposal, covers every scenario, includes explicit facts and
constraints decisions plus notes, and obeys the rules for either approval or
revision. It does not mutate or promote artifacts.

`revise` requires a valid revision decision and generates a replacement
proposal through the existing Abbey research runner. `approve` requires a
fully approved, hash-bound review before promoting the proposal to an
`approved_human_reviewed` fact lock.

The regression suite passed 102 tests with no failures. Real five-scenario
smoke tests exercised both paths: the model-produced revision passed
deterministic proposal validation while remaining unapproved, and the
approval path produced a lock preserving its human review identity.

The next useful test is a new writing-request suite outside the original
evaluation, with attention to the human review experience rather than more
automation.
