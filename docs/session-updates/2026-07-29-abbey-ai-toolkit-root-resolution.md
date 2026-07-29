---
title: "Abbey AI Toolkit Root Resolution"
description: "Corrected Abbey AI library resolution for commands run from external Abbey projects."
date: 2026-07-29
status: complete
reviewed: false
session: abbey-ai-toolkit-root-resolution
tags:
  - Abbey Root
  - Developer Toolkit
  - Regression Fix
---

# Abbey AI Toolkit Root Resolution

## Objective

Allow `abbey ai decide` to run from an external Abbey project while preserving
the distinction between the shared Abbey toolkit and the active project.

## Definition of Done

- `abbey-ai` resolves its implementation libraries from the toolkit root.
- AI configuration, decision metadata, and knowledge remain project-aware.
- The command works from Abbey Root and through the dispatcher from an external
  Abbey project.
- Regression coverage reproduces the external-project path-resolution case.

## Summary

Separated the toolkit path used to load `tools/lib/config.sh` from the active
project path used by Abbey AI. The command now follows the portable
`ABBEY_TOOLKIT_ROOT` pattern already used by commands such as `abbey-doctor`,
`abbey-status`, and `abbey-version`.

## Accomplishments

- Derived a fallback toolkit root from the resolved `abbey-ai` script path.
- Loaded the shared configuration library from `ABBEY_TOOLKIT_ROOT`.
- Preserved `ABBEY_ROOT` as the active project for configuration, decision
  discovery, and knowledge paths.
- Added an integration-style regression that invokes `abbey ai decide --help`
  through the main dispatcher from an external Abbey project fixture.

## Impact

External Abbey projects no longer need to contain a duplicate
`tools/lib/config.sh` for `abbey ai decide` to start. The correction reinforces
the framework boundary between shared toolkit implementation and project-owned
content.

## Validation

- `abbey ai decide --help` from the Abbey Root checkout.
- External-project dispatcher regression passed and loaded project-owned
  decision metadata.
- Existing `tests/test-abbey-ai.sh` assertions through the decision-command
  coverage passed; later knowledge-context assertions remain unavailable on the
  macOS system Bash because the existing script requires Bash 4 lowercase
  expansion and GNU `sed -i`.
- Shell syntax checks for the changed command and regression suite.
- `git diff --check`.

## Lessons Learned

Portable Abbey commands must treat the toolkit root and active project root as
separate concepts. Any shared library load tied to `ABBEY_ROOT` can accidentally
require framework implementation files inside an external project.

## Next Steps

- Re-run the complete AI regression suite on the Linux development host.

## Notes

The named `bread-pitt` repository could not be cloned in this environment
because it is private and neither local Git nor the connected GitHub account
had access. The external-project fixture exercises the same `.abbey/project.yml`
discovery and dispatcher behavior that produced the reported failure.
