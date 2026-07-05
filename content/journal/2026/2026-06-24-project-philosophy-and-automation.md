---
title: "Project Philosophy and Automation"
date: 2026-06-24
summary: "Defined the Abbey Root philosophy and completed major Ansible, Homepage, and infrastructure automation milestones."
tags:
  - Automation
  - Ansible
  - Documentation
  - Homepage
  - Infrastructure
---
# Abbey Root

## Purpose

Create a home Linux lab for learning, experimentation, automation, and AI-assisted development.

The lab exists to build practical skills by creating real projects rather than collecting idle virtual machines.

The long-term goal is to evolve the environment into a reproducible Infrastructure-as-Code platform managed through Git, Ansible, templates, and automated deployments.

---

## Long-Term Goals

- Learn Linux administration and troubleshooting.
- Gain experience with multiple Linux distributions.
- Learn Proxmox virtualization and templates.
- Learn Docker and containerized applications.
- Learn Ansible and infrastructure automation.
- Explore AI tools and self-hosted AI technologies.
- Build and maintain BradCooke.com using AI-assisted workflows.
- Practice Git and GitHub workflows.
- Learn networking, monitoring, backup, and security concepts.
- Create a reusable environment for future experiments.
- Document progress and lessons learned.
- Manage the lab through Infrastructure-as-Code.

---

## Guiding Principles

### Learn by Building

Prefer working projects over theory.

Build systems, break them, fix them, and understand why they work.

---

### Keep It Reproducible

Document configurations and automate wherever practical.

Prefer Ansible, Git, templates, and Infrastructure-as-Code over manual changes.

---

### Use Multiple Distributions

Gain experience across different Linux ecosystems.

Examples:

- Ubuntu
- Debian
- Rocky Linux
- AlmaLinux
- Fedora
- Kali Linux

---

### Favor Open Source

Prefer open-source and self-hosted solutions whenever practical.

---

### Experiment Safely

Treat the lab as a playground.

Mistakes are expected and encouraged.

---

### Rebuild Rather Than Repair

When practical, recreate systems from templates and automation rather than manually repairing them.

---

### Document Progress

Maintain notes on:

- Goals
- Accomplishments
- Problems encountered
- Lessons learned
- Future ideas

---

### Use AI as a Tool

Use AI to:

- Explain concepts.
- Write scripts.
- Generate documentation.
- Assist with coding.
- Create and maintain BradCooke.com.
- Help troubleshoot problems.
- Accelerate learning.

AI should enhance understanding rather than replace it.

---

## Website Goal

Use the lab to rebuild and maintain BradCooke.com.

The site should:

- Be stored in GitHub.
- Be developed primarily from Linux systems.
- Use AI assistance for content and code generation.
- Serve as a portfolio and project journal.
- Document experiments, accomplishments, and lessons learned.
- Evolve continuously rather than attempting a perfect initial design.

---

## Security Goal

Use Kali Linux and isolated lab systems to learn security concepts in a safe and ethical manner.

Areas of study include:

- Network scanning
- Vulnerability assessment
- Password security
- Linux hardening
- Container security
- Log analysis
- Monitoring and intrusion detection
- Security best practices

Testing should always be limited to systems owned by or intentionally created within the lab.

---

## Infrastructure Philosophy

- Prefer templates and automation over manual builds.
- Use Docker before creating additional virtual machines when appropriate.
- Keep resource usage reasonable.
- Separate experimentation from important services.
- Maintain backups of important configurations.
- Use Git for documentation and configuration files.
- Favor simple solutions over unnecessary complexity.
- Manage systems declaratively whenever practical.
- Treat servers as disposable and reproducible.

---

## Current Platform

### Hypervisor

- Proxmox

### Source Control

- Git
- GitHub

Repository:

- abbey-root

### Virtual Machines

#### ubuntu-dev01

Purpose:

- Infrastructure services
- Docker host

Containers:

- Homepage
- Portainer
- Uptime Kuma
- Nginx Proxy Manager
- nginx-labtest

---

#### ai-worker01

Purpose:

- AI experimentation
- Docker host

Containers:

- Open WebUI
- Portainer Agent

---

#### rocky-ansible01

Purpose:

- Automation control node

Responsibilities:

- Git repository
- Ansible inventory
- Roles
- Playbooks
- Group variables
- Host variables
- Vault management

---

## Current Automation

### Roles

- common
- docker
- motd
- issue
- time
- homepage
- labtest

### Playbooks

- site.yml
- update.yml
- facts.yml
- docker.yml

### Helper Scripts

- ansible-site.sh
- ansible-update.sh
- ansible-facts.sh
- ansible-docker.sh

---

## Homepage

Managed by Ansible:

- services.yaml
- docker.yaml
- settings.yaml
- widgets.yaml
- bookmarks.yaml
- docker-compose.yml

Features:

- Server inventory auto-generated from Ansible inventory
- Homepage deployment managed through Ansible handlers
- Service entries managed through host variables and templates

---

## Infrastructure

- Standardized timezone: America/Chicago
- NTP synchronization enabled on all hosts
- Passwordless SSH between Ansible controller and managed hosts
- Ansible Vault configured
- Git repository integrated with automation workflow

---

## Areas of Study

- Linux administration
- Proxmox
- Docker
- Ansible
- Git and GitHub
- Networking
- Bash scripting
- Python
- Monitoring
- Backup and recovery
- Security
- AI technologies
- Self-hosted applications
- Web development
- Automation
- Infrastructure-as-Code
- Troubleshooting

---

## Success Criteria

Success is measured by:

- Knowledge gained.
- Systems built.
- Problems solved.
- Documentation created.
- Automation developed.
- Websites maintained.
- Lessons learned.
- Ability to rebuild systems quickly.
- Reduction of manual configuration.

---

## Mindset

The purpose of Abbey Root is not to create the perfect environment.

Progress is more important than perfection.

Break things.

Fix things.

Document what was learned.

Automate what is repeated.

Rebuild rather than repair when practical.

Build useful projects instead of collecting idle virtual machines.

Keep the lab fun and treat it as a long-term investment in skills and knowledge.

The journey matters more than the destination.

"sudo make me a sandwich."

---

## Completed 2026-06-24

### Ansible

- Learned Jinja templates
- Learned handlers
- Learned host_vars and group_vars
- Created motd role
- Created issue role
- Created time role

### Homepage

- services.yaml managed by Ansible
- docker.yaml managed by Ansible
- settings.yaml managed by Ansible
- widgets.yaml managed by Ansible
- bookmarks.yaml managed by Ansible
- Server inventory auto-generated from Ansible inventory
- Homepage docker-compose.yml generated from Ansible
- Homepage deployment managed by Ansible handlers

### Infrastructure

- Standardized timezone to America/Chicago
- Enabled NTP synchronization on all hosts

### Containers

- Deployed nginx-labtest through Ansible
- Validated Docker Compose deployment workflow
- Validated Homepage automation workflow

### Automation

- Generated Homepage server inventory from Ansible inventory
- Generated Homepage Docker Compose configuration from variables
- Deployed Homepage through Ansible-managed Docker Compose
