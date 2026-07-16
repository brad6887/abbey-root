---
title: "Initial Abbey Review Workflow"
description: "Created a deterministic pre-commit review command for summarizing session work, checking documentation, and recommending the next workflow step."
date: 2026-07-16
status: complete
reviewed: false
session: primary
tags:
  - Abbey Root
  - Workflow
  - Developer Toolkit
  - Automation
---

# Initial Abbey Review Workflow

## Objective

Design and implement the first practical version of `abbey review`.

## Definition of Done

- Create the `abbey review` command.
- Integrate it into the metadata-driven CLI.
- Review repository state and summarize current work.
- Detect session update and journal artifacts.
- Recommend planning documents that may require review.
- Suggest a commit message.
- Recommend the next Abbey workflow step.
- Keep the command deterministic, read-only, and independent of AI.
- Validate the command against the current development session.

## Accomplishments

### Abbey Review Command

Created the initial `abbey review` workflow as a new top-level Abbey command.

The command reports:

- Current branch.
- Staged changes.
- Unstaged changes.
- Untracked files.
- Changed file paths.
- Presence of a session update.
- Presence of a journal entry.
- Planning documents that may require review.
- A categorized summary of the current work.
- A deterministic suggested commit message.
- The next recommended Abbey workflow step.

### Metadata-Driven CLI Integration

Added `abbey review` to the primary command dispatcher and CLI metadata.

The command now appears in generated Abbey help under the Workflow category.

### Workflow Boundaries

Defined `abbey review` as a reviewer rather than an editor.

The first version:

- Does not modify planning documents.
- Does not automatically reconcile documentation.
- Does not require an AI model.
- Treats `NEXT.md` as a human-directed priority document.
- Uses deterministic repository state to make recommendations.

This preserves a clear distinction between:

- `abbey review`, which reviews the current working session before commit.
- `abbey session review`, which performs historical session reconciliation using Codex.
- `abbey end`, which certifies the committed session state.

### Workflow Recommendation Refinement

Initial testing showed that the command recommended documentation before validation.

The decision order was corrected so the command follows the Abbey Session Workflow:

1. Review
2. Define
3. Build
4. Validate
5. Document
6. Capture
7. Commit
8. Review

For an unstaged implementation, `abbey review` now recommends validating the current changes before creating session documentation.

## Validation

Completed validation included:

- `bash -n tools/bin/abbey tools/bin/abbey-review`
- `git diff --check`
- `abbey help`
- `abbey review help`
- Live execution of `abbey review`
- Verification that dispatcher and CLI metadata entries agree
- Verification that the command correctly categorized toolkit changes
- Verification that the command suggested the expected commit message
- Verification that the command recommended validation as the next workflow step

All validation completed successfully.

## Lessons Learned

- Workflow recommendations must identify the next incomplete stage, not merely the most visible missing artifact.
- Planning reconciliation is broader than planning review and should remain a separate future capability.
- A deterministic foundation makes the review command useful even when AI services are unavailable.
- Generated session context should prevent redundant repository discovery at the start of an AI-assisted session.

## Next Steps

- Refine `abbey review` through practical usage.
- Improve detection of validation already performed.
- Improve rule-based planning recommendations.
- Evaluate optional AI-assisted review after the deterministic workflow stabilizes.
- Preserve automatic planning reconciliation as a separate future capability.
