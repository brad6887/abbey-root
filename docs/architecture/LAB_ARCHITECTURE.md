# Abbey Root Lab Architecture

## Purpose

This document defines the logical architecture of the Abbey Root lab.

It describes the platform roles, responsibility boundaries, and relationships between the major components of the platform.

Implementation details are documented elsewhere.

---

## Status

Foundation Established

---

## Design Principles

The lab architecture follows the principles defined in:

- `docs/architecture/ARCHITECTURE_PRINCIPLES.md`

---

## Platform Overview

| Platform Role | Current Implementation | Mission |
|---------------|------------------------|---------|
| Operator Workstation | MacBook Pro | Primary engineering workstation |
| Virtualization Platform | Proxmox | Virtual machine lifecycle management |
| Remote Operations Platform | `ubuntu-dev01` | Primary operator workspace |
| Automation Platform | `rocky-ansible01` | Infrastructure automation |
| AI Compute Platform | `ai-worker01` | Local AI inference and experimentation |
| Infrastructure Services Platform | `edge01` | Foundational infrastructure services |
| Network Platform | TRENDnet TEG-S380 | Multi-gigabit network connectivity |

---

## Related Documents

- `docs/architecture/ARCHITECTURE_PRINCIPLES.md`
- `docs/architecture/REMOTE_ACCESS.md`
- `docs/reference/HARDWARE.md`
- `docs/reference/NAMING.md`

---

## Revision History

| Date | Change |
|------|--------|
| 2026-07-14 | Initial document created. |
