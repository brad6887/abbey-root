# Abbey Root

## Proxmox

Management IP

192.168.1.55

---

## ubuntu-dev01

IP Address

192.168.1.86

### Services

- Homepage
- Portainer
- Uptime Kuma
- Nginx Proxy Manager

---

## ai-worker01

IP Address

192.168.1.87

### Hardware

- RTX 4060 Laptop GPU
- 32 GB RAM
- 1 TB SSD

### Services

- Docker
- NVIDIA Driver 595
- CUDA 13.2
- Ollama
- Open WebUI
- Portainer Agent

### Models

- qwen3:8b
- gemma3:4b
- gpt-oss:20b

---

# Current Priorities

## Primary

- Continue BradCooke.com content pipeline
- Develop AI-assisted website generation workflow
- Continue expanding Infrastructure-as-Code
- Improve Abbey Root developer toolkit

## Planned

- Convert remaining containers to Docker Compose
- Watchtower
- Tailscale
- Kali VM
- Grafana
- Prometheus

---

# Current Status (2026-06-28)

## Infrastructure

- Proxmox environment operational.
- Three managed Linux servers online.
- GitHub repository established.
- Backup infrastructure deployed.
- Backup restore successfully tested.

---

## Documentation

Documentation is generated automatically from Ansible inventory and host metadata.

Generated documentation includes:

- Architecture
- Servers
- Services
- Containers
- Network
- Inventory
- Automation
- Lab Summary

---

## Single Source of Truth

Host variables now serve as the authoritative source for:

- Homepage configuration
- Generated documentation
- Service inventory
- Server inventory

The project continues to follow a "define once, reuse everywhere" philosophy.

---

## Automation

Each Ansible role contains documentation.

Each playbook contains accompanying documentation used to generate the Automation Guide.

Inventory validation is performed automatically before documentation generation.

---

## Homepage

Homepage configuration is generated automatically from Ansible inventory and host metadata.

Manual editing is no longer required.

---

## Backup Strategy

### Storage

- SanDisk Extreme Portable SSD (2 TB)
- Storage ID: abbey-backup
- Mount Point: /mnt/abbey-backup

### Schedule

- Daily
- Snapshot mode
- ZSTD compression
- Retain last 7 backups

### Protected Systems

- ubuntu-dev01
- ai-worker01
- rocky-ansible01

Templates remain excluded because they are reproducible.

### Restore Testing

Status: Complete

A full restore test of rocky-ansible01 was successfully performed and validated.

Future improvements:

- Scheduled restore testing
- Backup monitoring
- Backup reporting
- Off-site replication

---

## Developer Toolkit

Current Abbey Root commands:

- abbey-status
- abbey-build
- abbey-docs
- abbey-validate
- abbey-help
- abbey-git-status
- abbey-git-history
- abbey-git-last

Current capabilities include:

- Standardized command interface
- Inventory validation
- Documentation generation
- Lab status reporting
- Git helpers
- Consistent help output
- Standard build workflow

---

## Repository Architecture

ansible/     Infrastructure as Code docs/        Technical documentation content/     BradCooke.com source content homepage/    Homepage configuration tools/       Developer toolkit scripts/     Helper scripts

---

## BradCooke.com

A dedicated content/ directory has been created as the source for future website content.

The long-term publishing pipeline is:

Infrastructure         ↓ Generated Documentation         ↓ Markdown Content         ↓ AI Enhancement         ↓ BradCooke.com

Markdown remains the primary source format for all publishable content.

---

## Standard Workflow

1. Update inventory or code.
2. Run abbey-status.
3. Run abbey-build.
4. Review generated documentation.
5. Review git diff.
6. Commit and push.

---

## Current Direction

Abbey Root has evolved beyond simply building infrastructure.

The project is now becoming a self-documenting Infrastructure-as-Code platform where:

- Infrastructure generates documentation.
- Documentation feeds AI workflows.
- AI assists with content creation.
- Markdown becomes the source for BradCooke.com.
- The website becomes the public presentation of work already taking place inside the lab.

The goal remains to build once, document once, and reuse everywhere.

###2026-06-30

- Established BradCooke.com content philosophy.
- Added content/pages for timeless site content.
- Implemented first Markdown → HTML proof-of-concept builder.
- Installed Node.js 24 LTS on ubuntu-dev01.
- Created initial Astro project.
- Verified Astro development server is running.
- Chose a hybrid content discovery model (folders define structure, metadata customizes behavior).

### 2026-06-30

- Installed Astro 7 development environment.
- Learned Astro pages, layouts, and components.
- Created reusable `Layout.astro` and `Nav.astro`.
- Configured Astro Content Collections using the external `content/` directory.
- Added schema validation for publishable content.
- Converted the About and Projects pages to render from Markdown.
- Established the first end-to-end content pipeline:
  `Markdown → Content Collection → Astro → Generated HTML`.
