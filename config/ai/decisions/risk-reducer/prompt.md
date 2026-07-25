# Risk-Reducer Decision

Review the supplied Abbey Root planning documents and recommend the single
smallest practical change that materially reduces operational or workflow
risk.

A risk reducer must:

- Address a concrete failure mode supported by the supplied documents.
- Fit within one focused development session.
- Reduce the likelihood, impact, or detection time of that failure mode.
- Deliver durable protection through validation, testing, safeguards,
  recovery, observability, or removal of fragile manual work.
- Complete or materially advance a clearly identified backlog item.
- Fit the current project phase without displacing prerequisite or urgent
  work.

Prefer bounded changes that prevent data loss, broken releases, unsafe
operations, silent failures, unrecoverable state, misleading status, or
recurring workflow mistakes. Rank candidates by meaningful risk reduction,
not by how alarming their wording sounds.

Reject candidates that:

- Depend on unresolved design decisions or unavailable external systems.
- Require broad refactoring, deployment, migration, or multi-session research.
- Merely add documentation without changing detection, prevention, recovery,
  or operational clarity.
- Duplicate an existing safeguard.
- Are already recorded as complete.
- Cannot identify a credible one-session boundary.

Use only facts present in the supplied documents. Do not name implementation
files, functions, libraries, languages, commands, or test techniques unless
the documents explicitly provide them. Do not claim that a change guarantees
an outcome when it only detects, warns, or reduces risk. Record uncertain
implementation details as assumptions.

The recommendation and summary must describe the desired risk-reduction
outcome, not prescribe an implementation. Statements such as "add a helper,"
"make a single code change," "update the tests," or equivalent code-level
claims are prohibited unless the supplied documents explicitly establish
those details.

Separate confidence in selecting the recommendation from confidence in its
implementation approach:

- Recommendation confidence measures how strongly the supplied planning
  evidence supports choosing this risk reducer over the alternatives.
- Implementation confidence measures how much the supplied documents reveal
  about the actual architecture, integration points, dependencies, and tests.
  Because this decision receives planning documents rather than repository
  implementation files, implementation confidence must not exceed 0.5.

List the repository review required before implementation. These review items
must identify what needs inspection or verification without pretending the
inspection has already occurred.

Return exactly one recommendation. Name the specific backlog item or bounded
portion of one that the session should complete. Explain the failure mode,
one-session boundary, risk reduction, residual risk, backlog reduction, and
why the strongest alternatives are weaker bounded risk reducers.

Before returning, verify that every implementation claim is either directly
supported by a cited supplied document or moved into assumptions or repository
review. Lower implementation confidence when repository inspection is needed.
