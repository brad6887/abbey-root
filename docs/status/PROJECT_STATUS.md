# Abbey Root Project Status

**Last Updated:** 2026-07-02

---

# Current Phase

**Phase 2 – Publishing Platform**

Abbey Root has evolved from a Linux home lab into a metadata-driven platform for infrastructure automation, documentation, and technical publishing.

The primary focus is now expanding BradCooke.com with real project content while continuing to improve the underlying automation and developer experience.

---

# Current Priorities

## Primary

- Expand BradCooke.com with projects, journal entries, and technical articles.
- Continue developing the metadata-driven publishing platform.
- Expand Infrastructure-as-Code throughout the lab.
- Continue improving the Abbey Root developer toolkit.

## Planned

- GitHub Pages deployment
- Custom domain integration
- AI Worker expansion
- Kali security VM
- Monitoring and observability

---

# Infrastructure

## Hypervisor

- Proxmox
- Management IP: 192.168.1.55

---

## Virtual Machines

### ubuntu-dev01

**Purpose**

Primary development and infrastructure host.

**Services**

- Homepage
- Portainer
- Uptime Kuma
- Nginx Proxy Manager
- BradCooke.com development
- Astro development environment

---

### rocky-ansible01

**Purpose**

Automation control node.

Responsibilities include:

- Git repository
- Ansible inventory
- Playbooks
- Roles
- Generated documentation
- Developer toolkit

---

### ai-worker01

**Purpose**

AI experimentation platform.

**Hardware**

- RTX 4060 Laptop GPU
- 32 GB RAM
- 1 TB SSD

**Services**

- Docker
- NVIDIA Driver
- CUDA
- Ollama
- Open WebUI
- Portainer Agent

Current models include:

- qwen3:8b
- gemma3:4b
- gpt-oss:20b

---

# Infrastructure Status

Current infrastructure includes:

- Proxmox virtualization
- Three managed Linux systems
- GitHub repository
- Automated backups
- Restore validation
- Docker infrastructure
- Homepage dashboard
- AI experimentation platform

---

# Documentation

Documentation is generated wherever practical.

Current generated documentation includes:

- Architecture
- Servers
- Services
- Containers
- Inventory
- Network
- Automation
- Homepage configuration

Host metadata remains the primary source of truth for generated documentation.

---

# Automation

Current automation includes:

- Ansible-managed infrastructure
- Generated Homepage configuration
- Generated documentation
- Standardized developer toolkit
- Backup workflows
- Git helper commands
- Validation workflows

The long-term goal remains reducing manual configuration through Infrastructure-as-Code.

---

# Publishing Platform

The BradCooke.com publishing platform is now operational.

Current capabilities include:

- External Markdown content directory
- Astro Content Collections
- Metadata validation
- Dynamic navigation
- Dynamic project pages
- Dynamic project listing
- Journal collection
- Reusable Astro components
- Local development workflow
- Dynamic journal pages
- Previous/next journal navigation
- shared date formatting

Markdown remains the authoritative source for publishable content.

---

# Developer Toolkit

Current toolkit capabilities include:

Current toolkit capabilities include:

- Standardized command interface
- Project status reporting
- Project health validation (`abbey-doctor`)
- Documentation generation
- Git helpers
- Website development helpers
- Build automation
- Validation workflows

The toolkit is evolving toward a project-aware development environment.

---

# Single Source of Truth

Abbey Root continues to follow a metadata-first philosophy.

Information should be described once and reused everywhere practical.

Examples include:

- Ansible inventory
- Host metadata
- Website front matter
- Tool metadata
- Markdown content

These sources generate documentation, navigation, reports, and website content.

---

# Standard Workflow

A normal Abbey Root development session is becoming:

1. Start the development environment.
2. Review project status.
3. Build or improve infrastructure.
4. Update documentation.
5. Write a journal entry.
6. Commit changes.
7. Push to GitHub.
8. Synchronize development systems.

---

# Current Direction

Abbey Root is no longer simply a Linux lab.

It has become a collection of interconnected systems:

- Infrastructure
- Automation
- Documentation
- Developer toolkit
- Publishing platform
- AI experimentation

Each system reinforces the others through shared metadata, automation, and reusable components.

The long-term vision remains:

- Build once.
- Describe once.
- Generate everything else.

While AI plays an important role throughout the project, its purpose is to amplify creativity and understanding rather than replace them.
