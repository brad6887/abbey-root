# Abbey Root Remote Access

## Purpose

This document defines the standard architecture and operating procedures for secure remote access to the Abbey Root lab.

Remote access is intended to enable safe administration, remote development, collaboration, and future multi-operator workflows while minimizing the attack surface exposed to the Internet.

---

# Design Principles

Abbey Root follows these principles for remote access:

- No infrastructure management interfaces are directly exposed to the Internet.
- Remote administration uses encrypted, authenticated connections.
- SSH public key authentication is required.
- Operator access is documented and reproducible.
- Least privilege is preferred.
- Operational simplicity is favored over unnecessary complexity.
- Remote access architecture should remain independent of automation architecture.

---

# Architecture

```
                    Internet
                         │
                  Tailscale Network
                         │
                 ubuntu-dev01
        Remote Access & Operations Node
                         │
     ┌──────────────┬──────────────┬──────────────┐
     │              │              │              │
 ai-worker01   rocky-ansible01   Proxmox     Docker Services
                    │
             Ansible Control Node
```

Abbey Root currently separates **remote operations** from **automation**.

- `ubuntu-dev01` is the **Remote Access & Operations Node**.
- `rocky-ansible01` is the **Ansible Control Node**.

This separation allows remote administration without requiring the automation platform to also serve as the primary entry point into the lab.

---

# Remote Access & Operations Node

`ubuntu-dev01` provides:

- Abbey Root repository
- Abbey CLI
- Docker management
- Infrastructure health checks
- Website builds
- Session workflow
- SSH access to lab systems
- Tailscale remote access endpoint

Routine operator sessions should normally begin on this system.

---

# Ansible Control Node

`rocky-ansible01` currently hosts the Abbey automation environment.

Responsibilities include:

- Ansible execution
- Infrastructure automation
- Playbook development
- Inventory management

Future versions of Abbey may consolidate these responsibilities, but they remain intentionally separate today.

---

# Remote Access Standard

The standard remote access solution for Abbey Root is:

- Tailscale

Reasons:

- Zero Trust networking
- No inbound firewall rules
- End-to-end encryption
- Cross-platform support
- Simple operator onboarding
- Minimal maintenance

---

# Authentication

Remote administration requires:

- SSH public key authentication
- Individual operator accounts
- Individual SSH keys

Password authentication should be avoided whenever practical.

---

# Operator Workflow

Typical remote workflow:

1. Connect to the Tailscale network.
2. SSH to `ubuntu-dev01`.
3. Verify lab health.

```bash
abbey doctor
abbey lab check
```

4. Perform the required work.
5. If infrastructure automation is required, access the Ansible Control Node.
6. Validate changes.
7. Capture a session update.
8. Commit changes.

---

# Future Enhancements

Planned improvements include:

- `abbey operator add`
- Automated operator onboarding
- Remote connectivity validation in `abbey doctor`
- Discord session notifications
- Remote AI-assisted development workflows
- Architecture diagrams
- Evaluation of consolidating remote operations and Ansible control onto a single platform

---

# Security Notes

The following services should not be directly exposed to the public Internet:

- Proxmox
- SSH
- Portainer
- Docker APIs
- Uptime Kuma
- Homepage administration
- Nginx Proxy Manager administration

Remote administration should occur through Tailscale using the Remote Access & Operations Node.

---

# Revision History

| Date | Change |
|------|--------|
| 2026-07-14 | Initial remote access architecture defined using Tailscale. |
| 2026-07-14 | Distinguished the Remote Access & Operations Node from the Ansible Control Node. |
