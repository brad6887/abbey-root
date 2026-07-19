---
title: "abbey-next-definition-of-done-generation.md"
description: "Corrected Definition of Done generation in Abbey Next to align with the selected recommendation."
date: 2026-07-18
draft: false
tags:
  - Abbey Root
---

# abbey-next-definition-of-done-generation.md

## Summary

Today's session started with a recommendation from `abbey next` that immediately looked wrong. The recommended session and Definition of Done described two different pieces of work. That turned into a short investigation which uncovered a subtle coupling between the recommendation engine and the ordering of backlog items.

## Accomplishments

- Traced the incorrect Definition of Done output to positional backlog parsing.
- Replaced positional extraction with recommendation-specific Definition of Done generation.
- Added a deterministic fallback for recommendations without custom completion criteria.
- Added regression coverage to prevent unrelated backlog items from becoming a recommendation's Definition of Done.
- Updated an existing regression test to validate pending session updates without depending on recommendation ranking.
- Verified the implementation through syntax checks, regression testing, and live `abbey next` output.

## Lessons Learned

Recommendation output should always be derived from the recommendation selected by the engine rather than the surrounding structure of planning documents. Hidden positional coupling can remain unnoticed until planning documents evolve, making deterministic mappings a more maintainable design.

## Next Steps

- Expand recommendation-specific objective and Definition of Done generation as additional recommendation types are added.
- Continue refining Abbey Next through practical usage and regression testing.
- Reconcile completed planning items after implementation work has been validated.
