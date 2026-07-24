# Fact-Locked Voice Verification Prompt

Verify the supplied generated output against the supplied fact-lock document.
Do not rewrite the responses and do not evaluate style.

For each scenario:

- Check whether every immutable proposition is present.
- Identify any unsupported factual proposition.
- Check that creative-slot use stays within its authorized description.
- Treat names, times, causes, relationships, outcomes, physical events, and
  system behavior as factual propositions.

Return only one raw JSON object:

{
  "schema_version": 1,
  "workflow": "fact_locked_voice_verification",
  "fact_lock_id": "VOICE-MODEL-001-FACT-LOCK-001",
  "items": [
    {
      "scenario_id": "EVAL-001",
      "all_facts_present": true,
      "unsupported_claims": [],
      "creative_slots_valid": true,
      "result": "pass"
    }
  ],
  "result": "pass"
}

Return all eight scenarios exactly once and in scenario order. Set the overall
result to `pass` only when every item passes.
