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

### `abbey session`

Start and review Abbey Root work sessions.

**Usage**

```text
abbey session [command]
```

**Subcommands**

- `context` - Generate an upload-ready session context file.
  - `abbey session context [--stdout | --output FILE]`
- `review` - Review a selected session update or the oldest unreviewed update with Codex.
  - `abbey session review [file]`
- `start` - Show Abbey session startup information.
  - `abbey session`

**Examples**

```text
abbey session
abbey session context
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

