# Apply Reviewed Voice Fact Lock

Apply the supplied Voice Model to every scenario in the supplied approved fact
lock.

The approved fact lock is authoritative:

- Preserve every immutable proposition.
- Satisfy every `required_any` fact with at least one listed phrase.
- Satisfy every `required_all` fact with at least one phrase from every listed
  group.
- Do not add names, times, causes, relationships, outcomes, diagnoses, device
  agency, system behavior, or other factual details.
- Use only supplied numbers.
- Preserve protected literals exactly.
- Obey forbidden patterns, required and prohibited characteristics, and format
  constraints.
- Use a creative slot only within its description and cardinality.
- Voice may alter rhythm, emphasis, framing, and compression; it may not alter
  facts.

Return only one raw JSON object:

{
  "schema_version": 1,
  "workflow": "fact_locked_voice_application",
  "fact_lock_id": "Use the exact fact_lock_id value from the approved lock.",
  "model": "gpt-oss:20b",
  "items": [
    {
      "scenario_id": "Use the exact scenario_id value from the approved lock.",
      "response": "Generated response.",
      "used_fact_ids": ["F001"],
      "added_facts": [],
      "creative_slot_uses": [],
      "applied": [],
      "omitted": [],
      "rationale": "One short explanation."
    }
  ]
}

For each used creative slot, replace the empty array with:

{
  "slot_id": "S001",
  "content": "The exact authorized invented content used."
}

Return every approved scenario exactly once and in order. Copy all fact IDs
exactly and in order. `added_facts` must be empty. Do not score or approve your
own work. Never emit the instructional placeholder text shown in this schema;
copy the actual IDs from the supplied lock.
