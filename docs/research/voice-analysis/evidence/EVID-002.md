---
artifact_id: EVID-002
artifact_type: evidence
title: Evidence Supporting Preference for Concise Expression
version: 2
status: draft

source:
  corpus: CORPUS-001
  experiment: EXP-001
  parent_artifacts:
    - OBS-002
    - EVIDENCE003-preference-for-concise-writing

created:
  date: 2026-07-21
  author: Brad Cooke
  method: AI-assisted research

updated:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted candidate retrieval with human review
---

# Evidence

## Observation

OBS-002 proposes that the author frequently communicates complete ideas using highly compressed language, relying on context and reader inference rather than extensive explanation.

## Corpus

Experiment:

- EXP-001 - Initial Facebook Corpus Voice Analysis

Frozen source:

- CORPUS-001
- 3,039 normalized records
- SHA-256: `b5dc53ffc11c19a18fd0b2fe9450ff91de03a24f905cd503d21c6a2daabdf07e`

Derived research view:

- 1,502 voice-eligible posts
- 127 Facebook status-prompt completions flagged
- 1,375 unflagged eligible posts reviewed through eleven deterministic chronological batches
- Coverage from 2009-03-04 through 2026-05-10

The derived view excludes platform-generated records without changing CORPUS-001.

## Method

Candidate retrieval used `gpt-oss:20b` and the versioned `concise-expression-candidate-retrieval.md` prompt.

The pilot prompt was revised after it incorrectly treated missing-context fragments as contradictions and generic short statements as strong support. The corrected prompt requires supporting examples to compress discernible meaning and contradictory examples to use unnecessary elaboration rather than merely lack context.

Every retained identifier and quotation was checked against the deterministic source batches. Human review rejected generic one-liners, image-dependent captions, cultural quotations without authored framing, missing-context fragments, and examples that were short without demonstrating semantic compression.

The model retrieved candidates rather than annotating every post. The results establish cross-period recurrence but do not measure frequency.

## Reviewed Result

| Classification | Retained | Provisional |
|---|---:|---:|
| Supporting | 16 | 0 |
| Contradictory | 3 | 2 |

The retained supporting candidates span 2009 through 2020. No strong supporting example after 2020 was retained from the sparse recent portion of the corpus; that does not establish absence.

## Representative Supporting Evidence

### FB-000801

**Date:** 2009-12-03

> Coffee + defective cup = shirt that smells like starbucks. And a huge stain.

An equation-like structure compresses the cause, event, and result of a coffee spill into a miniature narrative.

---

### FB-002449

**Date:** 2010-03-10

> First boner dies, then one of the Frog Brothers, who's next maybe Steve Urkle?

Several cultural references and a larger reaction to celebrity deaths are compressed into one question, leaving the reader to supply the connections.

---

### FB-002363

**Date:** 2010-09-30

> It's five o'clock somewhere, and by somewhere I mean right here.

A familiar expression is modified in one clause to communicate both the premise and the author's immediate conclusion.

---

### FB-002281

**Date:** 2011-07-16

> I'm going to enter some kind of contest so I can use the term "in it to win it" more.

A motive, action, and punch line are combined in one compact sentence without explanatory setup.

---

### FB-000368

**Date:** 2013-04-14

> Apparently Ikea is Swedish for "screaming babies"

A complete situational joke is reduced to a mock translation, relying on the reader to infer the shopping experience.

---

### FB-000097

**Date:** 2013-09-04

> I got two olives and a couple of limes, Guessin' that means it's martini time.

A small set of objects supplies the premise and permits the activity to be inferred in one compact statement.

---

### FB-002928

**Date:** 2014-04-24

> Throw back Thursday. This is me, last Thursday.

Two short sentences establish and subvert a familiar social-media convention without explaining the joke.

---

### FB-003010

**Date:** 2015-05-22

> Did I just lose a molar? Or is this gravy? you be the judge!

A possible event, absurd alternative, and audience invitation are compressed into three short questions and statements.

---

### FB-001890

**Date:** 2016-01-28

> Reminder: Nobody cares who you're voting for.

A complete social judgment is delivered as a compact mock reminder with no supporting explanation.

---

### FB-001593

**Date:** 2018-03-04

> I don't know why people need to announce they're not watching the Oscars, but thanks for letting me know I guess?

The post compresses an observation, criticism, and sarcastic response into one sentence.

---

### FB-001316

**Date:** 2020-11-01

> Giant flying lobsters of Mexico.

An entire absurd image is communicated through a five-word declarative phrase with no explanatory framing.

## Representative Contradictory Evidence

### FB-002438

**Date:** 2010-04-15

> Do you know where OBAMA was on 9/11? Me either, doesn't that make you wonder? Did you know the current Secretary of Defence doesn't even know karate? HE DOESN'T EVEN KNOW TAE KWON DO! How is HE supposed to defend anybody? 99% of you will not repost this because it's some stupid crap I just made up, but those of you who care about the ridiculous please repost this as your status and enjoy.

The parody builds its point through repeated questions, escalating examples, direct explanation, and audience instruction rather than compression.

---

### FB-002348

**Date:** 2010-12-13

> Thanks to everyone who wished me happy birthday! And those of you who didn't... Well I just hope you find a way to make peace with that decision, paybacks are a BITCH!!!

A simple thank-you expands into a narrated warning and explicit punch line.

---

### FB-002260

**Date:** 2011-09-21

> I can't decide what's more annoying, people bitching about Facebook or people bitching about people who are bitching about Facebook. I fall under both categories so I'm annoying X2.

The post intentionally repeats and elaborates its central complaint before explaining the self-directed conclusion.

## Provisional Contradictory Evidence

Two long-form posts were retained provisionally:

- FB-001866, a twelve-album list with explanations and memories.
- FB-001650, a thirty-six-question survey with extended comic answers.

Both demonstrate an expansive writing mode, but their source formats invite elaboration. They are evidence against a universal brevity claim, not strong evidence of unnecessary explanation.

## Integrity Findings

- All retained identifiers and quotations match the deterministic source batches.
- The first pilot's invalid contradiction category was corrected before the full run.
- Human review rejected generic brevity, fragments, image-dependent captions, and unsupported cultural interpretations.
- Several model explanations overstated what absent context allowed; retention decisions use only the supplied text.
- The frozen corpus was not modified.

## Current Assessment

The broader evidence supports concise expression as a recurring but selective characteristic in Facebook writing from 2009 through at least 2020.

The strongest examples compress causal sequences, cultural connections, situational jokes, judgments, and micro-narratives while relying on the reader to infer unstated relationships. The contradictory evidence shows that the author also uses repetition, escalation, and extended formats when those approaches serve the post.

The evidence does not establish a frequency rate, coverage outside Facebook, or continuity after 2020. EVID-002 therefore remains draft.

## Revision History

Version 1:
Initial evidence from the first 100 chronological clean Facebook posts.

Version 2:
Expanded to the reviewed 1,375-post unflagged voice-eligible view, added cross-period supporting and contradictory evidence, documented prompt correction and human-review safeguards, and narrowed the assessment to the supported scope.
