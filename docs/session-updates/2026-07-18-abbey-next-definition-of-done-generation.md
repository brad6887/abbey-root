---
title: "abbey-next-definition-of-done-generation.md"
description: "Corrected Abbey Next so Definition of Done output matches the selected recommendation and added regression coverage."
date: 2026-07-18
draft: false
tags:
  - Abbey Root
  - Abbey Next
  - Recommendation Engine
  - Testing
---

# abbey-next-definition-of-done-generation.md

## Summary

Corrected a flaw in `abbey next` where the **Definition of Done** section was generated from the next few entries in the **Project-Aware Recommendations** list rather than from the recommendation actually selected by the recommendation engine. The implementation now generates recommendation-specific completion criteria with a deterministic fallback for recommendations that do not yet have custom criteria.

## Accomplishments

- Identified that Definition of Done generation was position-based instead of recommendation-based.
- Removed the positional extraction logic that depended on neighboring backlog entries.
- Replaced it with a recommendation-aware `print_definition_of_done()` helper.
- Added recommendation-specific completion criteria for existing Abbey Next recommendation types.
- Added a deterministic generic fallback for future recommendations without custom definitions.
- Added regression coverage verifying that the selected recommendation receives its own Definition of Done rather than unrelated neighboring backlog items.
- Updated an existing regression test so pending session updates are validated without assuming a fixed recommendation ranking.
- Validated the implementation with shell syntax checks, clean diffs, the Abbey Next regression suite, and live `abbey next` output.

## Validation

- `bash -n tools/bin/abbey-next`
- `bash -n tests/test-abbey-next.sh`
- `git diff --check`
- `tests/test-abbey-next.sh` — 18 passed, 0 failed
- Verified `abbey next` generates a Definition of Done that matches the selected recommendation.

## Lessons Learned

The recommendation engine should derive all recommendation-specific output from the selected recommendation rather than from document ordering. Using positional relationships within planning documents created hidden coupling that became incorrect as the planning documents evolved. Mapping output directly from the selected recommendation is simpler, more deterministic, and easier to extend.

## Next Steps

- Expand recommendation-specific objective and Definition of Done generation as additional recommendation types are introduced.
- Continue refining recommendation output through practical use and regression testing.
- Reconcile completed planning items after implementation work is validated so planning documents remain an accurate reflection of project status.
