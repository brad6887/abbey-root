# Full-Corpus Observation Discovery

## Purpose

Full-corpus observation discovery lets an AI worker look for writing patterns
without starting from an existing observation or hypothesis.

Discovery produces candidates for human review. It does not create formal
`OBS`, `EVID`, `HYP`, or `VAL` artifacts automatically.

## Workflow

1. Freeze and fingerprint the normalized corpus.
2. Apply the documented voice-eligibility filter.
3. Divide eligible posts into deterministic chronological batches.
4. Run `abbey research discover` against the batch manifest.
5. Preserve the raw AI-worker response for each batch.
6. Attach citation text deterministically from the frozen corpus.
7. Validate each normalized result against both the batch and frozen corpus.
8. Aggregate validated candidates and create a pending review scaffold.
9. Cluster repeated candidates across batches during human review.
10. Record human review decisions in a candidate backlog.
11. Promote selected candidates through the normal observation, evidence,
   hypothesis, and validation lifecycle.

## End-to-End Command

Run:

```text
abbey research discover \
  --model gpt-oss:20b \
  --prompt docs/research/voice-analysis/prompts/full-corpus-observation-discovery.md \
  --corpus /path/to/clean_corpus.csv \
  --batch-manifest /path/to/batches/manifest.json \
  --output-dir working/research/voice-analysis/discovery-run \
  --max-tokens 10000 \
  --resume
```

`--resume` validates and skips completed results. A missing or invalid result is
rerun. The command stops when a newly generated result cannot be normalized or
validated, preserving completed work and the raw failing response.

`--validate-only` performs no model calls. It validates existing results and
rebuilds the aggregate outputs.

The output directory contains:

- `prompts/` - rendered prompt for each batch,
- `raw-results/` - unmodified AI-worker responses,
- `results/` - corpus-hydrated, validated manifests,
- `candidate-index.json` - all validated candidates and citations,
- `review-scaffold.json` - one pending human-review item per candidate.

The review scaffold deliberately contains no automatic clusters or promotion
decisions.

## Discovery Artifact

Each batch produces a JSON manifest with:

- a corpus fingerprint,
- model and prompt identity,
- a batch identifier,
- exactly three provisional candidates,
- two to four cited sources per candidate,
- source identifiers selected by the AI worker,
- complete source text attached deterministically from the frozen corpus,
- a scope note,
- and a boundary note.

The status must remain:

`candidate_discovery_human_review_required`

## Validation

Run:

```text
abbey research validate-discovery \
  --manifest FILE \
  --corpus FILE \
  --batch FILE
```

Validation requires:

- the expected schema and status,
- a matching corpus fingerprint,
- unique and correctly scoped candidate identifiers,
- source identifiers present in the supplied batch,
- and citation text that exactly matches the frozen corpus.

Passing validation establishes traceability, not analytical validity.

## Review Rules

- Prefer patterns independently found in more than one chronological batch.
- Treat platform conventions, recurring subject matter, and writing voice as
  separate concepts.
- Relate candidates to existing observations before proposing new ones.
- Retain weak or single-batch findings in the backlog rather than deleting
  them.
- Require broader evidence review before promoting any candidate.
