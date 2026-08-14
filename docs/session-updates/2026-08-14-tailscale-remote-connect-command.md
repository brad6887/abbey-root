---
title: "Tailscale Remote Connect Command"
description: "Added an inventory-aware Abbey command that resolves a named Tailscale peer and connects to it with SSH."
date: 2026-08-14
status: complete
reviewed: false
session: tailscale-remote-connect-command
tags:
  - Abbey Root
---

# Tailscale Remote Connect Command

## Objective

Add a focused Abbey workflow for connecting to a named lab host from an
external network without manually copying its current Tailscale IP address.

## Definition of Done

- `abbey remote connect --name NAME` resolves an exact Tailscale peer name.
- The command selects the peer's current Tailscale IPv4 address.
- The SSH user comes from the authoritative Abbey Ansible inventory.
- An explicit `--user USER` override supports peers outside the inventory.
- Missing, disconnected, offline, and unknown peer states fail with useful
  messages before SSH runs.
- CLI metadata, generated command documentation, architecture guidance, and
  focused regression coverage remain synchronized.
- Canonical Abbey validation passes.

## Summary

Implemented `abbey remote connect` as a small orchestration boundary around the
existing Tailscale and SSH clients. The command reads Tailscale's structured
status output, matches the requested peer by hostname or MagicDNS name, selects
its IPv4 address, looks up the matching `ansible_user`, displays the resolved
target, and replaces itself with the normal interactive SSH client.

The workflow only reads Tailscale and inventory state. It does not enable
Tailscale, change network preferences, manage SSH keys, or persist copied IP
addresses.

## Accomplishments

- Added `abbey remote connect --name NAME [--user USER]`.
- Added exact, case-insensitive matching for Tailscale hostnames, full MagicDNS
  names, and their short names.
- Added explicit handling for unavailable Tailscale clients, disconnected
  backends, unknown or ambiguous names, offline peers, and peers without IPv4.
- Reused `ansible/inventory/hosts.yml` as the SSH-user source of truth.
- Added command routing and metadata-driven help/reference content.
- Updated the remote-access architecture's standard operator workflow.
- Added focused command regression tests with isolated Tailscale and SSH test
  doubles.

## Impact

Remote access now has a short, repeatable entry point:

```bash
abbey remote connect --name ubuntu-dev01
```

The operator no longer needs to open the Tailscale peer list, copy an address,
remember the SSH user, and assemble the target manually. Tailscale remains the
authoritative source for current overlay addresses, and Ansible inventory
remains authoritative for managed host users.

## Validation

- `tests/test-abbey-remote.sh` — 10 passed, 0 failed.
- Shell syntax validation passed for the dispatcher, wrapper, and focused test.
- Python compilation passed for `scripts/abbey_remote.py`.
- `git diff --check` passed.
- `abbey docs generate` completed successfully.
- `abbey validate` passed all repository consistency checks.
- The installed Tailscale 1.102.2 client returned the expected structured
  status shape, and the real `ubuntu-dev01` peer resolved as online with both
  IPv4 and IPv6 addresses; SSH was intentionally not started during validation.

## Lessons Learned

Resolving the Tailscale peer before reading its inventory user produces clearer
failures: an unknown peer is a network-name problem, while a known peer without
an inventory user is a configuration decision. Keeping those layers ordered
also prevents SSH from running against partially resolved state.

Using Tailscale's JSON output avoids scraping human-oriented status text, and
executing the normal SSH client preserves the operator's existing key,
known-host, and interactive terminal behavior.

## Next Steps

- Validate the command from a normal external-network operator session against
  the real `ubuntu-dev01` peer.
- Consider a default remote-operations host only if repeated use shows that
  requiring `--name` adds friction without useful safety.

## Notes

No remote infrastructure or Tailscale preferences were changed during this
session. The real local Tailscale status response was inspected read-only, and
the connection behavior was exercised with deterministic regression fixtures.
Live SSH from an external network remains an operator validation boundary.
