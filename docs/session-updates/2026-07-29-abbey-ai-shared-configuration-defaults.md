---
title: "Abbey AI Shared Configuration Defaults"
description: "Made shared Abbey AI configuration defaults available to external Abbey projects."
date: 2026-07-29
status: complete
reviewed: false
session: abbey-ai-shared-configuration-defaults
tags:
  - Abbey Root
  - Developer Toolkit
  - Regression Fix
---

# Abbey AI Shared Configuration Defaults

## Objective

Allow shared AI decisions to run from an external Abbey project without
requiring that project to duplicate Abbey Root's AI service configuration.

## Definition of Done

- Toolkit tracked and local configuration load before active-project
  configuration.
- Active projects retain tracked and local override behavior.
- External projects inherit `OLLAMA_URL` and `ABBEY_AI_DECISION_MODEL`.
- Regression coverage proves the configuration precedence.

## Summary

Layered shared toolkit defaults and ignored-local overrides into
`load_abbey_config` before the active project's tracked configuration and local
overrides.

## Accomplishments

- Added toolkit-aware tracked and local configuration loading.
- Preserved project-specific tracked and ignored-local overrides.
- Added regression assertions for inherited Ollama settings and project
  override precedence.

## Impact

External Abbey projects can execute the shared `abbey ai decide` workflows
without maintaining duplicate AI endpoint or model settings.

## Validation

- AI configuration regression assertions pass.
- External-project decision discovery regression assertions pass.
- Shell syntax checks for the configuration loader and AI test suite.
- `git diff --check`.

## Lessons Learned

Shared commands need both shared implementation and shared defaults. Keeping
only the implementation portable can defer failures until command execution.

## Next Steps

- Re-run `abbey ai decide easy-win` from Bread Pitt on `ubuntu-dev01` after
  merging and pulling the fix.

## Notes

The issue was reproduced from the real Bread Pitt and Abbey Root checkouts:
Bread Pitt has no local AI config, while the shared decision requires the
toolkit-owned Ollama endpoint and model defaults.
