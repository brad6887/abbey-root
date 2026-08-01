# Backlog-Blocker Decision

Review the supplied Abbey Root planning documents and identify the single
clearest pending backlog checkbox that should not be selected as standalone
work because one or more prerequisite checkboxes remain unfinished.

A blocker finding must:

- Name one exact pending checkbox as `primary_backlog_item`.
- Identify every exact pending checkbox that must be completed before the
  primary item can be completed honestly.
- Explain the concrete dependency in `failure_mode`.
- Be based on explicit wording, ordering, grouping, or capability state in the
  supplied planning documents.
- Distinguish a true prerequisite from adjacent, optional, or merely related
  work.
- Help prevent a planning or easy-win decision from treating dependent work as
  an independently completable backlog reduction.

Strong blocker signals include:

- Regression coverage for a capability that planning still records as
  unimplemented.
- Documentation or validation for a command, option, workflow, or artifact that
  a preceding pending checkbox still needs to create.
- Deployment, migration, or adoption work that depends on unfinished design or
  implementation.
- A child or follow-up item whose parent capability remains pending.
- Completion wording that presupposes another pending item already exists.

Do not infer a dependency solely because checkboxes are near each other. Do not
classify optional follow-up work, normal sequencing preferences, broad themes,
or shared subject matter as blockers. Do not report completed work as a
blocker.

Use only facts present in the supplied planning documents. Copy the primary and
blocking checkbox text verbatim, including `- [ ]`. Do not invent repository
implementation details. If the documents strongly suggest a dependency but do
not prove implementation state, state that limit in `assumptions` and list the
repository review needed to confirm it. Keep implementation confidence at or
below 0.25 because repository source is not included.

Return exactly one highest-confidence blocker finding. In `recommendation`, say
that the primary item should not be selected standalone and summarize what must
precede it. In `alternatives`, compare other plausible blocker findings and
explain why their dependency evidence is weaker.

Before returning, verify:

1. `primary_backlog_item` is an exact pending checkbox in BACKLOG.md.
2. Every `blocking_items` entry is an exact pending checkbox in BACKLOG.md.
3. At least one blocking item is required for the primary item, not merely
   related to it.
4. `failure_mode` explains why completing the primary item first would be
   impossible, misleading, or incomplete.
5. Evidence cites the planning text that establishes both sides of the
   dependency.
6. No field claims repository implementation facts absent from the documents.
