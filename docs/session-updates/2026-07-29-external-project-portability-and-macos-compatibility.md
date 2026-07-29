---
title: "External Project Portability and macOS Compatibility"
description: "Separated Abbey toolkit code from active-project data, added macOS-compatible shell behavior, and validated core workflows in Bread Pitt."
date: 2026-07-29
status: pending
reviewed: false
session: external-project-portability-and-macos-compatibility
tags:
  - Abbey Root
---

# External Project Portability and macOS Compatibility

## Objective

Make core Abbey commands portable across external project roots and supported host shells.

## Definition of Done

- Core commands distinguish the Abbey toolkit root from the active project root.
- External-project knowledge, context, AI, documentation, research, and session-ending workflows locate toolkit implementation files correctly.
- Generated Abbey runtime state is ignored in initialized projects.
- Runtime commands work with the macOS-provided Bash 3.2 shell.
- Newly initialized and nested external projects pass deterministic regression tests.
- Bread Pitt validates the workflow through a real AI decision run.

## Summary

Separated Abbey framework implementation paths from active-project data paths across the core commands used by external projects.

The work began as a repository-root portability review and expanded to include host-shell portability after Bread Pitt testing on macOS exposed Bash 4-only constructs. The resulting workflow was validated through deterministic regression tests and a real `abbey ai decide easy-win` run from the Bread Pitt repository.

## Accomplishments

- Updated `abbey-ai`, `abbey-context`, `abbey-docs`, `abbey-end`, `abbey-knowledge`, and `abbey-research` to resolve implementation files from `ABBEY_TOOLKIT_ROOT`.
- Preserved `ABBEY_ROOT` as the active project root for project configuration, planning documents, generated context, knowledge snapshots, AI history, and other project-local artifacts.
- Replaced `readarray` and `mapfile` usage with Bash 3.2-compatible array population loops.
- Replaced Bash 4 lowercase parameter expansion with portable `tr`-based normalization.
- Replaced platform-specific `sed -i` usage in tests with a Python-backed file replacement helper.
- Updated context generation to handle repositories with no commits without emitting fatal Git output.
- Updated `abbey init` to ignore `.abbey/ai/`, `.abbey/context/`, `.abbey/knowledge/`, and `.abbey/config.conf`.
- Preserved `.abbey/project.yml` and `.abbey/session-guidance.md` as trackable project files.
- Extended `test-abbey-init.sh` with generated-state and trackability assertions.
- Added `tests/test-abbey-portability.sh` to exercise external-project initialization, nested project discovery, knowledge, context, AI, research, documentation, and session-ending workflows.
- Made `test-abbey-next.sh` establish its required backlog state explicitly instead of inheriting mutable state from the live backlog.
- Validated a successful Bread Pitt AI decision that read Bread Pitt planning documents and wrote ignored AI history into the Bread Pitt project.

## Impact

External Abbey projects can now use core Abbey commands without requiring copies of Abbey implementation files inside each project.

The separation between toolkit code and project data provides a clearer foundation for Abbey as a reusable framework rather than a collection of commands tied to the Abbey Root repository.

macOS is now a validated development environment for these core workflows using the system-provided Bash 3.2 shell.

Initialized projects also remain clean after knowledge, context, and AI commands generate local runtime state.

## Validation

- `tests/test-abbey-init.sh`: 25 passed, 0 failed
- `tests/test-abbey-knowledge.sh`: 9 passed, 0 failed
- `tests/test-abbey-ai.sh`: 74 passed, 0 failed
- `tests/test-abbey-next.sh`: 18 passed, 0 failed
- `tests/test-abbey-portability.sh`: 29 passed, 0 failed
- `git diff --check`: passed
- Shell syntax validation with `bash -n`: passed
- Static scan found no remaining `readarray`, `mapfile`, lowercase parameter expansion, or uppercase parameter expansion under `tools/bin`.
- `abbey knowledge build` passed in Bread Pitt.
- `abbey knowledge status` reported `FRESH` in Bread Pitt.
- `abbey context brief` passed in Bread Pitt.
- Nested project discovery resolved Bread Pitt correctly.
- `abbey end` located toolkit backlog and doctor commands.
- `abbey ai decide easy-win` completed successfully in Bread Pitt.
- Generated knowledge, context, and AI history remained ignored by Git.

## Lessons Learned

- Toolkit location and active-project location are separate concepts and need separate variables.
- Repository-root portability does not guarantee host-shell portability.
- External-project regression tests should invoke the real toolkit from a separate project root instead of copying tools into the fixture.
- Generated runtime state needs an explicit lifecycle and ignore policy.
- Test fixtures should define the states they exercise rather than depending on mutable live planning documents.
- macOS testing exposes shell assumptions that can remain hidden on newer Linux Bash versions.
- Real project validation can reveal integration problems that focused command tests do not expose.

## Next Steps

- Review whether `abbey-site`, `abbey-lab`, and `abbey-ssh` correctly distinguish toolkit and project roots.
- Make `abbey status` capability-aware so external projects do not receive irrelevant Docker or website warnings.
- Review Abbey-specific wording in knowledge, context, and AI output for external-project use.
- Add broader framework adoption and migration guidance after the portability workflow has been used by additional projects.
- Commit the Bread Pitt `.gitignore` migration separately in the Bread Pitt repository.

## Notes

Bread Pitt served as the first real external-project portability target.

The successful AI decision generated history at `/Users/bradcooke/git/bread-pitt/.abbey/ai/history/2026/07/20260729-074623-easy-win-gpt-oss-20b.json`.

The generated history, knowledge snapshot, metadata, and context files remained project-local and ignored by Git.

This session intentionally focused on core Abbey portability. Capability-specific behavior and commands that may intentionally operate against Abbey Root infrastructure remain separate follow-up work.
