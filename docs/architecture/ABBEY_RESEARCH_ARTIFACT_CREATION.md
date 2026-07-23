---
artifact_id: ARCH-ABBEY-RESEARCH-ARTIFACT-CREATION
artifact_type: architecture
title: Abbey Research Artifact Creation
version: 1
status: draft

created:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted design
---

# Abbey Research Artifact Creation

## Purpose

Define a controlled workflow for creating canonical Abbey Research artifacts from source material without manually converting legacy research documents.

The completed Voice Analysis chains are reference fixtures for this workflow:

- OBS-001 → EVID-001 → HYP-001 → VAL-001
- OBS-002 → EVID-002 → HYP-002 → VAL-002
- OBS-003 → EVID-003 → HYP-003 → VAL-003

They demonstrate the expected artifact shape. They are not a queue that requires additional manual migrations.

## Scope

The design covers:

- Candidate generation.
- Structural normalization.
- Deterministic sanitization.
- Metadata and relationship validation.
- Corpus citation verification.
- Human review.
- Canonical promotion.
- Provenance capture.
- Stage-by-stage creation of observations, evidence, hypotheses, and validation records.

The design does not:

- Automatically decide that a research conclusion is true.
- Promote AI output without human review.
- Convert every legacy Experiment 001 file.
- Build a Voice Model.
- Require Voice Analysis-specific logic in the orchestration layer.

## Design Principles

### Candidates Are Not Canonical Artifacts

Generated output remains in a working area until it passes deterministic checks and a human explicitly promotes it.

Generation must never write directly to:

    docs/research/<project>/observations/
    docs/research/<project>/evidence/
    docs/research/<project>/hypotheses/
    docs/research/<project>/validation/

### Research Stages Remain Separate

The canonical lifecycle is:

    observation
        ↓
    evidence
        ↓
    hypothesis
        ↓
    validation

Each stage produces one independently reviewable artifact. A command may guide the researcher to the next stage, but it must not silently generate or promote an entire chain.

### Human Authority Is Explicit

Abbey may:

- Assemble source material.
- Run a configured model.
- Normalize structure.
- Sanitize formatting.
- Verify citations.
- Validate metadata.
- Detect relationship errors.
- Prepare a promotion.

A human must:

- Accept the research question.
- Review interpretations and scoring.
- Decide whether evidence is representative.
- Approve hypotheses.
- Judge validation outcomes.
- Explicitly promote each canonical artifact.

### Deterministic Checks Guard Flexible Generation

AI-assisted generation is probabilistic. Everything around it should be deterministic where practical.

The same candidate and source inputs must produce the same:

- Sanitized Markdown.
- Citation-verification result.
- Metadata-validation result.
- Relationship-validation result.
- Promotion target.

### Provenance Begins Before Generation

Every run must record its inputs before invoking a model.

Provenance must not be reconstructed later from memory or filenames.

## Workflow Model

Each artifact moves through the following states:

    initialized
        ↓
    generated
        ↓
    normalized
        ↓
    sanitized
        ↓
    verified
        ↓
    review-ready
        ↓
    approved
        ↓
    promoted

Failure states are retained:

    generation-failed
    normalization-failed
    verification-failed
    validation-failed
    review-rejected

A failed run remains inspectable. Abbey must not overwrite or discard the raw model response.

## Run Workspace

Each creation attempt receives an immutable run identifier and a dedicated workspace:

    working/research/runs/<run-id>/

Minimum contents:

    manifest.yaml
    inputs/
    raw.md
    normalized.md
    candidate.md
    validation.txt
    review.md

### Run Identifier

The run identifier identifies an execution, not a canonical artifact.

Recommended initial format:

    RUN-YYYYMMDD-HHMMSS-<short-random-suffix>

The suffix prevents collisions without implying research identity.

### Manifest

`manifest.yaml` records:

```yaml
run_id: RUN-20260723-120000-a1b2
project: voice-analysis
artifact_type: evidence
state: initialized

source:
  corpus: CORPUS-001
  experiment: EXP-001
  parent_artifacts:
    - OBS-004

inputs:
  - path: working/research/inputs/sample.md
    sha256: <fingerprint>

generation:
  model: gpt-oss:20b
  prompt: evidence-candidate
  prompt_version: 1
  tool_version: 1

created:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted research
```

State changes append execution records rather than replacing the original provenance.

## Canonical Artifact Identity

Canonical identifiers are assigned during promotion, not candidate generation.

Prefixes remain:

| Artifact type | Prefix | Directory |
|---|---|---|
| observation | OBS | observations |
| evidence | EVID | evidence |
| hypothesis | HYP | hypotheses |
| validation | VAL | validation |

The initial allocator should:

1. Discover canonical artifacts for the selected project.
2. Validate existing identifiers.
3. Determine the next unused numeric identifier for the selected type.
4. Refuse promotion if the target path or identifier already exists.
5. Display the proposed identifier before writing.

An identifier is never reused after promotion, even if an artifact is later superseded.

## Stage Contracts

### Observation

Required context:

- Project.
- Corpus.
- Experiment.
- Research question or exploratory prompt.
- Fingerprinted source input.

Required candidate content:

- Question.
- Corpus.
- Method.
- Findings.
- Interpretation.
- Questions Raised.
- Status.

Required checks:

- Required sections exist and contain content.
- Corpus and experiment references resolve.
- Every source-like identifier uses the canonical format.
- Referenced source identifiers exist in the supplied corpus.
- Findings preserve representative source citations.
- Interpretation is distinguishable from observation.

Promotion creates:

    docs/research/<project>/observations/OBS-###.md

### Evidence

Required context:

- One promoted observation.
- The same corpus and experiment context as the observation.
- Fingerprinted corpus data or an approved sample derived from it.
- A documented scoring scheme when scoring is used.

Required candidate content:

- Observation.
- Corpus and sample.
- Method or scoring rules.
- Evidence log.
- Supporting, neutral, and contradictory evidence where available.
- Summary.
- Current Assessment.
- Limitations.

Required citation checks for structured corpora:

- Source identifier exists.
- Quoted text exactly matches the source record.
- Date matches the source record.
- Duplicate citations are reported.
- Excluded corpus rows are reported.
- Score is within the declared scoring range.
- Summary arithmetic matches the evidence log.

Semantic judgments such as relevance and score remain human-reviewed.

Promotion creates:

    docs/research/<project>/evidence/EVID-###.md

The evidence identifier does not need to share the observation number. Relationships come from metadata, not matching suffixes.

### Hypothesis

Required context:

- At least one promoted observation.
- At least one promoted evidence artifact.
- Resolved corpus and experiment context.

Required candidate content:

- Description.
- Status.
- Supporting Evidence.
- Contradictory Evidence.
- Confidence.
- Open Questions.
- Validation Requirements.
- Revision History.

Required checks:

- All parent artifacts resolve.
- At least one parent is evidence.
- Supporting claims cite promoted evidence artifacts.
- Confidence uses an allowed value.
- Missing contradictory evidence is stated explicitly.
- The hypothesis does not claim validation.

Promotion creates:

    docs/research/<project>/hypotheses/HYP-###.md

### Validation

Required context:

- One promoted hypothesis.
- Its supporting evidence artifacts.
- A defined validation plan.

Required candidate content:

- Hypothesis.
- Validation Objective.
- Evidence Reviewed.
- Validation Tests.
- Current Assessment.
- Outcome.
- Confidence.
- Open Questions.
- Revision History.

Required checks:

- Hypothesis and evidence parents resolve.
- Every reviewed evidence artifact is promoted.
- Required validation dimensions have explicit states.
- Counterexample search is addressed.
- Outcome uses an allowed value.
- Confidence is proportional to completed validation tests.

The proportionality decision requires human review even when structural checks pass.

Promotion creates:

    docs/research/<project>/validation/VAL-###.md

## Command Interface

The proposed interface separates candidate creation from canonical promotion.

### Create a Candidate

```text
abbey research create \
  --project voice-analysis \
  --type observation \
  --corpus CORPUS-001 \
  --experiment EXP-001 \
  --model gpt-oss:20b \
  --prompt exploratory-observation \
  --input working/research/facebook-posts.md
```

Downstream stages add promoted parents:

```text
abbey research create \
  --project voice-analysis \
  --type evidence \
  --parent OBS-004 \
  --model gpt-oss:20b \
  --input /path/to/corpus.csv
```

The command should orchestrate:

    initialize
    → run
    → normalize
    → sanitize
    → validate

It returns a run identifier and review-ready candidate path. It does not create a canonical artifact.

### Inspect a Run

```text
abbey research run-status RUN-20260723-120000-a1b2
```

This reports:

- Current state.
- Inputs and fingerprints.
- Model and prompt provenance.
- Validation results.
- Candidate path.
- Unresolved failures.

### Review a Candidate

```text
abbey research review RUN-20260723-120000-a1b2
```

The initial implementation may generate a review checklist rather than launching an interactive reviewer.

The checklist records:

- Structural checks.
- Citation checks.
- Relationship checks.
- Human research decisions.
- Approval or rejection.

### Promote a Candidate

```text
abbey research promote RUN-20260723-120000-a1b2
```

Promotion requires:

- A review-ready candidate.
- Passing deterministic checks.
- Recorded human approval.
- Resolved canonical parents.
- An available canonical identifier and path.

Before writing, Abbey prints:

- Proposed artifact identifier.
- Target path.
- Parent relationships.
- Corpus and experiment.
- Input fingerprints.

Promotion is the only command in this workflow allowed to write beneath canonical research directories.

## Relationship Rules

Minimum allowed parent relationships:

| Child | Required formal parent |
|---|---|
| observation | experiment context |
| evidence | observation |
| hypothesis | evidence |
| validation | hypothesis and evidence |

Additional parents are allowed when they resolve and their role is recorded.

Legacy references must not be stored as formal parents. If historical traceability is needed, use a separate field:

```yaml
source:
  parent_artifacts:
    - OBS-004
  legacy_artifacts:
    - OBSERVATION007-implicit-reader-participation
```

## Validation Layers

### Layer 1 — File Safety

- Input exists and is readable.
- Output paths remain within the run workspace.
- Existing files are not overwritten without an explicit retry action.
- Canonical paths are protected from generation commands.

### Layer 2 — Structure

- Frontmatter parses.
- Required metadata exists.
- Required headings exist in the correct order.
- Sections contain content.

### Layer 3 — Relationships

- Corpus, experiment, and parent identifiers resolve.
- Artifact types match allowed stage relationships.
- The child does not create a dependency cycle.

### Layer 4 — Evidence Integrity

- Corpus fingerprint matches the declared source.
- Source identifiers resolve.
- Dates and quotations match.
- Derived counts and score totals are correct.

### Layer 5 — Human Research Review

- Finding wording is proportional to evidence.
- Evidence selection is representative.
- Scores are defensible.
- Counterexamples were sought.
- Confidence is justified.
- Conclusions do not exceed the validation scope.

Only Layers 1–4 are deterministic.

## Failure and Retry Behavior

- Raw output is immutable after successful generation.
- A retry creates a new attempt record in the same run or a new run, depending on whether inputs changed.
- Changing a model, prompt, source input, or parent creates a new run.
- Normalization and sanitization may be repeated from the same raw output with recorded tool versions.
- Failed validation never deletes a candidate.
- Rejected candidates remain available for methodology review.

## Implementation Sequence

### Phase 1 — Observation Candidate Orchestration

- Add `abbey research create --type observation`.
- Reuse existing run, normalize, sanitize, and observation validation capabilities.
- Add run manifests and immutable raw output.
- Add safe working-directory rules.
- Add regression tests using existing observation artifacts as fixtures.

### Phase 2 — Canonical Promotion

- Add deterministic identifier allocation.
- Add review records.
- Add `abbey research promote`.
- Protect canonical directories from all other creation commands.

### Phase 3 — Evidence Creation and Citation Verification

- Add the evidence candidate schema.
- Add CSV-backed source identifier, date, and quotation checks.
- Add score and summary arithmetic checks.
- Validate against EVID-001, EVID-002, and EVID-003.

### Phase 4 — Hypothesis and Validation Creation

- Add stage-specific schemas and validators.
- Enforce promoted-parent requirements.
- Preserve human authority over confidence and outcome.

### Phase 5 — Generalization

- Move Voice Analysis-specific schemas into project configuration when needed.
- Keep orchestration, workspace safety, provenance, and relationship checks reusable.
- Integrate creation runs with deterministic research status reporting.

## Acceptance Tests

The implementation is ready for real research when tests prove:

- Generation cannot write directly to canonical directories.
- A failed stage leaves raw output and provenance intact.
- Observation creation works when no optional `--input` values are supplied, including on the macOS Bash runtime.
- Source citations survive normalization and sanitization.
- Evidence with a wrong identifier, date, or quotation fails verification.
- Summary arithmetic errors fail verification.
- Missing or invalid parents block promotion.
- Canonical identifier collisions block promotion.
- A promoted artifact includes model, prompt, source fingerprint, and parent provenance.
- The three existing chains pass as reference fixtures.
- No test requires Voice Analysis conclusions to be hard-coded into Abbey.

## Initial Implementation Target

Implement Phase 1 only:

    abbey research create --type observation

This is the smallest useful vertical slice because the existing tooling has already validated its component steps. It will prove orchestration, provenance, workspace safety, and review-ready output before canonical promotion or downstream research stages are automated.
