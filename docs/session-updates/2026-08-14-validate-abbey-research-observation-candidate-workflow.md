---
title: "Validate Abbey Research Observation Candidate Workflow"
description: "Validate the observation-candidate workflow through real use and make backlog-leverage coverage respect explicit planning boundaries."
date: 2026-08-14
status: complete
reviewed: false
session: validate-abbey-research-observation-candidate-workflow
tags:
  - Abbey Root
  - Abbey Research
  - Abbey AI
  - workflow validation
---

# Validate Abbey Research Observation Candidate Workflow

## Objective

Review the normal-use `abbey ai decide backlog-leverage` recommendation, execute
the valid bounded portion of its proposed work, and correct the decision
workflow where its coverage map crosses explicit planning and phase boundaries.

Validate `abbey research create --type observation` with a real non-canonical
input while preserving the explicit prohibition against canonical promotion or
downstream research-stage implementation in the same session.

## Definition of Done

- Complete one real observation-candidate run outside canonical research
  directories.
- Verify manifest provenance, input fingerprints, raw-output immutability,
  citation preservation, required observation sections, and stage results.
- Do not assign a canonical observation identifier or promote the candidate.
- Review the attached backlog-leverage recommendation against `NEXT.md` and the
  staged Abbey Research architecture.
- Make backlog-leverage treat explicit current-session exclusions and
  sequential phase boundaries conservatively.
- Add focused regression coverage and rerun the AI and Research suites.
- Record whether Phase 2 review-record and promotion implementation is ready to
  begin.

## Summary

Ran the completed observation-candidate workflow against a bounded working
sample of ten citation-bearing Facebook source records. The run reached
`review-ready`; its prompt and input snapshots matched their recorded hashes,
all ten source identifiers survived generation and normalization, raw output
was read-only, and structural validation passed.

The supplied backlog-leverage result was not conservative. It correctly found
the current observation-validation objective, but then claimed the same session
would complete canonical promotion, evidence generation, and hypothesis and
validation generation. `NEXT.md` explicitly placed those items in later phases
and made canonical promotion out of scope.

The backlog-leverage decision contract now treats `NEXT.md` boundaries as
controlling, rejects sequential phase bundling, distinguishes work on a covered
item from completion of its prerequisite, and requires explicit session-boundary
and excluded-work fields. A normal-use comparison against the same planning
state reduced confirmed coverage from four items to one and listed the later
research phases as excluded work.

## Accomplishments

- Created ignored, non-canonical working input and prompt files under
  `working/research/`.
- Completed real run `RUN-20260814-063002-0dab` with `gpt-oss:20b`.
- Verified the manifest recorded:
  - project `voice-analysis`
  - artifact type `observation`
  - corpus `CORPUS-001`
  - experiment `EXP-001`
  - model and token budget
  - prompt and input paths, snapshots, and SHA-256 fingerprints
  - artifact paths
  - commands, timestamps, exit codes, and results for all four stages
- Verified the prompt snapshot fingerprint:
  `e7ce4832a82cca297ea19bd1dcd3b12343b3876d4a695fbb09aa3e1bad1ab83d`.
- Verified the input snapshot fingerprint:
  `d01da02150d0b58bd3d97ffbb624e3426c29c5f94bbcce3d2d660dbfa4987d57`.
- Verified all ten `FB-NNNNNN` identifiers in the candidate existed in the
  input and no source identifier was introduced or lost.
- Confirmed `raw.md` was mode `0444` and the candidate passed all structural
  checks.
- Added planning-boundary and coverage-classification rules to the
  backlog-leverage prompt.
- Required `session_boundary` and `optional_work_excluded` in the
  backlog-leverage result schema and prohibited unspecified result fields.
- Added the session boundary to the shared Abbey AI report.
- Added focused prompt, schema, and report regression checks.
- Reran backlog-leverage against the unchanged planning state and received a
  conservative result with confirmed coverage `1`.
- Replaced Python 3.9-only `str.removeprefix` calls in Abbey Next backlog
  section extraction after the standard validation workflow exposed the
  incompatibility on macOS Python 3.8.
- Added a regression assertion that keeps the Python 3.9-only API out of the
  candidate extractor.

## Impact

Abbey Research Phase 1 is validated through real use. The observation workflow
is stable enough to begin the separately bounded Phase 2 implementation of
explicit review records and canonical observation promotion.

Abbey AI now has stronger protection against a high-impact planning failure:
turning a chain of documented prerequisites into one falsely high-leverage
session. Future backlog-leverage results must expose their boundary, exclude
later phases, and classify coverage based on the selected outcome's own
deliverables.

## Validation

- Real Abbey Research run:
  - state: `review-ready`
  - generation: passed
  - normalization: passed
  - sanitization: passed
  - structural validation: passed
  - canonical research changes: none
- Direct run-workspace inspection:
  - prompt snapshot hash matched its source
  - input snapshot hash matched its source
  - raw output was read-only
  - all candidate citations resolved to the bounded input
  - all required observation sections were present, unique, ordered, and
    non-empty
- `tests/test-abbey-ai.sh`
  - 150 passed, 0 failed.
- `tests/test-abbey-research.sh`
  - 129 passed, 0 failed.
- `tests/test-abbey-next.sh`
  - 40 passed, 0 failed.
- Normal-use backlog-leverage comparison:
  - original canonical-Ubuntu result: 4 items, including three later phases
  - updated local result using the configured Ubuntu-hosted model: 1 item
  - promotion, evidence, hypothesis, and validation work explicitly excluded
- `python3 -m json.tool config/ai/decisions/backlog-leverage/schema.json`
  - passed.
- `bash -n tools/bin/abbey-ai tests/test-abbey-ai.sh`
  - passed.
- `git diff --check`
  - passed before planning reconciliation.
- `abbey next`
  - completed successfully on macOS Python 3.8 after the compatibility fix.
- `abbey validate`
  - passed repository consistency checks.
- `abbey docs check`
  - passed all deterministic documentation freshness checks.

## Lessons Learned

Feature coherence is not session coherence. Canonical promotion, evidence
creation, hypothesis creation, and validation creation belong to one research
lifecycle, but they remain separate implementation phases with distinct human
authority and prerequisite boundaries.

A coverage map needs negative evidence as well as positive relationships.
Explicit exclusions, `after` dependencies, and future-phase headings must limit
coverage rather than becoming evidence that the work can be bundled.

Real workflow use remains the correct gate before automation expansion. The
Phase 1 run did not expose a blocker, so there is no basis for changing the
research orchestrator before beginning Phase 2.

The standard Abbey validation path is also valuable cross-platform coverage.
Running it from the actual session host exposed a portability defect that the
focused Next fixtures had not prevented on newer Python runtimes.

## Next Steps

- Rerun the updated backlog-leverage decision from the canonical Ubuntu
  environment before closing its normal-use evaluation backlog item.
- Implement explicit human review records and canonical observation promotion
  as the next separately bounded Abbey Research phase.
- Keep evidence candidate generation and hypothesis and validation candidate
  workflows out of scope until their documented prerequisites are promoted and
  validated.

## Notes

The real run workspace remains ignored at:

`working/research/runs/RUN-20260814-063002-0dab/`

The corrected decision history remains ignored under `.abbey/ai/history/`.

No generated candidate was assigned an `OBS` identifier, reviewed as approved,
or written beneath `docs/research/`.
