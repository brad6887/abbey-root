Naming Standards

Purpose

This document defines naming standards for Abbey Root.

Consistent naming makes the project easier to understand, automate, document, and search.

⸻

General Rules

Use names that are:

* Descriptive
* Predictable
* Lowercase when practical
* Easy to type
* Easy to sort
* Consistent with existing patterns

Avoid names that are vague, temporary, overly clever, or dependent on memory.

⸻

Virtual Machines

Virtual machine names should describe the operating system or purpose.

Current examples:

* ubuntu-dev01
* ai-worker01
* rocky-ansible01

Preferred format:

purpose-role-number

Examples:

ubuntu-dev01
rocky-ansible01
debian-test01
kali-sec01

⸻

Toolkit Commands

Abbey toolkit commands should use the abbey namespace.

Preferred format:

abbey <command>

Examples:

abbey doctor
abbey ai
abbey journal
abbey session

Helper scripts may use hyphenated names when appropriate.

Examples:

abbey-doctor
abbey-git-sync
abbey-new-tool

⸻

Journal Entries

Journal entries are stored under:

content/journal/YYYY/

Filename format:

YYYY-MM-DD-short-title.md

Example:

2026-07-05-documentation-day.md

Use lowercase words separated by hyphens.

⸻

Documentation Files

Documentation files should use uppercase descriptive names when they are major reference or guide documents.

Examples:

GETTING_STARTED.md
ARCHITECTURE.md
DOCUMENTATION.md
PROJECT_STATUS.md
BACKLOG.md
ROADMAP.md

Generated documentation may use lowercase names.

Examples:

servers.md
containers.md
services.md
network.md

⸻

Directories

Directory names should be lowercase.

Examples:

docs/
content/
ansible/
tools/
scripts/

Use singular names when the directory represents a category.

Examples:

guide/
reference/
planning/
generated/

⸻

Ansible Roles

Ansible role names should be lowercase and descriptive.

Examples:

common
docker
homepage
motd
issue
time
labtest

⸻

Playbooks

Playbook names should be lowercase and descriptive.

Examples:

site.yml
update.yml
facts.yml
docker.yml

⸻

Docker Containers

Docker container names should clearly describe the service they run.

Examples:

homepage
portainer
uptime-kuma
nginx-proxy-manager
open-webui

⸻

Commit Messages

Commit messages should be short, direct, and describe the completed change.

Good examples:

Establish Abbey Root documentation framework
Add journal tag reference
Improve Abbey toolkit help output
Update Homepage service metadata

Avoid vague messages such as:

updates
fix stuff
changes
more docs

⸻

Future Automation

Future Abbey toolkit commands may validate naming patterns for:

* Journal files
* Documentation files
* Toolkit commands
* Generated documentation
* Ansible roles
* Playbooks
