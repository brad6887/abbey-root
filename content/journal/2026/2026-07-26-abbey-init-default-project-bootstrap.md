---
title: "Abbey Init Default Project Bootstrap"
description: "Created the first safe default Abbey project bootstrap and validated it with Bread Pitt."
date: 2026-07-26
draft: false
tags:
  - Abbey Root
---

# Abbey Init Default Project Bootstrap

## Summary

Abbey can now create a new independent project with `abbey init PATH`. The
bootstrap produces a small, recognizable Abbey repository while leaving the
shared toolkit in Abbey Root instead of copying framework implementation into
every project.

## Accomplishments

- Added safe destination checks, read-only dry runs, optional Git
  initialization, generated-file reporting, and post-generation validation.
- Introduced project metadata in `.abbey/project.yml`.
- Separated the installed toolkit root from the active project root.
- Made version, doctor, status, session, and session context project-aware.
- Validated the complete flow with a temporary Bread Pitt repository and
  focused regression tests.

## Lessons Learned

- A reusable framework needs an explicit distinction between where its tools
  are installed and which repository they are operating on.
- A minimal bootstrap is more useful than a large speculative template:
  project-specific structure belongs in the project's first real session.
- Running the workflow on macOS exposed a GNU-specific date assumption and an
  untracked-file health-check gap that focused acceptance testing could fix.

## Next Steps

- Review and commit the completed bootstrap session.
- Use Bread Pitt's first project session to define its domain model without
  expanding the universal initializer.
