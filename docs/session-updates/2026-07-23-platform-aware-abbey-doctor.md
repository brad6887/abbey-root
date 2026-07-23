---
title: "Platform-Aware Abbey Doctor"
description: "Made Abbey Doctor system and reachability checks portable across macOS and Linux."
date: 2026-07-23
status: completed
reviewed: false
session: primary
tags:
  - Abbey Root
  - Developer Toolkit
  - macOS
---

# Platform-Aware Abbey Doctor

## Objective

Make `abbey doctor` select platform-appropriate system and host
reachability checks so that macOS reports reflect actual host health.

## Definition of Done

- Linux behavior remains supported.
- macOS avoids Linux-only `ping`, `/proc`, and `timedatectl` assumptions.
- All inventory hosts are reported reachable from the Mac.
- Platform-selection behavior has regression coverage.

## Summary

Introduced a shared Doctor platform layer and routed host reachability,
load-average, timezone, and network-time checks through it. The Mac now
reports all four managed hosts as reachable and completes without false
platform failures.

## Accomplishments

- Added reusable platform detection and platform-specific helper functions.
- Preserved the existing Linux IPv4 ping and timeout behavior.
- Added a macOS-compatible ping invocation with two attempts to tolerate cold
  ARP neighbor discovery.
- Added macOS load-average and timezone discovery.
- Reported the macOS network time service without requiring administrator
  access to `systemsetup`.
- Added focused regression tests for macOS, Linux, and conservative fallback
  behavior.

## Impact

`abbey doctor` can now serve as a reliable development-environment check on
the primary Mac workstation as well as the Linux lab hosts. Platform-specific
details are centralized instead of being scattered through individual checks.

## Validation

- `bash -n` passed for the Doctor entry point, platform library, modified
  checks, and regression test.
- `tests/test-abbey-doctor-platform.sh` passed 6 checks with 0 failures.
- `git diff --check` passed.
- A real `abbey doctor` run on macOS reported 19 OK checks, 3 expected
  host-role warnings, and 0 failures.
- All four inventory hosts were reported reachable.

## Lessons Learned

The original failures came from unsupported Linux `ping -4` syntax, not from
the network or inventory. A single macOS ICMP attempt also produced transient
false negatives until ARP discovery completed, so the Mac path uses two
attempts.

## Next Steps

- Validate the unchanged Linux path during the next session on a managed Linux
  host.
- Consider whether expected host-role skips should remain warnings or become
  informational results in a future focused session.

## Notes

The working tree remains intentionally uncommitted for user review.
