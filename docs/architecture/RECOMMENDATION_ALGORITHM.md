Abbey Recommendation Algorithm

Purpose

This document defines the deterministic algorithm used by abbey next to recommend one focused engineering session.

The algorithm implements the principles defined in RECOMMENDATION_ENGINE.md.

Its purpose is not to make creative decisions or replace project planning. Its purpose is to consistently transform authoritative project information into one explainable recommendation.

The same project state should always produce the same result.

⸻

Design Principles

The algorithm should be:

* Deterministic
* Explainable
* Conservative
* Easy to test
* Easy to refine
* Grounded in authoritative project sources
* Focused on recommending complete sessions rather than isolated tasks

Version 1 should favor predictable recommendations over sophisticated recommendations.

⸻

Inputs

Version 1 reads the following sources.

Human Direction

Highest authority:

* docs/planning/NEXT.md
* An explicitly defined active session objective

Project State

* docs/planning/PROJECT_STATUS.md
* Current Git branch
* Working tree status
* Recent commits
* Recent completed session updates

Available Work

* docs/planning/BACKLOG.md
* docs/planning/ROADMAP.md

Supplemental Evidence

Version 1 may use:

* Most recent journal entry
* Presence of unfinished working files
* Relationships between backlog items

Supplemental evidence may refine a recommendation but must not override explicit human direction.

⸻

Output

Version 1 returns exactly one recommended session.

The recommendation contains:

* Title
* Objective
* Definition of Done
* Reasoning
* Supporting evidence
* Related planning items
* Score
* Confidence
* Suggested first step

⸻

Recommendation Object

A normalized recommendation may be represented conceptually as:

title: "Refine abbey review through practical usage"
objective: >
  Improve the deterministic abbey review workflow based on observations
  from real development sessions.
definition_of_done:
  - Identify one or more practical weaknesses in the current review output.
  - Implement focused improvements.
  - Validate the revised workflow against a real repository state.
  - Capture the session outcome.
reasons:
  - "Listed as a current priority in NEXT.md."
  - "Identified as immediate work in PROJECT_STATUS.md."
  - "Continues the most recently completed workflow session."
evidence:
  - source: "docs/planning/NEXT.md"
    authority: "human_direction"
  - source: "docs/planning/PROJECT_STATUS.md"
    authority: "project_state"
  - source: "docs/session-updates/2026-07-16-initial-abbey-review-workflow.md"
    authority: "project_history"
related_items:
  - "Complete abbey-review."
  - "Refine abbey review through practical usage."
score: 115
confidence: high
suggested_first_step: "Run abbey review against the current repository state."

This structure is conceptual for Version 1. It does not require introducing YAML storage or a formal API before the workflow has been validated.

⸻

Recommendation Process

Collect
  ↓
Parse
  ↓
Normalize
  ↓
Generate Candidates
  ↓
Filter Candidates
  ↓
Score Candidates
  ↓
Break Ties
  ↓
Build Session
  ↓
Render Recommendation

Each stage should remain independently understandable and testable.

⸻

Stage 1: Collect Sources

The engine locates and reads the required project documents.

Required sources:

* PROJECT_STATUS.md
* NEXT.md
* BACKLOG.md
* ROADMAP.md

Optional sources:

* Recent session updates
* Recent journal entries
* Git history
* Working tree state

Missing optional sources should reduce available evidence but should not cause the command to fail.

Missing required planning documents should produce a clear validation error rather than an invented recommendation.

⸻

Stage 2: Parse Sources

Version 1 should use existing stable document headings and simple Markdown conventions.

The parser should identify:

* Current theme
* Primary objective
* Current priorities
* Immediate priorities
* Current focus areas
* Incomplete backlog items
* Active roadmap capabilities
* Recent completed session themes
* Explicitly deferred work

The parser should not attempt unrestricted natural-language interpretation.

Initial parsing should remain rule-based and should rely on stable headings wherever possible.

⸻

Stage 3: Normalize Work Items

Raw planning entries should be converted into candidate work items with common fields.

Conceptual structure:

summary: "Create abbey next"
source: "BACKLOG.md"
section: "Project-Aware Recommendations"
authority: "available_work"
status: "incomplete"
area: "workflow"

Normalization should:

* Remove Markdown checkbox syntax.
* Remove formatting characters.
* Preserve the original wording as evidence.
* Assign the source authority.
* Assign a broad project area when it can be determined reliably.
* Detect duplicate wording across documents.

Project areas may initially include:

* Framework
* Workflow
* Developer Toolkit
* AI
* Infrastructure
* Website
* Documentation
* Publishing
* Plant Toolkit

Area detection should remain simple and explainable.

⸻

Stage 4: Generate Candidate Sessions

Candidates may originate from:

* Individual current priorities
* Individual incomplete backlog items
* Roadmap capabilities that align with current priorities
* Natural continuations of recently completed sessions
* Repository work already in progress

A candidate should represent one coherent development session.

Examples:

Good candidate:

Improve abbey review validation detection.

Too broad:

Complete the Abbey Framework.

Too narrow:

Rename one variable in abbey-review.

When a source item is too broad, Version 1 should prefer a related concrete backlog item rather than inventing an arbitrary subdivision.

⸻

Stage 5: Deduplicate Candidates

The same work may appear in several planning documents.

Candidates should be considered duplicates when their normalized text or recognized capability refers to the same underlying work.

Example:

NEXT.md:
Complete abbey-review.
BACKLOG.md:
Improve detection of validation already performed in abbey review.

These may belong to the same recommendation family.

Deduplication should preserve all supporting evidence rather than discarding repeated references.

Repeated appearance across authoritative sources should increase the recommendation score.

⸻

Stage 6: Filter Candidates

Remove candidates that should not be recommended.

Completed Work

Exclude:

* Checked backlog items
* Roadmap capabilities explicitly marked complete
* Work clearly completed in recent session updates
* Work already represented by an existing completed implementation

Explicitly Deferred Work

Exclude or heavily suppress items the human has explicitly chosen to postpone.

For example, abbey init should not be recommended while the maintainer has intentionally deferred it until BradCooke.com is more mature.

A future implementation may record deferrals in structured metadata. Version 1 may rely on an explicit deferred-work section or configured exclusion list.

Blocked Work

Exclude work with known unmet prerequisites.

Version 1 should only treat work as blocked when the prerequisite is explicit. It should not guess.

Duplicate Work

Combine duplicate candidates and preserve their evidence.

Inappropriate Scope

Exclude candidates that cannot reasonably form one coherent session.

⸻

Stage 7: Score Candidates

Version 1 uses additive deterministic scoring.

Authority Scores

Evidence	Score
Explicit active session objective	+100
Current priority in NEXT.md	+50
Immediate priority in PROJECT_STATUS.md	+40
Current focus in PROJECT_STATUS.md	+30
Active capability in ROADMAP.md	+20
Incomplete item in BACKLOG.md	+20

Continuity Scores

Evidence	Score
Natural continuation of most recent session	+15
Explicit next step in most recent session update	+15
Related to one of the three most recent commits	+5

Leverage Scores

Evidence	Score
Unblocks two or more known items	+15
Establishes a reusable framework capability	+10
Reduces a recurring manual workflow	+10
Validates an existing framework through real use	+10

Readiness Scores

Evidence	Score
Prerequisites appear complete	+10
Existing implementation can be refined practically	+5
Work is already present in the working tree	+20

Penalties

Condition	Score
Explicitly deferred	Exclude
Known blocked prerequisite	Exclude
Completed	Exclude
Too broad for one session	-30
Requires speculative architecture without current use	-20
Recently attempted without meaningful new evidence	-10

Scores should be reported as an explanation aid, not as an absolute measurement of project value.

⸻

Stage 8: Tie-Breaking

When candidates have equal scores, apply the following tie-breakers in order:

1. Higher-authority evidence
2. More direct alignment with NEXT.md
3. More direct continuation of recent completed work
4. Greater number of supporting sources
5. Smaller and more achievable session scope
6. Stable alphabetical order

The final alphabetical tie-breaker ensures deterministic output even when all meaningful factors are equal.

⸻

Stage 9: Build the Recommended Session

The winning candidate must be converted into a complete Abbey session.

Title

Use a concise noun phrase or action-oriented session name.

Example:

Refine Abbey Review Validation Detection

Objective

Describe one focused outcome.

Example:

Improve abbey review so it can recognize validation already performed during the current session and recommend the correct next workflow step.

Definition of Done

Generate three to six measurable criteria.

The Definition of Done should normally include:

* The intended behavior is implemented or designed.
* The behavior is validated.
* Relevant documentation is captured.
* The change remains within the defined session scope.

The engine should prefer criteria derived from planning evidence rather than generic filler.

Reasoning

List the strongest two to five reasons.

Each reason should correspond to concrete evidence.

Suggested First Step

Recommend the first practical Abbey workflow action.

Examples:

* Review the current implementation.
* Run the existing command against a real project state.
* Inspect the relevant planning document.
* Start an Abbey session with the generated objective.

⸻

Confidence

Confidence describes the strength and agreement of the evidence.

High

Use when:

* The recommendation appears in NEXT.md, and
* It is supported by project state, backlog, roadmap, or recent history.

Medium

Use when:

* The recommendation appears in one authoritative planning source, or
* Several lower-authority sources agree.

Low

Use when:

* Only backlog or supplemental evidence supports the recommendation.
* Planning sources conflict.
* Candidate generation required broad interpretation.

Version 1 should avoid presenting a low-confidence recommendation as authoritative.

When confidence is low, the output should clearly state that the available planning evidence is weak.

⸻

Repository State Rules

The current working tree may change the recommendation.

Work Already in Progress

When the repository contains coherent uncommitted work:

* Prefer completing, validating, documenting, or reviewing that work.
* Do not recommend unrelated new development.
* Explain that the existing working tree takes precedence.

Clean Working Tree

When the working tree is clean:

* Rank planning-derived candidates normally.

Untracked Experimental Files

Untracked files under working/ should not automatically become the primary recommendation.

They may provide supplemental evidence when they clearly relate to an active priority.

⸻

Human Overrides

Explicit human direction always wins.

Examples:

abbey next --area website
abbey next --strategy quick-win
abbey next --exclude abbey-init

These options are future possibilities and are not required for Version 1.

For Version 1, an active session objective or explicit user request should bypass normal ranking and become the current recommendation.

⸻

Version 1 Simplifications

Version 1 intentionally does not:

* Use AI.
* Perform semantic similarity with embeddings.
* Learn from user behavior.
* Track time spent by project area.
* Automatically rewrite planning documents.
* Infer undocumented blockers.
* Generate several competing recommendations.
* Optimize project balance.
* Modify the repository.

These capabilities may be considered only after the deterministic workflow has been proven useful.

⸻

Example Evaluation

Assume the project contains the following evidence:

NEXT.md
- Refine abbey review through practical usage.
- Continue developing BradCooke.com.
PROJECT_STATUS.md
- Complete abbey-review.
- Continue technical publishing.
BACKLOG.md
- Improve detection of validation already performed.
- Add live-site verification to abbey site publish.
Recent session
- Initial abbey review workflow completed.
- Next step: refine abbey review through practical usage.

Candidate scores:

Refine abbey review
NEXT.md                              +50
PROJECT_STATUS immediate priority    +40
BACKLOG                              +20
Recent session continuation          +15
Recent session explicit next step    +15
Reusable workflow capability         +10
-----------------------------------------
Total                                150
Add live-site verification
BACKLOG                              +20
Reduces recurring manual workflow    +10
-----------------------------------------
Total                                 30
Continue BradCooke.com content
NEXT.md                              +50
PROJECT_STATUS current focus         +30
ROADMAP active capability            +20
-----------------------------------------
Total                                100

Expected recommendation:

Refine abbey review through practical usage.

The result is predictable and fully explainable.

⸻

Test Scenarios

The initial implementation should be validated against at least the following scenarios.

Scenario 1: Clean Repository with Clear Priority

Expected behavior:

* Recommend the highest-ranked current priority.

Scenario 2: Coherent Uncommitted Work

Expected behavior:

* Recommend completing the current work before beginning something new.

Scenario 3: Completed Backlog Item Still Mentioned Elsewhere

Expected behavior:

* Exclude the completed item.

Scenario 4: Explicitly Deferred High-Priority Item

Expected behavior:

* Do not recommend it.

Scenario 5: Equal Candidate Scores

Expected behavior:

* Apply deterministic tie-breaking.

Scenario 6: Missing Optional History

Expected behavior:

* Produce a recommendation using planning documents only.

Scenario 7: Missing Required Planning Document

Expected behavior:

* Report a validation failure and identify the missing source.

Scenario 8: Conflicting Planning Sources

Expected behavior:

* Prefer the higher-authority source and explain the conflict.

Scenario 9: No Strong Candidate

Expected behavior:

* Report low confidence rather than inventing work.

⸻

Validation Questions

Before accepting the first implementation, ask:

* Does the recommendation match documented human priorities?
* Can every score be traced to evidence?
* Does the command avoid completed and deferred work?
* Does it recommend a realistic single session?
* Is the Definition of Done measurable?
* Does repeated execution produce the same result?
* Does existing work in progress take precedence?
* Would the maintainer reasonably agree with the recommendation?

A recommendation engine that cannot clearly answer these questions is not ready for automation.

⸻

Initial Implementation Boundary

The first implementation should prove only this workflow:

Read planning documents
        ↓
Extract a small set of candidates
        ↓
Apply deterministic rules
        ↓
Recommend one session
        ↓
Explain why

Provider abstractions, configuration files, reusable libraries, AI integration, and advanced ranking should wait until practical use demonstrates a need.

The architecture should allow future extension, but the implementation should remain simple.

⸻

Success Criteria

The deterministic recommendation algorithm is successful when:

* abbey next consistently recommends one coherent session.
* The recommendation respects human direction.
* The recommendation is supported by visible project evidence.
* The same project state produces the same result.
* Completed, blocked, and deferred work are not recommended.
* The result includes a useful Objective and Definition of Done.
* The maintainer can understand and challenge every decision the engine made.

The standard is not whether Abbey appears intelligent.

The standard is whether Abbey provides useful, trustworthy, and explainable guidance.
