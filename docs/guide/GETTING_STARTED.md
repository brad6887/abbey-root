Getting Started

Welcome to Abbey Root.

This guide is the recommended starting point for understanding the project.

Abbey Root is more than a Linux lab. It is an AI-assisted Infrastructure-as-Code platform built to learn, experiment, automate, and document real-world systems through practical projects.

The long-term goal is to create an environment that can be reproduced, maintained, and continuously improved using Git, Ansible, Docker, automation, and AI.

⸻

Project Goals

Abbey Root exists to:

* Learn by building real systems.
* Automate repetitive work.
* Document knowledge as it is gained.
* Manage infrastructure through Infrastructure-as-Code.
* Experiment safely with new technologies.
* Build and maintain BradCooke.com.
* Explore AI-assisted development workflows.

Progress is valued over perfection.

The lab is intended to evolve continuously.

⸻

Repository Organization

The repository is organized into several major areas.

Documentation (docs/)

Project documentation is organized by purpose.

* guide/ — Learn how Abbey Root works.
* reference/ — Project facts, standards, and reference material.
* planning/ — Current priorities and long-term planning.
* runbooks/ — Step-by-step operational procedures.
* adr/ — Architecture Decision Records explaining important design choices.
* generated/ — Documentation produced automatically by project tooling.

⸻

Website (content/)

The website is built from Markdown content.

This includes:

* Journal entries
* Project pages
* Documentation content

The website serves as both a portfolio and the public history of the project.

⸻

Automation

Infrastructure automation is primarily managed through:

* Ansible
* Git
* Docker
* The Abbey developer toolkit

Whenever practical, automation is preferred over manual configuration.

⸻

Recommended Reading

New contributors should read the documentation in the following order.

1. README
2. This document
3. guide/DOCUMENTATION.md
4. planning/PROJECT_STATUS.md
5. planning/NEXT.md
6. guide/ENVIRONMENT_OVERVIEW.md

From there, explore additional guides or reference material as needed.

⸻

Development Workflow

A typical development session follows this process.

1. Synchronize the Git repository.
2. Review the current project status.
3. Review the current priorities.
4. Select a task.
5. Complete the work.
6. Update documentation.
7. Create a journal entry if appropriate.
8. Commit related changes together.
9. Push changes to the remote repository.

Future versions of Abbey Root will automate much of this workflow through the Abbey toolkit.

⸻

Project Philosophy

Several principles guide every decision made within Abbey Root.

* Learn by building.
* Prefer automation over repetition.
* Keep documentation current.
* Maintain a single source of truth.
* Rebuild rather than repair whenever practical.
* Favor open-source solutions.
* Use AI to enhance understanding rather than replace it.

These principles are applied consistently across infrastructure, automation, documentation, the developer toolkit, and the website.

⸻

Current Technologies

Abbey Root currently uses technologies including:

* Proxmox
* Linux
* Docker
* Ansible
* Git
* GitHub
* Astro
* Markdown
* Open WebUI
* Python
* Bash

Additional technologies will be introduced as the project evolves.

⸻

Staying Current

The best way to understand the current state of the project is to review:

* planning/PROJECT_STATUS.md
* planning/NEXT.md
* Recent journal entries under content/journal/

These documents reflect the project’s current direction and recent progress.

⸻

Contributing

When making changes to Abbey Root:

* Keep solutions simple.
* Prefer automation over manual processes.
* Avoid duplicating information.
* Update documentation alongside code.
* Record significant milestones in the project journal.
* Preserve the project’s philosophy of reproducibility and continuous learning.

Every improvement should make the platform easier to understand, maintain, automate, or rebuild.
