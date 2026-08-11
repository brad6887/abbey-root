---
title: "Inventory-Driven Network Interface Validation"
description: "Moved network-interface risk detection to the inventory-aware lab health boundary."
date: 2026-08-10
draft: false
tags:
  - Abbey Root
---

# Inventory-Driven Network Interface Validation

## Summary

The risk-reducer recommendation proposed adding interface detection to Abbey
Doctor. Reviewing the implementations changed the destination: Doctor is a
portable local-project check, while `abbey lab check` already owns managed-host
inventory and gathers interface facts across the fleet.

The resulting check is deliberately opt-in. Each authoritative expectation
uses a role and stable MAC address. The known `sites01` MAC is the first
declaration; hosts without verified hardware identity report SKIP rather than
creating false confidence or false alarms.

## Accomplishments

- Added reusable expected-interface validation to the lab health playbook.
- Reported present, missing/replaced, observed, and undeclared states.
- Preserved failure-tolerant reporting across every reachable host.
- Added the documented `sites01` primary-interface identity to inventory.
- Added and passed a five-case synthetic Ansible regression suite.

## Lessons Learned

- Operational ownership matters more than backlog placement: fleet hardware
  checks belong where fleet inventory and remote facts already meet.
- MAC addresses are suitable replacement signals; interface names are often
  deployment details that can change independently of hardware.
- Opt-in validation makes incomplete inventory visible instead of silently
  treating absence of configuration as success.

## Next Steps

- Certify the `sites01` expectation through a live control-node lab check.
- Add other hosts only after verifying their stable interface identities.
