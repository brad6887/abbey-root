---
title: "Project-Aware Site Publishing"
description: "Made shared Abbey site publishing explicit, project-aware, and safe by default."
date: 2026-08-04
draft: false
tags:
  - Abbey Root
---

# Project-Aware Site Publishing

## Summary

The Abbey site command previously carried Abbey Root's source path,
BradCooke.com domain, and production checkout as built-in defaults. That made a
shared command unsafe in an external Abbey project. The workflow now reads its
site definition from the active project's metadata and refuses to publish when
that project has not deliberately configured deployment.

## Accomplishments

- Defined project-owned source, build method, output, publish target, domain,
  and deployment method settings.
- Supported both generated npm sites and direct static artifacts such as Bread
  Pitt's checked-in `site/` directory.
- Added regression coverage proving Bread Pitt cannot reach the BradCooke.com
  publishing path without its own explicit configuration.
- Made the resolved project and deployment details visible before work begins.

## Lessons Learned

- Shared automation should not carry a privileged project's deployment defaults.
- Failing closed is clearest when missing configuration is rejected before
  checking tools, repositories, or targets.

## Next Steps

- Configure Bread Pitt's static build metadata when the project adopts the
  shared command, while keeping publication disabled until intentionally set.
