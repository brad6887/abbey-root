# Start Here

Welcome to Abbey Root.

If this is your first time working with the project, this document will help you understand what Abbey Root is, how the project is organized, and how to begin a development session.

You do **not** need to understand every part of the repository before contributing. Abbey Root is designed so that the documentation and command-line tools guide you through the normal engineering workflow.

---

# What is Abbey Root?

Abbey Root is the reference implementation of the Abbey Framework.

It is both a working Linux home lab and a development platform for building reusable engineering practices, automation, documentation, AI-assisted workflows, and infrastructure tooling.

While Abbey Root is itself a functional project, its larger purpose is to develop ideas, workflows, and tools that can be reused by future projects.

Whenever practical, improvements made here should become part of the framework rather than remain one-off solutions.

---

# Your First Commands

Most development sessions begin with:

```bash
abbey session
```

This command summarizes the current state of the project and reminds you of the standard engineering workflow.

Other useful commands include:

```bash
abbey help
abbey status
abbey doctor
abbey version
```

If you are unsure what to do next, start with `abbey session`.

---

# The Engineering Workflow

Every development session follows the same general process.

1. Review the current project status.
2. Define one clear objective for the session.
3. Build the change.
4. Validate that it works.
5. Update the documentation.
6. Capture what was learned.
7. Commit a logical unit of work.
8. Review what should happen next.

Following the same workflow each session makes the project easier to understand and easier to maintain over time.

---

# Where to Find Information

The documentation is organized by purpose.

| Location                | Purpose                                                            |
| ----------------------- | ------------------------------------------------------------------ |
| `docs/guide/`           | Getting started and day-to-day usage.                              |
| `docs/planning/`        | Current project direction, roadmap, backlog, and next tasks.       |
| `docs/architecture/`    | How Abbey Root itself is designed and implemented.                 |
| `docs/framework/`       | Standards that define the Abbey Framework for all future projects. |
| `docs/reference/`       | Reference material about the environment.                          |
| `docs/runbooks/`        | Operational procedures and repeatable tasks.                       |
| `docs/generated/`       | Automatically generated documentation.                             |
| `docs/session-updates/` | Summaries of completed engineering sessions.                       |

If you're unsure where something belongs, ask whether it describes **what the project is trying to do**, **how it works**, **how to use it**, or **what happened during development**.

---

# The Philosophy

Abbey Root is built around a simple idea:

Every engineering improvement should make the next project easier to build.

Whenever you solve a problem, consider whether the solution should become part of the Abbey Framework so future projects benefit from it automatically.

The goal is not simply to complete projects, but to continually improve the engineering process used to build them.

---

# Where to Go Next

After reading this document:

1. Run `abbey session`.
2. Review `docs/planning/PROJECT_STATUS.md`.
3. Review `docs/planning/NEXT.md`.
4. Define a single objective for your session.
5. Begin building.

Welcome to Abbey Root.

