---
title: "Abbey Doctor DNS Checks"
description: "Added portable external and controlled internal DNS validation to Abbey Doctor."
date: 2026-07-26
status: complete
reviewed: false
session: abbey-doctor-dns-checks
tags:
  - Abbey Root
  - Developer Toolkit
  - DNS
  - Risk Reduction
---

# Abbey Doctor DNS Checks

## Objective

Add deterministic DNS-resolution checks to Abbey Doctor without duplicating
its existing host-reachability checks.

## Definition of Done

- Abbey Doctor verifies external DNS resolution on every host.
- The controlled `ubuntu-dev01` validation client verifies
  `edge01.home.arpa`.
- The internal result must include the expected address from the authoritative
  `edge01` host variables.
- Hosts outside the controlled internal-DNS rollout report that the check is
  not required without degrading Doctor health.
- Successful, failed, mismatched, and out-of-scope behavior has focused
  regression coverage.
- Existing platform and Git Doctor regression suites continue to pass.

## Summary

Added a new modular DNS check to Abbey Doctor. It uses Python's standard socket
resolver for portable IPv4 lookup, verifies external forwarding through
`github.com`, and validates the internal `edge01.home.arpa` record on
`ubuntu-dev01`.

The expected internal address is read from
`ansible/inventory/host_vars/edge01.yml`, preserving repository-owned
infrastructure metadata as the source of truth.

## Accomplishments

- Added a portable `doctor_resolve_ipv4` platform helper.
- Added external DNS verification for every Doctor host.
- Scoped authoritative internal DNS verification to the documented validation
  client.
- Detected missing resolution and incorrect internal addresses separately.
- Added six focused DNS regression checks.
- Preserved all existing platform and Git Doctor regression behavior.

## Impact

Abbey Doctor can now distinguish DNS failures from its existing IP-based host
reachability failures. The bounded rollout avoids declaring internal DNS
unhealthy on hosts that have not yet adopted the Technitium resolver.

## Validation

- `tests/test-abbey-doctor-dns.sh` — 6 passed.
- `tests/test-abbey-doctor-platform.sh` — 6 passed.
- `tests/test-abbey-doctor-git.sh` — 6 passed.
- Shell syntax checks for the changed and added shell files.
- `abbey docs check`.
- `abbey backlog check`.
- `git diff --check`.

## Lessons Learned

The existing reachability check deliberately uses inventory IP addresses
because DNS is not universally deployed. DNS health therefore belongs in a
separate check with rollout-aware scope rather than replacing or wrapping
reachability.

Python's standard resolver avoids platform-specific assumptions about `dig`,
`host`, or `nslookup`.

## Next Steps

- Validate the new internal and external checks on `ubuntu-dev01`.
- Continue broader network-health work only as separately defined backlog
  sessions.

## Notes

The broader `Add network health checks to abbey-doctor` backlog item remains
pending; this session completes only the explicit DNS check.
