---
artifact_id: EVID-004
artifact_type: evidence
title: Evidence Supporting Quoted Language as Comic Framing
version: 1
status: draft

source:
  corpus: CORPUS-001
  experiment: EXP-001
  parent_artifacts:
    - OBS-004

created:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted complete candidate classification with human review
---

# Evidence

## Observation

OBS-004 proposes that the author sometimes uses quotation marks to create
distance from literal wording, supply a comic alternative name, or frame a
phrase for reinterpretation or reversal.

The observation excludes ordinary titles, attributed quotations, and reported
speech unless the surrounding authored text materially changes their
function.

## Corpus

Frozen source:

- CORPUS-001
- 3,039 normalized records
- SHA-256: `b5dc53ffc11c19a18fd0b2fe9450ff91de03a24f905cd503d21c6a2daabdf07e`

Research view:

- 1,342 unflagged voice-eligible posts
- Eleven deterministic chronological batches
- Coverage from 2009 through 2026

Candidate set:

- 165 posts containing deterministic paired quotation signals
- 136 ASCII double-quote matches
- 13 curly double-quote matches
- 19 paired ASCII single-quote matches

Signal counts overlap.

## Method

Candidate construction used
`build_quoted_language_candidates.py`. It required an eligible research status,
excluded platform-context rows, and excluded ordinary curly apostrophes in
contractions.

The local `gpt-oss:20b` worker classified the 165 candidates in seventeen
small batches of no more than ten sources. Each result used a compact category
and relevance code.

`normalize_quoted_language_classification.py` required:

- every expected source exactly once,
- no unexpected source,
- a valid category code,
- and a valid relevance code.

All seventeen batches passed without manual repair.

Human review used a conservative mapping:

- `SD-S`, scare or distancing support: retain.
- `IR-S`, invented label or renaming support: retain.
- `DQ-S` and `RS-S`, direct quotation or reported speech marked as support:
  provisional pending case-specific framing review.
- comparison classifications: retain as comparisons.
- copied, malformed, or unsuitable matches: reject.

REVIEW-004 records a decision and exact frozen-corpus citation for every
candidate.

## Complete Review Result

| Evidence role | Decision | Posts |
|---|---:|---:|
| Supporting | Retain | 76 |
| Supporting | Provisional | 20 |
| Comparison | Retain | 65 |
| Comparison | Reject | 4 |
| **Total** |  | **165** |

The retained supporting core contains:

- 44 scare-or-distancing cases
- 32 invented-label-or-renaming cases

The 20 provisional cases contain direct quotations or reported speech whose
comic contribution depends on surrounding framing.

## Canonical Supporting Evidence

### Distancing or questioning a label

| Source | Date | Post |
|---|---|---|
| FB-001085 | 2009-06-24 | yummy "meat" pressed into the shape of "ribs?" |
| FB-002517 | 2009-09-10 | finds it humorous that people are using the words "credibility" and "American Idol" in the same sentence today. |
| FB-000363 | 2013-04-30 | I'm "live" tweeting tonight from @HGBrewery I'm drinking a beer. |
| FB-002210 | 2012-08-17 | I like to say horrible things, and then I put "LOL" at the end so It's cool. |
| FB-001386 | 2020-05-05 | Dear Facebook. I have aced all your "genius" quizzes. I'll be expecting my Noble Peace prize to arrive in 3-5 days please. |
| FB-001354 | 2020-07-27 | You conspiracy people have to come up with a better insult than "sheep." Sheep are actually pretty cool. And you can't have "snowflake" back. You've ruined that one with all your crying. |
| FB-001221 | 2021-08-21 | I’m currently getting the run down on the “truth about Covid”. Also left wing retailers that I can’t shop at. And also pieces of shit that vote for Democrats who enjoy the protection of real men who will kill for their freedom. Thanks East Texas. |

These posts mark the quoted wording as questionable, qualified, or inadequate
rather than neutrally reproducing it.

### Comic renaming or reinterpretation

| Source | Date | Post |
|---|---|---|
| FB-000664 | 2010-09-22 | I'm getting a little suspicious of these 'tea party' people because I never see them with any tea. |
| FB-000565 | 2011-01-07 | I suspect that movie "Country Strong" should be named "Country Suck". |
| FB-002324 | 2011-02-21 | I've just declared myself "President of my cubicle" so I can have today off. I wish I would have thought of that before I actually went to work. |
| FB-000368 | 2013-04-14 | Apparently Ikea is Swedish for "screaming babies" |
| FB-002138 | 2013-06-27 | My favorite feature of facebook is the "People You May Know" which on my page should be called "Here's a list of people who've defriended you recently" |
| FB-002064 | 2014-03-15 | I'd like to propose that we ban the term "viral video" and replace it with "some crap we saw on the internet and decided to use as filler on our news broadcast." |
| FB-001583 | 2018-03-25 | I’ve developed a new algorithm for Facebook that I’m trying to sell them. It’s called “ chronological order”. It’s very sophisticated. |
| FB-001455 | 2019-07-18 | Another addition to my “food found on gas pumps” collection. |

These examples give ordinary subjects altered names, treat a phrase literally,
or mark an invented category as the compact center of the joke.

## Canonical Comparisons

Ordinary title use:

- FB-000785: Prince song title `1999`.
- FB-000052: Led Zeppelin song title `The Ocean`.
- FB-000357: Marvin Gaye song title `Sexual Healing`.

Attributed direct quotation:

- FB-002275: Bon Scott quotation.
- FB-002282: Dave Grohl quotation.
- FB-001990: quotation attributed to The Dude.

Reported speech:

- FB-002051: first-day-at-work quotation.

These comparison cases show that typography alone is insufficient. The
surrounding sentence must make the quoted wording a target of distance,
renaming, reinterpretation, or reversal.

## Integrity Findings

- All 165 candidate identifiers received exactly one classification.
- All seventeen classification batches passed exact source-set validation.
- REVIEW-004 contains 165 unique review items and 165 exact citations.
- REVIEW-004 passes `abbey research validate-review`.
- No model output was manually completed or repaired.
- The earlier 42-source classification attempts were rejected and are not
  used.
- The frozen corpus and derived eligibility view were not modified.

## Current Assessment

The evidence supports OBS-004 as a recurring Facebook-writing characteristic.

The strongest evidence is not generic quotation. It is the repeated use of
marked wording to signal that a label should not be accepted literally or to
replace it with a comic alternative. Retained examples span 2009 through 2021
and occur across unrelated subjects.

The evidence does not yet establish prevalence among all posts, comparative
distinctiveness, transfer beyond Facebook, or whether distancing and renaming
should become separate hypotheses. EVID-004 therefore remains draft.

