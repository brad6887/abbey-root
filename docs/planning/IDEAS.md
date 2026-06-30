## Project-Aware Developer Environment

Long-term vision:

Transform the Abbey Root developer toolkit into a project-aware command-line environment.

Instead of only reporting infrastructure status, tools such as abbey-status should understand the current state of the project.

Potential capabilities include:

- Display the current roadmap phase.
- Display the active milestone.
- Count open backlog items.
- Suggest the next recommended task.
- Show the most recent journal entry.
- Summarize recent accomplishments.
- Report Git repository status.
- Display infrastructure health.
- Display Docker service status.
- Report documentation coverage.
- Report website build status.
- Detect inconsistencies between sources of truth.

The objective is to make returning to Abbey Root after several days or weeks effortless.

A typical workflow would become:

abbey
 abbey-status 

The project itself should communicate:

- where work stopped
- what has changed
- what should be done next

The long-term goal is for Abbey Root to become a self-documenting, project-aware development environment rather than simply a collection of scripts.
