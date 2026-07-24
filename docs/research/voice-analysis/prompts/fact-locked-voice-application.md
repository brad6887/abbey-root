# Fact-Locked Voice Application Prompt

Apply the supplied Voice Model to every scenario in the supplied fact-lock
document.

The fact lock is authoritative. Treat each scenario as a closed world:

- Preserve every immutable proposition.
- For every fact with `required_any`, include at least one literal phrase from that list.
- For every fact with `required_all`, include at least one literal phrase from every group.
- These lexical anchors are deterministic checks for the propositions; anchors do not replace the underlying facts.
- JSON serialization may escape quotation marks, but parsed human-facing response text must not contain visible backslashes before quotation marks.
- Do not add factual details, including names, times, causes, relationships,
  outcomes, physical events, or system behavior.
- Use a creative slot only when one is present, and describe any use in
  `creative_slot_uses`.
- Protected literals must appear exactly, including ordinary spaces and ASCII hyphen-minus characters; do not substitute typographic spaces or hyphens.
- Voice characteristics may change expression, emphasis, rhythm, and framing;
  they may not change the facts.
- Follow each scenario's task, required characteristics, prohibited
  characteristics, and format constraints.
- If an appealing line requires a new fact, omit the line.
- Do not add vague timing words such as `now`, `soon`, `shortly`, or `later`
  when the facts supply no time.
- Do not assign intent, preference, or agency to a device unless supplied.
- When editing source text, preserve all listed propositions.
- Do not claim a characteristic unless it is visible in the response.

Return only one raw JSON object:

{
  "schema_version": 1,
  "workflow": "fact_locked_voice_application",
  "fact_lock_id": "SUPPLIED_FACT_LOCK_ID",
  "model": "RUNTIME_MODEL_VALUE",
  "items": [
    {
      "scenario_id": "SUPPLIED_SCENARIO_ID",
      "response": "Generated scenario response.",
      "used_fact_ids": ["F001", "F002", "F003"],
      "added_facts": [],
      "creative_slot_uses": [
        {
          "slot_id": "S001",
          "content": "A short description of the authorized invented content."
        }
      ],
      "applied": ["VM-C01", "VM-C02"],
      "omitted": ["VM-C03", "VM-C04"],
      "rationale": "One short explanation."
    }
  ]
}

Copy the supplied fact lock's `fact_lock_id` exactly. Return every supplied scenario exactly once and in the source order, without assuming a fixed scenario count. Copy each supplied scenario's `scenario_id` exactly. Every `used_fact_ids` list must contain all and only that scenario's fact IDs, in source order. `added_facts` must be empty. Do not score your own work.

Use every creative slot only within its description and cardinality. Record each use under its exact `slot_id` in `creative_slot_uses`; use `creative_slot_uses: []` when no slot is present or no slot is used.
