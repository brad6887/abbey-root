# Voice Fact-Lock Workflow

## Purpose

Convert a new writing request into a human-reviewed generation boundary before
VOICE-MODEL-001 produces text.

The workflow is:

```text
request suite
  → AI proposal
  → structural validation
  → human review
  → AI revision when required
  → hash-bound approval
  → approved fact lock
  → voice generation
  → deterministic validation
  → semantic verification
  → human proposition review
```

No proposed or revised lock is approved merely because it passes structural
validation.

## Proposal

The supported public command is:

```text
abbey research fact-lock propose \
  --model gpt-oss:20b \
  --suite working/research/voice-analysis/request-suite.json \
  --output working/research/voice-analysis/fact-lock-proposal.json \
  --max-tokens 16000
```

The command fixes `propose-voice-fact-lock.md` as the prompt and supplies the
request-suite JSON document to the existing Abbey research runner.

The proposal must remain in
`proposed_human_review_required` status.

Validate and optionally normalize it with:

```text
abbey research fact-lock validate \
  --suite working/research/voice-analysis/request-suite.json \
  --proposal working/research/voice-analysis/fact-lock-proposal.json \
  --normalized-output working/research/voice-analysis/fact-lock-proposal-normalized.json
```

The public command delegates to `validate_voice_fact_lock_proposal.py`. It
checks source-request coverage, schema completeness, fact IDs, anchor
structure, regex validity, creative slots, style boundaries, sentence-count
constraints, and number types.

Both commands state that the result still requires human review. Neither
command can approve or apply a lock.

## Review Summary

After validation and normalization, print the deterministic review summary:

```text
abbey research fact-lock review \
  --suite working/research/voice-analysis/request-suite.json \
  --proposal working/research/voice-analysis/fact-lock-proposal-normalized.json
```

The command validates before displaying:

- suite and proposal SHA-256 hashes,
- recorded source-hash agreement,
- scenario and aggregate constraint counts,
- every immutable proposition and anchor mode,
- protected literals and numeric content,
- required and prohibited characteristics,
- sentence-count and forbidden-pattern constraints,
- creative-slot boundaries and cardinality,
- and scenario-specific review-attention flags.

The summary is read-only. It does not create a review manifest, modify inputs,
approve a proposal, or promote a lock. The proposal JSON remains the source of
truth.

## Review Scaffold

Initialize a blank review manifest from the exact normalized proposal:

```text
abbey research fact-lock review-init \
  --suite working/research/voice-analysis/request-suite.json \
  --proposal working/research/voice-analysis/fact-lock-proposal-normalized.json \
  --output working/research/voice-analysis/fact-lock-review.json
```

The scaffold records:

- the proposal manifest ID,
- canonical proposal SHA-256,
- canonical source-request SHA-256,
- one item per scenario in proposal order,
- null review and future fact-lock IDs,
- an `undecided` overall decision,
- `undecided` facts and constraints decisions,
- and blank human notes.

The command validates the proposal and any recorded source hash before writing.
It protects an existing output and never preselects approval or revision. The
unchanged scaffold cannot pass the approval tool.

## Human Review and Revision

Review every scenario for:

- complete source and context preservation,
- correct relationships between facts,
- grammatical state and timing,
- nonduplicated facts,
- natural but discriminating lexical anchors,
- authorized numeric content,
- narrowly bounded creative slots,
- privacy and factual prohibitions,
- and exact style and format constraints.

Record `approve` or `revise` for facts and constraints separately and add a
nonblank note for every scenario. Validate the completed review with:

```text
abbey research fact-lock review-validate \
  --suite working/research/voice-analysis/request-suite.json \
  --proposal working/research/voice-analysis/fact-lock-proposal-normalized.json \
  --review working/research/voice-analysis/fact-lock-review.json
```

The validator checks the canonical suite and proposal hashes, proposal
manifest ID, exact scenario coverage and order, completed item decisions,
notes, overall decision, and decision-specific ID rules. It does not revise,
approve, or promote anything.

When the overall decision is `revise`, create a replacement proposal with:

```text
abbey research fact-lock revise \
  --model gpt-oss:20b \
  --suite working/research/voice-analysis/request-suite.json \
  --proposal working/research/voice-analysis/fact-lock-proposal-normalized.json \
  --review working/research/voice-analysis/fact-lock-review.json \
  --output working/research/voice-analysis/fact-lock-proposal-revised.json \
  --max-tokens 16000
```

The command refuses a review whose decision is not `revise`, fixes the
generalized revision prompt, and supplies the suite, rejected proposal, and
review record to the Abbey research runner. The replacement remains
`proposed_human_review_required`; validate it and begin a new complete review.

## Approval

An approval review contains the canonical SHA-256 hash of the complete
normalized proposal.

Promote it with:

```text
abbey research fact-lock approve \
  --suite working/research/voice-analysis/request-suite.json \
  --proposal working/research/voice-analysis/fact-lock-proposal-normalized.json \
  --review working/research/voice-analysis/fact-lock-review.json \
  --output working/research/voice-analysis/fact-lock-approved.json
```

The public command first requires a completed review whose overall decision is
`approve`, then delegates promotion to `approve_voice_fact_lock.py`. It
rejects:

- a mismatched proposal hash,
- incomplete review coverage,
- any scenario whose facts or constraints are not approved,
- a non-approval decision,
- missing review or fact-lock IDs,
- and an existing output path.

Promotion changes only artifact metadata and the `requests` key to
`scenarios`; it does not rewrite facts or constraints.

## Generation and Verification

Generate with:

- `apply-reviewed-voice-fact-lock.md`
- VOICE-MODEL-001
- the approved lock

Validate with:

```text
validate_fact_locked_voice_output.py
```

The validator supports:

- `required_any` alternative anchors,
- `required_all` groups for compound propositions,
- quote-insensitive anchor matching,
- exact protected literals,
- allowed numbers,
- forbidden patterns,
- creative-slot cardinality,
- required and prohibited characteristics,
- and sentence counts.

Then run `verify-reviewed-voice-fact-lock.md` as an advisory semantic pass and
validate that response with
`validate_fact_locked_voice_verification.py`.

Human proposition review remains mandatory. The semantic verifier has
previously missed factual changes.

## Evaluation Result

VOICE-FACT-EXTRACTION-EVAL-001 exercised:

- an ordinary Facebook post,
- an edit,
- a callback with authorized invention,
- a sensitive message,
- and a factual notice.

The initial approved lock failed end-to-end generation validation, exposing
anchor, number, regex, and prompt-ID defects. After review and revision,
VOICE-FACT-LOCK-002 passed deterministic and semantic verification for all
five requests.

## Boundary

The proposal-through-approval workflow is functional through public Abbey
commands and has exercised both revision and approval branches. This
evaluation does not approve fully automatic fact extraction. Human review is a
required control, and multiple revisions may be necessary.
