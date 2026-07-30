---
title: "Retire Legacy Abbey Build Workflow"
description: "Removed an obsolete build wrapper instead of turning Abbey Root-specific behavior into a universal command."
date: 2026-07-30
draft: false
tags:
  - Abbey Root
  - CLI
  - Legacy Cleanup
---

# Retire Legacy Abbey Build Workflow

## Summary

The backlog said to expand `abbey-build`, but investigation showed that the
command belonged to Abbey Root's older standalone-tool layer and was not part
of the current registered CLI.

Rather than formalizing an ambiguous wrapper, the session removed it and
updated current documentation to use supported, purpose-specific commands.

## Accomplishments

- Removed the legacy `tools/abbey-build` script.
- Removed stale help and documentation references.
- Regenerated the legacy command-header reference.
- Preserved the historical architecture review.
- Added regression coverage proving the retired command stays retired.
- Completed the reconciled backlog item.

## Lessons Learned

- Not every old backlog item should be implemented literally.
- A universal Abbey command should represent behavior shared across project
  types.
- Sometimes the correct framework improvement is deleting an obsolete
  abstraction rather than expanding it.

## Next Steps

- Review other standalone legacy tools only when there is concrete evidence
  that they overlap or conflict with the registered CLI.
