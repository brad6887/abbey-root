---
title: "Plant Workspace Photo Consistency Validation"
description: "Added evidence-backed photo-reference and orphan detection to Plant Model validation."
date: 2026-08-10
session_update: "docs/session-updates/2026-08-10-plant-workspace-photo-consistency-validation.md"
draft: false
tags:
  - Abbey Root
---

# Plant Workspace Photo Consistency Validation

## Summary

An AI backlog-leverage decision grouped eight plant tasks into one alleged
session. The actual implementation boundary was smaller: canonical photo
references, workspace photo inventory, and their set differences all belong to
one read-only validation pass.

`abbey plant validate` now checks role paths, history photo entries, Markdown
images, and photo-metadata tables against supported files in `photos/`. Missing
references fail. Unreferenced files warn because preserved originals may be
intentional source material rather than defects.

## Accomplishments

- Added canonical reference discovery across facts and Markdown.
- Added missing-reference failures with source document and line evidence.
- Added warning-level undocumented/orphaned photo reporting.
- Ignored XMP, AppleDouble, and unsupported artifacts.
- Added focused regression fixtures and validated all eleven real workspaces.
- Found two genuine undocumented Doctor Robert photographs.

## Lessons Learned

- Shared domain language is not enough to establish one implementation scope.
- Missing references and extra files have different risk semantics.
- Real-workspace validation is essential for tuning consistency rules and
  exposing genuine findings without inventing cleanup policy.

## Next Steps

- Classify Doctor Robert's two orphaned photographs.
- Address the separate missing `sources/` directory debt for Phal McCartney and
  Something.
