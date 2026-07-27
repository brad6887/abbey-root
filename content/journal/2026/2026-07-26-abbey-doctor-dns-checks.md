---
title: "Abbey Doctor DNS Checks"
description: "Abbey Doctor can now identify external and internal DNS resolution failures separately from host reachability."
date: 2026-07-26
draft: false
tags:
  - Abbey Root
  - Developer Toolkit
  - DNS
  - Risk Reduction
---

# Abbey Doctor DNS Checks

## Summary

Abbey Doctor now verifies external DNS resolution everywhere and validates the
internal `edge01.home.arpa` record on `ubuntu-dev01`, the lab's controlled
Technitium DNS client.

## Accomplishments

- Added portable IPv4 resolution using Python's standard socket library.
- Compared the internal result with the repository-managed `edge01` address.
- Kept the internal check scoped to the documented rollout boundary.
- Added focused success, failure, mismatch, and scope regression coverage.

## Lessons Learned

- DNS resolution and IP reachability answer different operational questions
  and should remain separate Doctor checks.
- Rollout-aware checks avoid false failures while infrastructure adoption is
  intentionally incomplete.

## Next Steps

- Validate the check through normal Abbey Doctor use on `ubuntu-dev01`.
