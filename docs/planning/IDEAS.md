# Project-Aware Developer Environment

**Status:** Active architectural direction

The Abbey Root developer toolkit has evolved from a collection of helper scripts into the foundation of a metadata-driven, project-aware development environment.

The long-term vision is to build an environment that not only automates infrastructure, but also understands the current state of the project and helps guide future work.

---

# Core Philosophy

The development environment should become another product of Abbey Root.

Rather than requiring the developer to remember project context, the environment should continuously provide it.

The toolkit should answer questions such as:

- Where did I leave off?
- What changed recently?
- What should I work on next?
- Is everything healthy?
- Is the documentation current?
- Is anything inconsistent?

---

# Design Principles

## Metadata First

Whenever practical, describe information once as structured metadata.

Generate documentation, interfaces, reports, and automation from that metadata rather than maintaining multiple independent copies.

## Single Source of Truth

Avoid duplicate configuration.

Whenever possible:

Metadata → Components → Documentation → Automation

should all originate from the same source.

## Learn by Building

The toolkit should encourage progress rather than perfection.

Every improvement should reduce manual work while increasing understanding.

---

# Potential Capabilities

## Project Awareness

- Display current roadmap phase.
- Display active milestone.
- Count open backlog items.
- Recommend the next task.
- Show recent accomplishments.
- Display latest journal entries.
- Highlight documentation requiring attention.

## Infrastructure Awareness

- Report Git repository status.
- Display infrastructure health.
- Report Docker service status.
- Validate Ansible inventory.
- Detect inconsistent metadata.
- Detect configuration drift.

## Developer Toolkit

- Auto-generate `abbey-help`.
- Generate command documentation.
- Validate toolkit consistency.
- Detect missing Purpose/Usage metadata.
- Verify required development tools.
- Detect stale generated documentation.
- Create new tools from templates.

## Website Awareness

- Report website build status.
- Show unpublished content.
- Detect missing metadata.
- Validate navigation.
- Report broken internal links.
- Detect missing project pages.
- Validate collections.

## AI Awareness

Future ai-worker01 responsibilities may include:

- Session summaries.
- Suggested next tasks.
- Weekly project recap.
- Documentation review.
- Metadata suggestions.
- Project historian.
- AI-assisted publishing.

---

# Daily Workflow

A normal development session should eventually become:

```text
abbey
abbey-status
```

followed by a summary similar to:

```text
Abbey Root

Project
--------
Phase: Publishing Platform
Current Focus:
• BradCooke.com
• Abbey Root

Recent Changes
--------------
✓ 3 commits
✓ 2 pages updated
✓ Documentation current

Recommended Next Task
---------------------
Create the Power Infrastructure project page.

Infrastructure
--------------
✓ Git clean
✓ Documentation current
✓ Website builds successfully
✓ All hosts reachable

AI Notes
--------
Last session:
- Added ProjectHeader.
- Added ProjectCard.
- Improved Home page.
```

The goal is to eliminate the need to remember project context between work sessions.

---

# Long-Term Vision

Abbey Root should evolve into a:

- self-documenting platform
- self-validating platform
- project-aware development environment
- AI-assisted publishing platform
- continuous learning platform

Every improvement should reduce cognitive overhead while preserving understanding.

The environment should help answer questions, suggest work, validate changes, and document progress without replacing the developer's judgment.

Ultimately, Abbey Root should become a system that helps build itself.
