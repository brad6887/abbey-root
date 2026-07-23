---
artifact_id: VOICE-MODEL-001
artifact_type: voice_model
title: Bounded Facebook Voice Model
version: 2
status: draft

source:
  corpus: CORPUS-001
  experiment: EXP-001
  parent_artifacts:
    - VAL-001
    - VAL-002
    - VAL-003
    - VAL-004

created:
  date: 2026-07-23
  author: Brad Cooke
  method: Synthesis of four validated research chains
---

# Voice Model

## Overview

VOICE-MODEL-001 represents the current research-backed understanding of the
author's Facebook writing voice.

Within that scope, the writing often achieves its effect through economical
expression, reader inference, contrast between ordinary presentation and
unusual premises, continuity across separate posts, and marked wording that
signals a nonliteral or skeptical stance.

This is a bounded research model. It is not a general personality profile, an
imitation prompt, or evidence that the same characteristics govern technical,
professional, private, or long-form writing.

## Scope

Supported scope:

- Authored Facebook posts in CORPUS-001
- Primarily 2009 through 2021
- Recurring-narrative evidence extending through 2024
- Unflagged voice-eligible view of 1,342 posts

Confidence:

- Medium for the existence and recurrence of all four characteristics within
  their tested Facebook scopes
- Low for prevalence outside each measured population
- Low for post-2021 continuity except recurring narratives
- Low for transfer to other formats, audiences, and purposes

## Communication Identity

The validated Facebook voice is conversational and assumes an active reader.
It often leaves relationships, implications, or the final evaluative step for
the reader to recover.

The writing does not require every post to be humorous, concise, recurrent, or
typographically marked. Each characteristic is selective and
context-dependent.

## Validated Characteristics

### VM-C01: Deadpan Contrast

**Research chain:** OBS-001 → EVID-001 → HYP-001 → VAL-001

**Confidence:** Medium within absurd or exaggerated Facebook posts

When a post contains an impossible, fictional, absurd, or strongly exaggerated
premise, it often presents that premise through literal, procedural, or
ordinary language. The contrast between premise and presentation contributes
to the humorous effect.

Validated result:

- 11 deadpan cases among 16 qualifying absurd-premise posts
- Conditional rate: 68.75%
- 95% Wilson interval: 44.40% to 85.84%

Application guidance:

- State an unusual premise as though it were an ordinary fact or task.
- Let the mismatch carry the effect before adding explanation.
- Prefer one concrete operational detail over multiple comic intensifiers.

Do not:

- Apply deadpan delivery to every humorous statement.
- Explain the joke immediately after presenting it.
- Use this technique for sensitive, grieving, or high-stakes communication
  without explicit contextual justification.

### VM-C02: Semantic Compression

**Research chain:** OBS-002 → EVID-002 → HYP-002 → VAL-002

**Confidence:** Medium within Facebook writing from 2009 through at least 2020

The writing often communicates a complete relationship, reaction, causal
sequence, or joke with less explanation than a literal paraphrase would
require. It relies on shared context and reader inference while keeping the
intended connection recoverable.

Application guidance:

- Remove explanation the reader can reliably infer.
- Keep the causal or contrast relationship recoverable.
- Stop after the idea lands rather than restating it.
- Add context when the audience cannot reasonably supply it.

Do not:

- Equate compression with sentence fragments alone.
- Remove information required for accuracy, safety, or unfamiliar readers.
- Force every output into a one-liner.

### VM-C03: Selective Continuity

**Research chain:** OBS-003 → EVID-003 → HYP-003 → VAL-003

**Confidence:** Medium for selective recurrence in Facebook writing through
2024

The writing sometimes carries a distinctive premise, reporting frame, persona,
phrase, or recurring failure across otherwise independent posts. Later
references may omit reintroduction or explicitly point backward, creating
continuity for readers with prior context.

Application guidance:

- Reuse a distinctive established element only when prior context exists.
- Advance, vary, or reinterpret the element rather than merely repeat it.
- Let a callback remain compact when the audience can recover its history.

Do not:

- Invent shared history that has not been established.
- Treat repeated ordinary topics as narrative continuity.
- Require callbacks in standalone or first-contact writing.

### VM-C04: Quoted Stance Marking

**Research chain:** OBS-004 → EVID-004 → HYP-004 → VAL-004

**Confidence:** Medium within quote-bearing Facebook posts from 2009 through
2021

Quotation marks sometimes signal that wording is disputed, nonliteral,
inadequate, provisional, or being replaced with a deliberately comic name.
The marked phrase becomes an object of stance rather than neutral quotation.

Validated holdout result:

- 61 core cases among 139 holdout candidates
- Core rate: 43.88%
- 95% Wilson interval: 35.91% to 52.19%
- 36 distancing cases
- 25 comic-renaming cases
- 60 retained comparisons

Application guidance:

- Mark a term when the surrounding sentence genuinely questions or renames
  it.
- Make the stance recoverable from context.
- Use comic renaming as a compact alternative to an explanatory critique.

Do not:

- Treat ordinary titles, attributed quotations, or reported speech as this
  characteristic.
- Add scare quotes as decoration.
- Overuse quotation marks until the stance becomes ambiguous.

## Provisional Interactions

The following interactions are plausible syntheses but have not been
independently validated as combined characteristics.

### Compression and Deadpan Contrast

A compressed post may strengthen deadpan delivery by withholding explanation
after an absurd premise.

**Status:** Provisional interaction

### Compression and Selective Continuity

A callback may remain short because previous posts supply missing context.

**Status:** Provisional interaction

### Quoted Stance and Comic Renaming

Quotation marks can concentrate a longer critique into one marked replacement
label.

**Status:** Supported within VM-C04, but its interaction with VM-C01 remains
provisional

## Organization

The current evidence supports several local organizational tendencies:

- Brief setup followed by a contrast, inversion, or marked phrase
- Economical endings that do not restate the effect
- Later callbacks that assume prior context
- Occasional quoted wording that becomes the center of the post's stance

The research does not establish a general paragraph, essay, or technical
document structure.

## Language

Supported language-level characteristics:

- Conversational constructions
- Recoverable implication
- Literal or procedural wording around unusual premises
- Compact labels and renamed concepts
- Selective repetition across posts

Vocabulary preferences, dialect, punctuation frequency, profanity, spelling,
and sentence-length distributions have not been independently modeled.

## Humor

Validated humorous mechanisms include:

- Contrast between ordinary delivery and an unusual premise
- Literal reinterpretation
- Comic renaming
- Reversal of a quoted claim
- Callbacks to established elements

The research does not support applying humor universally. Overt humor,
emotional escalation, explanation, and nonhumorous posts also occur.

## Reader Relationship

The writing frequently assumes that the reader can infer an unstated
relationship or remember earlier context.

This should not be generalized to unfamiliar audiences. For readers without
shared history or domain knowledge, additional context may be necessary.

## Known Exceptions and Boundaries

VOICE-MODEL-001 is least reliable for:

- Technical documentation
- Professional or institutional communication
- Academic writing
- Long-form explanation
- Unfamiliar audiences
- Sensitive or high-stakes subjects
- Posts after 2021 for characteristics other than validated recurring
  narratives

The model does not establish:

- Authorial intent
- Reader reaction
- Comparative uniqueness
- Stable personality traits
- A complete catalog of the author's voice
- Safe imitation in every context

## Application Principles

When using this model to assist new writing:

1. Determine whether the context fits the validated Facebook scope.
2. Select no more characteristics than the task naturally supports.
3. Preserve factual clarity and audience needs before stylistic compression.
4. Use callbacks only when their prior context is supplied.
5. Use quotation marks only when their stance is clear.
6. Prefer restraint over stacking every characteristic.
7. Generate new language; do not reproduce corpus posts or distinctive source
   phrases.
8. Do not invent factual details such as times, causes, outcomes, names, or
   system behavior that the task does not supply.
9. When editing, preserve the original factual propositions unless the task
   explicitly authorizes changing them.
10. If a generated response visibly uses a characteristic, report it as
    applied rather than claiming it was omitted.

## Traceability

| Characteristic | Observation | Evidence | Hypothesis | Validation | Confidence |
|---|---|---|---|---|---|
| Deadpan contrast | OBS-001 | EVID-001 | HYP-001 | VAL-001 | Medium |
| Semantic compression | OBS-002 | EVID-002 | HYP-002 | VAL-002 | Medium |
| Selective continuity | OBS-003 | EVID-003 | HYP-003 | VAL-003 | Medium |
| Quoted stance marking | OBS-004 | EVID-004 | HYP-004 | VAL-004 | Medium |

## Revision History

Version 1:
Synthesized the four validated Facebook characteristics and defined bounded
application guidance.

Version 2:
Added factual-preservation, edit-preservation, and self-report consistency
constraints after the first application evaluation invented a maintenance
time and changed the factual premise of an editing task.

## Version Status

Version 2 is a bounded research draft.

Two controlled application runs failed mandatory factual-preservation checks.
The model should not be used as a free-generation writing prompt until an
application workflow can lock supplied facts and verify edits
deterministically.

It should not yet be treated as a cross-format author model.
