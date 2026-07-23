---
title: "Making Abbey Doctor Platform-Aware"
description: "Abbey Doctor now distinguishes macOS and Linux system behavior while preserving one shared health-check workflow."
date: 2026-07-23
draft: false
tags:
  - Abbey Root
  - Developer Toolkit
  - macOS
  - Linux
---

# Making Abbey Doctor Platform-Aware

## Summary

Abbey Doctor had been reporting every managed host as unreachable from the
primary Mac workstation even though direct pings succeeded. The inventory and
network were healthy. The failure came from the check itself: it passed Linux
options to the macOS `ping` command and treated the resulting usage error as a
network failure.

The same Linux assumption appeared in the system checks. Abbey read
`/proc/loadavg` and called `timedatectl`, neither of which represents the
macOS environment.

This session introduced a shared platform layer so Abbey can preserve one
Doctor workflow while selecting the correct operating-system primitives.

## Accomplishments

- Added explicit macOS, Linux, and conservative fallback behavior for host
  reachability.
- Preserved the existing Linux IPv4 timeout behavior.
- Added two macOS ping attempts so cold ARP discovery does not create
  intermittent false failures.
- Added platform-aware load-average and timezone discovery.
- Added a macOS network-time service check that does not require administrator
  access.
- Added regression coverage for platform selection and command construction.
- Validated all four managed hosts from the Mac.

The completed Mac health check reported:

- 19 successful checks.
- 3 expected host-role warnings.
- 0 failures.

## Lessons Learned

- A failed command is not necessarily a failed resource. Suppressing command
  errors made an unsupported option look exactly like an unreachable host.
- Platform differences belong behind a small shared interface instead of
  being repeated throughout individual checks.
- A single ICMP attempt is too fragile for a deterministic health check when
  neighbor discovery may still be warming.
- Real environment validation remains necessary even when mocked regression
  tests pass; the first live run exposed the cold-cache behavior.

## Next Steps

- Validate the preserved Linux path during the next session on a managed Linux
  host.
- Consider whether expected checks skipped because of host role should be
  informational rather than warnings.
