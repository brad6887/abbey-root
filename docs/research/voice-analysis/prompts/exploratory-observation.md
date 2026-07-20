# Exploratory Observation Prompt

Review the supplied Facebook corpus sample and produce one exploratory observation document.

## Research Objective

Identify recurring writing patterns visible in the supplied sample without assuming any predefined categories or conclusions.

The purpose of this review is to generate candidate observations for later, separate evidence evaluation.

## Corpus Scope

The supplied corpus contains the first 100 chronological clean posts from Experiment 001 – Facebook Corpus.

Treat the sample as partial.

Do not claim that a pattern is established across the complete corpus.

## Evidence Requirements

For every candidate pattern:

- Provide a complete description of the observed pattern.
- Include at least two representative source identifiers from the supplied corpus.
- Source identifiers must use the exact format `FB-000000`.
- Do not create or infer source identifiers.
- Do not summarize a finding without retaining its supporting examples.
- If a pattern cannot be supported by source identifiers, do not include it as a finding.

## Review Method

Review the posts for recurring characteristics involving areas such as:

- sentence length and construction,
- tone,
- humor,
- narrative perspective,
- treatment of ordinary events,
- use of cultural references,
- relationship with the implied reader,
- recurring rhetorical techniques,
- and repeated structural choices.

These areas are guides only.

Do not force the findings into predefined categories.

## Traceability

Use the stable source identifiers included in the corpus, such as:

    FB-002631

When mentioning an illustrative post, cite its source identifier.

Do not invent identifiers.

Do not alter quoted wording.

Use only the supplied corpus as evidence.

## Research Constraints

The output must remain descriptive and provisional.

Do not:

- produce a scored evidence log,
- calculate an evidence score,
- claim that a characteristic is conclusively established,
- infer private facts about the author,
- diagnose the author,
- or compare the author with named writers.

Distinguish direct observations from interpretation.

Use cautious language such as:

- appears to,
- may,
- suggests,
- within this sample,
- and warrants further investigation.

## Required Output

Return only a Markdown observation document using exactly this structure:

    # Observation – Exploratory Survey of Early Facebook Posts

    ## Question

    ## Corpus

    ## Method

    ## Findings

    ## Interpretation

    ## Questions Raised

    ## Status

Use this corpus description:

    **Experiment:** 001 – Facebook Corpus

    **Sample:**

    The first 100 chronological clean posts from the normalized corpus.

Set the status to:

    Preliminary

The Findings section should identify distinct candidate patterns and include source identifiers for representative examples.

Do not reproduce the complete corpus or create a full evidence document.

Produce all seven required sections before adding detail.

Do not expand the Method section beyond one paragraph.

The Findings section is the main analytical section.

## Length Constraints

Keep the complete observation under 1,500 words.

Identify no more than eight candidate patterns.

For each candidate pattern:

- use a name of no more than eight words,
- write one short descriptive paragraph,
- cite two to four representative source identifiers,
- and do not quote more than one short phrase.

Keep the Interpretation section to no more than three paragraphs.

Include no more than six questions in Questions Raised.

## Machine-Validation Requirements

Use plain ASCII characters for all structural syntax.

Specifically:

- Write headings with no trailing spaces.
- Use the normal ASCII hyphen-minus character in source identifiers.
- Write identifiers exactly as `FB-002631`.
- Do not use Unicode hyphens, en dashes, em dashes, or non-breaking spaces inside identifiers.
- Cite only identifiers visibly present in the supplied corpus.
- Never cite an analogous, remembered, inferred, or unavailable post.
- If a pattern has no supplied representative source, omit that pattern.
- Do not include phrases such as "not shown," "analogous," or "outside the sample."

Use a Markdown bullet list in the Findings section rather than a table.

For each candidate pattern, use this form:

### Candidate Pattern: Name

Description of the observed pattern.

Representative sources:

- `FB-000000`
- `FB-000000`
