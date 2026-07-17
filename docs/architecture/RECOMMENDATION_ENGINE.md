# Abbey Recommendation Engine

## Purpose

The Abbey Recommendation Engine provides deterministic, project-aware guidance about what work should be performed next.

Rather than replacing project planning, it interprets the project's authoritative planning documents and current state to recommend focused engineering sessions.

Its purpose is to help answer one of the most common engineering questions:

> "What should I work on next?"

The Recommendation Engine should always be able to explain *why* it made a recommendation.

Planning remains a human responsibility.

Recommendations remain an Abbey responsibility.

---

# Philosophy

Abbey should help engineers make productive decisions without taking control away from them.

The Recommendation Engine exists to interpret the current state of a project—not to invent work or redefine priorities.

Planning documents remain authoritative.

Humans decide project direction.

Abbey recommends the next productive engineering session.

Recommendations should always be:

- Deterministic
- Explainable
- Reproducible
- Project-aware
- Evidence-based
- Focused on one coherent session

Every recommendation should answer three questions:

1. What should I work on?
2. Why is this the best recommendation?
3. What does success look like?

The long-term vision is for Abbey to evolve from a collection of engineering utilities into a project-aware engineering assistant that understands the current state of a project and can recommend productive work while always respecting human direction.

---

# Design Goals

The Recommendation Engine should be:

- Deterministic
- Explainable
- Modular
- Extensible
- Project-aware
- Human-directed

It should produce the same recommendation when presented with the same project state.

The recommendation process should never be a black box.

---

# Recommendation Hierarchy

Not all project information has equal authority.

The Recommendation Engine interprets project information using the following hierarchy.

## 1. Human Direction (Highest Authority)

Represents intentional human decisions.

Examples:

- `NEXT.md`
- Active session objective
- Explicit user requests

These should never be overridden by the recommendation engine.

---

## 2. Project State

Represents the current condition of the project.

Examples:

- `PROJECT_STATUS.md`
- Current repository state
- Recent completed sessions
- Current branch
- Working tree

These describe reality rather than future plans.

---

## 3. Available Work

Represents potential future work.

Examples:

- `BACKLOG.md`
- `ROADMAP.md`

These provide candidate work but do not define immediate priorities.

---

## 4. Supplemental Evidence

Provides additional context that may improve recommendations.

Examples:

- Infrastructure health
- AI evaluation history
- Documentation freshness
- Generated metrics
- Review history

Supplemental evidence may influence recommendations but should never outweigh explicit human priorities.

---

# Version 1 Scope

The first implementation intentionally remains simple.

Version 1 will recommend a single engineering session.

It will:

- Read project planning documents.
- Interpret current project priorities.
- Consider repository state.
- Produce one recommended session.
- Explain the reasoning.
- Generate a Definition of Done.

Version 1 will not use AI.

---

# Inputs

## Planning Documents

- `PROJECT_STATUS.md`
- `NEXT.md`
- `BACKLOG.md`
- `ROADMAP.md`

## Repository

- Git status
- Current branch
- Working tree
- Recent commits

## Project History

- Recent session updates
- Recent journal entries

Future versions may incorporate:

- Infrastructure health
- Documentation validation
- AI evaluation results
- Generated project metrics
- Review history

---

# Recommendation Pipeline

```
Collect Inputs
      ↓
Normalize Information
      ↓
Generate Candidate Sessions
      ↓
Filter Candidates
      ↓
Score Candidates
      ↓
Rank Candidates
      ↓
Produce Recommendation
```

Each stage should remain deterministic and independently testable.

---

# Candidate Generation

The engine should identify potential engineering sessions from multiple sources.

Examples include:

- Current priorities
- Backlog items
- Roadmap milestones
- Continuations of recent work
- Repository observations

Candidates should represent complete engineering sessions rather than isolated tasks whenever possible.

---

# Candidate Filtering

Before scoring, eliminate recommendations that are clearly unsuitable.

Examples include:

- Completed work
- Duplicate recommendations
- Blocked work
- Recommendations conflicting with explicit human direction

---

# Scoring

Version 1 uses simple deterministic scoring.

Example factors:

| Factor | Example Weight |
|----------|---------------:|
| Appears in `NEXT.md` | +50 |
| Supports current project theme | +25 |
| Appears in `BACKLOG.md` | +20 |
| Unblocks additional work | +15 |
| Continues recent work | +10 |

Weights should remain configurable as experience grows.

---

# Recommendation Model

Every recommendation should contain:

## Objective

A concise session objective.

---

## Definition of Done

Clear completion criteria.

---

## Reasoning

An explanation of why the recommendation was selected.

---

## Supporting Evidence

Which planning documents or repository observations contributed to the recommendation.

---

## Priority Score

Deterministic score used for ranking.

---

## Confidence

An indication of how strongly the available evidence supports the recommendation.

---

# Recommendation Output

Version 1 should produce output similar to:

```text
Abbey Recommendation

Recommended Session
-------------------

Design the Recommendation Engine.

Reason

• Current project theme emphasizes framework development.
• Continues recent workflow improvements.
• Enables future project-aware commands.
• Unblocks abbey next.

Definition of Done

✓ Architecture documented
✓ Recommendation pipeline defined
✓ Future extensions identified

Supporting Evidence

NEXT.md
PROJECT_STATUS.md
BACKLOG.md
ROADMAP.md
```

Every recommendation should be fully explainable.

---

# Recommendation Providers

The Recommendation Engine should be designed around reusable providers rather than hard-coded logic.

Examples:

- Planning Provider
- Repository Provider
- Session History Provider
- Infrastructure Provider
- Documentation Provider
- AI Provider

Each provider contributes evidence to the recommendation process.

Future providers should be addable without redesigning the engine.

---

# Future Recommendation Types

Although Version 1 focuses on engineering sessions, the architecture should support additional recommendation categories.

Examples include:

- Next engineering work
- Infrastructure maintenance
- Documentation improvements
- Publishing opportunities
- Plant workspace reviews
- AI evaluations
- Technical debt reduction
- Security reviews
- Research topics

The recommendation engine should become a reusable capability shared across future Abbey commands.

---

# Non-Goals

The Recommendation Engine intentionally does not:

- Rewrite planning documents.
- Reorder project priorities.
- Invent roadmap items.
- Replace human judgment.
- Require AI.
- Automatically modify the repository.

Its role is advisory.

Planning remains the responsibility of humans.

Execution remains the responsibility of engineers.

---

# Long-Term Vision

The Recommendation Engine is the first step toward making Abbey project-aware.

Today, Abbey understands:

- documentation
- repository state
- planning documents

The Recommendation Engine allows Abbey to interpret that knowledge and recommend productive engineering sessions.

Future Abbey commands will reuse this capability to provide increasingly intelligent guidance while remaining deterministic, explainable, and firmly grounded in the project's authoritative sources of truth.
