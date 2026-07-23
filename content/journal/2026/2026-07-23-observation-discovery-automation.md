---
title: Observation Discovery Automation
date: 2026-07-23
session: observation-discovery-automation
status: complete
reviewed: false
type: journal
tags:
  - abbey-root
  - research
  - voice-analysis
  - automation
---

# Observation Discovery Automation

The first full-corpus observation run proved the research method, but Codex
still had to orchestrate the model calls, validate individual files, and
assemble the candidate list. The repository contained the parts, not the
whole process.

Abbey now owns that repeatable process through:

```text
abbey research discover
```

The command reads a deterministic batch manifest and processes every batch.
It saves the model's raw response, attaches exact citation text from the
frozen corpus, validates the normalized result, and stops safely if a batch
cannot pass. Completed valid batches can be reused with `--resume`.

After all batches pass, the command produces a single candidate index and a
review scaffold containing one pending item for every candidate.

This preserves an important boundary. Execution, source hydration, validation,
aggregation, and scaffolding are deterministic platform responsibilities.
Clustering, deciding whether a finding describes voice or merely topic, and
promoting a candidate remain human-review responsibilities.

The new workflow was replayed against the completed Facebook discovery without
calling the model. It validated all 11 batches and reproduced an index of 33
candidates with 92 exact citations. It also produced 33 pending review items.

The research regression suite now has 40 passing checks, including a synthetic
end-to-end validation-only fixture.

The discovery run can now be repeated from repository commands rather than
being reconstructed from a Codex conversation.

