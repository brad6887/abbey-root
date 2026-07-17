---
title: "Edge01 Technitium DNS Deployment"
description: "Deployed Technitium DNS on edge01 and established Abbey's first internal authoritative DNS service."
date: 2026-07-15
status: pending
reviewed: true
session: primary
tags:
  - Abbey Root
  - Infrastructure
  - Networking
  - DNS
  - Raspberry Pi
---

# Edge01 Technitium DNS Deployment

## Objective

Deploy Technitium DNS on `edge01` and establish the first internal DNS service for the Abbey lab.

## Definition of Done

- Install Technitium DNS.
- Verify external DNS resolution.
- Create an internal authoritative zone.
- Add initial host records.
- Verify forward and reverse lookups.
- Configure one Abbey host to use the new DNS server.
- Document the deployment.

## Summary

Technitium DNS was successfully deployed on `edge01` and configured as the authoritative DNS server for the `home.arpa` zone.

Initial host records were created for the core Abbey infrastructure, including `edge01`, `ubuntu-dev01`, `ai-worker01`, `rocky-ansible01`, and `proxmox01`. Reverse DNS was enabled and verified.

External DNS forwarding was configured using Cloudflare's public recursive resolvers.

As a controlled validation step, only `ubuntu-dev01` was configured to use `edge01` as its preferred DNS server. Forward lookups, reverse lookups, Internet resolution, and normal name resolution were all verified successfully.

The remainder of the network continues using the existing AT&T gateway DNS configuration while the new service is evaluated before broader deployment.

## Accomplishments

- Installed Technitium DNS on `edge01`.
- Configured Cloudflare upstream forwarders.
- Created the `home.arpa` authoritative zone.
- Added initial infrastructure host records.
- Verified forward DNS resolution.
- Verified reverse (PTR) records.
- Configured `ubuntu-dev01` to use `edge01` as its preferred resolver.
- Successfully validated internal and external DNS resolution.

## Lessons Learned

- Deploying a foundational infrastructure service to a single validation client provides a low-risk rollout strategy.
- `home.arpa` provides a standards-based internal namespace without conflicting with mDNS.
- Reverse DNS is straightforward to implement during initial deployment and simplifies future troubleshooting.

## Next Steps

- Continue operating `ubuntu-dev01` against Technitium for several days.
- Document the deployment within Abbey infrastructure documentation.
- Verify `edge01` is represented in the hardware inventory.
- Add friendly service records after the infrastructure naming strategy is finalized.
- Promote Technitium to the primary DNS server for the entire lab after successful validation.
