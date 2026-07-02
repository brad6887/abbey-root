# Project-Aware Developer Environment

**Status:** Emerging direction

This concept became more concrete after the Abbey Root developer toolkit was standardized into standalone executable tools, Ansible-managed shell configuration, and auto-generated command documentation.

---

## Long-Term Vision

Transform the Abbey Root developer toolkit into a project-aware command-line environment.

Instead of only reporting infrastructure status, tools such as `abbey-status` should understand the current state of the project and guide development.

---

## Potential Capabilities

### Project Awareness

- Display the current roadmap phase.
- Display the active milestone.
- Count open backlog items.
- Suggest the next recommended task.
- Show the most recent journal entry.
- Summarize recent accomplishments.

### Infrastructure Awareness

- Report Git repository status.
- Display infrastructure health.
- Display Docker service status.
- Report documentation coverage.
- Report website build status.
- Detect inconsistencies between sources of truth.

### Developer Toolkit

- Generate `abbey-help` automatically from tool metadata.
- Generate command documentation from tool metadata.
- Validate toolkit consistency.
- Report missing documentation or metadata.
- Verify required development tools are installed.
- Detect stale generated documentation.

### Publishing Platform

- Show unpublished content.
- Display the latest generated pages.
- Validate site navigation.
- Detect missing front matter or metadata.
- Report website build status.

---

## Daily Workflow

A typical development session would become:

```text
abbey
abbey-status
```

Rather than remembering where work stopped, the project itself should communicate:

- where work stopped
- what changed since the last session
- what should be done next
- whether the environment is healthy
- whether documentation is current

---

## Long-Term Goal

Abbey Root should evolve into a **self-documenting**, **self-validating**, **project-aware** development environment rather than simply a collection of scripts.

The environment should continuously reduce the amount of project context the developer needs to remember, allowing work to resume quickly even after days or weeks away from the project.
