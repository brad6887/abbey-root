# Abbey Root Next

Last Reviewed: 2026-08-14

# Current Theme

## Validate Human Authority at Promotion

# Primary Objective

Complete one real human observation review and decide whether its candidate
warrants canonical promotion.

# Success Criteria

The real-use review session is complete when:

- A human reads the candidate and its bounded source input.
- The human explicitly approves or rejects every research-review check.
- The review record names the reviewer, records a timezone-aware timestamp,
  and explains the decision.
- `abbey research review-validate` accepts the completed record.
- A rejected candidate creates no canonical artifact.
- An approved candidate receives a read-only promotion preview before any
  canonical write is considered.
- The human explicitly decides whether to stop after preview or rerun promotion
  with `--confirm`.
- Any confirmed artifact has the previewed identifier, target, relationships,
  and provenance and passes `abbey research status` inspection.
- The session records whether evidence candidate generation is ready to begin.

## Current Objective

Exercise the completed Phase 2 review and promotion workflow with a real
observation candidate while preserving the human approval boundary.

## Definition of Done

The validation is complete when:

- One manifest-anchored review record moves from `undecided` to an explicit
  human decision.
- The completed record passes deterministic review validation.
- The decision produces either a documented rejection with no canonical change
  or an inspected promotion preview and separate human confirmation decision.
- No command or AI process fills in or changes the human review decision.
- No evidence, hypothesis, or validation candidate workflow is added.

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

## Observation Review and Promotion

Completed:

- `abbey research review-init` creates an undecided review record anchored to
  the run manifest and candidate fingerprint.
- `abbey research review-validate` requires complete explicit human decisions.
- `abbey research promote` previews a validated canonical promotion without
  writing.
- `abbey research promote --confirm` exclusively installs one reviewed
  observation, preserves provenance, freezes authoritative outputs, and records
  the promotion in the run manifest.
- Fail-closed fixtures cover rejection, stale content, unsafe paths, malformed
  canonical identity, collisions, duplicate promotion, and provenance.

---

# Current Priorities

## Current Phase — Real Observation Promotion Validation

## Objective

Validate the completed review and promotion boundary without treating workflow
testing as approval of the research conclusion.

## Implementation Scope

### Human Review

- Select a real review-ready observation run and inspect its candidate and
  bounded source material.
- Record the reviewer, timestamp, canonical title when applicable, checklist
  decisions, overall decision, and explanatory notes.
- Leave the record untouched until a human supplies those judgments.

### Promotion Decision

- Validate the completed review record.
- If rejected, retain the run and stop without canonical mutation.
- If approved, inspect the read-only promotion preview.
- Require a separate human decision before invoking `--confirm`.
- Inspect any confirmed canonical artifact and its run-manifest provenance.

### Safety Boundary

The validation must:

- Support observation artifacts only.
- Never infer, manufacture, or default a human review decision.
- Keep the current real review record undecided until a human acts.
- Treat preview as read-only and confirmation as a separate authority boundary.
- Keep evidence, hypothesis, validation, and interactive discovery-review
  implementation outside this session.

### Tests

- Run review validation after the human decision.
- If promotion is confirmed, run `abbey research status` and inspect the new
  incomplete observation chain without treating incompleteness as failure.
- Run `abbey review` before capture.

---

# Future Direction

## Evidence Creation

After one real review and promotion decision validates Phase 2:

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
