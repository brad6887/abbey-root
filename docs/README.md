Abbey Root Documentation

Welcome to the Abbey Root documentation.

Abbey Root is an AI-assisted Infrastructure-as-Code home lab focused on learning, automation, documentation, and technical publishing. The documentation is organized by purpose to make information easy to find, maintain, and automate.

Whether you’re learning how the platform works, looking for operational guidance, or exploring the project’s current status, this documentation is intended to guide you to the appropriate location.

⸻

Start Here

If you are new to Abbey Root, read these documents in order.

* Getting Started
* Architecture
* Environment Overview
* Session Workflow
* Documentation Standards

These guides provide the foundation for understanding the project.

⸻

Planning

Planning documents describe the current state of the project and its future direction.

* Project Status
* Next
* Backlog
* Roadmap
* Ideas

⸻

Reference

Reference documents describe the current environment and project standards.

* Hardware
* Backups
* Backup Strategy
* External Services

Additional reference documentation will be added as the project evolves.

⸻

Runbooks

Runbooks provide repeatable operational procedures.

* Network Interface Migration

⸻

Generated Documentation

The following documents are generated automatically from project metadata and should not be edited manually.

Environment

* Lab Summary
* Architecture
* Servers
* Inventory
* Network

Services

* Services
* Containers

Automation

* Automation
* Abbey Commands

If generated documentation is incorrect, update the automation that produces it rather than editing the generated files.

⸻

Architecture Decision Records

Architecture Decision Records (ADRs) document significant design decisions made throughout the project’s development.

The adr/ directory will contain records describing:

* The problem being solved
* The decision that was made
* Alternatives that were considered
* The reasoning behind the decision

⸻

Project Journal

The historical record of Abbey Root is maintained under:

content/journal/

Journal entries document:

* Accomplishments
* Lessons learned
* Design decisions
* Problems encountered
* Future ideas

The journal serves as the long-term history of the project and provides the source content for BradCooke.com.

⸻

Regenerating Documentation

Generated documentation can be rebuilt from the repository root:

./scripts/ansible-docs.sh

⸻

Documentation Principles

Abbey Root documentation follows several guiding principles:

* Automate whenever possible.
* Maintain a single source of truth.
* Keep documentation current.
* Prefer small, focused documents.
* Write for both people and AI.
* Record significant architectural decisions.
* Preserve the project’s history through journal entries.

Additional documentation standards are described in:

* Documentation Standards
