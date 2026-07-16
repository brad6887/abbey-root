---

title: "Building the First Abbey Review Workflow"

description: "Added a deterministic pre-commit reviewer that helps complete Abbey sessions in the correct order."

date: 2026-07-16

draft: false

tags:

  - Abbey Root

  - Workflow

  - Automation

  - Developer Toolkit

---

# Building the First Abbey Review Workflow

## Summary

Abbey Root now has an initial `abbey review` command for reviewing the current development session before commit.

The command summarizes repository changes, checks whether the session update and journal entry are present, recommends planning documents that may need attention, suggests a commit message, and identifies the next Abbey workflow step.

The first version is intentionally deterministic and read-only. It does not depend on AI and does not modify authoritative planning documents.

## Accomplishments

- Created the top-level `abbey review` command.

- Added the command to the Abbey dispatcher.

- Added CLI metadata so the command appears in generated help.

- Reported staged, unstaged, and untracked changes separately.

- Added changed-file reporting.

- Added session update and journal detection.

- Added rule-based planning review recommendations.

- Preserved `NEXT.md` as a human-directed priority document.

- Added a categorized work summary.

- Added deterministic commit message suggestions.

- Added next-step recommendations based on current repository state.

- Corrected the workflow order so validation is recommended before documentation.

- Validated shell syntax, CLI help, metadata integration, and live command behavior.

## Lessons Learned

The most important lesson from the first live run was that a workflow assistant must understand sequence.

The initial implementation saw missing documentation and recommended creating it immediately. That skipped the validation stage.

The command was corrected to recommend the next incomplete Abbey workflow step rather than simply reacting to the most obvious missing file.

The session also clarified an important boundary: reviewing planning documents is not the same as reconciling them. The current command recommends attention but leaves authoritative edits under human control.

## Next Steps

- Use `abbey review` during normal development sessions.

- Refine its recommendations based on actual friction.

- Improve validation-state detection.

- Improve planning-document recommendations.

- Consider optional AI assistance only after the deterministic workflow has proven stable.
