# edge01 Commissioning

## Purpose

This document defines the commissioning approach for the Abbey Root Infrastructure Services Platform.

`edge01` is the first dedicated infrastructure appliance deployed specifically for Abbey Root and establishes the pattern for future infrastructure service hosts.

---

## Status

Foundation Established

---

## Platform Role

| Platform Role | Current Implementation | Mission |
|---------------|------------------------|---------|
| Infrastructure Services Platform | `edge01` | Foundational infrastructure services |

---

## Responsibilities

`edge01` provides:

- Internal authoritative DNS
- Recursive DNS forwarding
- Tailscale endpoint
- SSH administration
- Foundation for future network infrastructure services

---

## Hardware

| Component | Value |
|-----------|-------|
| Device | Raspberry Pi 5 (4 GB) |
| Operating System | Debian 13 |
| Hostname | `edge01` |
| IPv4 Address | `192.168.1.221` |

---

## Commissioning Process

### Hardware Registration

The appliance is registered in the Abbey Root hardware inventory.

Reference:

```
docs/reference/HARDWARE.md
```

The hardware record defines:

- hostname
- network information
- purpose
- service responsibilities

---

### Ansible Integration

`edge01` is integrated into Abbey Root automation through the Ansible inventory.

Inventory locations:

```
ansible/inventory/hosts.yml
ansible/inventory/host_vars/edge01.yml
```

Host-specific configuration defines:

- primary IP address
- host description
- server purpose
- dashboard integration

The primary Ansible convergence entry point is:

```
ansible/playbooks/site.yml
```

Ansible commands should be executed from the Ansible project directory:

```
cd ansible
```

Inventory and role paths are managed through the Ansible project configuration.

Current managed configuration includes:

- common host configuration
- DNS client configuration
- time synchronization
- system identification

---

## DNS Service Deployment

Technitium DNS was deployed on `edge01` as the first infrastructure service.

The service provides:

- authoritative DNS for the `home.arpa` zone
- internal host resolution
- reverse DNS
- external DNS forwarding

Deployment:

Technitium DNS is deployed as a native systemd-managed service.

Service:

```
dns.service
```

Application location:

```
/opt/technitium/dns
```

Configuration:

| Setting | Value |
|---------|-------|
| Internal Zone | `home.arpa` |
| Upstream Resolver | Cloudflare |
| Primary Resolver | `1.1.1.1` |
| Secondary Resolver | `1.0.0.1` |

---

## DNS Validation

The initial deployment was validated using `ubuntu-dev01` as a controlled test client.

Validation completed:

- Forward DNS lookups
- Reverse DNS lookups
- External DNS resolution
- Internal host record resolution

Initial infrastructure records were created for:

- `edge01`
- `ubuntu-dev01`
- `ai-worker01`
- `rocky-ansible01`
- `proxmox01`

---

## Validation Criteria

A commissioned `edge01` should have:

- [x] Hardware documented
- [x] Inventory integration complete
- [x] Ansible management established
- [x] Technitium DNS operational
- [x] Internal DNS records configured
- [x] Reverse DNS functioning
- [x] External DNS forwarding validated

---

## Current State

`edge01` is operational as the Abbey Root Infrastructure Services Platform.

Completed:

- Raspberry Pi 5 deployed
- Debian 13 installed
- Host integrated into Abbey inventory
- Ansible management established
- Technitium DNS deployed
- `home.arpa` authoritative DNS established
- DNS validation completed

---

## Future Automation Opportunities

Potential improvements:

- Automate infrastructure service deployment
- Manage DNS records through infrastructure-as-code
- Add automated service health validation
- Document backup and recovery procedures

---

## Related Documents

- `docs/architecture/LAB_ARCHITECTURE.md`
- `docs/reference/HARDWARE.md`
- `docs/architecture/REMOTE_ACCESS.md`

---

## Revision History

| Date | Change |
|------|--------|
| 2026-07-14 | Initial document created. |
| 2026-08-05 | Completed commissioning documentation based on deployed `edge01` implementation. |
