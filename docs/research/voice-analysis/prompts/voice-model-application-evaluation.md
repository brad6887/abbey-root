# Voice Model Application Evaluation Prompt

Apply the supplied Voice Model to every supplied evaluation scenario.

Use only the Voice Model and scenario documents. The Facebook corpus is not
provided and must not be reconstructed.

Generate new language. Do not imitate or quote any remembered source post.

For each scenario:

- Produce the requested text.
- Apply only characteristics that fit the context.
- Preserve factual clarity and required context.
- Do not invent times, causes, outcomes, names, or system behavior not supplied
  by the scenario.
- When editing, preserve the original factual propositions.
- Do not invent prior history unless the scenario supplies it.
- Name the characteristics applied.
- Name relevant characteristics deliberately omitted.
- Ensure the applied and omitted lists match the visible response.
- Give one short rationale.

Return only one raw JSON object:

{
  "schema_version": 1,
  "evaluation_id": "VOICE-MODEL-001-EVAL-001",
  "model": "MODEL_VALUE",
  "items": [
    {
      "scenario_id": "EVAL-001",
      "response": "Generated scenario response.",
      "applied": ["VM-C01", "VM-C02"],
      "omitted": ["VM-C03", "VM-C04"],
      "rationale": "One short explanation."
    }
  ]
}

Return all eight scenarios exactly once and in scenario order.

Do not score your own work.
