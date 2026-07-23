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
4. Run the discovery prompt independently against every batch.
5. Validate each machine-readable result against both the batch and frozen
   corpus.
6. Correct only reviewable citation transcription errors. Reject citations
   whose identifiers and text refer to different sources.
7. Cluster repeated candidates across batches.
8. Record human review decisions in a candidate backlog.
9. Promote selected candidates through the normal observation, evidence,
   hypothesis, and validation lifecycle.

## Discovery Artifact

Each batch produces a JSON manifest with:

- a corpus fingerprint,
- model and prompt identity,
- a batch identifier,
- exactly three provisional candidates,
- two to four cited sources per candidate,
- complete source text,
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

