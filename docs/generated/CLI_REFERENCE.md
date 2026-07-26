# Abbey Root CLI Reference

*Generated automatically from `config/cli/cli.yml`. Do not edit directly.*

## Overview

Abbey Root Toolkit

AI-assisted infrastructure lab and reusable project framework.

```text
abbey <command> [options]
```

## Core CLI

### `abbey doctor`

Run repository and environment health checks.

**Usage**

```text
abbey doctor
```

**Examples**

```text
abbey doctor
```

### `abbey help`

Show Abbey Root CLI help.

**Usage**

```text
abbey help
```

**Examples**

```text
abbey help
```

### `abbey status`

Show local system and project status.

**Usage**

```text
abbey status
```

**Examples**

```text
abbey status
```

### `abbey version`

Show project version and framework information.

**Usage**

```text
abbey version
```

**Examples**

```text
abbey version
```

## Workflow

### `abbey backlog`

Maintain generated backlog completion statistics.

**Usage**

```text
abbey backlog <command>
```

**Subcommands**

- `check` - Verify that generated backlog statistics are current.
  - `abbey backlog check`
- `refresh` - Refresh generated complete, pending, and total counts.
  - `abbey backlog refresh`

**Examples**

```text
abbey backlog refresh
abbey backlog check
```

### `abbey end`

Certify that the current Abbey session is complete.

**Usage**

```text
abbey end
```

**Examples**

```text
abbey end
```

### `abbey journal`

Create or open an Abbey Root journal entry.

**Usage**

```text
abbey journal <title>
```

**Examples**

```text
abbey journal "Architecture Framework Introduced"
```

### `abbey next`

Recommend the next focused Abbey engineering session.

**Usage**

```text
abbey next
```

**Examples**

```text
abbey next
```

### `abbey review`

Review the current Abbey session before commit.

**Usage**

```text
abbey review
```

**Examples**

```text
abbey review
```

### `abbey session`

Start and review Abbey Root work sessions.

**Usage**

```text
abbey session [command]
```

**Subcommands**

- `capture` - Create or resume the session update and journal entry together.
  - `abbey session capture [--title TITLE] <slug>`
- `context` - Generate an upload-ready session context file.
  - `abbey session context [--stdout | --output FILE]`
- `review` - Review a selected session update or the oldest unreviewed update with Codex.
  - `abbey session review [file]`
- `start` - Show Abbey session startup information.
  - `abbey session`
- `update` - Create a session update from the standard repository template.
  - `abbey session update [--title TITLE] <slug>`

**Examples**

```text
abbey session
abbey session context
abbey session update abbey-ai-decision-help
abbey session capture guided-session-capture-workflow
abbey session review
abbey session review docs/session-updates/2026-07-10-doctor-robert-plant-publishing-workflow.md
```

## AI and knowledge

### `abbey ai`

Start Abbey AI helper commands.

**Usage**

```text
abbey ai <command>
```

**Examples**

```text
abbey ai
```

### `abbey context`

Build or inspect Abbey AI context.

**Usage**

```text
abbey context <command>
```

**Examples**

```text
abbey context
```

### `abbey knowledge`

Build and view Abbey knowledge context.

**Usage**

```text
abbey knowledge <command>
```

**Examples**

```text
abbey knowledge build
```

## Structured research

### `abbey research`

Run structured research workflows and inspect formal research artifacts.

**Usage**

```text
abbey research <command>
```

**Subcommands**

- `discover` - Run resumable observation discovery across deterministic corpus batches.
  - `abbey research discover --model MODEL --prompt FILE --corpus FILE --batch-manifest FILE --output-dir DIR [--resume]`
- `status` - Report formal research artifact relationships and chain status.
  - `abbey research status`
- `validate-discovery` - Validate a batch discovery manifest and exact corpus citations.
  - `abbey research validate-discovery --manifest FILE --corpus FILE --batch FILE`
- `validate-review` - Validate a machine-readable review manifest and exact corpus citations.
  - `abbey research validate-review --manifest FILE --corpus FILE`
- `voice` - Apply VOICE-MODEL-001 through an approved Facebook fact lock.
  - `abbey research voice apply --model MODEL --fact-lock FILE --output FILE --report FILE`

**Examples**

```text
abbey research --help
abbey research run --help
abbey research validate-review --manifest FILE --corpus FILE
abbey research validate-discovery --manifest FILE --corpus FILE --batch FILE
abbey research discover --model MODEL --prompt FILE --corpus FILE --batch-manifest FILE --output-dir DIR --resume
abbey research status
```

## Lab infrastructure

### `abbey lab`

Inspect and manage Abbey Root lab infrastructure.

**Usage**

```text
abbey lab <command>
```

**Subcommands**

- `check` - Run read-only health checks against managed lab hosts.
  - `abbey lab check`

**Examples**

```text
abbey lab check
```

### `abbey ssh`

Audit and synchronize SSH public keys across managed Abbey nodes.

**Usage**

```text
abbey ssh <command>
```

**Subcommands**

- `audit` - Report node public-key authorization across managed hosts.
  - `abbey ssh audit [--limit HOST_OR_GROUP]`
- `sync` - Synchronize Abbey node public keys through a managed authorized_keys block.
  - `abbey ssh sync [--check] [--limit HOST_OR_GROUP]`

**Examples**

```text
abbey ssh audit
abbey ssh sync --check
abbey ssh sync
abbey ssh sync --limit edge01
```

## Website

### `abbey site`

Build, run, and publish the BradCooke.com website.

**Usage**

```text
abbey site <command>
```

**Subcommands**

- `build` - Build the Astro production site.
  - `abbey site build`
- `publish` - Build and publish the site to GitHub Pages.
  - `abbey site publish [--dry-run]`
- `restart` - Restart the Astro development server.
  - `abbey site restart`
- `start` - Start the Astro development server.
  - `abbey site start`
- `status` - Show the Astro development server status.
  - `abbey site status`
- `stop` - Stop the Astro development server.
  - `abbey site stop`

**Examples**

```text
abbey site build
abbey site publish --dry-run
abbey site publish
abbey site start
```

## Content management

### `abbey plant`

Manage, validate, and publish plant workspaces.

**Usage**

```text
abbey plant <command>
```

**Subcommands**

- `publish` - Generate Astro content and copy selected public images.
  - `abbey plant publish <slug>`
- `validate` - Validate a plant workspace against the Plant Model.
  - `abbey plant validate <slug>`

**Examples**

```text
abbey plant validate doctor-robert
abbey plant publish doctor-robert
```

