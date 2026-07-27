---
title: "Abbey Status Project Metrics"
description: "Abbey status now reports four deterministic measures of repository growth."
date: 2026-07-26
draft: false
tags:
  - Abbey Root
  - Developer Toolkit
  - Project Metrics
---

# Abbey Status Project Metrics

## Summary

`abbey status` now reports four locally derived project metrics: toolkit
commands, website pages, journal entries, and documentation files. The counts
come directly from repository artifacts and require no network service.

## Accomplishments

- Added a Project Metrics section to the existing modular status workflow.
- Defined a concrete source and file rule for every count.
- Made absent sources report `Unavailable` without interrupting other checks.
- Added focused regression coverage and synchronized generated CLI
  documentation.

## Lessons Learned

- Small metrics become trustworthy only when their counting rules are explicit.
- The existing numbered status checks were already the right extension point;
  a new metrics framework would have been premature.

## Next Steps

- Evaluate the initial metrics through normal use before expanding the set.
