# Full-Corpus Batch Observation Discovery Prompt

Review the supplied chronological Facebook corpus batch for recurring,
observable writing patterns. This is open-ended discovery: do not assume that
the existing voice observations are complete, and do not try to confirm a
preselected conclusion. Perform the review directly and return the requested
object without explaining your reasoning.

Return only one raw JSON object. Do not use Markdown fences or commentary.

Use this exact structure:

{
  "schema_version": 1,
  "batch_id": "BATCH_ID",
  "status": "candidate_discovery_human_review_required",
  "corpus": {
    "artifact_id": "facebook-clean-corpus",
    "sha256": "CORPUS_SHA256"
  },
  "model": "MODEL_VALUE",
  "prompt": "full-corpus-observation-discovery-v1",
  "candidates": [
    {
      "candidate_id": "B000-C01",
      "label": "Short neutral label",
      "description": "A descriptive statement of the visible pattern.",
      "citations": [
        {
          "source_id": "FB-000000"
        },
        {
          "source_id": "FB-000000"
        }
      ],
      "scope_note": "A cautious statement limited to this batch.",
      "boundary_note": "A counterexample, variation, or reason not to overgeneralize."
    }
  ]
}

Replace BATCH_ID and CORPUS_SHA256 with the values supplied below. Candidate
identifiers must use the three-digit batch number, for example B001-C01.

Requirements:

- Return exactly three distinct candidate patterns.
- Every pattern must describe form, tone, structure, or rhetorical behavior
  visible in the writing itself.
- Use two to four representative posts per candidate.
- Return only each cited post's source identifier. The workflow will attach
  corpus-authoritative text after generation.
- Cite only source identifiers present in the supplied batch.
- Prefer patterns that recur across non-adjacent posts.
- Include meaningful variations or counterexamples in each boundary note.
- Keep findings provisional and limited to this batch.
- Do not infer private facts, personality, intention, diagnosis, or audience
  reaction.
- Do not score, rank, validate, or promote a candidate into a formal
  observation.
- Do not make frequency claims unless every post in the batch was counted.
- Do not use existing observation names as a required taxonomy.
- Keep each description, scope note, and boundary note to one sentence.
- Keep the complete JSON response under 1,200 words.

Run metadata:

BATCH_ID: BATCH_ID_VALUE
CORPUS_SHA256: CORPUS_SHA256_VALUE
