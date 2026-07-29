# Easy-Win Decision

Review the supplied Abbey Root planning documents and recommend the single
best easy win.

An easy win must:

- Be concrete enough to complete in one focused development session.
- Have low implementation and operational risk.
- Deliver durable value rather than a one-time cosmetic improvement.
- Fully complete at least one existing pending parent checkbox in BACKLOG.md.
- Include every nested child item required to mark that parent complete.
- Produce a positive net backlog reduction with no new backlog items.
- Fit the current project phase without displacing prerequisite or urgent work.

Prefer work that improves a reusable command, validation rule, workflow, test,
or source of truth. Prefer the smallest coherent scope that closes the selected
parent checkbox. Do not select an item merely because it is small.

Backlog accounting rules:

- Count only exact pending Markdown checkbox items as backlog parents closed.
- Do not count nested descriptive bullets or uncheckable subtasks as separate
  backlog items.
- Treat every nested child beneath a selected parent as required scope unless
  the planning documents explicitly mark it optional.
- Copy each selected parent checkbox verbatim into `completion_checkboxes`.
- List the required child work separately in `required_subtasks`.
- Exclude adjacent enhancements that are not required to close the checkbox,
  and identify them in `optional_work_excluded`.
- Set `new_backlog_items_expected` to zero. If a candidate requires new backlog
  entries or deferred cleanup to be considered complete, reject it.
- Compute `expected_net_backlog_reduction` as the number of unique parent
  checkboxes closed minus new backlog items expected.

Use only facts present in the supplied planning documents. Do not name
implementation files, functions, libraries, commands, flags, storage paths, or
test techniques unless the documents explicitly provide them. Do not convert a
broad workflow item into a specific command or feature design. Record uncertain
implementation details as assumptions and list the repository review required
before implementation.

Report recommendation confidence separately from implementation confidence.
Because the supplied documents do not include repository implementation
details, set `implementation_approach` to
`unknown-pending-repository-review`, return an empty
`documented_implementation_details` list, and keep implementation confidence at
or below 0.25. The recommendation, session fit, durable value, repository
review, and alternatives must not fill that evidence gap with a guessed
solution.

Reject candidates that:

- Depend on unresolved design decisions or unavailable external systems.
- Require broad refactoring, deployment, migration, or multi-session research.
- Duplicate an existing capability.
- Reduce the backlog only nominally.
- Merely advance, enable, investigate, or partially complete a backlog item.
- Select an open-ended or recurring parent whose wording begins with or depends
  on `Continue`, `Expand`, `Refine`, ongoing practical usage, or evaluation
  through normal use, unless explicit nested criteria define a finite state
  that closes the parent in this session.
- Complete child work while leaving its pending parent checkbox open.
- Add adjacent features or follow-up work to make the session appear durable.
- Require invented implementation details to support the one-session estimate.
- Are already recorded as complete.

Return exactly one recommendation containing only the exact checkable parent
backlog item the session will complete, without an implementation proposal.
Report every parent closed, its exact completion checkbox, all required
subtasks, optional work excluded, new backlog items expected, and expected net
backlog reduction. Explain the one-session boundary, risks, durable value, and
repository review required before implementation. Compare the strongest
alternatives and explain why they are weaker easy wins.

Before returning, verify:

1. Every item in `backlog_parents_closed` is an exact pending parent checkbox
   in BACKLOG.md.
2. `completion_checkboxes` contains the same unique parents, copied verbatim.
3. `required_subtasks` includes every nested child needed to close them.
4. `new_backlog_items_expected` is zero.
5. `expected_net_backlog_reduction` equals the number of unique parent
   checkboxes closed.
6. No output field proposes an implementation approach that is absent from the
   planning documents.
