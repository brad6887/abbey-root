---
title: "Edge01 Becomes Abbey's Internal DNS Server"
description: "Commissioned Abbey's first internal authoritative DNS service using Technitium DNS on edge01."
date: 2026-07-15
draft: false
tags:
  - Abbey Root
  - Infrastructure
  - DNS
  - Raspberry Pi
  - Networking
---

# Edge01 Becomes Abbey's Internal DNS Server

## Summary

Today marked an important infrastructure milestone for Abbey Root with the deployment of its first internal authoritative DNS service.

Technitium DNS was installed on the Raspberry Pi `edge01` and configured to serve the `home.arpa` internal DNS zone. Initial DNS records were created for the core Abbey infrastructure, providing stable hostnames for the lab instead of relying solely on IP addresses.

Cloudflare was configured as the upstream resolver, and both forward and reverse DNS resolution were successfully validated. As a controlled rollout, only `ubuntu-dev01` was configured to use the new DNS server while the remainder of the network continues using the existing AT&T gateway during an evaluation period.

The deployment establishes the foundation for future infrastructure improvements such as friendly service names, reverse proxying, TLS, monitoring, and service discovery.

## Accomplishments

- Installed Technitium DNS on `edge01`.
- Configured Cloudflare as the upstream DNS forwarder.
- Created the `home.arpa` authoritative DNS zone.
- Added DNS records for the primary Abbey infrastructure hosts.
- Enabled and verified reverse (PTR) records.
- Configured `ubuntu-dev01` to use `edge01` as its preferred DNS server.
- Verified successful internal and external DNS resolution.
- Confirmed the deployment without impacting the remainder of the home network.

## Lessons Learned

- Rolling out foundational infrastructure to a single validation client greatly reduces deployment risk.
- `home.arpa` provides a standards-based internal namespace that avoids conflicts with mDNS.
- Reverse DNS is simple to implement during initial deployment and provides immediate operational benefits.
- Building core infrastructure capabilities before expanding services creates a more maintainable platform.

## Next Steps

- Operate `ubuntu-dev01` against Technitium DNS for several days to validate long-term stability.
- Document the deployment in Abbey infrastructure documentation.
- Verify `edge01` is fully represented in the hardware inventory.
- Add friendly DNS records for Abbey services after the naming strategy is finalized.
- Promote `edge01` to the primary DNS server for the lab after successful validation.
