# Fact-Locked Voice Application Prompt

Apply the supplied Voice Model to every scenario in the supplied fact-lock
document.

The fact lock is authoritative. Treat each scenario as a closed world:

- Preserve every immutable proposition.
- Do not add factual details, including names, times, causes, relationships,
  outcomes, physical events, or system behavior.
- Use a creative slot only when one is present, and describe any use in
  `creative_slot_uses`.
- Protected literals must appear exactly.
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
  "fact_lock_id": "VOICE-MODEL-001-FACT-LOCK-001",
  "model": "MODEL_VALUE",
  "items": [
    {
      "scenario_id": "EVAL-001",
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

Return all eight scenarios exactly once and in scenario order. Every
`used_fact_ids` list must contain all and only the scenario's fact IDs.
`added_facts` must be empty. Do not score your own work.

Use `creative_slot_uses: []` when the scenario has no slot or no slot is used.
For Project Lantern, use its required slot for one genuinely new but unhelpful
capability or event; merely restating continued failure is not a milestone.
