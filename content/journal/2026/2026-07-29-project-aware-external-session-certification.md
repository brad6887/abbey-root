---
title: "Project-Aware External Session Certification"
description: "Final Abbey certification now respects each project's declared policy and capabilities."
date: 2026-07-29
draft: false
tags:
  - Abbey Root
---

# Project-Aware External Session Certification

## Summary

Abbey's final session checks now distinguish framework requirements from
project-owned behavior. External projects can certify a completed session
without publishing a journal entry or inheriting Abbey Root's infrastructure
and internal-DNS checks.

## Accomplishments

- Made `abbey end` honor required, event-driven, and optional journal policies.
- Gave internal DNS its own explicit project capability.
- Verified globally inherited Git author identity.
- Ran `abbey doctor` and `abbey end` successfully from a generated Bread Pitt
  project.
- Added focused regression coverage for the complete external-project path.

## Lessons Learned

- A reusable framework should not infer operational dependencies from a broad
  project category when they can be declared directly.
- End-to-end external fixtures reveal integration assumptions that isolated
  command tests cannot.

## Next Steps

- Keep Bread Pitt as a regression example as more Abbey session certification
  checks become project-aware.
