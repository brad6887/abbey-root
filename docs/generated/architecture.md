# Abbey Root Architecture

Generated automatically by Ansible.

## Platform Overview

| Component | Description |
|----------|-------------|
| Hypervisor | Proxmox |
| Automation Controller | rocky-ansible01 |
| Source Control | Git / GitHub |
| Configuration Management | Ansible |
| Documentation | Generated from inventory and host variables |

---

## Infrastructure

# ai-worker01

**Description**

AI experimentation and Docker services

**IP Address**

192.168.1.87

**Purpose**

- AI experimentation
- Docker host

**Inventory Groups**

- ai

**Services Provided**

### AI

- Open WebUI
- Ollama
- Portainer Agent


---

# rocky-ansible01

**Description**

Ansible control node

**IP Address**

192.168.1.88

**Purpose**

- Ansible Control Node
- Git Repository
- Automation

**Inventory Groups**

- automation

**Services Provided**

### Automation

- Rocky Ansible


---

# ubuntu-dev01

**Description**

Infrastructure and Docker services

**IP Address**

192.168.1.86

**Purpose**

- Infrastructure services
- Docker host

**Inventory Groups**

- infrastructure

**Services Provided**

### Infrastructure

- Proxmox
- Portainer
- Homepage
- Nginx Proxy Manager

### Lab Tests

- Nginx Lab Test

### Monitoring

- Uptime Kuma

### Development

- GitHub
- BradCooke.com
- ChatGPT

### Future Services

- Grafana
- Prometheus
- Watchtower
- Immich
- n8n


---


## Architecture Principles

Abbey Root follows these design principles:

- Inventory is the source of truth.
- Each server owns its own metadata.
- Homepage is generated from host metadata.
- Documentation is generated from the same metadata.
- Configuration is managed with Ansible.
- Infrastructure is maintained as code.
