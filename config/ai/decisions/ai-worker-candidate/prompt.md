# AI Worker Candidate Decision

Review the supplied Abbey planning documents and identify exactly one bounded
piece of pending work that is a strong candidate for the AI Worker.

The AI Worker is best suited to reviewable, non-interactive work with explicit
inputs and deliverables. It may either research a question or implement a
well-defined repository task. It must not replace human approval, make an
irreversible operational change, deploy infrastructure, handle unavailable
secrets, or resolve an undocumented product or architecture decision.

Classify the recommendation as exactly one of:

- `research`: investigate a documented question and produce a reviewable
  research artifact or recommendation.
- `implementation`: complete a bounded, already-defined repository change and
  return a patch or branch for human review.
- `none`: the planning documents do not contain a sufficiently safe and
  well-defined AI Worker candidate.

Selection rules:

- Base the decision only on pending work explicitly found in the supplied
  planning documents.
- Prefer a candidate with a clear objective, discoverable inputs, testable or
  inspectable deliverables, and a meaningful connection to current priorities.
- Prefer research when planning identifies uncertainty, investigation,
  evaluation, comparison, validation, or a design question.
- Prefer implementation only when planning already defines the intended
  outcome and leaves no material product, architecture, safety, or operational
  decision to the worker.
- Reject work requiring live deployment, destructive changes, physical
  access, privileged infrastructure mutation, hidden credentials, or an
  unrecorded human decision.
- Do not claim that a command already exists. Provide a proposed command
  concept beginning with `abbey ai work research` or
  `abbey ai work implement`; this is a suggestion for a future worker command,
  not an executable command in the current toolkit.
- Put that command concept in `proposed_command`. Put a plain-language
  description of the result the worker should achieve in `worker_objective`;
  do not place a command in `worker_objective`.
- Keep the proposed command concise. Use placeholders such as `<prompt-file>`
  or `<task-file>` when the planning documents do not provide a real path.
- List the planning evidence that supports both the work item and its fitness
  for delegation.
- State the human review or approval that remains required.
- Distinguish evidence from assumptions. Do not invent repository structure,
  implementation details, completed prerequisites, commands, or capabilities.

If no candidate meets the boundary:

- Set `candidate_type` to `none`.
- Set `proposed_command` to an empty string.
- Explain what definition or prerequisite is missing.
- Leave inputs and deliverables empty.

Return exactly one recommendation, with alternatives limited to the strongest
other candidates visible in planning.
