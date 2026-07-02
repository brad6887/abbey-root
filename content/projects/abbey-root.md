---
title: Abbey Root
description: Home Linux lab for automation, Infrastructure-as-Code, AI-assisted development, and BradCooke.com.
status: Active
featured: true
draft: false
startedDate: 2026-06-20
updatedDate: 2026-07-02
tags:
  - Linux
  - Ansible
  - Docker
  - Proxmox
  - AI
---
# Abbey Root

Abbey Root is my home Linux lab for learning, experimentation, automation, and AI-assisted development.

The goal is not to build the perfect lab. The goal is to build practical skills by creating real systems, documenting what I learn, and automating the pieces that repeat.

Metadata First

Whenever practical, describe information once as structured metadata.

Generate documentation, interfaces, and automation from that metadata rather than maintaining multiple independent copies.

## Current Environment

The lab currently runs on Proxmox and includes several Linux virtual machines with dedicated roles.

### rocky-ansible01

`rocky-ansible01` is the automation control node.

It manages:

- Ansible inventory
- Roles
- Playbooks
- Group variables
- Host variables
- Vault configuration
- Generated documentation
- Lab automation workflows

### ubuntu-dev01

`ubuntu-dev01` is the main infrastructure and development host.

It runs Docker-based services including:

- Homepage
- Portainer
- Uptime Kuma
- Nginx Proxy Manager
- nginx-labtest

It also hosts the BradCooke.com development workflow.

### ai-worker01

`ai-worker01` is the dedicated AI experimentation host.

Its purpose is to keep AI-related workloads separate from core infrastructure services while giving me a safe place to experiment with self-hosted tools, containers, models, and AI-assisted development workflows.

Current and planned uses include:

- Running Open WebUI
- Testing self-hosted AI services
- Experimenting with containerized AI tools
- Supporting BradCooke.com content and development workflows
- Learning how AI can assist with documentation, automation, and coding

## Automation

Abbey Root is managed through Ansible wherever practical.

Current automation includes:

- Common system configuration
- Docker installation
- MOTD and login banner management
- Timezone and NTP configuration
- Homepage deployment
- Lab test container deployment
- Generated documentation
- Developer toolkit commands

## Developer Toolkit

Abbey Root includes a small command-line toolkit to make common project tasks easier.

The toolkit now includes:

- Standardized Abbey command headers
- Metadata-driven `abbey-help`
- Generated command documentation
- A reusable tool template
- `abbey-new-tool` for creating new commands

This keeps the toolkit self-documenting and reduces duplicated command lists.

## Website Goal

BradCooke.com is being rebuilt as part of Abbey Root.

The site is intended to become:

- A personal technical portfolio
- A project journal
- A place to document experiments
- A record of lessons learned
- A practical output of the home lab

## The Four Members of the Lab

Each VM in Abbey Root has a clearly defined purpose. Rather than collecting virtual machines, each system exists to own a specific responsibility within the environment.

Together they form the core of the lab.

### rocky-ansible01

`rocky-ansible01` brings the lab together through Ansible, Git, inventory, playbooks, and generated documentation.

It is the automation control node and the place where infrastructure starts becoming reproducible.

### ubuntu-dev01

`ubuntu-dev01` is the main development and infrastructure host.

It runs Docker services, supports BradCooke.com development, and acts as the place I keep coming back to while building the public-facing side of the project.

### ai-worker01

`ai-worker01` is the AI experimentation node.

It is where new ideas start to rise: Open WebUI, self-hosted AI tools, documentation assistance, content workflows, and future automation experiments.

### Security VM

A dedicated security VM is planned for safe, isolated security learning.

Its purpose will be to help validate the lab through scanning, testing, hardening, log analysis, and defensive security practice.

As Abbey Root continues to evolve, each system will grow alongside the project while remaining focused on a single responsibility. The goal is not to collect servers, but to build a small, cohesive platform where every component has a purpose.

The name Abbey Root is a small nod to Abbey Road, filtered through Linux, root access, and the idea of getting closer to how systems really work.

## Guiding Principles

Abbey Root follows a few simple principles:

- Learn by building
- Automate repeated work
- Prefer templates and Infrastructure-as-Code
- Document progress
- Use multiple Linux distributions
- Keep important services separate from experiments
- Treat servers as reproducible
- Use AI as a learning and development assistant

## Next Steps

Near-term goals include:

- Publish the first real version of BradCooke.com
- Continue developing Astro layouts and reusable components
- Improve Docker health reporting in `abbey-status`
- Automate the `ai-worker01` shell environment through Ansible
- Expand AI-assisted workflows using `ai-worker01`
- Continue improving generated documentation
