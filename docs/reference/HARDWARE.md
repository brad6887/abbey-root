# Abbey Root Hardware Inventory

This document tracks the physical hardware that supports the Abbey Root lab.

The purpose of this inventory is to document the major infrastructure components, their role within the lab, and future expansion plans.

---

# Hardware Summary

| Device | Purpose | Status |
|---------|---------|--------|
| MacBook Pro (M3 Pro) | Primary workstation | In Service |
| Dell Laptop (Service Tag: ST-GB24CL3) | Proxmox virtualization host | In Service |
| Gigabyte G6-KF (2024) Laptop | AI Worker host | In Service |
| TRENDnet TEG-S380 8-Port 2.5 Gb Switch | Primary lab network switch | In Service |
| UGREEN USB 3.0 2.5 Gb Ethernet Adapter | AI Worker wired networking | In Service |
| Raspberry Pi 5 (4 GB) - edge01 | Edge infrastructure node | Ordered |
| SanDisk Extreme Portable SSD (2 TB) | Proxmox backup storage | In Service |
| Anker USB-C Hub | USB expansion for Proxmox | In Service |
| Belkin 12-Outlet Surge Protector | Power protection | In Service |

---

# MacBook Pro (M3 Pro)

## Role

Primary workstation for Abbey Root.

## Responsibilities

- SSH administration
- Git and GitHub
- VS Code development
- Documentation
- ChatGPT
- Website development
- Infrastructure management
- General lab administration

This is the primary interface used to manage the entire environment.

---

# Dell Laptop (Service Tag: ST-GB24CL3)

## Role

Primary Proxmox host.

## Responsibilities

- Proxmox VE
- Virtual machine hosting
- Docker hosts
- Infrastructure services
- Templates
- Backup management

This system is the foundation of the Abbey Root infrastructure.

---

# Gigabyte G6-KF (2024) Laptop

## Role

AI experimentation and development server.

## Responsibilities

- Ollama host
- Open WebUI
- AI-assisted content generation
- AI experimentation
- Docker host
- BradCooke.com AI publishing workflows

## Operating System

Ubuntu Linux

## Network

- Primary connection: Wired Ethernet
- UGREEN USB 3.0 2.5 Gb Ethernet adapter
- Connected to the TRENDnet TEG-S380 2.5 Gb switch
- DHCP reservation managed by the router
- Wi-Fi retained as an emergency fallback but disabled for normal operation

## Docker Services

- Open WebUI
- Portainer Agent

## Notes

Originally deployed using Wi-Fi.

Migrated to wired Ethernet to improve reliability, reduce latency, and provide a stable platform for AI services and future website generation workflows.

---

# TRENDnet TEG-S380 8-Port 2.5 Gb Switch

## Role

Primary network switch for the Abbey Root lab.

## Responsibilities

- Multi-gigabit connectivity
- Interconnect lab infrastructure
- Foundation for future network expansion
- Low-latency communication between infrastructure services

## Specifications

- 8 × 2.5GBASE-T ports
- Fanless design
- 25 Gbps switching capacity

## Connected Systems

- Proxmox host
- AI Worker
- Primary workstation (when docked)
- Future edge infrastructure
- Additional lab systems

## Notes

Installed as part of the Abbey Root network refresh to provide reliable multi-gigabit networking and support future infrastructure growth.

Status: In Service

---

# UGREEN USB 3.0 2.5 Gb Ethernet Adapter

## Role

Primary wired network interface for the AI Worker.

## Responsibilities

- Stable wired networking
- 2.5 Gb Ethernet connectivity
- Primary interface for AI services
- Docker networking

## Notes

Installed to replace Wi-Fi as the primary network connection for the AI Worker.

Status: In Service

---

# SanDisk Extreme Portable SSD (2 TB)

## Role

Dedicated Proxmox backup storage.

## Configuration

- Capacity: 2 TB
- Filesystem: ext4
- Volume Label: abbey-backup
- Mount Point: /mnt/abbey-backup
- Backup Directory: /mnt/abbey-backup/proxmox

## Purpose

- Proxmox VM backups
- Restore testing
- Disaster recovery
- Future configuration exports

## Notes

- Mounted using UUID via `/etc/fstab`
- Dedicated exclusively to Abbey Root
- Used as the primary Proxmox backup repository

Status: In Service

---

# Anker USB-C Hub

## Role

USB expansion for the Proxmox host.

## Connected Devices

- SanDisk Extreme Portable SSD (2 TB)

## Planned Usage

- Backup SSD
- USB installer media
- Future UPS monitoring cable
- Future USB peripherals
- General USB expansion

Status: In Service

---

# Belkin 12-Outlet Surge Protector

## Role

Primary power distribution and surge protection for the Abbey Root lab.

## Purpose

- Surge protection
- Additional outlet capacity
- Foundation for future UPS deployment

## Connected Equipment

- Proxmox host
- AI Worker host
- Lab peripherals

Status: In Service

---

# Pending Hardware

## Raspberry Pi 5 (4 GB) - edge01

### Status

Ordered (2026-07-14)

### Planned Hostname

`edge01`

### Planned Role

Edge Infrastructure Node

### Initial Responsibilities

- Local DNS
- Tailscale
- SSH
- Abbey infrastructure experimentation
- ARM Linux learning platform

### Future Responsibilities

- Infrastructure services
- Network monitoring
- NTP
- Environmental monitoring
- Additional lightweight infrastructure services

### Notes

`edge01` will be the first physical system commissioned after the Abbey Root platform architecture was established.

Unlike earlier lab systems, it will be integrated into Abbey using the project's current standards for:

- Documentation
- Inventory management
- Session workflow
- Architecture
- Validation
- Automation

The system will initially boot from the supplied microSD card. Migration to NVMe storage will be evaluated after commissioning and integration into the lab.

---

## Cat6 Patch Cables (10 × 3 ft)

### Status

Ordered (2026-06-28)

### Planned Purpose

Improve cable management and provide short patch cables throughout the Abbey Root lab.

### Planned Uses

- Proxmox host
- AI Worker host
- Network switch
- Future lab hardware

These items will move into their permanent hardware sections once installed and placed into service.

---

# Future Hardware Roadmap

Potential additions include:

- UPS
- Network Attached Storage (NAS)
- Additional Proxmox node
- Memory upgrades
- Managed network switch
- 10 Gb networking
- Dedicated backup server

Each hardware purchase should improve one or more of the following:

- Reliability
- Automation
- Documentation
- AI capabilities
- Learning opportunities

---

# Hardware Philosophy

Hardware should be selected to support the long-term goals of Abbey Root.

When practical:

- Buy once, use for multiple purposes.
- Prefer reliability over maximum performance.
- Document every significant piece of infrastructure.
- Validate new hardware before placing it into production.
- Build incrementally rather than all at once.

The goal is to create a reliable, reproducible, AI-assisted infrastructure that continues to evolve over time.
