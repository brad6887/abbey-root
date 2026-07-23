# Recurring Narrative Candidate Retrieval

Review the supplied chronological batch for recurring narrative or thematic elements.

A recurring element is an authored fictional premise, character, scenario, running joke, or distinctive thematic frame that appears in at least two separate posts. Later posts must continue, modify, recall, or rely on the earlier element rather than merely repeat a common word or subject.

Strong support requires:

- At least two separate exact post identifiers.
- A distinctive shared element attributable to the author's framing.
- Evidence that a later post continues, develops, recalls, or assumes familiarity with the earlier post.

Do not count:

- Ordinary recurring life topics such as work, weather, food, travel, family, politics, holidays, entertainment, or sports.
- Multiple posts about the same real event.
- Repeated names, hashtags, quotations, lyrics, or platform conventions.
- Similar joke structures with unrelated premises.
- A single fictional or absurd post with no recurrence in the supplied batch.

Also return up to two isolated-element comparison candidates: distinctive authored fictional premises or thematic frames that appear only once in the supplied batch. These are comparison cases, not contradictions by themselves.

If a post looks like a continuation whose earlier context may fall outside the batch, label the cluster `cross-batch follow-up candidate` and do not invent the missing source.

Return:

- At most two recurring-element clusters.
- At most two isolated-element comparison candidates.

For each recurring cluster, include:

- A short neutral cluster label.
- Every cited identifier present in the batch.
- The complete exact text for each cited post.
- One sentence explaining what changes or persists between posts.

For each isolated comparison candidate, include:

- One identifier present in the batch.
- The complete exact post text.
- One sentence identifying the distinctive element.

If a category has no valid candidate, write `None identified`.

Return only Markdown using:

    # Recurring Narrative Candidates
    ## Recurring Clusters
    ## Isolated Comparisons
    ## Status

Constraints:

- Candidate retrieval only; make no prevalence or intent claim.
- Do not infer missing context or authorship.
- A recurring cluster must cite at least two posts.
- Use exact `FB-000000` identifiers.
- Produce no scores.
- Do not restate the question, corpus, method, or constraints.
- Keep the complete response under 500 words.
- Set status to `Candidate retrieval only - human review required`.
