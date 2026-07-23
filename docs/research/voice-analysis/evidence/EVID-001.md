---
artifact_id: EVID-001
artifact_type: evidence
title: Evidence Supporting Deadpan Delivery
version: 3
status: draft

source:
  corpus: CORPUS-001
  experiment: EXP-001
  parent_artifacts:
    - OBS-001
    - EVIDENCE004-deadpan-delivery

created:
  date: 2026-07-20
  author: Brad Cooke
  method: AI-assisted research

updated:
  date: 2026-07-23
  author: Brad Cooke
  method: AI-assisted candidate retrieval with human review
---

# Evidence

## Observation

OBS-001 proposes that the author frequently presents absurd or impossible situations using an ordinary, matter-of-fact tone.

## Corpus

Experiment:

- EXP-001 - Initial Facebook Corpus Voice Analysis

Frozen source:

- CORPUS-001
- 3,039 normalized records
- SHA-256: `b5dc53ffc11c19a18fd0b2fe9450ff91de03a24f905cd503d21c6a2daabdf07e`

Derived research view:

- 1,469 voice-eligible posts
- 127 Facebook status-prompt completions flagged
- 1,342 unflagged eligible posts represented across eleven deterministic chronological batches
- Coverage from 2009-03-04 through 2026-05-10

The derived view excludes platform-generated records without changing CORPUS-001.

The Version 3 view additionally excludes 33 records beginning with the generated `Mobile uploads Place:` prefix. None of those records was cited by EVID-001.

## Method

Candidate retrieval used `gpt-oss:20b` and the versioned `deadpan-candidate-retrieval.md` prompt.

Every retained source identifier was checked against the frozen corpus. Human review then evaluated the complete source text and rejected candidates that were ordinary complaints, puns, cultural quotations, real events, platform prompts, image-dependent claims, or mismatched quotation-and-identifier pairs.

The model retrieved candidates rather than scoring a representative sample. The counts below establish recurring cross-period evidence but do not measure how frequently the technique occurs.

## Reviewed Result

| Classification | Retained | Provisional |
|---|---:|---:|
| Supporting | 16 | 7 |
| Contradictory | 13 | 1 |

The reviewed candidates span 2009 through 2021. No supporting example after 2021 was retained from the sparse 2022-2026 portion of the corpus; that does not establish absence.

## Representative Supporting Evidence

### FB-002586

**Date:** 2009-04-14

> flew his time machine to the west coast and was able to successfully travel 2 hours into the future, that's progress.

Time travel is reported as incremental technical progress. The practical closing phrase sustains the impossible premise without announcing the joke.

---

### FB-002420

**Date:** 2010-06-11

> I just challenged Gary Coleman to a duel to the death. I have not heard back from him yet, we'll see how it goes.

An extreme fictional challenge is followed by routine follow-up language, as though the author is waiting on an ordinary reply.

---

### FB-002325

**Date:** 2011-02-19

> IMPORTANT. Tomorrow Facebook will change its settings to allow zombies to come into your house while you sleep and eat your brains with a sharpened spoon. To stop this from happening go to Accounts / Home Invasion Settings / Cannibalism / Brains and un-check the "Tasty" box. Please copy and re-post.

A zombie invasion is presented as a procedural Facebook-settings problem. The administrative instructions carry the absurd premise.

---

### FB-002214

**Date:** 2012-07-26

> Apparently I've logged into Chick-Fil-a-Obama-Romney-book.com

An impossible blended website is reported as an ordinary login result with no explanatory setup.

---

### FB-000367

**Date:** 2013-04-19

> I'm no longer "live tweeting" any events. From now on my all tweets will be pre-recorded in front of a live studio audience.

Mutually incompatible forms of live and recorded communication are framed as a normal procedural change.

---

### FB-002065

**Date:** 2014-03-12

> can't find my flux capacitor.

A fictional device is treated as an ordinarily misplaced object.

---

### FB-001966

**Date:** 2015-02-12

> I just used my hot tub time machine to travel to the future and watch Hot Tub Time Machine 3.

Impossible travel is reported as routine transportation used for a practical entertainment purpose.

---

### FB-001583

**Date:** 2018-03-25

> I’ve developed a new algorithm for Facebook that I’m trying to sell them. It’s called “ chronological order”. It’s very sophisticated.

An ordinary display order is presented as a sophisticated invention through restrained technical language.

---

### FB-001316

**Date:** 2020-11-01

> Giant flying lobsters of Mexico.

An impossible image is stated as a standalone declarative fact without explanation or emphasis.

## Representative Contradictory Evidence

### FB-002502

**Date:** 2009-10-09

> WHAT?! Obama wins the Nobel Peace prize and the only hours later bombs the moon.

The absurd event is announced with capitalization and an emphatic question rather than restraint.

---

### FB-002438

**Date:** 2010-04-15

> Do you know where OBAMA was on 9/11? Me either, doesn't that make you wonder? Did you know the current Secretary of Defence doesn't even know karate? HE DOESN'T EVEN KNOW TAE KWON DO! How is HE supposed to defend anybody? 99% of you will not repost this because it's some stupid crap I just made up, but those of you who care about the ridiculous please repost this as your status and enjoy.

The political parody uses capitalization, repeated questions, direct explanation, and explicit acknowledgment of its absurdity.

---

### FB-000629

**Date:** 2010-11-04

> I hope the new Republican congress will pass a law to SEVERELY punish people who burn microwave popcorn at work. #officestinks

The exaggerated legal response is emphasized with capitalization and a complaint hashtag.

---

### FB-002278

**Date:** 2011-07-22

> I LOVE Johnny cash but I'm a little freaked out that he is dead, yet still posting things of Facebook.

The impossible premise is framed with overt love and alarm rather than neutral delivery.

---

### FB-002189

**Date:** 2012-12-12

> I just saw a story about "Storage Wars" being fake! I hope A&E pays a heavy price for putting something on TV that's not real. If something's not 100% real I don't waste my time with it! Later today I'm watching that documentary about the giant lizard that crawled out of the ocean and destroyed Tokyo.

The contrast is developed through explicit explanation and repeated emphasis rather than being left implicit.

---

### FB-003027

**Date:** 2018-04-12

> A double yolk! WHAT DOES IT MEAN??!?!!?

An ordinary event is given exaggerated cosmic significance through capitalization and extreme punctuation.

## Integrity Findings

- All retained identifiers resolve to CORPUS-001.
- Reviewed batch copies pass source-membership validation.
- Two materially false quotation-and-identifier pairs were detected and rejected.
- A generated identifier-range endpoint was corrected in the reviewed working copy.
- Decisions used complete frozen-corpus records when generated excerpts were shortened.
- A faster comparison model was excluded because its semantic classifications were unreliable.

## Current Assessment

The broader evidence supports deadpan delivery as a recurring but selective characteristic in Facebook writing from 2009 through at least 2021.

The strongest examples apply practical, procedural, technical, or emotionally neutral language to fictional technology, impossible events, and absurd premises. The contradictory examples demonstrate that the author also uses overt emphasis, explanation, emotional narration, and escalating punctuation for absurd material.

The evidence does not establish a frequency rate, coverage outside Facebook, or continuity after 2021. EVID-001 therefore remains draft.

## Revision History

Version 1:
Initial evidence from the first 100 chronological clean Facebook posts.

Version 2:
Expanded to the reviewed 1,375-post unflagged voice-eligible view, added cross-period supporting and contradictory evidence, documented model-error safeguards, and narrowed the assessment to the supported scope.

Version 3:
Applied the residual location-metadata exclusion, updated the derived view to 1,469 eligible and 1,342 unflagged posts, and confirmed that no retained citation was removed.
