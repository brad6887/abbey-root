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

## 2026-06-26 Progress

### Documentation

- Added lab-summary.md generated documentation.
- Improved generated server documentation.
- Added service lifecycle status (active, planned, etc.).
- Improved template robustness using default() and namespace().
- Introduced inventory validation before documentation generation.

### Command-Line Toolkit

Created the initial Abbey Root CLI toolkit:

- abbey-build
- abbey-docs
- abbey-validate
- abbey-help
- abbey-git-status
- abbey-git-history
- abbey-git-last

Features include:

- Consistent command naming
- Standardized headers
- --help support
- Colored output
- Standard build workflow

### Workflow

The standard Abbey Root development workflow is now:

1. Update inventory or code.
2. Run abbey-build.
3. Review generated documentation.
4. Review git diff.
5. Commit and push.

### Current Direction

Abbey Root is evolving into a self-documenting Infrastructure-as-Code platform where:

- Inventory is the single source of truth.
- Documentation is generated automatically.
- Homepage configuration is generated automatically.
- Developer tools provide a consistent workflow.
- Future BradCooke.com content will be generated from the same source data.
