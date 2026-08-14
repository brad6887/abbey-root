# Backlog-Leverage Decision

Review the supplied Abbey Root planning documents and recommend the single
focused development session that will clear or materially advance the largest
coherent set of backlog items.

Backlog leverage means one bounded outcome has documented overlap with several
backlog items: doing X directly completes or materially advances A, B, and C.
It does not mean choosing a broad project merely because it could eventually
help many areas.

A backlog-leverage recommendation must:

- Define one concrete outcome that fits within one focused development session,
  or a bounded first slice with its own useful completion state.
- Identify one primary backlog item.
- Identify every additional backlog item the same outcome will complete,
  materially advance, or directly enable.
- Explain the specific relationship between the outcome and each covered item.
- Use only explicit planning-document evidence for every claimed item and
  relationship.
- Respect the current priority, prerequisites, safety boundaries, and project
  phase.
- Deliver a coherent outcome rather than bundle unrelated small tasks.

Planning-boundary rules:

- Treat the current objective, Definition of Done, implementation scope,
  safety boundary, and explicit exclusions in `NEXT.md` as controlling session
  constraints.
- Do not combine sequential implementation phases into one outcome merely
  because they belong to the same feature or subsystem.
- Treat phrases such as `after`, `once`, `until`, `future direction`, and
  `deferred` as dependency boundaries. Work beyond such a boundary is not part
  of the current outcome unless the planning documents explicitly say it is.
- If `NEXT.md` places an item outside the current session, list it in
  `optional_work_excluded`; do not include it in the coverage map.
- Completing a prerequisite does not by itself complete or materially advance
  a dependent backlog item.

Coverage-classification rules:

- Use `completes` only when the bounded outcome satisfies the full pending
  backlog item and no later phase or separate human decision is still required.
- Use `materially-advances` only when the outcome produces part of the covered
  item's own named deliverable. Shared context, groundwork, or completion of a
  prerequisite is insufficient.
- Use `directly-enables` only when the outcome removes an explicitly documented
  blocker for that item. A normal phase dependency or speculative future
  benefit is insufficient.
- When uncertain, omit the item from confirmed coverage and identify it as
  excluded work rather than inflating the coverage count.

Rank candidates in this order:

1. Number of backlog items completed by the same outcome.
2. Number of additional backlog items materially advanced by that outcome.
3. Strength and directness of the documented relationships.
4. Fit with the current objective and roadmap dependencies.
5. Durable value and confidence that the work fits one session.

Treat `directly enables` as weaker coverage than completion or material
advancement. Do not count vague benefits, thematic similarity, shared labels,
or speculative future work as backlog coverage. Do not count the same backlog
item more than once.

Reject candidates that:

- Combine independent tasks solely to increase the coverage count.
- Depend on unresolved design decisions or unavailable external systems.
- Require broad refactoring, deployment, migration, or multi-session research
  without a valuable bounded first slice.
- Conflict with the current primary objective or bypass prerequisites.
- Duplicate an existing capability or count work already recorded as complete.
- Rely on inferred backlog items that are not present in the supplied
  documents.
- Cross an explicit `NEXT.md` safety boundary or absorb work assigned to a
  later implementation phase.
- Count a later phase because the recommended outcome completes its
  prerequisite.

Use only facts present in the supplied documents. Do not name implementation
files, functions, libraries, languages, commands, or test techniques unless
the documents explicitly provide them. Record uncertain implementation details
as assumptions.

Return exactly one recommendation. State the shared outcome, its one-session
boundary in `session_boundary`, the primary backlog item, and a coverage map
containing the primary item and every additional item. List adjacent, deferred,
or later-phase work in `optional_work_excluded`. For each covered item,
classify the effect as `completes`, `materially-advances`, or
`directly-enables` and explain why the same outcome has that effect. Report the
confirmed coverage count, excluding unsupported or merely thematic
relationships. Compare the strongest alternatives and explain why they clear
less backlog or form a less coherent session.

Before returning, verify that the confirmed coverage count equals the number
of unique items in the coverage map, every relationship has direct documentary
evidence, no covered item is excluded by `NEXT.md`, and no later phase is
counted solely because its prerequisite is selected.
