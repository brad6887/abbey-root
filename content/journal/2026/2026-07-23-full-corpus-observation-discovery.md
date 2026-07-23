---
title: Full-Corpus Observation Discovery
date: 2026-07-23
session: full-corpus-observation-discovery
status: complete
reviewed: false
type: journal
tags:
  - abbey-root
  - research
  - voice-analysis
  - ai-worker
---

# Full-Corpus Observation Discovery

The Voice Analysis project had three carefully validated examples, but it
still lacked one of its original goals: asking the AI worker to inspect the
whole Facebook dataset and report patterns that had not already been selected.

That workflow now exists and has completed its first full run.

The corrected voice-eligible corpus contains 1,469 posts divided into 11
deterministic chronological batches. The local `gpt-oss:20b` worker reviewed
each batch independently and returned three provisional candidates in a
machine-readable manifest.

Every candidate retained exact source text and stable Facebook identifiers.
The new validator checks the frozen corpus fingerprint, ensures each source
belongs to the supplied batch, and compares every cited post character for
character with the corpus.

The run produced 33 candidates and 92 retained citations. All 11 final
manifests pass validation.

The validation step mattered. Four initial outputs contained citation
problems: two examples paired a valid ID with unrelated text, one source ID
had a one-digit transcription error, and several examples added quotation
marks or missed a character while copying. Unsupported examples were removed;
safe transcription differences were replaced from the authoritative corpus.

The run also exposed a platform limit. Some batches used the entire fixed
6,144-token generation budget for reasoning and returned no result. Abbey now
supports an explicit `--max-tokens` option while preserving the old default.
The failed batches completed under a 10,000-token ceiling.

Human review grouped the 33 candidates into a backlog. The strongest genuinely
new directions are quoted language used as a comic framing device and hashtags
used as punchlines or closing commentary. Reusable first-person openings and
wordplay also warrant targeted review.

Several clusters independently rediscovered concise delivery, hyperbolic
absurdity, and repeated formulations. Those belong with the existing OBS-001,
OBS-002, and OBS-003 chains rather than becoming duplicates. Other findings
were classified as Facebook conventions, recurring subject matter, or weak
single-batch patterns.

Most importantly, the worker's findings remain candidates. The process now
separates open-ended discovery, exact traceability, human review, and formal
promotion. That gives the project a practical way to expand the voice model
without letting plausible model output turn directly into research claims.

