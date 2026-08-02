---
title: "Plant Workspace Onboarding Command"
description: "Rocky Raccoon turned a manual plant-template process into a tested Abbey command."
date: 2026-08-02
draft: false
tags:
  - Abbey Root
  - Plant Toolkit
  - Automation
---

# Plant Workspace Onboarding Command

## Summary

Rocky Raccoon gave me the real example I needed to finish the plant onboarding
workflow. Instead of manually copying the reusable template and hoping every
field and directory was handled correctly, I can now create a canonical plant
workspace with one Abbey command and get an immediate validation result.

## Accomplishments

- Added `abbey plant new` with required plant identity and optional status, date, and initial photos.
- Made creation atomic and non-overwriting so a failed onboarding cannot leave a partial workspace.
- Kept unknown botanical, care, source, and location facts explicit instead of guessing.
- Added focused regression coverage for the successful workflow and its safety boundaries.
- Created and validated Rocky Raccoon's workspace through the finished command.

## Lessons Learned

- A template can remain the source of structure without copying its instructional files into every real workspace.
- The first real use case is where a command contract becomes concrete: identity and structure belong in onboarding, while richer photo metadata and publication remain later workflows.
- Validation warnings are useful at onboarding time. Rocky Raccoon is structurally valid, while the missing transferred photograph remains visible work rather than hidden debt.

## Next Steps

- Add Rocky Raccoon's real photographs and verified plant-specific story, history, inventory, and photo metadata before publication.
