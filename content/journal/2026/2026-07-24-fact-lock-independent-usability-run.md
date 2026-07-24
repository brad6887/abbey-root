---
title: Fact-Lock Independent Usability Run
date: 2026-07-24
type: journal
tags:
  - abbey-root
  - research
  - voice-analysis
  - fact-lock
  - usability
---

# Fact-Lock Independent Usability Run

The complete fact-lock review workflow has now been exercised on four new
Facebook writing requests outside the original extraction evaluation.

The first run exposed proposal-prompt assumptions that only worked for the
original suite. The prompt now copies suite identity, restarts fact numbering
inside each scenario, shows the validator's exact creative-slot schema, and
requires raw JSON. The revision prompt now explicitly prevents an extra array
layer in compound anchor groups.

The workflow caught more than structural errors. Review identified an omitted
source fact, a callback changed from an attempt into an accomplished state,
anchors too weak to verify their propositions, ineffective privacy patterns,
and a missing protected project name. Hash-bound revision reviews carried
those findings through successive replacements.

The final four-scenario proposal passed deterministic validation and addressed
the recorded findings. After the user explicitly approved all four scenarios,
a fresh hash-bound approval review promoted the exact proposal to
`VOICE-FACT-LOCK-USABILITY-001` with `approved_human_reviewed` status.

This run confirms both the value of the review gates and the practical need
for precise notes, repeated validation, and an explicit human approval
boundary. The next stage is voice generation and output verification using the
approved lock.
