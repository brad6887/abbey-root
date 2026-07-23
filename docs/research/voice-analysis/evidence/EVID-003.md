---
artifact_id: EVID-003
artifact_type: evidence
title: Evidence Supporting Recurring Narrative Elements
version: 2
status: draft

source:
  corpus: CORPUS-001
  experiment: EXP-001
  parent_artifacts:
    - OBS-003
    - EVIDENCE005-recurring-narrative-elements

created:
  date: 2026-07-21
  author: Brad Cooke
  method: AI-assisted research

updated:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted cluster retrieval with deterministic search and human review
---

# Evidence

## Observation

OBS-003 proposes that the author sometimes develops fictional or thematic concepts across multiple independent pieces of writing rather than treating each idea as a standalone reference.

## Corpus

Experiment:

- EXP-001 - Initial Facebook Corpus Voice Analysis

Frozen source:

- CORPUS-001
- 3,039 normalized records
- SHA-256: `b5dc53ffc11c19a18fd0b2fe9450ff91de03a24f905cd503d21c6a2daabdf07e`

Research views:

- The original first-100 sample, including authored Facebook status-prompt completions.
- Eleven deterministic chronological batches from the 1,375-post unflagged voice-eligible view.
- Combined coverage from 2009 through 2026.

CORPUS-001 remained unchanged.

## Method

Candidate retrieval used `gpt-oss:20b` and the versioned `recurring-narrative-candidate-retrieval.md` prompt.

Unlike single-post evidence, a recurring cluster required at least two separate source posts with a distinctive shared element. A later post had to continue, modify, recall, or assume familiarity with the earlier element.

The first prompt exhausted the output budget before returning findings and was replaced with a shorter equivalent. Batch 008 also required a separate retry after one empty length-limited response.

Human review rejected:

- Multiple updates from the same real event.
- Repeated ordinary topics or real organizations.
- Duplicate or platform-generated records.
- Repeated wording without narrative or thematic development.
- Image-dependent relationships that could not be established from text.

Retained cluster labels were expanded through deterministic corpus search. Every cited identifier and quotation was checked against the source.

## Reviewed Result

| Classification | Clusters |
|---|---:|
| Retained recurring clusters | 5 |
| Provisional recurring clusters | 2 |
| Representative isolated comparisons | 5 |

Retained clusters span 2009 through 2024.

## Retained Recurring Clusters

### Time-Machine Narrative and Callbacks

| Source | Date | Post |
|---|---|---|
| FB-002620 | 2009-02-09 | is making adjustments to his time machine. |
| FB-002619 | 2009-02-10 | is is disappointed his time machine is still not working. I'll try again yesterday. |
| FB-002589 | 2009-04-06 | has just adjusted the flurb and installed the new flux capacitor. Time machine testing tomorrow, I'll call you yesterday if all goes well. |
| FB-002586 | 2009-04-14 | flew his time machine to the west coast and was able to successfully travel 2 hours into the future, that's progress. |
| FB-002553 | 2009-06-16 | wants to do away with the phrase "In today's economy". Everything you do is in "today's economy" unless you have a time machine...... If you do have a time machine (that works), call me.....I have some ideas. |
| FB-002476 | 2010-01-22 | I just found out I have jury duty in Tyler last week. I hope my time machine works better than it did the last time I used it. |
| FB-002065 | 2014-03-12 | can't find my flux capacitor. |

The 2009 posts progress from adjustment and failed repair to testing and partial success. The 2010 and 2014 posts refer to prior use and established equipment without rebuilding the premise.

FB-001966, a 2015 "hot tub time machine" post, is a provisional member because it may depend more on the film reference than the author's earlier sequence.

---

### Overheard-at-Work Frame

**FB-002357 — 2010-11-11**

> Overheard at work: "She was a communist, but I didn't realize that when I married her because I was in love with her at the time".

**FB-002310 — 2011-03-28**

> Overheard at work - Computer Geek insult attempt: You're so dumb you probably tried to buy a kindle and an iPad on the dame day.....

The later post reuses the distinctive reporting frame for a new workplace quotation, creating a small recurring series rather than repeating the same event.

---

### Pay-It-Forward Inversion

**FB-002854 — 2013-05-11**

> Sometimes people go to a public restroom and leave a drink for the next visitor. Paying it forward people.

**FB-002872 — 2013-08-17**

> The only coffee in the hotel room this morning was decaffeinated. I made it just so I could throw it away. Pay it forward people.

Two unrelated situations apply the same mock-altruistic closing to waste or an unwanted item. The later post assumes the recurring inversion can carry the joke.

---

### GrandBrad Persona

**FB-001474 — 2019-05-15**

> I’m going to be a GrandBrad.

**FB-001360 — 2020-07-13**

> Look who came to see GrandBrad!

The first post establishes the name; the later post uses it as an already familiar identity more than a year later.

---

### National Daughters Day Failure

**FB-001183 — 2022-09-26**

> Whelp, missed National Daughters Day again. I think this is the only photo I have of her. Sorry Megan Cooke

**FB-000531 — 2023-09-26**

> Megan Cooke I thought national daughters day meant my daughter was supposed to post about me. I’m sorry I messed this up for the 20th consecutive time.

**FB-000347 — 2024-09-26**

> Happy day after National Daughters day Megan Cooke. #fatheroftheyear

Three annual posts explicitly repeat and develop the same failure narrative. "Again," "20th consecutive time," and the day-after framing rely on recurrence as part of the joke.

## Provisional Recurring Clusters

- Fred: FB-002782 introduces Fred and FB-003032 later attributes an opinion to Fred. Missing image context prevents confirming whether the text alone establishes an authored character.
- Suzypalooza: FB-001940 announces the event and FB-003012 closes the 2015 event while announcing preparation for 2016. The named annual frame recurs, but both retained posts come from one weekend.

## Isolated Comparisons

Representative one-off premises include:

- FB-002484: joining the circus.
- FB-002362: exile to a prison asteroid.
- FB-002214: the invented Chick-Fil-a-Obama-Romney-book.com.
- FB-001903: the Zark Muckerberg chain-post parody.
- FB-001316: giant flying lobsters of Mexico.

These show that distinctive concepts frequently remain standalone. They establish selectivity but do not contradict the existence of recurring clusters.

## Integrity Findings

- All retained identifiers and quotations match the source corpus or deterministic batches.
- The model attached the first "Overheard at work" quotation to FB-002359; deterministic search found the actual source at FB-002357, and only the verified identifier was retained.
- A same-event concert sequence, real-band updates, ordinary home-brewing posts, and a duplicated concert upload were rejected.
- Thirty-three residual `Mobile uploads Place:` records were discovered in the unflagged batches and excluded from evidence.
- One Batch 008 run returned no artifact after exhausting its output budget; its successful retry is the only Batch 008 result used.
- The frozen corpus was not modified.

## Current Assessment

The broader evidence supports recurring narrative and thematic elements as a selective Facebook-writing technique from 2009 through at least 2024.

The strongest clusters do more than repeat a subject. Later posts refer to prior use, reuse a distinctive frame in a new situation, preserve a named persona, or explicitly turn earlier failures into annual shared context.

The evidence cannot demonstrate whether readers recognized the references or whether the continuity was deliberately planned. It also does not establish frequency or use outside Facebook. EVID-003 therefore remains draft.

## Revision History

Version 1:
Initial evidence from the 2009 time-machine sequence in the first 100 chronological clean Facebook posts.

Version 2:
Expanded to cross-period cluster retrieval, deterministic corpus search, and human review; added five retained clusters through 2024, provisional clusters, isolated comparisons, integrity corrections, and the residual-platform-artifact limitation.
