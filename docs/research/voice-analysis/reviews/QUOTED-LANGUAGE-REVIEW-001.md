# Quoted-Language Targeted Review

## Question

Does the eligible Facebook corpus support a preliminary observation that
quotation marks recur as a comic framing device, beyond ordinary quotation
and title punctuation?

## Corpus

The review uses the same 1,342-post population supplied to the full-corpus
discovery batches:

- `research_status` equals `eligible`
- `platform_context` is empty

Source:

`working/research/voice-analysis/full-corpus-batches-2026-07-23-v2/voice-eligible.csv`

Source SHA256:

`f796ad73cfd2dee20f26c24c7fe9876fc3430d2801fbbac65eb07a7ec0e32d27`

## Candidate Construction

`build_quoted_language_candidates.py` selected posts containing:

- ASCII double quotation marks,
- curly double quotation marks,
- paired ASCII single quotation marks outside words,
- or paired curly single quotation marks.

Ordinary curly apostrophes in contractions were excluded.

Results:

- Eligible posts: 1,342
- Quote-bearing candidates: 165
- ASCII double-quote candidates: 136
- Curly double-quote candidates: 13
- Paired ASCII single-quote candidates: 19

Signal counts overlap when a post contains more than one quote form.

## Discovery Context

The open-ended full-corpus worker independently produced:

- B001-C02, quotative emphasis with quotation marks
- B004-C01, quoted external text inclusion

These candidates raised a useful distinction. External quotations are not
automatically voice evidence. The quotation marks must materially alter the
writer's framing to support the proposed observation.

## Supporting Review

Representative examples span multiple chronological periods.

### Distancing from a literal label

- FB-001085 places `meat` and `ribs?` in quotation marks to question the
  product labels.
- FB-002517 contrasts `credibility` with `American Idol`.
- FB-000363 marks `live` as a qualified description.
- FB-000664 marks `tea party` before interpreting the phrase literally.
- FB-002397 places `work` in quotation marks after listing a comfortable
  setup.
- FB-002044 marks `wordsy` as a questionable label.
- FB-001999 marks `entertainment` to distance the writer from the announced
  description.
- FB-001386 marks `genius` while mocking easy Facebook quizzes.
- FB-001354 marks `sheep` and `snowflake` while challenging their use as
  insults.

### Comic renaming or invented labels

- FB-000057 renames the band `Genius Of The Heard the Audiobook`.
- FB-000368 states that Ikea is Swedish for `screaming babies`.
- FB-000565 proposes replacing `Country Strong` with `Country Suck`.
- FB-002064 proposes replacing `viral video` with a deliberately long,
  dismissive label.
- FB-002138 rewrites `People You May Know` as a list of people who recently
  defriended the writer.
- FB-002273 proposes `Saturday fatter day` as an alternative rhyming phrase.
- FB-002324 declares the writer `President of my cubicle`.
- FB-002333 invents the `high six`.
- FB-002356 names an imagined application `words with people you would murder
  if you thought you could get away with it`.
- FB-001455 names a recurring `food found on gas pumps` collection.

### Quotation as reversal setup

- FB-002210 quotes `LOL` while explaining its use as cover for saying
  something horrible.
- FB-002186 quotes `Failure is not an option!` before considering what should
  happen after failure.
- FB-002334 quotes `Failure is not an option` and supplies a dismissive
  internal response.
- FB-001773 quotes `Facebook is a place for Assholes` as the conclusion of a
  mock contest.
- FB-001583 quotes `chronological order` while calling a basic ordering feature
  a sophisticated algorithm.

## Comparison and Boundary Examples

The candidate set also contains ordinary quotation functions:

- FB-000052 uses quotation marks for the song title `The Ocean`.
- FB-000357 uses quotation marks for the song title `Sexual Healing`.
- FB-000785 uses quotation marks for the song title `1999`.
- FB-002423 uses quotation marks for the film title `Fast Times At Ridgemont
  High`.
- FB-002275 attributes a direct Bon Scott quotation.
- FB-002282 attributes a direct Dave Grohl quotation.
- FB-001990 attributes a quotation to The Dude.
- FB-002051 reports a quotation heard on the first day at a job.
- FB-002125 reports speech overheard in a bar.
- FB-000047 reproduces a long external publication blurb.

These examples show that quotation marks alone are not the characteristic.
The proposed pattern is limited to cases where marked language creates
distance, renaming, reinterpretation, or reversal.

## AI Classification Attempt

The local worker was asked to classify all 165 candidates. A verbose batch
exhausted its generation budget and produced truncated JSON. A compact retry
also failed completeness by replacing required source identifiers with an
ellipsis.

Neither output was accepted as research data.

The failed attempt is retained in the working directory for process diagnosis.
The observation decision below is based on deterministic candidate
construction and explicit source review.

## Decision

The pattern warrants a preliminary formal observation.

Reasons:

- It appears in widely separated chronological periods.
- Multiple examples use quotation marks to alter the stance toward a term,
  not merely quote it.
- Comic renaming and reversal recur with different subjects.
- Ordinary titles, direct quotations, and reported speech provide a clear
  boundary class.

This review does not establish prevalence, distinctiveness outside Facebook,
or whether all framing subtypes belong in one final hypothesis.

## Status

Human review complete.

OBS-004 was created as a draft observation.

Follow-up review completed all 165 candidate decisions in seventeen batches
of no more than ten sources. REVIEW-004 and EVID-004 now preserve that complete
review. HYP-004 and VAL-004 remain deferred.
