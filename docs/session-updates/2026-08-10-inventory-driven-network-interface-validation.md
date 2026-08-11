---
title: "Inventory-Driven Network Interface Validation"
description: "Added opt-in, inventory-driven missing or replaced network-interface detection to the read-only Abbey lab health check."
date: 2026-08-10
status: complete
reviewed: true
session: inventory-driven-network-interface-validation
tags:
  - Abbey Root
---

# Inventory-Driven Network Interface Validation

## Objective

Add missing or replaced network-interface detection at the managed-lab boundary
using explicit per-host inventory and gathered Ansible facts, without adding
host-specific behavior to portable `abbey doctor` checks.

## Definition of Done

- Expected interfaces are declared explicitly per managed host using stable MAC
  identities and descriptive roles.
- `abbey lab check` reports present and missing-or-replaced expectations.
- Mismatches include observed interface identities for diagnosis.
- Undeclared hosts are skipped without false-positive warnings.
- A mismatch does not stop health reporting for other managed hosts.
- The known `sites01` primary-interface identity is inventory-managed.
- Synthetic regression coverage and Ansible syntax validation pass.

## Summary

Extended the first, fact-gathering play in `abbey lab check` with a reusable
network-interface validation task set. Expectations are opt-in host variables
and match normalized MAC addresses rather than unstable operating-system
interface names. `sites01` is the first declared host because its MAC address
is already documented as authoritative.

## Accomplishments

- Added expected-interface collection and comparison against Ansible facts.
- Added clear OK, WARN, observed-interface, and SKIP reporting.
- Declared the documented `sites01` primary network MAC in host inventory.
- Added synthetic Ansible fixtures for present, missing/replaced, and undeclared
  states while proving all hosts continue through validation.
- Documented the inventory contract and updated durable project status.
- Reframed and completed the backlog item under the correct `abbey lab check`
  execution boundary.

## Impact

Routine fleet health checks can now identify when declared network hardware has
disappeared or been replaced while continuing to report the rest of the lab.
The opt-in contract makes coverage explicit and avoids pretending that hosts
without authoritative hardware identities have been validated.

## Validation

- Ansible syntax check passed for `ansible/playbooks/lab-check.yml`.
- `tests/test-abbey-lab.sh`: 5 passed, 0 failed with temporary Ansible Core.
- YAML parsing passed for the playbook, task set, and `sites01` host variables.
- Shell syntax passed for the lab command and regression suite.
- A normal live `abbey lab check` from the Ansible control node gathered all
  six managed hosts, skipped the five without declared expectations, and
  certified the `sites01` primary interface on `ens18` with the expected
  `bc:24:11:02:02:84` MAC address.
- The live check remained read-only and did not change managed hosts.

## Lessons Learned

The correct boundary is `abbey lab check`, not `abbey doctor`: the former owns
managed-host inventory and already gathers remote interface facts, while the
latter intentionally runs across local macOS, Linux, and external-project
contexts.

Interface names are not durable hardware identity. MAC-based declarations can
detect both absence and replacement, but they must only be added when the
repository has an authoritative value. A completely disconnected management
interface will first appear as an unreachable host; no remote fact collector
can diagnose hardware that it cannot reach.

## Next Steps

- Add interface expectations for additional managed hosts only after their
  stable MAC identities and intended roles are verified.

## Notes

Local validation used an isolated Ansible Core installation under `/tmp`
because the macOS workstation does not have Ansible installed. No system Python
packages were modified. The later control-node run certified `sites01` without
changing remote inventory state or managed hosts. No commit was created during
implementation.
