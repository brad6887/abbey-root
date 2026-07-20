---
title: "Abbey Next Deterministic Recommendation Engine"
description: "Designed and implemented the initial project-aware abbey next command, validated deterministic recommendation behavior, and identified unreconciled session updates as a required freshness layer."
date: 2026-07-16
status: complete
reviewed: true
session: primary
tags:
  - Abbey Root
  - Developer Toolkit
  - Workflow
  - Recommendation Engine
  - Project-Aware Automation
---

Abbey Next Deterministic Recommendation Engine

Objective

Design and implement the initial abbey next command as a deterministic, explainable recommendation workflow for selecting the next focused Abbey Root development session.

Definition of Done

* Define the Recommendation Engine architecture.
* Define the deterministic recommendation algorithm.
* Define the initial abbey next output.
* Register abbey next in the metadata-driven CLI.
* Validate required planning documents.
* Detect active Recommendation Engine work.
* Recommend one focused session.
* Explain the recommendation using visible project evidence.
* Add regression tests for the implemented behavior.
* Identify architectural limitations through practical use.

Accomplishments

Recommendation Engine Design

Created the initial architecture documents for Abbey’s project-aware recommendation capability:

* docs/architecture/RECOMMENDATION_ENGINE.md
* docs/architecture/RECOMMENDATION_ALGORITHM.md
* docs/architecture/ABBEY_NEXT_OUTPUT.md

The design establishes that:

* Human direction remains authoritative.
* Recommendations must be deterministic and explainable.
* Abbey recommends complete engineering sessions rather than isolated tasks.
* Existing coherent work should take precedence over unrelated new work.
* AI may enhance recommendations later but is not required for the deterministic foundation.

Planning Authority Model

Defined the initial relationship between planning sources:

NEXT.md / PROJECT_STATUS.md
    current human direction
BACKLOG.md / ROADMAP.md
    valid future opportunities

Reconciled the current planning documents by removing abbey init from immediate priorities while preserving it as valid future work in the backlog and roadmap.

The project intentionally deferred abbey init until BradCooke.com and other real Abbey projects provide more practical framework experience.

Abbey Next Command

Created tools/bin/abbey-next and registered it through:

* tools/bin/abbey
* config/cli/cli.yml

The command now:

* Appears in generated Abbey CLI help.
* Supports abbey next and abbey next help.
* Validates required planning documents.
* Displays the current project theme.
* Displays the primary project objective.
* Produces one recommended engineering session.
* Generates an objective.
* Generates an initial Definition of Done.
* Explains why the recommendation was selected.
* Displays supporting project evidence.
* Suggests the first implementation step.

Deterministic Candidate Engine

Created:

scripts/abbey_next_candidates.py

The helper separates recommendation logic from the shell command and provides a foundation for deterministic candidate collection and ranking.

The initial engine:

* Reads incomplete backlog work.
* Reads current priorities from NEXT.md.
* Reads immediate priorities from PROJECT_STATUS.md.
* Inspects the current Git working tree.
* Detects active Recommendation Engine files.
* Restricts recommendations to the relevant backlog family when coherent work is already active.
* Promotes the next incomplete item after completed work is checked off.
* Returns structured evidence to the shell command.

Active Work Detection

Validated that abbey next distinguishes between:

* A repository containing active Recommendation Engine work.
* A clean repository with no related implementation in progress.

When related files are active, the command prioritizes completing the current coherent session instead of recommending unrelated work.

Completed Work Detection

Validated that checking off:

- [x] Create `abbey next`.

causes the command to promote:

Build deterministic project recommendation engine

The recommendation objective and suggested first step also change with the promoted item.

Regression Tests

Created:

tests/test-abbey-next.sh

The regression suite validates:

* Current theme parsing.
* Initial recommendation selection.
* Active Recommendation Engine detection.
* Coherent work-in-progress priority.
* Completed-item suppression.
* Promotion to the next incomplete recommendation.
* Recommendation-specific objective generation.
* Recommendation-specific first-step generation.
* Failure when a required planning document is missing.
* Clear reporting of the missing document.

Final result:

Passed: 10
Failed: 0

Repetitive Context Discovery

Identified repeated inspection of the Abbey CLI dispatcher, CLI metadata, and command files as unnecessary session overhead.

Added a high-priority backlog item to include a generated CLI architecture and registered-command summary in future abbey session context output.

This will allow future AI-assisted sessions to understand the command architecture without repeatedly rediscovering it.

AI Evaluation Cleanup

Removed the temporary working/ai-evals/ directory after determining that its contents were no longer needed for the current repository state.

Validation

Completed validation included:

python3 -m py_compile scripts/abbey_next_candidates.py
bash -n tools/bin/abbey tools/bin/abbey-next tests/test-abbey-next.sh
git diff --check
abbey help
abbey next help
abbey next
tests/test-abbey-next.sh

Additional isolated Git fixtures validated:

* Clean repository behavior.
* Active-work behavior.
* Completed backlog item behavior.
* Required planning document failure behavior.

All final syntax, diff, command, and regression checks completed successfully.

Lessons Learned

Authority and Freshness Are Different

Planning documents are authoritative, but they are not always the freshest representation of project state.

Abbey Root sessions are normally captured first through session updates. Planning documents are reconciled periodically rather than immediately after every session.

Therefore:

* Planning documents define official direction.
* Unreconciled session updates describe changes that have occurred since planning was last refreshed.
* Current working-tree state identifies work already in progress.
* Recommendation logic must consider both authority and freshness.

Session Updates Are a Required Recommendation Source

The reviewed: false session-update metadata provides a natural freshness signal.

Future versions of abbey next should use unreconciled session updates to:

* Suppress work already completed.
* Discover recently identified next steps.
* Detect priorities not yet promoted into planning documents.
* Report conflicts between recent work and existing planning.
* Avoid treating stale unchecked backlog items as current work.

Keyword Matching Is Not Project Understanding

Loose token matching produced plausible but incorrect recommendations such as AI documentation review.

The engine confused shared words such as documentation, review, and session with meaningful project relationships.

This demonstrated that:

Abbey should model project state directly rather than attempting to recreate human judgment through increasingly complicated text heuristics.

Active Work Is Strong Evidence

The current working tree is one of the most reliable signals available.

When a coherent set of related files is already being changed, finishing that work is normally a better recommendation than beginning an unrelated backlog item.

Fixtures Must Define Their Own State

Regression tests initially inherited the repository’s current backlog completion state.

Tests became reliable only after fixtures explicitly created the state required by each scenario.

Test fixtures should remain independent of the live project’s current planning status.

Implementation Validates Architecture

The first deterministic implementation exposed limitations that were not obvious during design.

The command is valuable not only as a tool but as a way to validate the Recommendation Engine model through real use.

Next Steps

* Use unreconciled session updates as recommendation evidence.
* Suppress work completed in unreconciled session updates.
* Extract candidate follow-up work from session-update Next Steps.
* Report conflicts between recent session updates and planning documents.
* Design structured recommendation metadata where practical.
* Replace broad text matching with stronger project-state relationships.
* Generate recommendation-specific Definitions of Done for candidates outside the Recommendation Engine workflow.
* Add a clean-repository recommendation scenario to the regression suite.
* Add generated CLI architecture and registered-command summaries to abbey session context.
* Continue refining abbey next through practical Abbey Root sessions.
