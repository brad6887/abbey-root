Documentation Standards

Purpose

Documentation is a first-class component of Abbey Root.

Its purpose is to:

* Preserve knowledge.
* Explain how the platform works.
* Record project history.
* Guide future development.
* Enable automation and AI assistance.
* Allow the entire lab to be recreated from documentation and source control.

Documentation should always make the project easier to understand, maintain, and rebuild.

⸻

Documentation Principles

The following principles guide all documentation within Abbey Root.

Automate Whenever Possible

If information can be generated automatically, it should be.

Examples include:

* Host inventory
* Docker container inventory
* Ansible roles
* Playbook lists
* Toolkit command reference
* Service inventory

Generated documentation should never be edited manually.

If generated documentation is incorrect, fix the code that produces it rather than editing the generated file.

⸻

Write Only What Automation Cannot

Documentation should focus on information that cannot be discovered automatically.

Examples include:

* Design decisions
* Architecture
* Workflows
* Lessons learned
* Project goals
* Future plans
* Operational procedures

⸻

One Source of Truth

Every piece of information should have a single authoritative location.

Avoid duplicating the same information across multiple documents.

Instead, reference the authoritative document whenever possible.

⸻

Keep Documentation Current

Documentation is updated as part of normal development.

Every significant project session should include a documentation review before completion.

⸻

Prefer Small Documents

Each document should have a clear purpose.

It is better to have several focused documents than one large document covering unrelated topics.

⸻

Write for Future Readers

Documentation should assume the reader may have no prior knowledge of the project.

Every document should answer one primary question.

Examples:

* How does this work?
* Why was this chosen?
* What is currently deployed?
* What should be worked on next?

⸻

Documentation Structure

Guide

The guide/ directory explains how Abbey Root works.

Typical topics include:

* Getting Started
* Architecture
* Daily Workflow
* Session Workflow
* AI Integration
* Docker
* Ansible
* Website
* Documentation Standards

Guide documents explain how something works.

⸻

Reference

The reference/ directory contains factual information.

Examples include:

* Naming standards
* Directory layout
* Network information
* Command reference
* Tag vocabulary

Reference documents answer what exists.

⸻

Planning

The planning/ directory contains active project planning.

Current planning documents include:

* PROJECT_STATUS
* NEXT
* BACKLOG
* ROADMAP
* IDEAS

These documents are living documents and change regularly.

⸻

Journal

The journal/ directory records the project’s history.

Each journal entry captures:

* Work completed
* Problems encountered
* Lessons learned
* Future ideas
* Significant milestones

Journal entries are never rewritten except to correct factual errors.

They represent the project’s historical record.

⸻

Generated

The generated/ directory contains documentation produced automatically by Abbey Root tools.

These files are never edited manually.

⸻

Architecture Decision Records (ADR)

The adr/ directory records significant architectural decisions.

Each ADR explains:

* The problem
* The decision
* Alternatives considered
* Why the chosen solution was selected

These records preserve project reasoning for future reference.

⸻

Documentation Workflow

Start of Session

Before beginning work:

* Synchronize the Git repository.
* Verify the working tree is clean.
* Review PROJECT_STATUS.
* Review NEXT.
* Review the most recent journal entry.
* Determine the goals for the session.

Future versions of Abbey Root will automate this workflow.

⸻

During Development

As work progresses:

* Update planning documents if priorities change.
* Record significant discoveries.
* Capture lessons learned.
* Document reusable procedures.

⸻

End of Session

Before ending a work session:

* Update documentation affected by the work completed.
* Create a journal entry summarizing the session.
* Review PROJECT_STATUS if project status changed.
* Review NEXT if priorities changed.
* Commit related changes together.
* Push changes to the remote repository.

⸻

Journal Standards

Journal entries should document:

* What was accomplished
* Why the work was performed
* Problems encountered
* Solutions implemented
* Lessons learned
* Planned follow-up work

Journal entries should describe decisions and progress rather than every individual command that was executed.

⸻

Journal Tags

Journal entries use a controlled vocabulary.

Current tags include:

* AI
* Ansible
* Automation
* Backup
* Docker
* Documentation
* Git
* Hardware
* Homepage
* Infrastructure
* Linux
* Networking
* Proxmox
* Project Management
* Security
* Website

Each journal entry should normally include three to five relevant tags.

⸻

AI Integration

Abbey Root is designed to work alongside AI assistants.

Project documentation should provide sufficient context for an AI assistant to:

* Understand the project’s current state.
* Recommend next tasks.
* Generate documentation.
* Assist with troubleshooting.
* Explain architecture.
* Produce code and automation.

Documentation should be written for both human readers and AI systems.

⸻

Long-Term Vision

The long-term goal is for Abbey Root to become largely self-documenting.

Automation should generate factual information whenever possible, while human-written documentation focuses on design, reasoning, experience, and project direction.

The ultimate objective is for a new user to clone the repository, read the documentation, and understand not only what Abbey Root is, but also how it is built, why it was designed that way, and how to continue developing it.
