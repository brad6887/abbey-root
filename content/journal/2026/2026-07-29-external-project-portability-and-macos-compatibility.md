---
title: "External Project Portability and macOS Compatibility"
description: "Made core Abbey commands portable across external projects and compatible with the macOS-provided Bash 3.2 shell."
date: 2026-07-29
draft: false
tags:
  - Abbey Root
---

# External Project Portability and macOS Compatibility

## Summary

Validated Abbey as a toolkit that can operate against projects outside the Abbey Root repository.

Bread Pitt served as the real external-project test. Running Abbey commands from that repository exposed several places where the active project root and the Abbey toolkit root were still treated as the same location.

The initial path fixes worked, but testing on the Mac exposed a second portability problem: several commands and tests relied on features available in newer Linux Bash versions but not in the macOS-provided Bash 3.2 shell.

The session addressed both problems and added repeatable regression coverage.

## Accomplishments

- Separated the active project root from the Abbey toolkit root in core commands.
- Updated AI, context, documentation, end, knowledge, and research workflows to load implementation files from the toolkit.
- Kept project planning documents, generated context, knowledge, and AI history inside the active project.
- Replaced Bash 4-only `readarray`, `mapfile`, and lowercase parameter expansion.
- Replaced platform-specific `sed -i` usage in regression tests.
- Prevented context generation from printing a fatal Git message in repositories with no commits.
- Updated `abbey init` so generated Abbey runtime state is ignored by Git.
- Kept `.abbey/project.yml` and `.abbey/session-guidance.md` trackable.
- Added a dedicated external-project portability regression suite.
- Made the `abbey next` test fixture define its own backlog state instead of depending on the current Abbey Root backlog.
- Successfully ran `abbey ai decide easy-win` from Bread Pitt.

## Validation

- `tests/test-abbey-init.sh`: 25 passed, 0 failed
- `tests/test-abbey-knowledge.sh`: 9 passed, 0 failed
- `tests/test-abbey-ai.sh`: 74 passed, 0 failed
- `tests/test-abbey-next.sh`: 18 passed, 0 failed
- `tests/test-abbey-portability.sh`: 29 passed, 0 failed
- `git diff --check`: passed
- Bash syntax validation: passed
- Static Bash 4 construct scan: passed
- Bread Pitt knowledge build and status: passed
- Bread Pitt context generation and nested project discovery: passed
- Bread Pitt live AI decision: passed

## Lessons Learned

- The Abbey toolkit root and the active project root must be treated as separate concepts.
- A command can be repository-portable and still fail because of shell-version assumptions.
- macOS is a useful portability target because its default Bash exposes compatibility problems hidden by newer Linux environments.
- External-project tests should run the real Abbey toolkit against a separate project instead of copying toolkit files into the fixture.
- Generated runtime state needs a clear Git ignore policy.
- Test fixtures should create the exact state they need instead of inheriting mutable project planning data.
- Bread Pitt is already proving useful as Abbey's first real external-project test case.

## Next Steps

- Review `abbey-site`, `abbey-lab`, and `abbey-ssh` for toolkit-root and project-root assumptions.
- Make `abbey status` warnings depend on project capabilities.
- Review Abbey Root-specific language shown in external-project output.
- Commit the Bread Pitt `.gitignore` migration separately.
- Use another external project to confirm the portability model continues to hold.
