Project Standards

Purpose

This document defines the general standards used throughout Abbey Root.

The goal is to ensure the project remains consistent, maintainable, reproducible, and easy to understand as it grows.

Where possible, these standards should be implemented through automation rather than relying on manual enforcement.

⸻

General Principles

Abbey Root follows several guiding principles.

* Learn by building.
* Automate repetitive work.
* Maintain a single source of truth.
* Document significant decisions.
* Rebuild rather than repair whenever practical.
* Prefer simple solutions over unnecessary complexity.
* Use AI to assist rather than replace understanding.

⸻

Documentation

Documentation is considered part of the project, not an afterthought.

Documentation should:

* Be updated alongside code.
* Have a clear owner.
* Avoid duplicate information.
* Be concise and focused.
* Explain why as well as how.

Generated documentation should never be edited manually.

⸻

Automation

Automation is preferred whenever work becomes repetitive.

Examples include:

* Infrastructure deployment
* Documentation generation
* Validation
* Health checks
* Developer workflows

Manual procedures should be candidates for future automation.

⸻

Infrastructure

Infrastructure should be reproducible.

Configuration should be managed through:

* Git
* Ansible
* Templates
* Variables

Manual configuration should be minimized whenever practical.

⸻

Git

Git is the authoritative source for the project.

General expectations:

* Commit logical units of work.
* Keep the main branch in a working state.
* Write descriptive commit messages.
* Commit documentation with related code changes whenever appropriate.

⸻

Commit Messages

Commit messages should:

* Describe what changed.
* Use clear language.
* Represent one logical unit of work.

Examples:

* Establish Abbey Root documentation framework
* Add session workflow guide
* Improve Abbey toolkit help output
* Generate Homepage documentation

Avoid generic messages such as:

* Updates
* Fixes
* More changes
* Miscellaneous

⸻

Documentation Workflow

Significant work should normally include:

* Documentation updates
* Planning updates (if priorities changed)
* Journal entry (when appropriate)

Documentation should evolve with the project rather than being deferred until later.

⸻

Journal Entries

Journal entries record meaningful progress.

Each entry should summarize:

* Accomplishments
* Problems encountered
* Lessons learned
* Design decisions
* Follow-up work

Journal entries should use the approved tag vocabulary documented in reference/TAGS.md.

⸻

Generated Content

Generated files should be treated as build artifacts.

If generated output is incorrect:

* Fix the source.
* Regenerate the output.

Do not manually edit generated documentation.

⸻

AI Integration

AI is an important component of Abbey Root.

AI should be used to:

* Explain concepts
* Generate documentation
* Assist with scripting
* Review designs
* Suggest improvements
* Reduce repetitive work

Final technical decisions remain the responsibility of the developer.

⸻

Continuous Improvement

Abbey Root is expected to evolve continuously.

Whenever a process becomes repetitive, difficult to remember, or prone to error, it should be considered for documentation, standardization, or automation.

The long-term objective is to build a platform that becomes easier to maintain, easier to understand, and easier to rebuild with every iteration.
