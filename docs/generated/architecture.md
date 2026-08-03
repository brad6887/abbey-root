# Abbey Root Architecture

Generated automatically by Ansible.

## Lab Summary

| Item | Count |
|------|------:|
| Hosts | 6 |
| Docker Hosts | 2 |
| Homepage Servers | 5 |
| Inventory Groups | 6 |

---

## Platform Overview

| Component | Description |
|-----------|-------------|
| Hypervisor | Proxmox |
| Source Control | Git / GitHub |
| Configuration Management | Ansible |
| Documentation | Generated from inventory and host variables |
| Managed Hosts | 6 |

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

### edge01

**Description**

Internal DNS and edge services

**IP Address**

192.168.1.221

**Purpose**

- Internal DNS
- Foundational network services
- Edge infrastructure

**Capabilities**

| Capability | Value |
|------------|-------|
| Docker Host | No |
| Homepage Visible | Yes |

**Inventory Groups**

- edge_services

**Services Provided**

#### Infrastructure

- Technitium DNS


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


---

### sensor01

**Description**

Temperature and humidity sensor

**IP Address**

192.168.1.222

**Purpose**

- Environmental monitoring
- Temperature sensing
- Humidity sensing

**Capabilities**

| Capability | Value |
|------------|-------|
| Docker Host | No |
| Homepage Visible | No |

**Inventory Groups**

- sensors


---

### sites01

**Description**

Static website hosting

**IP Address**

192.168.1.84

**Purpose**

- Static website hosting
- Production web content

**Capabilities**

| Capability | Value |
|------------|-------|
| Docker Host | No |
| Homepage Visible | Yes |

**Inventory Groups**

- web


---

### ubuntu-dev01

**Description**

Infrastructure and Docker services

**IP Address**

192.168.1.86

**Purpose**

- Infrastructure services
- Docker host

**Capabilities**

| Capability | Value |
|------------|-------|
| Docker Host | Yes |
| Homepage Visible | Yes |

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
- Umami

#### Development

- GitHub
- BradCooke.com
- ChatGPT


---


## Design Principles

Abbey Root follows these design principles:

- Inventory is the source of truth.
- Each server owns its own metadata.
- Homepage is generated from host metadata.
- Documentation is generated from the same metadata.
- Configuration is managed with Ansible.
- Infrastructure is maintained as code.
