# CLI Standard

## Purpose

The CLI standard defines the command structure expected for Abbey-style repositories.

The goal is not for every project CLI to be identical. The goal is for every project CLI to feel familiar, predictable, and self-documenting.

A user who understands `abbey` should be able to understand `pwr`, and a future project CLI should follow the same basic model from the beginning.

## Principles

- Every project should provide a single top-level command.
- Every project CLI should be metadata-driven.
- Help output and CLI reference documentation should come from the same source of truth.
- Universal commands should mean the same thing across projects.
- Project-specific commands should extend the standard without changing the core model.
- Commands should support the session workflow and documentation lifecycle.

## Metadata

Each project should define CLI metadata in:

```text
config/cli/cli.yml
```

This file is the source of truth for:

- command names
- command categories
- descriptions
- usage examples
- aliases
- subcommands
- generated CLI documentation

Generated CLI documentation should be written to:

```text
docs/generated/CLI_REFERENCE.md
```

## Command Classes

### Universal Commands

Universal commands should exist in every Abbey-style project.

| Command | Purpose |
| ------- | ------- |
| `help` | Show command help and available workflows. |
| `version` | Show project version, branch, commit, and framework status. |
| `status` | Show current repository and project status. |
| `doctor` | Validate project installation and environment health. |
| `session` | Start a structured work session. |
| `build` | Build or regenerate project outputs. |
| `validate` | Validate project structure and required files. |
| `publish` | Publish project outputs, usually documentation. |

### Framework Commands

Framework commands are shared concepts that may apply to some projects.

| Command | Purpose |
| ------- | ------- |
| `workflow` | Run Workflow Engine commands. |
| `docs` | View or regenerate project documentation. |
| `knowledge` | Build or inspect AI knowledge context. |
| `context` | Build or inspect AI context inputs. |
| `ai` | Run AI helper workflows. |

### Project-Specific Commands

Project-specific commands belong to one repository or domain.

Examples:

| Project | Commands |
| ------- | -------- |
| Power Infrastructure | `request`, `playbook`, `report`, `service-review` |
| Website project | `content`, `theme`, `deploy` |
| Secret Shopper project | `shop`, `scheduler`, `earnings`, `report` |

Project-specific commands should not redefine the meaning of universal commands.

## Categories

Command categories should be used to group help output.

Common categories include:

| Category | Purpose |
| -------- | ------- |
| `core` | Basic CLI commands such as help, status, doctor, and version. |
| `workflow` | Session and workflow commands. |
| `build` | Build and validation commands. |
| `docs` | Documentation and publishing commands. |
| `ai` | AI and knowledge commands. |
| `automation` | Automation and playbook commands. |
| `reporting` | Reporting workflows. |
| `request` | Request lifecycle commands. |

Projects may add categories when needed, but should avoid unnecessary category drift.

## Naming Rules

- Use short, clear command names.
- Prefer nouns for command groups, such as `docs`, `workflow`, `request`, and `report`.
- Prefer verbs for actions inside command groups, such as `build`, `show`, `search`, `publish`, and `validate`.
- Use hyphenated names for multi-word commands, such as `service-review`.
- Avoid different names for the same concept across projects.
- Prefer subcommands when a command has multiple related actions.

## Help Output

The top-level help command should show:

- project name
- short project description
- usage pattern
- common commands grouped by category
- a reminder for command-specific help

Help output should be generated from CLI metadata.

## Generated CLI Reference

Every project should be able to generate a CLI reference document from the same metadata used for help output.

Expected output:

```text
docs/generated/CLI_REFERENCE.md
```

This file is generated content and should not be edited manually.

## Universal Command Expectations

### `status`

Shows current project state.

Expected information:

- repository path
- current branch
- remote status
- working tree status
- relevant project health summary

### `doctor`

Runs deeper validation.

Expected information:

- repository checks
- required commands
- required files and directories
- environment health
- project-specific checks

### `session`

Starts the standard work session.

Expected workflow:

```text
1. Review
2. Define
3. Build
4. Validate
5. Document
6. Capture
7. Commit
8. Review
```

### `version`

Shows project identity and framework state.

Expected information:

- project name
- version
- branch
- commit
- working tree state
- framework status

### `build`

Builds or regenerates project outputs.

Examples:

- generated documentation
- generated inventory
- generated reports
- website output
- CLI reference

### `validate`

Validates project structure and required files.

### `publish`

Publishes project outputs.

Examples:

```text
project publish docs
project publish site
```

## Implementation Notes

Abbey Root is the reference implementation.

Power Infrastructure is the first production implementation.

Future projects should begin with the same CLI structure even if many commands are simple placeholders at first.

The CLI should grow with the project, but the project should begin with a familiar command shape.
