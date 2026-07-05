Session Workflow

Purpose

Abbey Root development follows a consistent workflow to ensure that infrastructure, documentation, planning, and project history remain synchronized.

Using the same workflow for every session reduces context switching, improves documentation quality, and makes it easier to automate repetitive tasks.

The long-term goal is for much of this workflow to be managed through the Abbey developer toolkit.

⸻

Guiding Principles

Every development session should:

* Begin with an understanding of the current project state.
* Focus on one primary objective.
* Keep documentation current.
* Record significant accomplishments.
* Leave the repository in a clean, reproducible state.

⸻

Start of Session

Before beginning development:

1. Synchronize the Repository

Synchronize the local repository with the remote repository.

Confirm:

* Git repository is healthy.
* Working tree is clean.
* Current branch is correct.

⸻

2. Review Project Status

Review the current planning documents.

At minimum:

* planning/PROJECT_STATUS.md
* planning/NEXT.md

Review the most recent journal entry if additional context is needed.

⸻

3. Select a Session Theme

Each development session should have a primary focus.

Examples include:

* Documentation Day
* Automation Day
* Website Development
* AI Development
* Infrastructure
* Networking
* Docker
* Ansible

A clearly defined theme helps maintain focus and provides context for future journal entries.

⸻

4. Define Session Goals

Identify one primary objective and any secondary objectives.

Examples:

Primary:

* Improve documentation.

Secondary:

* Update planning documents.
* Refactor toolkit commands.
* Publish a journal entry.

⸻

During the Session

Development should proceed in small, logical steps.

Recommended practices include:

* Commit related work together.
* Avoid unrelated changes.
* Update documentation alongside code.
* Record lessons learned while they are fresh.
* Prefer automation over manual processes.
* Keep generated documentation out of manual edits.

When project direction changes, update the appropriate planning documents rather than relying on memory.

⸻

Documentation

Documentation is maintained continuously rather than at the end of a project.

Examples include:

* Architecture changes
* New workflows
* Operational procedures
* Design decisions
* Planning updates

Documentation should evolve alongside the project.

⸻

Journal Entries

Create a journal entry whenever a session includes meaningful progress.

Typical journal entries summarize:

* Work completed
* Problems encountered
* Lessons learned
* Design decisions
* Follow-up work

Journal entries should describe the session rather than every command that was executed.

⸻

End of Session

Before ending development:

Review Documentation

Confirm documentation reflects completed work.

Examples include:

* Planning documents
* Guides
* Runbooks
* Reference documentation

⸻

Review Planning

Update planning documents if priorities have changed.

Common updates include:

* PROJECT_STATUS
* NEXT
* BACKLOG
* ROADMAP

⸻

Validate the Environment

Run project validation tools as appropriate.

Examples include:

* Abbey Doctor
* Website build
* Ansible syntax checks
* Other project-specific validation

⸻

Commit Changes

Create a commit that represents a single logical unit of work.

Commit messages should clearly describe the completed work.

⸻

Push Changes

Synchronize the completed work with the remote repository.

The goal is for the remote repository to accurately reflect the current project state.

⸻

Future Automation

The Abbey developer toolkit will gradually automate much of this workflow.

Planned capabilities include:

Session Start

Future abbey session functionality may include:

* Synchronize Git
* Verify repository health
* Review planning documents
* Display project status
* Suggest next work items
* Create a session summary

⸻

Session End

Future abbey close functionality may include:

* Validate project health
* Review documentation updates
* Generate journal templates
* Suggest commit messages
* Build the website
* Run health checks
* Push completed work

⸻

Continuous Improvement

The workflow itself is expected to evolve.

As Abbey Root grows, repetitive tasks should be identified, documented, and eventually automated through the Abbey developer toolkit.

The objective is not simply to complete work, but to continuously improve the process used to complete that work.
