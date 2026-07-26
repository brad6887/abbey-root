---
title: "Bounded Documentation Generation"
description: "Added bounded deterministic generation and freshness checks for proven CLI documentation outputs."
date: 2026-07-26
status: complete
reviewed: false
session: bounded-documentation-generation
tags:
  - Abbey Root
  - Abbey Framework
  - Developer Toolkit
  - Documentation
  - Automation
---

# Bounded Documentation Generation

## Objective

Implement one bounded, deterministic documentation workflow for existing
proven generators without claiming that all generated project documentation is
ready for unified automation.

## Definition of Done

- Inventory tracked generated documentation and its current generators.
- Identify authoritative inputs and outputs that can be generated
  deterministically in this session.
- Add `abbey docs generate` and a read-only `abbey docs check`.
- Prove generation is idempotent and stale or missing outputs are detected.
- Preserve the existing Ansible documentation workflow for outputs that remain
  environment-dependent.
- Synchronize CLI metadata, generated references, guidance, planning, and
  session records.

## Summary

Added a bounded `abbey docs` command that manages the CLI reference generated
from `config/cli/cli.yml` and the legacy command reference generated from
executable `tools/abbey-*` headers.

`abbey docs generate` refreshes both tracked outputs. `abbey docs check`
renders both into a temporary directory, compares them with the tracked files,
and reports stale or missing output without modifying the repository.

The inventory also confirmed that eight infrastructure documents depend on the
Ansible inventory, host variables, and execution environment. Those remain
under the existing full `abbey-docs` workflow rather than being presented as
deterministic prematurely.

## Accomplishments

- Registered the `docs` command group in the dispatcher and CLI metadata.
- Added output-path overrides to the existing generators so freshness checks
  can render safely outside the working tree.
- Removed the volatile timestamp from `abbey-commands.md`.
- Made the legacy full `abbey-docs` workflow delegate deterministic CLI
  generation to the new command before running Ansible.
- Added focused regression coverage for help, generation, authoritative-source
  rendering, freshness, idempotency, stale output, missing output, read-only
  checks, and invalid commands.
- Documented the bounded source-to-output map and explicit Ansible exclusion.

## Impact

Two frequently maintained generated references now have one discoverable,
repeatable workflow and a non-mutating freshness gate. The narrower scope avoids
concealing environment-dependent Ansible behavior behind a misleading global
success result.

## Validation

- `tests/test-abbey-docs.sh`: 23 assertions passed.
- Shell syntax checks for the dispatcher, generators, orchestration command,
  legacy wrapper, and regression suite.
- `abbey docs generate`.
- `abbey docs check`.
- CLI metadata parsing and generated CLI reference.
- Existing focused documentation and workflow regression suites.
- Backlog generated-statistics freshness check.
- `git diff --check`.
- `abbey review`.
- Post-commit `abbey end` verified the clean commit, session update, journal,
  backlog freshness, and remote state, but remained incomplete because Abbey
  Doctor could not reach the four Linux lab hosts from the sandboxed Mac
  environment. The unrelated host-reachability failures were `ai-worker01`,
  `edge01`, `rocky-ansible01`, and `ubuntu-dev01`.

## Lessons Learned

The existing generated-document directory does not imply one uniform generation
contract. CLI metadata and command headers are repository-local and
deterministic; infrastructure documents currently depend on Ansible execution
context. Treating those groups separately makes the first orchestration layer
honest and testable.

## Next Steps

- Isolate Ansible-derived document rendering and add deterministic freshness
  checks before expanding `abbey docs` to manage those outputs.

## Notes

This session intentionally does not mark the broader backlog goal to eliminate
all manually maintained generated documentation as complete.
