Directory Layout

Purpose

This document describes the organization of the Abbey Root repository.

The repository is organized so that each top-level directory has a single responsibility. This makes the project easier to understand, automate, maintain, and extend.

Whenever possible, related files should be grouped together rather than scattered throughout the repository.

⸻

Repository Overview

The repository is organized into several major areas.

abbey-root/
├── ansible/
├── content/
├── docs/
├── scripts/
├── site/
├── tools/
└── ...

Each directory has a specific purpose.

⸻

ansible/

The ansible/ directory contains Infrastructure-as-Code for the lab.

Typical contents include:

* Inventory
* Playbooks
* Roles
* Group variables
* Host variables
* Templates
* Files

This directory is the primary source of truth for infrastructure automation.

⸻

content/

The content/ directory contains Markdown content used by BradCooke.com.

Examples include:

* Journal entries
* Project pages
* Future articles

Content should be written in Markdown whenever practical.

The journal under content/journal/ serves as the historical record of Abbey Root.

⸻

docs/

The docs/ directory contains project documentation.

Documentation is organized by purpose.

guide/

Guides explain how Abbey Root works.

Examples:

* Getting Started
* Architecture
* Environment Overview
* Session Workflow
* Documentation Standards

Guide documents answer:

How does this work?

⸻

planning/

Planning documents describe the current and future state of the project.

Examples:

* Project Status
* Next
* Backlog
* Roadmap
* Ideas

Planning documents are living documents and change regularly.

⸻

reference/

Reference documents contain factual information about the project.

Examples:

* Hardware
* Backup Strategy
* External Services
* Naming Standards
* Tags
* Directory Layout

Reference documents answer:

What exists?

⸻

runbooks/

Runbooks describe repeatable operational procedures.

Examples include:

* Recovery procedures
* Network changes
* Infrastructure maintenance
* Upgrade procedures

Runbooks should provide step-by-step instructions.

⸻

generated/

Generated documentation is produced automatically by Abbey Root tooling.

Examples include:

* Servers
* Services
* Containers
* Network
* Automation
* Command reference

Generated documentation should never be edited manually.

⸻

adr/

Architecture Decision Records (ADRs) preserve important design decisions.

Each ADR documents:

* The problem
* The decision
* Alternatives considered
* The reasoning behind the decision

⸻

scripts/

The scripts/ directory contains standalone helper scripts.

Scripts generally perform individual tasks and may be called manually or by automation.

Where practical, new functionality should be exposed through the Abbey toolkit instead of requiring users to execute scripts directly.

⸻

site/

The site/ directory contains the BradCooke.com website.

The website is built using Astro and publishes:

* Project pages
* Journal entries
* Technical documentation

The site consumes Markdown content from the repository and generates the public website.

⸻

tools/

The tools/ directory contains the Abbey developer toolkit.

The toolkit provides a consistent command-line interface for interacting with the project.

Examples include:

* Project health checks
* AI integration
* Documentation generation
* Journal creation
* Workflow automation

The long-term goal is for the toolkit to become the primary interface for working with Abbey Root.

⸻

Organization Principles

The repository follows several organizational principles.

Single Responsibility

Each directory should have one clear purpose.

⸻

Predictable Locations

Information should have one obvious location.

Avoid storing similar information in multiple places.

⸻

Single Source of Truth

Each type of information should have one authoritative source.

Generated information should be derived from that source rather than duplicated.

⸻

Documentation Alongside Development

Documentation should evolve together with the code.

Significant changes to architecture, workflows, or infrastructure should be reflected in the appropriate documentation.

⸻

Automation First

Whenever practical, repetitive tasks should be automated.

Repository organization should support automation rather than complicate it.

⸻

Future Growth

As Abbey Root evolves, additional directories may be introduced.

New directories should only be added when they represent a distinct responsibility that cannot reasonably fit within the existing structure.

Maintaining a simple and consistent repository layout is preferred over creating deeply nested or highly specialized directory structures.
