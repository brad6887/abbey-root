# Concise Expression Candidate Retrieval

Review the supplied batch for concise-expression candidates.

Concise expression means a complete idea, reaction, instruction, narrative, or joke is communicated through unusually compressed language, with important context or connections left for the reader to infer.

Strong support may include:

- A complete response or judgment expressed in very few words.
- A compact statement whose meaning depends on shared context.
- A dense list or sequence that compresses a larger narrative.
- A joke that omits explanation and relies on the reader to connect the premise and conclusion.

Do not count a post merely because it is short. Generic statements such as greetings, simple activity reports, ordinary reactions, or common phrases are not strong evidence unless they compress a larger discernible meaning. Reject fragments that do not communicate a discernible idea, platform conventions, automated text, link titles, quotations without authored framing, incomplete transcription, or text that only appears concise because necessary context is missing.

Contradictory evidence should show a complete idea that is explained, repeated, qualified, or narrated substantially more than its apparent context requires. Do not classify necessary detail, storytelling, instructions, or clarification for an unfamiliar audience as contradictory merely because the post is long.

Missing-context fragments are exclusions, not contradictory evidence. Never return an incomplete or context-dependent fragment as a contradiction. If no clear over-explained example exists, return `None identified`.

Return:

- At most four strong supporting candidates.
- At most two strong contradictory candidates.

For each candidate, include:

- One identifier present in the batch.
- The complete exact post text.
- One sentence explaining the classification.

If a category has no valid candidate, write `None identified`.

Return only Markdown using:

    # Observation - Concise Expression Retrieval
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
- Prefer semantic compression over word count alone.
- Supporting candidates must demonstrate omitted explanation or compressed relationships, not just brevity.
- Contradictory candidates must demonstrate unnecessary elaboration, not incompleteness.
- Use exact `FB-000000` identifiers.
- Produce no scores.
- Keep the complete response under 700 words.
- Set status to `Candidate retrieval only - human review required`.
