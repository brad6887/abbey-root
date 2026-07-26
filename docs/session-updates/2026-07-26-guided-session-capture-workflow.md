---
title: "Guided Session Capture Workflow"
description: "Added a guided, resumable session capture workflow and changed-file metadata validation while keeping historical metadata debt non-blocking."
date: 2026-07-26
status: complete
reviewed: true
session: primary
tags:
  - Abbey Root
  - Abbey Framework
  - Developer Toolkit
  - Session Workflow
---

# Guided Session Capture Workflow

## Objective

Create one guided Abbey command that captures both required session artifacts and enforces current session-update metadata requirements without forcing unrelated historical cleanup.

## Definition of Done

- `abbey session capture [--title TITLE] <slug>` creates the session update and journal entry together.
- Existing session and journal generation logic is reused rather than duplicated.
- Existing files are preserved.
- Partial capture states can be resumed safely.
- Generated artifact paths are reported clearly.
- New or modified session updates are validated for required metadata.
- Invalid changed session updates block `abbey review` with actionable errors.
- Pre-existing historical metadata debt is reported without blocking unrelated work.
- CLI metadata and focused regression coverage are updated.
- Planning reconciliation is left to the normal session review workflow.

## Summary

Implemented a guided session capture workflow by composing the existing `abbey session update` and `abbey journal` capabilities.

The new `abbey session capture` command creates both session artifacts, preserves existing files, and can be rerun to finish a partial capture. The journal command gained a reusable non-interactive mode so the capture workflow can create an entry without opening an editor.

A deterministic session-update metadata validator now checks new or modified session updates during `abbey review`. Invalid current work blocks review, while unrelated historical metadata problems are summarized as non-blocking debt.

## Accomplishments

- Added `abbey session capture [--title TITLE] <slug>`.
- Added `abbey journal --no-edit`.
- Reused existing session-update and journal generation behavior.
- Made session capture safe to rerun.
- Supported recovery when either the session update or journal entry already exists.
- Rejected conflicting titles when resuming an existing session capture.
- Reported the path of each created or existing artifact.
- Added deterministic session-update frontmatter validation.
- Integrated changed-file metadata validation into `abbey review`.
- Made invalid changed session updates fail review.
- Reported pre-existing historical session metadata debt without making it block unrelated work.
- Added CLI metadata for the new capture command.
- Added focused regression coverage for session capture and metadata validation.
- Corrected a function-return trap issue discovered by regression testing.

## Impact

Abbey sessions can now be captured through one clear command instead of requiring separate session-update and journal commands.

The workflow is stricter for current work without demanding an unrelated cleanup of historical files. This creates a practical migration boundary: new and modified session updates must meet the current metadata contract, while older debt remains visible and can be addressed independently.

The implementation directly addresses the guided session capture and scoped metadata-validation outcomes selected by `abbey ai decide backlog-leverage`.

## Validation

- Shell syntax validation passed.
- `tests/test-abbey-session-update.sh`: 18 passed, 0 failed.
- `tests/test-abbey-session-capture.sh`: 14 passed, 0 failed.
- `tests/test-abbey-journal.sh`: 30 passed, 0 failed.
- `tests/test-abbey-session-metadata.sh`: 9 passed, 0 failed.
- `tests/test-abbey-review-session-metadata.sh`: 6 passed, 0 failed.
- A real `abbey session capture guided-session-capture-workflow` run preserved the existing session update and created the missing journal entry.
- A repeated capture preserved existing artifacts.
- `abbey review` rejected the generated placeholder description in the changed session update.
- The same review reported historical metadata debt as warnings rather than as the cause of failure.
- `git diff --check` passed during implementation validation.
- Final `abbey review` accepted the changed session metadata and reported historical metadata debt as warning-only.
- `abbey session review` correctly identified both completed backlog entries and the required Developer Toolkit capability update without requiring changes to `NEXT.md`, `ROADMAP.md`, or `IDEAS.md`.

## Lessons Learned

The existing commands already contained most of the required behavior. The correct framework improvement was to compose them rather than create another independent artifact-generation path.

A non-interactive mode is an important interface for commands that may be used by other Abbey commands. Interactive editor behavior should remain the default for humans, while orchestration commands need a deterministic way to create and report artifacts.

Validation can enforce improved standards incrementally. Checking changed files strictly while reporting untouched historical problems provides useful enforcement without turning old documentation debt into a permanent blocker.

Moving temporary-file handling into a helper exposed a Bash `RETURN` trap lifetime issue. The trap had to be explicitly cleared before the helper returned so it would not reference a local variable after its scope ended.

## Next Steps

- Evaluate the guided capture command through normal use before adding active-session state or more interactive behavior.
- Keep historical metadata cleanup separate from unrelated current sessions.

## Notes

`docs/planning/BACKLOG.md` was intentionally not updated during implementation. This session is being used to test whether the existing session review workflow correctly identifies and recommends reconciliation of the completed backlog outcomes.
