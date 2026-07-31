---
title: "Lab-Wide DNS Client Rollout"
description: "Configured reproducible internal DNS client policy across all managed Abbey lab hosts."
date: 2026-07-31
status: complete
reviewed: true
session: lab-wide-dns-client-rollout
tags:
  - Abbey Root
  - Infrastructure
  - DNS
  - Ansible
  - Networking
---

# Lab-Wide DNS Client Rollout

## Objective

Configure reliable hostname resolution between managed Abbey lab systems using
the existing Technitium `home.arpa` DNS service.

## Definition of Done

- Every managed lab host resolves the canonical `home.arpa` host records.
- Reverse DNS exists for every managed lab IP address.
- Managed hosts use Technitium as their authoritative internal resolver.
- The `home.arpa` search domain supports short hostnames.
- External DNS forwarding continues to work.
- DNS client configuration is reproducible through Ansible.
- NetworkManager and netplan systems are supported.
- Repeated Ansible runs are idempotent.
- Project status and backlog records are reconciled.

## Summary

Completed the lab-wide rollout of the Technitium DNS service hosted on
`edge01`.

A new reusable `dns_client` Ansible role now configures all five managed Linux
hosts to use the inventory-owned `edge01` address as their internal resolver
and `home.arpa` as the canonical search domain.

The role supports both NetworkManager and netplan without modifying
`/etc/resolv.conf` directly.

## Accomplishments

- Added the reusable `dns_client` Ansible role.
- Derived the primary DNS server from the `edge01` inventory record.
- Configured `home.arpa` as the managed search domain.
- Added tagged DNS-only Ansible execution through `--tags dns`.
- Added NetworkManager client support.
- Added Debian-family netplan client support.
- Reactivated NetworkManager profiles when DNS policy changes.
- Prevented DHCP-provided non-authoritative resolvers from remaining active.
- Added a systemd-networkd drop-in that rejects DNS servers and search domains
  supplied through IPv6 router advertisements while preserving IPv6 service.
- Configured `ubuntu-dev01`.
- Configured `ai-worker01`.
- Configured `rocky-ansible01`.
- Configured `edge01`.
- Configured `sensor01`.
- Added the missing reverse record for `ai-worker01`.
- Rotated the Wi-Fi credential exposed during troubleshooting.
- Validated canonical FQDN resolution across every managed host.
- Validated short-name resolution through the `home.arpa` search domain.
- Validated external DNS forwarding.
- Documented Tailscale MagicDNS precedence for some single-label names.
- Completed the related hostname-resolution and internal-DNS rollout backlog
  entries.

## Impact

Managed Abbey hosts now share one reproducible internal name-resolution policy.

The canonical LAN hostnames are:

    ubuntu-dev01.home.arpa
    ai-worker01.home.arpa
    rocky-ansible01.home.arpa
    edge01.home.arpa
    sensor01.home.arpa

This removes dependence on the AT&T gateway's local hostname behavior and
establishes Technitium as the authoritative source for Abbey lab names.

The implementation also provides a reusable foundation for future friendly
service records and additional authoritative DNS servers.

## Validation

The following checks passed:

- Ansible playbook syntax validation.
- DNS-only check mode for NetworkManager and netplan hosts.
- DNS-only deployment to all five managed hosts.
- Idempotent DNS-only reruns.
- Canonical FQDN validation from every managed host.
- Short-name search-domain validation from every managed host.
- External resolution through Technitium forwarding.
- Direct forward queries against Technitium.
- Reverse DNS for `192.168.1.86`.
- Reverse DNS for `192.168.1.87`.
- Reverse DNS for `192.168.1.88`.
- Reverse DNS for `192.168.1.221`.
- Reverse DNS for `192.168.1.222`.
- Technitium DNS and management ports remained available on `edge01`.
- `abbey backlog check`
- `abbey docs check`
- `git diff --check`

## Lessons Learned

- A resolver that is not authoritative for `home.arpa` is not a safe fallback.
  It may return a valid negative response instead of retrying Technitium.
- DNS redundancy requires another resolver authoritative for the internal zone,
  not a public resolver or the network gateway.
- NetworkManager profile changes may require full profile reactivation before
  DHCP-provided resolver state disappears.
- Check mode needs an explicit preview task when the underlying configuration
  command cannot execute safely.
- Tailscale MagicDNS may take precedence for some single-label names. Fully
  qualified `home.arpa` names remain the canonical LAN identities.
- Broad network-configuration inspection can expose credentials and should be
  avoided or carefully filtered.

## Next Steps

- Establish reliable internal access to public proxied services through Abbey
  DNS.
- Finalize the infrastructure naming strategy and add friendly DNS service
  records.
- Consider a second authoritative DNS server if internal DNS redundancy becomes
  necessary.

## Notes

The role intentionally does not edit `/etc/resolv.conf`.

The authoritative DNS server address is derived from the existing `edge01`
inventory variable, preserving one source of truth.
