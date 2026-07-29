---
title: "Abbey Research Observation Candidate Workflow"
description: "Abbey Research gains a controlled path from model run to review-ready observation candidate."
date: 2026-07-28
draft: false
tags:
  - Abbey Root
---

# Abbey Research Observation Candidate Workflow

## Summary

Implemented the first complete Abbey Research artifact-creation slice:
`abbey research create --type observation`. Each attempt now has an inspectable
run workspace and stops before human review or canonical promotion.

## Accomplishments

- Captured prompt and input fingerprints before generation.
- Preserved raw model output as a read-only run artifact.
- Orchestrated generation, normalization, sanitization, and validation.
- Recorded successful and failed stages in a persistent manifest.
- Added focused regression coverage for success and failure boundaries.
- Fixed the previously documented macOS no-input portability defect.

## Lessons Learned

- A run workspace should be treated as an immutable execution record, not a
  directory to reuse.
- Portability behavior can be part of an architecture contract when a workflow
  explicitly allows an empty list of inputs.
- Calling the normalizer does not by itself advance the broader normalization
  backlog item.

## Next Steps

- Validate the candidate workflow through normal research use.
- Keep review records and canonical promotion in a separate focused session.
