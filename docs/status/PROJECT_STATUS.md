# Abbey Root

## Proxmox

192.168.1.55

## ubuntu-dev01

192.168.1.86

Services

- Homepage
- Portainer
- Uptime Kuma
- Nginx Proxy Manager

## ai-worker01

192.168.1.87

Hardware

- RTX 4060 Laptop GPU
- 32 GB RAM
- 1 TB SSD

Services

- Docker
- NVIDIA Driver 595
- CUDA 13.2
- Ollama
- Open WebUI
- Portainer Agent

Models

- qwen3:8b
- gemma3:4b
- gpt-oss:20b

## Next Steps

- Push Abbey Root to GitHub
- Convert containers to compose files
- rocky-ansible01
- Watchtower
- Tailscale
- Kali VM
- Grafana
- Prometheus
- BradCooke.com rebuild


## Current Status (2026-06-25)

### Documentation

Documentation is now generated automatically from Ansible inventory and host metadata.

Generated documents include:

- Architecture
- Servers
- Services
- Containers
- Network
- Inventory
- Automation

### Metadata

Host variables have become the authoritative source for:

- Homepage configuration
- Generated documentation
- Service inventory
- Server inventory

### Automation

Each Ansible role now contains a README describing its purpose.

Each playbook has accompanying documentation used to generate the automation guide.

### Homepage

Homepage configuration is generated from host metadata rather than being maintained manually.

### Documentation Philosophy

Abbey Root now follows a "single source of truth" model.

Information is defined once and consumed by:

- Homepage
- Generated documentation
- Future automation

