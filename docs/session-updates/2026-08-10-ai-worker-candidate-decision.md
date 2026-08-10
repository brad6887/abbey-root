---
title: "AI Worker Candidate Decision"
description: "Added a structured Abbey AI decision for finding bounded AI Worker research and implementation candidates in planning documents."
date: 2026-08-10
status: complete
reviewed: false
session: ai-worker-candidate-decision
tags:
  - Abbey Root
---

# AI Worker Candidate Decision

## Objective

Add an `abbey ai decide` profile that reviews authoritative planning documents
and recommends one safe, bounded candidate for AI Worker research or
implementation.

## Definition of Done

- The decision consumes the standard Abbey planning sources.
- Results distinguish research, implementation, and no-suitable-candidate
  outcomes.
- A recommendation identifies inputs, deliverables, validation, evidence, and
  the human review boundary.
- Proposed command concepts are explicitly non-executable and never dispatch
  work automatically.
- Focused regression coverage passes.

## Summary

Implemented the metadata-driven `ai-worker-candidate` decision profile and
extended the shared decision report to render its worker-specific fields.

## Accomplishments

- Added a strict JSON definition, prompt, and output schema under
  `config/ai/decisions/ai-worker-candidate/`.
- Limited eligible work to reviewable research or already-defined repository
  implementation tasks.
- Excluded deployment, destructive work, privileged infrastructure mutation,
  secrets, physical access, and unresolved human decisions.
- Constrained proposed command concepts to future `abbey ai work research` or
  `abbey ai work implement` syntax.
- Added fail-closed result validation that requires the proposed command to
  match the selected research or implementation classification.
- Added regression assertions for discovery, delegation boundaries, schema
  constraints, and report rendering.
- Recorded the capability in project status.

## Impact

Abbey can now use the existing local AI decision pipeline to scan planning for
work that is appropriate to delegate while keeping execution and approval in
human hands. The result also sketches the contract a future `abbey ai work`
command could consume.

## Validation

- A live AI Worker smoke test completed and exposed a misplaced proposed
  command that the generic required-field check did not catch; the focused
  semantic gate was added in response.
- The first post-fix live rerun exposed a missing import in that new semantic
  gate; the runtime path was corrected before final validation.
- A subsequent live run showed that Ollama's constrained decoder interpreted
  an empty-string regex alternative in the JSON schema as a literal `$`; the
  incompatible schema pattern was removed while the runtime command validator
  was retained.
- The final live AI Worker run passed end to end, selected the pending
  non-canonical Abbey Research validation as a research candidate, emitted a
  valid `abbey ai work research` concept, preserved human promotion authority,
  and stored the normal decision-history artifact.
- Final focused regression result: 143 passed, 0 failed.
- `bash tests/test-abbey-ai.sh` and `git diff --check` are rerun after the live
  test fix as final validation.

## Lessons Learned

An AI delegation recommendation needs a distinct `none` outcome. Forcing a
candidate would undermine the safety boundary when planning work is ambiguous,
operational, or dependent on a human decision.

## Next Steps

- Repeat live decision runs to tune the prompt if local-model output quality
  needs further refinement.
- If recommendations prove useful, design `abbey ai work` as a separate,
  review-first execution workflow rather than adding dispatch to `decide`.

## Notes

No AI Worker task was launched during this session.
