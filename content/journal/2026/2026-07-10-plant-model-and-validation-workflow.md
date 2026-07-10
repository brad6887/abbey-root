---
title: "Plant model and validation workflow"
description: "Defined the reusable plant content model and added Abbey validation for plant workspaces."
date: 2026-07-10
draft: false
tags:
  - Abbey Root
  - BradCooke.com
  - Orchid Rescue
  - Content Model
  - Automation
---

# Plant model and validation workflow

## Summary

Established a reusable content model for documenting plants in Abbey Root and implemented the first supporting Abbey command.

Doctor Robert served as the reference implementation for defining how plant facts, history, narrative, inventory, photographs, and source material should be organized. The resulting Plant Model separates machine-readable metadata from human-readable documentation while preserving original source material and photo provenance.

The session also introduced `abbey plant validate`, which checks a plant workspace against the model and reports missing files, invalid YAML, incomplete metadata, broken photo references, and directory mismatches.

## Accomplishments

- Created `docs/reference/PLANT_MODEL.md` as the canonical Plant Model specification.
- Defined `facts.yaml` as the machine-readable source of truth for plant metadata.
- Finalized the standard plant workspace structure under `working/plants/<slug>/`.
- Created a reusable plant template under `working/plants/_template/`.
- Added templates for:
  - `facts.yaml`
  - `history.md`
  - `story.md`
  - `inventory.md`
  - `photo-metadata.md`
  - `README.md`
- Documented the photo metadata philosophy and provenance rules.
- Added the `abbey plant` command family.
- Implemented `abbey plant validate <slug>`.
- Validated Doctor Robert successfully against the Plant Model.
- Confirmed that the incomplete template fails validation as expected.
- Added the `plant` command and its `validate` subcommand to CLI metadata.
- Regenerated the Abbey CLI reference from `config/cli/cli.yml`.

## Lessons Learned

- Modeling information before building automation produces simpler and more reliable tooling.
- A reference implementation and a reusable template serve different purposes and should remain separate.
- Machine-readable facts, current inventory, detailed history, and public narrative each need distinct authoritative files.
- Validation should report inconsistencies without silently modifying source material.
- Human observations should remain human-owned while automation manages structure, consistency, and state.
- Metadata and source provenance are essential parts of long-term project documentation.

## Next Steps

- Complete the current inventory for Doctor Robert.
- Review Doctor Robert against every section of the Plant Model.
- Add Git identity checks to `abbey doctor`.
- Consider adding `abbey plant new` after the manual template workflow has been validated.
- Prototype how BradCooke.com will consume plant workspaces.
- Define AI Worker's role in summarizing, validating, and assembling plant content.
