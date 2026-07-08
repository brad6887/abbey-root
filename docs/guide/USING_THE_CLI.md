# Using the Abbey CLI

## Purpose

The Abbey command-line interface (`abbey`) is the primary way to interact with the project.

Rather than remembering dozens of scripts, file locations, and procedures, the CLI provides a consistent entry point for common engineering tasks.

Think of the CLI as the front door to the project.

---

# The Philosophy

The CLI exists to simplify common workflows.

Instead of asking:

> "Where is the script that does this?"

the goal is to ask:

> "What am I trying to accomplish?"

As the project grows, new capabilities should be added to the CLI so the user experience remains consistent.

---

# Discovering Commands

If you're unsure what commands are available, start with:

```bash
abbey help
```

This displays the available commands grouped by purpose.

To learn more about the current project state:

```bash
abbey status
```

To verify your environment:

```bash
abbey doctor
```

To identify the current version of the project:

```bash
abbey version
```

---

# Starting a Development Session

Every engineering session should begin with:

```bash
abbey session
```

This command provides:

* Current repository status
* Planning document reminders
* Session workflow
* Suggested next steps

If you only remember one command, remember `abbey session`.

---

# Universal Commands

Every Abbey-style project is expected to provide a common set of commands.

These commands should have the same meaning regardless of the project.

| Command    | Purpose                                           |
| ---------- | ------------------------------------------------- |
| `help`     | Discover available commands.                      |
| `version`  | Identify the project and framework version.       |
| `status`   | Show the current state of the project.            |
| `doctor`   | Validate the project and development environment. |
| `session`  | Begin a structured engineering session.           |
| `build`    | Generate project artifacts.                       |
| `validate` | Verify project structure and consistency.         |
| `publish`  | Publish project outputs.                          |

Learning these commands makes it easier to move between Abbey-style repositories.

---

# Project-Specific Commands

Projects can add their own commands without changing the meaning of the universal commands.

For example:

* Abbey Root includes commands for AI, knowledge management, and website publishing.
* Power Infrastructure adds commands for requests, playbooks, reports, and operational workflows.

This allows every project to extend the framework while maintaining a familiar developer experience.

---

# Command Discovery

The CLI is metadata-driven.

Command descriptions, categories, examples, and generated documentation all come from a single source of truth.

This means:

* Help output stays consistent.
* Documentation stays synchronized.
* Adding a new command requires updating metadata in one place.

The CLI should always be easier to use than searching through the repository for scripts.

---

# Daily Workflow

A typical development session looks like this:

```text
abbey session
       ↓
abbey status
       ↓
Build
       ↓
Validate
       ↓
Document
       ↓
Commit
```

Most developers will use only a handful of commands during a typical session, with project-specific commands used as needed.

---

# The Goal

The CLI is more than a collection of scripts.

It is the primary interface between the developer and the project.

As Abbey evolves, new capabilities should be added through the CLI whenever practical so that every Abbey-style project remains familiar, discoverable, and easy to use.

