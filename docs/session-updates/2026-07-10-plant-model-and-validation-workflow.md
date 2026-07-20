---
title: Plant Model and Validation Workflow
description: "Defined the reusable Plant Model and implemented validation for canonical plant workspaces."
date: 2026-07-10
status: pending
reviewed: true
session: primary
tags:
  - Abbey Root
  - Plant Model
  - Validation
  - Developer Toolkit
journal: 2026-07-10-plant-model-and-validation-workflow
---

# Session Update

## Summary

Defined and validated the first reusable content model for personal projects in Abbey Root.

Using Doctor Robert as the reference implementation, the session formalized how plant metadata, current inventory, detailed history, public narrative, photographs, and supporting source material should be organized. A reusable `_template` workspace now captures that structure for future plants.

The session also implemented `abbey plant validate`, introducing the first Abbey command dedicated to structured content management. The validator checks required files and directories, parses `facts.yaml`, validates core metadata, confirms slug consistency, and verifies referenced photographs.

## Objective

Create a stable Plant Model and implement the first validation command for plant workspaces.

## Definition of Done

- [x] Define the canonical plant workspace structure.
- [x] Create the Plant Model reference document.
- [x] Create a reusable plant template.
- [x] Define machine-readable plant metadata.
- [x] Implement `abbey plant validate <slug>`.
- [x] Validate Doctor Robert against the model.
- [x] Confirm incomplete templates fail validation.
- [x] Add the plant command to generated CLI documentation.

## Changes

### Plant Model

Added:

```text
docs/reference/PLANT_MODEL.md
```

The model defines:

- Required plant workspace files
- `facts.yaml` field conventions
- Separation between facts, inventory, history, and story
- Photo metadata and provenance rules
- Source preservation expectations
- Validation and future automation principles

### Plant Template

Added:

```text
working/plants/_template/
```

The template contains:

```text
README.md
facts.yaml
history.md
inventory.md
photo-metadata.md
story.md
photos/
sources/
```

### Abbey Plant Command

Added:

```text
tools/bin/abbey-plant
```

Added dispatcher support for:

```text
abbey plant
```

Implemented:

```text
abbey plant validate <slug>
```

The validator currently checks:

- Plant directory existence
- Required files
- Required directories
- YAML syntax
- Required metadata fields
- Optional metadata fields
- Slug and directory agreement
- Hero image reference
- Current image reference
- PASS, WARN, and FAIL totals
- Appropriate exit status

### CLI Metadata

Updated:

```text
config/cli/cli.yml
```

Regenerated:

```text
docs/generated/CLI_REFERENCE.md
```

## Validation

Doctor Robert passed validation with one expected warning:

```text
OK: 19  WARN: 1  FAIL: 0
PASS Plant model validation completed with warnings.
```

The warning reflects an intentionally unknown species rather than invalid data.

The reusable template failed validation because required identity fields remain blank, confirming that the validator checks content rather than only file presence.

## Lessons Learned

- The content model should be established before website integration or AI automation.
- `null` is preferable to invented precision.
- Templates should intentionally fail full validation until instantiated.
- Metadata-driven CLI documentation prevents duplicate manual maintenance.
- Validation tooling is most useful when it informs the user without changing authoritative source files.
- Doctor Robert is the reference implementation; `_template` is the reusable starting point.

## Next Steps

- Complete and validate Doctor Robert's `inventory.md`.
- Review the Plant Model against the actual template and reference implementation.
- Add Git identity validation to `abbey doctor`.
- Evaluate `abbey plant new` after manually creating another plant workspace.
- Prototype the publishing path from `working/plants/` to BradCooke.com.
- Define AI-assisted validation and publishing workflows without giving AI ownership of source observations.
