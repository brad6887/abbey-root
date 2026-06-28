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

# Gigabyte G6-KF (2024)

## Role

AI Worker host.

## Responsibilities

- AI experimentation
- Local AI models
- Open WebUI
- Future code assistants
- AI-assisted website generation
- AI workflow automation
- AI-assisted BradCooke.com content generation

This system is dedicated to AI workloads and is intended to become the primary AI engine for BradCooke.com.

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

- Mounted using UUID via /etc/fstab
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
---

# Pending Hardware

## Plugable USB-C 2.5 Gb Ethernet Adapter

### Status

Ordered (2026-06-28)

### Planned Purpose

Provide a second wired network interface for ai-worker01.

### Planned Uses

- Future dedicated storage network
- Docker networking experiments
- Network isolation
- Lab expansion
- High-speed file transfers

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
