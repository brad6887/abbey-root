---
title: "Retire Legacy Abbey Build Workflow"
description: "Removed the obsolete Abbey Root-specific abbey-build wrapper and reconciled current documentation around supported commands."
date: 2026-07-30
status: complete
reviewed: true
session: retire-legacy-abbey-build-workflow
tags:
  - Abbey Root
  - CLI
  - Legacy Cleanup
  - Documentation
---

# Retire Legacy Abbey Build Workflow

## Objective

Retire the unsupported legacy `tools/abbey-build` command and reconcile current
documentation so only registered Abbey commands are presented as supported
workflows.

## Definition of Done

- `tools/abbey-build` is removed.
- `tools/abbey-help` no longer recommends `abbey-build`.
- Current documentation no longer tells users to run unsupported
  `abbey build`.
- Documentation points to supported, purpose-specific Abbey commands.
- The historical architecture review remains unchanged.
- Generated command documentation no longer includes `abbey-build`.
- No universal build command is added solely to preserve obsolete behavior.
- Focused regression coverage verifies the retirement.
- Documentation and backlog freshness checks pass.
- The original backlog item is reconciled and completed.

## Summary

Retired the legacy `tools/abbey-build` wrapper rather than expanding it.

The command belonged to Abbey Root's older standalone-tool layer and was not
registered in the current metadata-driven CLI. It combined Ansible inventory
validation, documentation generation, and Git status under the ambiguous term
"build."

The supported Abbey CLI now retains purpose-specific commands such as
`abbey docs`, `abbey review`, and `abbey site build` without introducing a
misleading universal build command.

## Accomplishments

- Removed `tools/abbey-build`.
- Removed the obsolete command from generated legacy command documentation.
- Updated `tools/abbey-help` to recommend supported documentation and review
  commands instead of `abbey-build`.
- Replaced unsupported `abbey build` examples in current documentation.
- Preserved the historical architecture review that accurately records the old
  CLI layer.
- Replaced the broad backlog item with a bounded retirement outcome and marked
  it complete.
- Added focused regression coverage for the retired command and stale
  references.

## Impact

Abbey documentation and help output no longer imply that `abbey build` is a
supported universal command.

This avoids formalizing an Abbey Root-specific wrapper as a framework
capability and preserves the clearer separation between project-specific
builds, documentation generation, validation, and pre-commit review.

## Validation

The following checks passed:

- Legacy `tools/abbey-build` executable is absent.
- `abbey build` is rejected as an unknown command.
- `tests/test-abbey-build-retirement.sh`
- `abbey docs check`
- `abbey backlog check`
- `bash -n tools/abbey-help`
- `git diff --check`

## Lessons Learned

- The generated registered-command inventory made the unsupported legacy
  command immediately visible as an inconsistency.
- A historical backlog entry should not automatically cause an old workflow to
  become part of the current framework.
- Universal Abbey commands should describe behavior that is meaningful across
  project types.
- Inventory validation, documentation generation, Git status, and website
  builds are separate responsibilities and should remain separately named.
- Historical reviews should be preserved when they accurately describe an
  earlier architecture.

## Next Steps

- Review the remaining standalone tools individually as normal work exposes
  duplication or unsupported behavior.
- Define a universal build command only if multiple Abbey project types
  demonstrate a stable shared build contract.

## Notes

The following legacy tools remain intentionally unchanged:

- `tools/abbey-validate`
- `tools/abbey-docs`
- `tools/abbey-git-status`
- `tools/abbey-help`

Their future retention or retirement is outside this session.
