# Observation Format Standard

## Purpose

Observation documents record patterns identified during review of the normalized corpus.

An observation is a descriptive research finding that may later be evaluated through a separate evidence document.

Observation documents identify:

- the question being investigated,
- the corpus sample reviewed,
- the review method,
- the initial findings,
- the current interpretation,
- unresolved questions,
- and the observation's research status.

Observations should remain descriptive and provisional.

They should not contain a scored evidence log or claim that a characteristic has been conclusively established.

---

## Document Structure

Every observation document follows this structure:

    Question

    Corpus

    Method

    Findings

    Interpretation

    Questions Raised

    Status

---

## Title

Use the observation number and canonical title.

Example:

    # Observation 004 – Deadpan Delivery

Observation numbers use three digits and remain stable after assignment.

---

## Question

State the research question evaluated by the observation.

The question should be:

- specific,
- testable against the corpus,
- focused on one writing characteristic,
- and phrased without assuming the conclusion.

Example:

    ## Question

    Does the author consistently present absurd or impossible situations using a serious, matter-of-fact tone?

---

## Corpus

Identify the experiment and the sample reviewed.

Example:

    ## Corpus

    **Experiment:** 001 – Facebook Corpus

    **Sample:**

    The first 100 chronological posts from the normalized corpus.

The sample description must be precise enough for another researcher to reproduce the review.

Examples include:

- the first 100 chronological posts,
- posts 101–200 from the normalized corpus,
- a defined random sample,
- or the complete normalized corpus.

---

## Method

Describe how the sample was reviewed and what characteristics were considered.

The method should explain:

- what qualified as relevant material,
- what distinctions were evaluated,
- and what was intentionally outside the scope of the observation.

Example:

    ## Method

    Posts containing absurd, impossible, or highly improbable statements were reviewed.

    The tone of each post was evaluated to determine whether the absurdity was emphasized or simply presented as an ordinary statement.

---

## Findings

Describe what was observed in the reviewed sample.

Findings should:

- report patterns present in the sample,
- avoid overstating frequency,
- distinguish direct observation from interpretation,
- and avoid reproducing the full evidence log.

Short illustrative lists may be included when they clarify the pattern.

---

## Interpretation

Explain the provisional significance of the findings.

Interpretation may describe:

- how the technique appears to function,
- how it affects the reader,
- how it relates to other observations,
- or why it may be important to the author's voice.

Interpretation must remain provisional until supported by broader evidence.

Preferred language includes:

- appears to
- may
- suggests
- within this sample

---

## Questions Raised

Record unresolved questions created by the observation.

Questions may address:

- consistency across the complete corpus,
- changes over time,
- relationships with other observations,
- differences between writing contexts,
- or areas requiring additional evidence.

Example:

    ## Questions Raised

    - Is the pattern present throughout the corpus?
    - Does it occur more frequently in humorous writing?
    - Is it also present outside Facebook?

---

## Status

Every observation includes a status.

Initial observations use:

    ## Status

    Preliminary

Additional statuses may be introduced later if the research workflow requires them.

A status change should reflect a defined research transition rather than a subjective confidence judgment.

---

## Relationship to Evidence

An observation identifies a possible writing pattern.

A corresponding evidence document evaluates how strongly the frozen corpus supports or contradicts that observation.

Example:

    observations/OBSERVATION004-deadpan-delivery.md
    evidence/EVIDENCE004-deadpan-delivery.md

The observation document should not duplicate the evidence entries, score distribution, weighted score, or current evidence assessment.

The relationship is:

    Observation
        ↓
    Evidence evaluation
        ↓
    Current assessment

---

## File Naming

Observation filenames use:

    OBSERVATIONNNN-canonical-title.md

Example:

    OBSERVATION004-deadpan-delivery.md

The observation number, document heading, and corresponding evidence number must agree.

Canonical titles should also remain consistent between observation and evidence filenames.
