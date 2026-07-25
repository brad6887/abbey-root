# Workflow-Friction Decision

Review the supplied Abbey Root planning documents and recommend the single
best bounded improvement for reducing recurring workflow friction.

Workflow friction is a repeated manual step, context switch, duplicate entry,
awkward handoff, avoidable search, or recurring verification burden that
consumes time or invites mistakes during normal Abbey work.

Prioritize recurring friction, not a one-off annoyance.
Distinguish evidence from assumptions explicitly.

A workflow-friction recommendation must:

- Address friction that recurs or is expected to recur, not a one-off
  annoyance.
- Cite supplied-document evidence for the workflow and its repetition. If
  recurrence is not directly established, say so and record it as an
  assumption rather than presenting it as fact.
- Fit within one focused development session or name a bounded first slice.
- Reduce effort, handoffs, ambiguity, or error opportunity durably.
- Complete or materially advance a clearly identified backlog item.
- Preserve an appropriate human decision or safety boundary.
- Fit the current project phase without displacing prerequisite or urgent
  work.

Prefer friction that affects frequent Abbey workflows, crosses tools or
repositories, duplicates source-of-truth data, obscures generated artifacts,
or repeatedly requires users to remember an undocumented handoff. Rank
candidates by recurrence, cumulative cost, maintainability, and breadth of
benefit—not by how irritating a single incident sounds.

Reject candidates that:

- Describe a one-time cleanup, isolated typo, or personal preference without
  evidence of recurrence.
- Depend on unresolved design decisions or unavailable external systems.
- Require broad refactoring, migration, or multi-session implementation
  without a useful bounded first slice.
- Automate a workflow before its human process or authority boundary is
  understood.
- Duplicate an existing capability or are already recorded as complete.
- Add more machinery than the recurring friction justifies.

Use only facts present in the supplied documents. Distinguish evidence from
assumptions explicitly. Do not name implementation files, functions,
libraries, languages, commands, integrations, or test techniques unless the
documents explicitly provide them. Do not claim exact time savings,
frequency, affected users, or implementation scope without evidence.

Separate confidence in selecting the recommendation from confidence in its
implementation approach:

- Recommendation confidence measures how strongly the supplied evidence
  supports choosing this recurring friction over the alternatives.
- Implementation confidence measures how much the supplied documents reveal
  about the actual architecture, integration points, dependencies, and tests.
  Because this decision receives planning documents rather than repository
  implementation files, implementation confidence must not exceed 0.5.

Classify the bounded improvement as exactly one of:

- `abbey-command`: use when a stable, repeatable operation should have an
  explicit Abbey CLI entry point.
- `standardized-workflow`: use when the durable value comes from a shared
  sequence, contract, template, or handoff and a new command is not yet
  justified.
- `local-fix`: use when the friction is specific to one implementation or
  repository and generalizing it would add unnecessary machinery.

Explain why the selected classification fits and why the other two would be
premature or excessive. Do not assume every recurring inconvenience should
become a command.

List the repository review required before implementation. Identify what
needs inspection or verification without pretending that review has already
occurred.

Return exactly one recommendation. Explain the recurring workflow, friction
point, recurrence evidence, cumulative cost, bounded improvement, retained
human boundary, classification, backlog reduction, and why the strongest
alternatives are weaker workflow-friction targets.

Before returning, verify that every implementation claim is either directly
supported by a cited supplied document or moved into assumptions or repository
review. Lower implementation confidence when repository inspection is needed.
