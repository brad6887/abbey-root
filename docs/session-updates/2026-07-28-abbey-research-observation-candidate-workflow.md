---
title: "Abbey Research Observation Candidate Workflow"
description: "Implemented the controlled observation-candidate orchestration workflow."
date: 2026-07-28
status: complete
reviewed: true
session: abbey-research-observation-candidate-workflow
tags:
  - Abbey Root
---

# Abbey Research Observation Candidate Workflow

## Objective

Implement `abbey research create --type observation` as the safe entry point
for producing an inspectable, review-ready research candidate.

## Definition of Done

- The command initializes a uniquely identified run workspace.
- Provenance is recorded before generation.
- Raw model output is immutable after successful generation.
- Existing run, normalize, sanitize, and validate components are orchestrated.
- Failed stages retain available outputs and record a clear failure state.
- Successful runs produce a review-ready candidate outside canonical research.
- Focused Abbey Research regressions and `abbey review` pass.

## Summary

Added the Phase 1 observation-candidate workflow defined by
`ABBEY_RESEARCH_ARTIFACT_CREATION.md`. The workflow stops at a review-ready
candidate and does not review or promote research.

## Accomplishments

- Registered `abbey research create` in the CLI metadata and generated
  reference.
- Added unique run workspaces under `working/research/runs/`.
- Snapshotted and fingerprinted the prompt and optional inputs before model
  generation.
- Recorded model, prompt, corpus, experiment, commands, timestamps, artifacts,
  stage results, and failure details in `manifest.yaml`.
- Made successful raw output read-only and rejected existing run workspaces.
- Reused the existing generation, observation normalization, sanitization, and
  validation commands in explicit stages.
- Added observation-aware structural validation without Voice Analysis-specific
  paths, identifiers, or conclusions.
- Corrected the existing macOS Bash empty-array failure that blocked research
  runs without optional inputs.
- Added regression coverage for success, no-input creation, unsupported type,
  generation failure, normalization failure, citation survival, and raw-output
  overwrite protection.

## Impact

Abbey Research now has one controlled vertical slice for creating observation
candidates with inspectable provenance and failure state. This completes the
primary backlog implementation item and materially advances the orchestration
item. General deterministic Markdown normalization was not changed.

## Validation

- `bash tests/test-abbey-research.sh` — 129 passed, 0 failed.
- `bash tests/test-abbey-docs.sh` — 23 passed, 0 failed.
- `git diff --check` — passed.
- `abbey review` — passed; only pre-existing historical metadata debt was
  reported.

## Lessons Learned

Portable handling of an empty optional Bash array is part of the workflow
contract, not an incidental compatibility detail. Run-level immutability is
strongest when a run workspace itself is never reopened or reused.

## Next Steps

- Exercise the workflow against a real non-canonical observation input.
- Design review records and canonical promotion as a separate session only
  after normal use validates this candidate workflow.

## Notes

Backlog impact:

- Completed: Implement `abbey research create --type observation` with run
  manifests, immutable raw output, and review-ready candidates.
- Materially advanced: Orchestrate research generation, normalization,
  sanitization, and validation without coupling the workflow to Voice Analysis.
- Not advanced: Complete deterministic research Markdown normalization using
  universally safe operations.
