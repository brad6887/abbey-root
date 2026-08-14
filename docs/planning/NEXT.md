# Abbey Root Next

Last Reviewed: 2026-08-14

# Current Theme

## Preserve Human Authority at Promotion

# Primary Objective

Implement explicit review records and safe canonical promotion for Abbey
Research observation candidates.

# Success Criteria

The canonical-promotion session is complete when:

- A review record is explicitly bound to one review-ready observation run and
  its candidate fingerprint.
- A newly created review record contains no implicit approval.
- Rejected, incomplete, stale, or invalid review records cannot authorize
  promotion.
- Promotion requires explicit human approval and passing deterministic checks.
- The next available `OBS-###` identifier and target path are determined
  without collisions or identifier reuse.
- Only the promotion workflow can write an observation candidate beneath the
  canonical research hierarchy.
- The promoted artifact preserves run, model, prompt, corpus, experiment,
  input-fingerprint, and review provenance.
- Focused regression coverage proves approval, rejection, collision, stale
  candidate, and canonical-path safety behavior.

## Current Objective

Implement Phase 2 of the staged Abbey Research artifact-creation workflow for
observation review and promotion.

## Definition of Done

The implementation is complete when:

- Review records begin undecided and are hash-bound to the candidate under
  review.
- Promotion fails closed unless the candidate is review-ready, unchanged,
  structurally valid, and explicitly approved.
- Promotion previews and then writes exactly one available canonical
  observation identifier and path.
- The promoted artifact contains the required research and generation
  provenance.
- No evidence, hypothesis, or validation candidate workflow is added in this
  phase.

---

# Completed Foundation

## Corpus Foundation

Completed:

- CORPUS-001 formalizes the Facebook source corpus.
- Source locations, normalization, identifiers, limitations, and provenance are documented.

## Experiment Alignment

Completed:

- EXP-001 formalizes Experiment 001.
- EXP-001 references CORPUS-001.
- Existing experiment outputs remain traceable.

## Artifact Workflow Validation

Four complete formal artifact chains now exist:

### Deadpan Delivery

- OBS-001
- EVID-001
- HYP-001
- VAL-001

### Concise Expression

- OBS-002
- EVID-002
- HYP-002
- VAL-002

### Recurring Narrative Elements

- OBS-003
- EVID-003
- HYP-003
- VAL-003

### Quoted Language

- OBS-004
- EVID-004
- HYP-004
- VAL-004

These reference fixtures demonstrate the expected artifact lifecycle:

Observation

↓

Evidence

↓

Hypothesis

↓

Validation

## Observation Candidate Orchestration

Completed:

- `abbey research create --type observation` creates a controlled run
  workspace with input snapshots, provenance, immutable raw output, and a
  review-ready candidate.
- Real run `RUN-20260814-063002-0dab` validated generation, normalization,
  sanitization, structural checks, fingerprints, citation preservation, and
  canonical-path isolation with `gpt-oss:20b`.
- No Phase 1 workflow blocker was discovered through real use.

---

# Current Priorities

## Current Phase — Canonical Observation Promotion

## Objective

Add the explicit human-review and promotion boundary required to move an
approved observation candidate from its run workspace into canonical research.

## Implementation Scope

### Review Records

- Create one explicit review record for one review-ready run.
- Bind the record to the run identifier and candidate fingerprint.
- Begin with human decisions unresolved rather than approved by default.
- Preserve the review record with the run for inspection and later promotion.

### Canonical Promotion

- Require a review-ready run, unchanged candidate, passing validation, and an
  explicit approval record.
- Discover existing canonical observation identifiers and select the next
  available identifier without reuse.
- Preview the identifier, target, relationships, and provenance before writing.
- Write one canonical observation artifact and retain its source-run and review
  traceability.

### Safety Boundary

The implementation must:

- Support observation artifacts only.
- Keep candidate generation outside canonical research directories.
- Permit canonical writes only through the promotion command.
- Never infer, manufacture, or default a human approval decision.
- Refuse stale candidates, missing or rejected reviews, unresolved project
  context, identifier collisions, and existing targets without mutation.

### Tests

- Add focused coverage for review initialization and candidate hash binding.
- Prove incomplete and rejected reviews block promotion.
- Prove candidate changes after review block promotion.
- Prove identifier and target collisions fail without overwriting.
- Prove candidate creation cannot write to canonical paths.
- Rerun the Abbey Research suite and `abbey review`.

---

# Future Direction

## Evidence Creation

After promotion is safe:

- Add evidence-specific candidate structure.
- Verify corpus identifiers, dates, and exact quotations.
- Verify score ranges and summary arithmetic.
- Validate against EVID-001, EVID-002, and EVID-003.

## Hypothesis and Validation Creation

After evidence creation is validated:

- Add stage-specific candidate schemas.
- Require promoted parent artifacts.
- Preserve human authority over confidence and outcome.

## Research Status

The initial deterministic, read-only `abbey research status` implementation is complete for the current repository happy path.

Refinement for invalid, incomplete, duplicate, and broken artifact states remains deferred. Artifact creation is the current human-directed priority.

## Voice Analysis Expansion

After creation, promotion, and validation tooling is stable:

- Review additional time periods.
- Review additional writing formats.
- Search systematically for counterexamples.
- Increase or reduce hypothesis confidence based on evidence.

## Voice Model Development

Create the first Voice Model only after:

- Multiple hypotheses have broader validation.
- Counterexamples are documented.
- Confidence levels are meaningful.
- Shared higher-level characteristics can be justified.

---

# Guiding Principle

Validate framework workflows through real, non-canonical use before expanding
their automation or promoting generated artifacts into authoritative sources.
