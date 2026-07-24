---
title: Fact-Locked Voice Application
date: 2026-07-23
type: journal
tags:
  - abbey-root
  - research
  - voice-analysis
  - voice-model
---

# Fact-Locked Voice Application

The two failed free-generation evaluations established that stronger prompt
language was not enough to preserve supplied facts. The next application
method therefore separated immutable propositions from stylistic choices.

A machine-readable fact lock now defines required propositions, protected
literals, authorized creative slots, characteristic boundaries, format
requirements, and known unsupported additions for the eight evaluation
scenarios. The generated output must pass deterministic checks before it is
eligible for a separate semantic review and human scoring.

This layered workflow caught several important problems during development:
partial JSON, a creative-slot schema mismatch, a tense change from an ongoing
action to a completed action, and invented device agency. It also demonstrated
that the semantic verifier is advisory because it initially missed the tense
change.

The final `gpt-oss:20b` candidate passed all eight deterministic checks, all
eight semantic-verification items, human proposition review, and the original
application rubric with a score of 78 out of 80.

VOICE-MODEL-001 version 3 is now approved only through this fact-locked
workflow and only within the tested Facebook scope. Free generation remains
unapproved.

The next unresolved platform problem is upstream: deriving a trustworthy,
reviewable fact lock from a new writing request before the style model runs.
