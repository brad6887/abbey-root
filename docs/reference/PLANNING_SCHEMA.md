Planning Document Schema

Purpose

This document defines the structure of Abbey Root planning documents.

These documents are consumed by both humans and automation. Their structure should therefore remain stable over time.

The section headings defined in this document are considered part of the public interface used by the Abbey toolkit and future AI-assisted workflows.

Changing document structure should be treated as an interface change rather than a formatting change.

⸻

General Principles

Planning documents should be:

* Easy for people to read.
* Easy for automation to parse.
* Stable over time.
* Predictable in structure.
* Focused on facts rather than narrative.

⸻

Formatting Standards

Planning documents should follow these guidelines:

* Use Markdown.
* Use consistent heading levels.
* Prefer lists over long paragraphs.
* Keep section names stable.
* Avoid tables unless they provide significant value.
* Use one bullet style consistently.
* Prefer short, structured statements over lengthy prose.

⸻

PROJECT_STATUS.md

Purpose:

Provide a high-level snapshot of the current state of Abbey Root.

Required sections:

Project Snapshot
Current Session
Overall Status
Immediate Priorities
Infrastructure
Developer Toolkit
Website
AI Platform
Documentation
Recent Accomplishments
Current Challenges
Next Major Milestones
Project Metrics
Project Health

These section names should remain stable.

⸻

NEXT.md

Purpose:

Define the current priorities for upcoming work sessions.

Required sections:

Primary Goal
High Priority
Abbey Toolkit
BradCooke.com
Infrastructure
AI
Stretch Goals
Notes

⸻

BACKLOG.md

Purpose:

Maintain the inventory of known work that has not yet been scheduled.

Recommended sections:

High Priority
Infrastructure
Developer Toolkit
Self-Documenting Platform
BradCooke.com
AI
Automation
Communications
Abbey Doctor Ideas

Additional sections may be introduced when they represent long-term project areas.

⸻

ROADMAP.md

Purpose:

Describe major milestones rather than individual tasks.

Roadmap items should represent significant project goals instead of day-to-day work.

⸻

VISION.md

Purpose:

Describe the long-term architectural direction of Abbey Root.

This document should evolve slowly and capture enduring principles rather than short-term priorities.

⸻

IDEAS.md

Purpose:

Capture brainstorming ideas before they are evaluated.

Ideas may later move to:

IDEAS
    ↓
BACKLOG
    ↓
NEXT
    ↓
Completed
    ↓
Journal Entry

⸻

Journal Entries

Journal entries are historical records.

They should remain human-focused and are not considered machine-readable planning documents.

⸻

Generated Documentation

Generated documentation should never be edited manually.

Automation should regenerate these documents from authoritative metadata.

⸻

Future Automation

Future Abbey toolkit commands may rely on these schemas.

Examples include:

* abbey session
* abbey end
* abbey status
* abbey ai
* abbey doctor

These commands should assume section names remain stable while allowing document content to evolve.

⸻

Versioning

When planning document structures change:

* Update this document.
* Update any affected toolkit commands.
* Update AI prompts or automation that depend on the previous structure.

Treat structural changes as interface changes rather than documentation edits.

⸻

Philosophy

Planning documents are more than documentation.

They are structured interfaces between the developer, the Abbey toolkit, and future AI systems.

Stable schemas reduce complexity, simplify automation, and allow Abbey Root to become increasingly project-aware over time.
