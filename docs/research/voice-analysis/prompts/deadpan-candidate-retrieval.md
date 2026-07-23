# Deadpan Candidate Retrieval

Review the supplied batch for deadpan-delivery candidates.

Deadpan delivery means an absurd, fictional, exaggerated, contradictory, or unexpected premise is presented with ordinary, practical, procedural, or emotionally restrained wording.

Do not count a post merely because it is funny, sarcastic, short, emphatic, a pun, a cultural reference, a complaint, or a platform convention.

Return:

- At most four supporting candidates.
- At most two contradictory candidates where an absurd premise uses overt emotional, explanatory, or exaggerated delivery.

For each candidate, include:

- One identifier present in the batch.
- The complete exact post text.
- One sentence explaining the classification.

If a category has no valid candidate, write `None identified`.

Return only Markdown using:

    # Observation - Deadpan Delivery Retrieval
    ## Question
    ## Corpus
    ## Method
    ## Findings
    ### Supporting Candidates
    ### Contradictory Candidates
    ## Interpretation
    ## Questions Raised
    ## Status

Constraints:

- Candidate retrieval only; make no prevalence claim.
- Do not infer missing context or intent.
- Use exact `FB-000000` identifiers.
- Produce no scores.
- Keep the complete response under 700 words.
- Set status to `Candidate retrieval only - human review required`.
