# Voice Fact-Lock Proposal Prompt

Convert every supplied writing request into a proposed fact lock. Do not write
the requested posts or messages.

The proposal will require human review. Extract only facts and constraints
explicitly supplied by each request, context, or source text.

For each request:

- Preserve names, titles, numbers, relationships, causes, timing, grammatical
  state, and system behavior.
- Treat supplied `context` and `source_text` as factual sources. Every explicit
  proposition in them that the requested output must preserve must appear in
  `immutable_facts`.
- Split independent propositions into separate immutable facts.
- Do not duplicate the same proposition in multiple facts.
- Give each fact a short lexical `required_any` list containing equivalent
  phrases that can verify the proposition without changing it.
- Copy exact names and titles into `protected_literals`.
- Put every supplied digit or number word into `allowed_numbers`.
- Add conservative case-insensitive regular-expression strings to
  `forbidden_patterns` for obvious unauthorized narrowing or invention called
  out by the request.
- When a request asks for a new example, event, milestone, label, or other
  content that it does not supply, create a creative slot for that content.
  Do not pretend the unspecified content is already an immutable fact.
- State every creative slot's narrow boundary and cardinality. A request for
  `one` new item requires `minimum: 1` and `maximum: 1`.
- Copy `style_targets` into `required_applied` exactly, including order.
- Copy `style_prohibitions` into `prohibited_applied` exactly, including order.
- Copy a sentence-count constraint when supplied.
- Do not infer preferences, diagnoses, schedules, identities, device agency,
  prior history, or outcomes.
- Use short lexical anchors, normally two to six words, not complete
  paraphrase sentences. Anchors are literal substring checks, so include
  natural phrases the generated response can reasonably contain.
- A fact may have multiple required alternatives, but each alternative must
  still verify that fact's essential object, action, state, or timing.
- A compound fact may instead use `required_all`, an array of alternative
  groups. At least one phrase from every group must be present. Every fact has
  exactly one of `required_any` or `required_all`.
- For an established callback with a requested new milestone, lock both the
  established premise and the requirement that the update contain a new,
  unhelpful milestone. Put only the unspecified milestone content in the
  creative slot.

Return only one raw JSON object:

{
  "schema_version": 1,
  "manifest_id": "VOICE-FACT-LOCK-PROPOSAL-001",
  "evaluation_id": "VOICE-FACT-EXTRACTION-EVAL-001",
  "voice_model": "VOICE-MODEL-001",
  "status": "proposed_human_review_required",
  "requests": [
    {
      "scenario_id": "REQ-001",
      "task": "The requested writing task.",
      "immutable_facts": [
        {
          "fact_id": "F001",
          "proposition": "One supplied proposition.",
          "required_any": ["one lexical realization"]
        }
      ],
      "protected_literals": [],
      "allowed_numbers": [],
      "forbidden_patterns": [],
      "creative_slots": [],
      "required_applied": [],
      "prohibited_applied": [],
      "extraction_notes": []
    }
  ]
}

Use `required_sentence_count` only when supplied. Return every request exactly
once and in request order. Do not approve your own proposal.
