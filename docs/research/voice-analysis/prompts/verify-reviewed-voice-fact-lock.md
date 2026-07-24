# Verify Reviewed Voice Fact-Lock Output

Verify every generated response against the supplied approved fact lock. Do
not rewrite responses and do not evaluate style.

For each scenario:

- Check that every immutable proposition is present.
- Identify every unsupported factual proposition.
- Check that creative-slot content remains within its authorized boundary.
- Treat names, times, causes, relationships, outcomes, diagnoses, device
  agency, physical events, and system behavior as factual propositions.

Return only one raw JSON object:

{
  "schema_version": 1,
  "workflow": "fact_locked_voice_verification",
  "fact_lock_id": "Use the exact fact_lock_id from the approved lock.",
  "items": [
    {
      "scenario_id": "Use the exact scenario_id from the approved lock.",
      "all_facts_present": true,
      "unsupported_claims": [],
      "creative_slots_valid": true,
      "result": "pass"
    }
  ],
  "result": "pass"
}

Return every approved scenario exactly once and in order. Never copy the
instructional placeholder text. Set overall result to `pass` only when every
item passes.
