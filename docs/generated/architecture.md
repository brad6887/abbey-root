# Abbey Root Architecture

Generated automatically by Ansible.

## Lab Summary

| Item | Count |
|------|------:|
| Hosts | 3 |
| Docker Hosts | 2 |
| Homepage Servers | 2 |
| Inventory Groups | 3 |

---

## Platform Overview

| Component | Description |
|-----------|-------------|
| Hypervisor | Proxmox |
| Source Control | Git / GitHub |
| Configuration Management | Ansible |
| Documentation | Generated from inventory and host variables |
| Managed Hosts | 3 |

---

## Hosts

### ai-worker01

**Description**

AI experimentation and Docker services

**IP Address**

192.168.1.87

**Purpose**

- AI experimentation
- Docker host

**Capabilities**

| Capability | Value |
|------------|-------|
| Docker Host | Yes |
| Homepage Visible | Yes |

**Inventory Groups**

- ai

**Services Provided**

#### AI

- Open WebUI
- Ollama
- Portainer Agent


---

### rocky-ansible01

**Description**

Ansible control node

**IP Address**

192.168.1.88

**Purpose**

- Ansible Control Node
- Git Repository
- Automation

**Capabilities**

| Capability | Value |
|------------|-------|
| Docker Host | No |
| Homepage Visible | Yes |

**Inventory Groups**

- automation

**Services Provided**

#### Automation

- Rocky Ansible


---

### ubuntu-dev01

**Description**

Not documented

**IP Address**

192.168.1.86

**Purpose**


**Capabilities**

| Capability | Value |
|------------|-------|
| Docker Host | Yes |
| Homepage Visible | No |

**Inventory Groups**

- infrastructure

**Services Provided**

#### Infrastructure

- Proxmox
- Portainer
- Homepage
- Nginx Proxy Manager

#### Lab Tests

- Nginx Lab Test

#### Monitoring

- Uptime Kuma

#### Development

- GitHub
- BradCooke.com
- ChatGPT

#### Planned Services

- Grafana
- Prometheus
- Watchtower
- Immich
- n8n


---


## Design Principles

Abbey Root follows these design principles:

- Inventory is the source of truth.
- Each server owns its own metadata.
- Homepage is generated from host metadata.
- Documentation is generated from the same metadata.
- Configuration is managed with Ansible.
- Infrastructure is maintained as code.
