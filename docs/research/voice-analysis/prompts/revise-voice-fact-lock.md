# Revise Voice Fact-Lock Proposal Prompt

Revise the supplied proposed fact lock using every supplied human-review
finding. Return a complete replacement proposal, not a patch or explanation.

The request suite remains authoritative. The reviewed proposal is not
approved and may contain omissions or category errors.

Apply these rules:

- Preserve every explicit output proposition from the request, context, and
  source text.
- Immutable facts describe content that must appear in the generated output.
- Put prohibitions, style boundaries, and sentence counts in their dedicated
  fields, never in `immutable_facts`.
- `allowed_numbers` contains only supplied numeric content that may appear in
  the generated response. Do not include a number used only to define a format
  constraint.
- Lexical anchors are literal substrings of two to eight words. Never use
  ellipses, placeholders, regex syntax, or complete paraphrase sentences.
- Make facts atomic enough that one short anchor can verify the proposition.
  Split a compound premise when verifying it would otherwise require several
  unrelated anchors.
- `required_any` means alternatives: every individual phrase in that array
  must independently verify the fact. Never put separate required components
  into the array as though all alternatives will be checked.
- When a compound proposition must retain relationships among several
  components, use `required_all` instead of `required_any`. `required_all` is
  an array of alternative groups; at least one phrase from every group must
  appear. Example:

  `"required_all": [["Project Name"], ["attempt to teach"], ["predict wind"]]`

- Every fact has exactly one of `required_any` or `required_all`.
- Creative-slot descriptions must state exactly what may be invented and any
  factual boundary it must obey.
- Copy style targets and prohibitions exactly.
- Preserve every required schema key from the proposal format. Every request
  must include `extraction_notes`, even when it is an empty array. Creative
  slots use the exact keys `slot_id`, `description`, `minimum`, and `maximum`.
- Every `allowed_numbers` value must be a JSON string.
- Do not approve your own revision.

Return only the complete raw JSON proposal with:

- `schema_version: 1`
- `manifest_id: VOICE-FACT-LOCK-PROPOSAL-001`
- `evaluation_id: VOICE-FACT-EXTRACTION-EVAL-001`
- `voice_model: VOICE-MODEL-001`
- `status: proposed_human_review_required`
- all five requests exactly once and in order
