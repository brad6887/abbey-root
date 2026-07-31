---
title: "Lab-Wide DNS Client Rollout"
description: "Rolled Abbey's internal Technitium DNS service out to every managed Linux host."
date: 2026-07-31
draft: false
tags:
  - Abbey Root
  - Infrastructure
  - DNS
  - Ansible
---

# Lab-Wide DNS Client Rollout

## Summary

Abbey's internal DNS service is no longer limited to one validation client.

All five managed Linux hosts now use the Technitium service on `edge01` for
the canonical `home.arpa` namespace.

## Accomplishments

- Added a reusable Ansible DNS client role.
- Supported both NetworkManager and netplan hosts.
- Blocked competing DNS and search-domain data from IPv6 router
  advertisements without disabling IPv6.
- Configured `home.arpa` as the lab search domain.
- Removed dependence on the AT&T gateway for Abbey hostnames.
- Completed forward and reverse records for every managed host.
- Validated short names, fully qualified names, and external DNS from the full
  managed inventory.
- Confirmed repeated DNS-only Ansible runs are idempotent.

## Lessons Learned

A normal external resolver is not a useful fallback for an internal
authoritative zone. DNS resilience will eventually require a second server
that also knows about `home.arpa`.

Tailscale may still win for some single-label hostnames, so the fully qualified
`host.home.arpa` form is the canonical choice when the LAN identity matters.

## Next Steps

- Rotate the Wi-Fi credential exposed during troubleshooting.
- Add friendly internal service records after the naming strategy is finalized.
- Evaluate a second authoritative resolver only when actual redundancy is
  needed.
