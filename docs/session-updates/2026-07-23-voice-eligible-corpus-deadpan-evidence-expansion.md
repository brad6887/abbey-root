---
artifact_id: SESSION-2026-07-23-VOICE-ELIGIBLE-CORPUS-DEADPAN-PILOT
artifact_type: session-update
title: Voice-Eligible Corpus and Deadpan Evidence Expansion
version: 1
status: completed
reviewed: false

created:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted research
---

# Voice-Eligible Corpus and Deadpan Evidence Expansion

## Objective

Begin full-corpus Voice Analysis research without platform artifacts by preserving a deterministic voice-eligibility filter, generating chronological batches, and retrieving human-reviewed deadpan candidates across the eligible corpus.

## Definition of Done

- CORPUS-001 remains unchanged.
- Platform-generated records are excluded through a derived research view.
- Ambiguous records remain reviewable.
- Original source identifiers and text are preserved.
- Eligible posts can be divided into deterministic chronological batches.
- A pilot batch completes generation, normalization, sanitization, deterministic validation, and human review.
- The remaining chronological batches complete candidate retrieval and human semantic review.
- A working cross-period aggregate preserves accepted, provisional, contradictory, and rejected candidates.

## Work Completed

Added:

- `tools/research/build_voice_eligible_corpus.py`
- `tools/research/batch_voice_corpus.py`
- `tests/test-voice-research-corpus.py`
- `docs/research/voice-analysis/prompts/deadpan-candidate-retrieval.md`

The eligibility filter classifies clean corpus records as:

- Eligible.
- Review.
- Excluded.

It also flags Facebook status-prompt completions so research may preserve them while omitting them from analyses where opening grammar would create platform bias.

## Eligibility Result

The frozen 3,039-row corpus produced:

- 1,502 eligible authored-voice candidates.
- 18 ambiguous records held for review.
- 1,519 excluded records, including the 1,287 rows already excluded by CORPUS-001.

New deterministic exclusions include:

- 210 automated check-ins.
- 22 link-only records.

Ambiguous records include:

- 15 Facebook mention-token records.
- 2 memory-metadata records.
- 1 application-quiz template.

The filter flagged 127 eligible Facebook status-prompt completions.

## Batch Generation

The unflagged eligible view contains 1,375 posts.

These were divided into eleven deterministic chronological batches:

- Ten batches of 125 posts.
- One final batch of 125 posts.
- Coverage from 2009-03-04 through 2026-05-10.

Each batch has:

- Stable chronological ordering.
- A manifest entry.
- First and last identifiers and timestamps.
- A SHA-256 fingerprint.

## Deadpan Pilot

The pilot used Batch 011:

- 125 posts.
- 2020-08-09 through 2026-05-10.
- Model: `gpt-oss:20b`.
- Prompt: `deadpan-candidate-retrieval.md`.

The pipeline preserved eight cited identifiers through:

- Generation.
- Normalization.
- Sanitization.
- Observation validation.

Deterministic validation reported zero failures.

## Human Review

Human review retained:

- Strong support: FB-001316.
- Provisional support: FB-001269.
- Provisional support: FB-001266.
- Contradictory evidence: FB-001267.

Human review rejected:

- FB-001276 because it is comic questioning and wordplay rather than clear deadpan delivery.
- FB-001248 because it is a pun rather than deadpan evidence.

The pilot demonstrates that batch retrieval is useful only when human semantic review removes plausible but invalid model classifications.

## Full Deadpan Retrieval

The validated prompt was run across Batches 001 through 010.

An initial verbose prompt caused Batch 003 to exhaust the model output limit without returning an artifact. A shorter equivalent prompt was tested successfully and used for Batches 003 through 010.

A `qwen3:8b` comparison completed much faster but produced poor semantic classifications. Its output was excluded. The accepted runs used `gpt-oss:20b`.

All eleven batches now have reviewed retrieval results.

The working aggregate retains:

- 16 supporting candidates.
- 7 provisional supporting candidates.
- 13 contradictory candidates.
- 1 provisional contradictory candidate.

The reviewed evidence spans 2009 through 2021.

No supporting example after 2021 was retained from the sparse recent-year sample. This does not establish absence.

## Integrity Findings

- All retained identifiers resolve to the frozen corpus.
- Reviewed batch copies pass source-membership validation.
- Batch 002 required a corrected reviewed copy because the model invented an identifier-range endpoint in its corpus description.
- Two generated quotation/identifier pairs were materially false and were rejected.
- Several generated excerpts omitted relevant surrounding text; decisions used complete frozen-corpus records.
- Human review rejected ordinary complaints, puns, cultural quotations, real events, platform prompts, and image-dependent claims that the model misclassified as deadpan.

## Research Assessment

The reviewed aggregate supports deadpan delivery as a recurring but selective characteristic across multiple writing periods.

Supporting forms include:

- Fictional technology and time travel.
- Procedural parody.
- Literal treatment of impossible events.
- Formal framing of absurd premises.
- Practical language applied to fictional or exaggerated situations.

Contradictory examples demonstrate that absurd material is also delivered through overt emphasis, explanation, emotional narration, and escalating punctuation.

## Canonical Evidence Revision

Revised:

- `EVID-001` from Version 1 to Version 2.
- `VAL-001` from Version 1 to Version 2.

EVID-001 now documents the derived corpus view, retrieval and human-review method, representative cross-period supporting evidence, representative contradictory evidence, and model-error safeguards.

VAL-001 now records:

- Substantially complete time-period diversity within Facebook through 2021.
- A completed counterexample search within the derived Facebook view.
- Passed source and citation integrity after human review.
- An unmeasured frequency claim.
- Continued lack of writing-format diversity.

The validation outcome remains `Provisionally Supported`. Confidence increases from `Low` to `Medium` within the Facebook scope, while remaining low for frequency, post-2021 continuity, and cross-format generalization.

## Validation

- New Python files compile.
- Nine focused corpus-filter and batching tests pass.
- Twenty-six existing Abbey Research regression tests pass.
- Pilot observation validation passes with zero failures.
- Reviewed batch copies pass source-membership validation.
- The frozen corpus was not modified.
- Working research outputs remain under ignored `working/research/`.

## Next Step

Review the complete session diff and commit the corpus workflow and canonical deadpan evidence revision as one coherent research increment.
