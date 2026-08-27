---
title: "Harden Multi-Plant Update Workflow"
description: "Turned real multi-plant update friction into safer worksheets, reusable slug discovery, and idempotent recovery."
date: 2026-08-27
session_update: "docs/session-updates/2026-08-27-harden-multi-plant-update-workflow.md"
draft: false
tags:
  - Abbey Root
  - plants
  - workflow
---

# Harden Multi-Plant Update Workflow

## Summary

The August 23 orchid update completed successfully, but it exposed avoidable
friction in the batch worksheet. Its compact YAML was easy to misindent while
adding prose, manually recreating the plant list was unnecessary, and a second
application attempt produced failure messages even though the canonical update
was already complete.

Abbey now treats those cases as workflow concerns rather than operator memory
tests.

## Accomplishments

- Generated worksheets use visibly nested photo lists and folded narrative
  placeholders that accept ordinary apostrophes and quotation marks.
- `abbey plant update-batch validate` checks completed worksheet structure
  without changing canonical workspaces.
- `abbey plant update-batch slugs` prints the reviewed plant list for reuse by
  validation and publication loops.
- Apply recognizes a complete existing update, leaves it unchanged, and
  distinguishes it from a partial or inconsistent state.
- The real August 23 worksheet passed the new validation and recovery paths for
  all eleven orchids.

## Lessons Learned

A reviewable workflow needs to support recovery as deliberately as its happy
path. Once the worksheet becomes the approved batch boundary, later commands
should consume it directly and repeated execution should explain existing
state rather than require reconstruction.

## Next Steps

- Exercise the revised procedure during the next plant observation batch.
- Keep future changes grounded in actual publishing runs.
