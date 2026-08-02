---
title: "Reviewable Multi-Plant Update Workflow"
description: "Added a worksheet-driven way to turn one day of renamed photos into several reviewed plant updates."
date: 2026-08-02
draft: false
tags:
  - Abbey Root
---

# Reviewable Multi-Plant Update Workflow

## Summary

The photo intake workflow now continues beyond renaming. Abbey can group a
day's exported photos by plant, create a worksheet for human observations, and
apply the completed updates across all affected plant workspaces.

## Accomplishments

- Added `abbey plant update-batch prepare` and `apply`.
- Made missing photos a warning and skip rather than an empty plant update.
- Required an explicit current image for multi-photo observations.
- Automatically populated each history entry's complete photo list.
- Kept XMP sidecars in incoming and preserved the existing publishing boundary.
- Added full-batch validation, rollback protection, and focused regression
  coverage.

## Lessons Learned

- Filenames can reliably provide structure, while narratives and current-image
  choices still benefit from a deliberate human review step.
- A missing observation is normal operational state, not an error requiring a
  placeholder record.

## Next Steps

- Run the workflow against the real August 2 plant export and refine it from
  normal use before extending it toward automatic publishing.
