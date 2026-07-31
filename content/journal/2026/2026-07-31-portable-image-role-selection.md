---
title: "Portable Image Role Selection"
description: "Added a reusable Abbey command for assigning project photographs to configured content roles."
date: 2026-07-31
draft: false
tags:
  - Abbey Root
  - Abbey Framework
  - Developer Toolkit
---

# Portable Image Role Selection

## Summary

Abbey can now select a photograph for a project-defined content role without
hard-coding a particular website, content model, or directory layout.

The first adopter is:

    abbey plant hero <slug>

It lists the eligible photographs in a plant workspace, identifies the current
hero, accepts a numbered selection, and updates the canonical `photos.hero`
value in `facts.yaml`.

## Accomplishments

- Added the generic `abbey image select` workflow.
- Added project-owned image-role configuration.
- Added `abbey plant hero` as a thin Plant Model wrapper.
- Preserved generated Astro content as output rather than a competing source of
  truth.
- Excluded XMP sidecars and unsupported files from selection.
- Added interactive cancellation and safe non-interactive operation.
- Proved the command works from an external Abbey project.
- Added 46 focused regression assertions.

- Fixed an `abbey end` crash exposed when completing the session on a branch
  without a configured upstream.

## Lessons Learned

The smallest useful version does not need thumbnails or contact sheets.
Filename selection is enough to validate the reusable architecture, safe YAML
update, and cross-project behavior before adding another dependency.

The final session check also exposed a small lifecycle bug: remote-status
counters must be initialized even when a branch has no upstream. The existing
Abbey End regression suite now confirms that path completes normally.

## Next Steps

- Use the command during normal plant-page maintenance.
- Revisit contact sheets only if filename selection proves meaningfully
  limiting.
