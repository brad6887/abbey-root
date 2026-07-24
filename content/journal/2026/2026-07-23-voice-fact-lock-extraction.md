---
title: Voice Fact-Lock Extraction
date: 2026-07-23
type: journal
tags:
  - abbey-root
  - research
  - voice-analysis
  - fact-lock
---

# Voice Fact-Lock Extraction

The fact-locked Voice Model could preserve a reviewed set of propositions, but
its upstream locks were still manually authored. This session built the
review-gated extraction process for new requests.

Five request types were tested: ordinary post, edit, callback, sensitive
message, and factual notice. The local worker proposed fact locks, deterministic
validation checked their structure, and machine-readable human reviews drove
complete replacement proposals until one was approvable.

The review history was as valuable as the final result. It exposed omitted
context, duplicated facts, changed relationships, brittle anchors, confused
format constraints, overbroad regexes, and schema regressions. A first
approved lock failed during generation, so approval was reopened and the
upstream proposal corrected.

The final VOICE-FACT-LOCK-002 passed deterministic generation validation,
semantic verification, and human proposition review for all five requests.

The process is now operational but deliberately not automatic. Human review
remains the authority for factual completeness and relationship preservation.
The next platform improvement should wrap proposal creation and validation in
an Abbey command while keeping approval explicit.
