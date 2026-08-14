---
title: "Add Safe Abbey Research Observation Promotion"
description: "Add explicit hash-bound human review records and fail-closed canonical observation promotion."
date: 2026-08-14
status: complete
reviewed: false
session: add-safe-abbey-research-observation-promotion
tags:
  - Abbey Root
  - Abbey Research
  - canonical promotion
  - human review
---

# Add Safe Abbey Research Observation Promotion

## Objective

Implement Phase 2 of the Abbey Research artifact-creation workflow for
observation candidates.

Add explicit, initially undecided human review records and make canonical
promotion fail closed unless the run, candidate, review, source context, and
target all satisfy the documented safety contract.

## Definition of Done

- Create one review record bound to a review-ready observation run and candidate
  fingerprint.
- Preserve human authority by leaving all review decisions undecided initially.
- Validate complete approval and rejection records without inferring a human
  decision.
- Preview promotion without writing canonical research.
- Require explicit confirmation for the canonical write.
- Revalidate candidate structure, fingerprints, project context, identifiers,
  and target safety immediately before promotion.
- Allocate above the highest existing `OBS-###` identifier and never overwrite
  an existing target.
- Preserve model, prompt, input, candidate, review, corpus, experiment, and run
  provenance in the promoted artifact.
- Add focused fail-closed regression coverage.
- Keep evidence, hypothesis, validation, and interactive discovery review out
  of scope.

## Summary

Added the observation-only `review-init`, `review-validate`, and `promote`
commands.

`review-init` creates `review.json` in the run workspace with an undecided
overall decision, undecided research checks, empty reviewer data, and the
candidate SHA-256 fingerprint. The same fingerprint and review path are
anchored in the run manifest so editing both the candidate and review file
cannot bypass stale-candidate detection.

`review-validate` accepts an explicit completed approval or rejection while
preserving the distinction between deterministic validation and human research
judgment. `promote` is preview-only by default and requires `--confirm` before
it can install one canonical observation.

## Accomplishments

- Added `scripts/abbey_research_promotion.py` as the bounded review and
  promotion implementation.
- Added `abbey research review-init RUN-ID`.
- Added `abbey research review-validate RUN-ID`.
- Added preview-only `abbey research promote RUN-ID`.
- Added confirmed `abbey research promote RUN-ID --confirm`.
- Required review-ready observation state and passing recorded structural
  validation.
- Verified every prompt and input snapshot against its manifest fingerprint.
- Restricted candidate, snapshot, review, and canonical paths to their declared
  roots and rejected symlink redirection.
- Required the canonical project, corpus, and experiment to resolve before
  allocation, with matching artifact metadata and experiment-to-corpus
  relationship.
- Validated existing observation filenames and matching frontmatter identity.
- Allocated above the highest current observation number without filling gaps.
- Added an atomic, exclusive canonical install that refuses target collisions.
- Froze the promoted artifact and approved review record as read-only.
- Recorded successful promotion in the run manifest only after the canonical
  write succeeded, with rollback if the manifest update failed.
- Blocked candidate generation from configured canonical research paths.
- Updated CLI metadata, generated command documentation, and the Abbey Research
  artifact-creation architecture.
- Created an undecided, manifest-anchored review scaffold for real run
  `RUN-20260814-063002-0dab` without approving or promoting it.

## Impact

Abbey Research now has an explicit boundary between probabilistic candidate
generation, human research judgment, and canonical repository mutation.

Automation can verify structure, provenance, relationships, paths, and
fingerprints, but it cannot manufacture approval. A human must complete the
review record, and canonical mutation still requires a separate confirmed
command after inspecting the promotion preview.

The implementation is project-neutral and observation-only. It provides the
safe promotion prerequisite for later evidence creation without prematurely
adding downstream research stages.

## Validation

- `tests/test-abbey-research.sh`
  - 173 passed, 0 failed.
  - Covers undecided, approved, and rejected reviews.
  - Covers stale candidates and manifest-anchored hashes.
  - Covers canonical-path and symlink redirection protection.
  - Covers malformed canonical identifiers and metadata.
  - Covers mismatched canonical source metadata.
  - Covers preview-only behavior, collision refusal, confirmed promotion,
    provenance, read-only outputs, and duplicate-promotion refusal.
- `tests/test-abbey-cli-context.sh`
  - 12 passed, 0 failed.
- `python3 -m py_compile`
  - passed for creation and promotion scripts.
- `bash -n`
  - passed for the research command and regression suite.
- `abbey docs check`
  - passed.
- `abbey validate`
  - passed repository consistency checks.
- `git diff --check`
  - passed before planning reconciliation.
- Real run `RUN-20260814-063002-0dab`
  - review scaffold created successfully.
  - manifest anchor matches candidate fingerprint
    `df5ab7f1e4c0da81be8818ff602e990f5b80d72d4673cd4423376d2847fe3bc9`.
  - review remains undecided.
  - no canonical artifact was written.

## Lessons Learned

Hash binding is stronger when the immutable workflow manifest anchors the value
that the human-editable review record must match. A candidate hash stored only
inside the editable review could be updated along with a changed candidate and
would not provide an independent stale-content boundary.

Promotion safety requires controlling directories as well as filenames.
Symlinked candidates, review files, snapshots, or canonical directories could
otherwise redirect validation or mutation outside the intended workspace.

Preview and confirmation should be distinct invocations. This keeps the
promotion target and provenance inspectable without introducing an interactive
prompt or allowing a routine inspection command to mutate canonical research.

## Next Steps

- Have a human review the real candidate and its bounded source input.
- Complete the review record with an explicit approval or rejection decision.
- Run `abbey research review-validate RUN-20260814-063002-0dab`.
- If approved, inspect `abbey research promote
  RUN-20260814-063002-0dab` before deciding whether to rerun with `--confirm`.
- Do not begin evidence candidate generation until the observation review and
  real-use promotion decision are complete.

## Notes

The real run workspace and review record remain ignored under:

`working/research/runs/RUN-20260814-063002-0dab/`

The human review record currently contains only `undecided` decisions. This
session intentionally made no claim that the candidate warrants canonical
promotion.
