---
title: "BradCooke.com Automation Architecture"
description: "Defined a staged hosted automation path that keeps BradCooke.com releases explicit and guarded."
date: 2026-07-26
draft: false
tags:
  - Abbey Root
  - BradCooke.com
  - Architecture
  - Automation
---

# BradCooke.com Automation Architecture

## Summary

BradCooke.com will adopt GitHub-hosted automation in two stages: credential-free
build validation first, followed later by manually approved production
deployment. Publishing on every push to `main` was rejected.

## Accomplishments

- Documented the existing two-repository publishing contract.
- Selected hosted Actions over a persistent self-hosted runner.
- Separated pull-request build validation from public release.
- Defined least-privilege credentials, source-revision traceability, live
  verification, and rollback requirements.
- Preserved `abbey site publish` throughout staged implementation.

## Lessons Learned

- The project already had substantial local automation; the missing capability
  was hosted validation and workstation independence.
- CI can remain low-risk by receiving no production credential.
- Production automation must translate existing safeguards instead of
  discarding them for convenience.

## Next Steps

- Implement and evaluate the path-scoped hosted build workflow.
