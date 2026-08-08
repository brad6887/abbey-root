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

### `abbey init`

Create a new Abbey project from the default template.

**Usage**

```text
abbey init PATH [--name NAME] [--description TEXT] [--journal-policy POLICY] [--dry-run] [--yes] [--no-git]
```

**Examples**

```text
abbey init bread-pitt --name "Bread Pitt" --yes
abbey init notes --journal-policy optional --yes
```

### `abbey project`

Show the resolved active project and configuration context.

**Usage**

```text
abbey project show [--project PATH] [--config PATH]
```

**Subcommands**

- `show` - Show project, toolkit, and configuration resolution.
  - `abbey project show [--project PATH] [--config PATH]`

**Examples**

```text
abbey project show
abbey project show --config .abbey/image-roles.yml
```

### `abbey status`

Show local system, repository, and project metrics.

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
abbey next [init]
```

**Examples**

```text
abbey next
abbey next init
```

### `abbey review`

Review the current Abbey session and recurring review workflows.

**Usage**

```text
abbey review [recurring [--due | run REVIEW]]
```

**Examples**

```text
abbey review
abbey review recurring
abbey review recurring --due
abbey review recurring run documentation-audit
```

### `abbey session`

Start and review Abbey Root work sessions.

**Usage**

```text
abbey session [command]
```

**Subcommands**

- `capture` - Create or resume session artifacts using one resolved slug.
  - `abbey session capture --title TITLE [--slug SLUG]`
- `context` - Generate an upload-ready session context file.
  - `abbey session context [--stdout | --output FILE]`
- `review` - Review a selected session update or the oldest unreviewed update with Codex.
  - `abbey session review [file]`
- `start` - Show Abbey session startup information.
  - `abbey session`
- `update` - Create a session update with a title-derived or explicitly overridden slug.
  - `abbey session update --title TITLE [--slug SLUG]`

**Examples**

```text
abbey session
abbey session context
abbey session update --title "Abbey AI Decision Help"
abbey session capture --title "Guided Session Capture Workflow"
abbey session review
abbey session review docs/session-updates/2026-07-10-doctor-robert-plant-publishing-workflow.md
```

## Documentation

### `abbey docs`

Generate and verify deterministic project documentation.

**Usage**

```text
abbey docs <command>
```

**Subcommands**

- `check` - Verify tracked deterministic documentation without modifying it.
  - `abbey docs check`
- `generate` - Regenerate deterministic documentation from authoritative sources.
  - `abbey docs generate`

**Examples**

```text
abbey docs generate
abbey docs check
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

- `create` - Create a controlled, review-ready research candidate.
  - `abbey research create --project PROJECT --type observation --corpus CORPUS --experiment EXPERIMENT --model MODEL --prompt FILE [--input FILE ...]`
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
abbey research create --project voice-analysis --type observation --corpus CORPUS-001 --experiment EXP-001 --model gpt-oss:20b --prompt FILE --input FILE
abbey research run --help
abbey research validate-review --manifest FILE --corpus FILE
abbey research validate-discovery --manifest FILE --corpus FILE --batch FILE
abbey research discover --model MODEL --prompt FILE --corpus FILE --batch-manifest FILE --output-dir DIR --resume
abbey research status
```

## Lab infrastructure

### `abbey git`

Audit and synchronize Git configuration across managed hosts.

**Usage**

```text
abbey git <command>
```

**Subcommands**

- `audit` - Verify Git policy, repository remotes, and GitHub SSH access.
  - `abbey git audit [--limit HOST_OR_GROUP]`
- `sync` - Install Git policy and normalize existing repository checkouts.
  - `abbey git sync [--check] [--limit HOST_OR_GROUP]`

**Examples**

```text
abbey git audit
abbey git sync --check
abbey git sync --limit ubuntu-dev01
```

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

Build, run, and publish the active project's configured website.

**Usage**

```text
abbey site <command>
```

**Subcommands**

- `build` - Build or validate the configured site artifact.
  - `abbey site build`
- `publish` - Build and publish with explicit project-owned configuration.
  - `abbey site publish [--dry-run]`
- `restart` - Restart the Astro development server.
  - `abbey site restart`
- `start` - Start the Astro development server.
  - `abbey site start`
- `status` - Show the Astro development server status.
  - `abbey site status`
- `stop` - Stop the Astro development server.
  - `abbey site stop`
- `validate` - Validate configured media manifests and generated routes.
  - `abbey site validate`

**Examples**

```text
abbey site build
abbey site validate
abbey site publish --dry-run
abbey site publish
abbey site start
```

## Content management

### `abbey image`

Select images through fail-closed, project-owned content roles.

**Usage**

```text
abbey image <command>
```

**Subcommands**

- `select` - Select an image and assign it to a configured entity role.
  - `abbey image select <entity> <item> --role <role>`

**Examples**

```text
abbey image select plant martha-my-dear --role hero
```

### `abbey media`

Prepare project media through safe, configured workflows.

**Usage**

```text
abbey media <command>
```

**Subcommands**

- `publish` - Generate privacy-safe public derivatives from a named workflow.
  - `abbey media publish <workflow> [--dry-run]`
- `rename-exports` - Rename image/XMP pairs from captions and capture dates.
  - `abbey media rename-exports <directory> [--dry-run]`

**Examples**

```text
abbey media rename-exports ~/incoming/photos --dry-run
abbey media rename-exports ~/incoming/photos
abbey media publish starter_gallery --dry-run
abbey media publish starter_gallery
```

### `abbey plant`

Manage, validate, and publish plant workspaces.

**Usage**

```text
abbey plant <command>
```

**Subcommands**

- `hero` - Select the photograph assigned to a plant's hero role.
  - `abbey plant hero <slug>`
- `index` - Select the photograph used on plant index pages.
  - `abbey plant index <slug>`
- `new` - Create a plant workspace from the canonical template.
  - `abbey plant new <slug> --name NAME --type TYPE [--status STATUS] [--date YYYY-MM-DD] [--photo FILE ...]`
- `publish` - Generate Astro content and copy selected public images.
  - `abbey plant publish <slug>`
- `rename-exports` - Compatibility wrapper for project-aware media export renaming.
  - `abbey plant rename-exports <directory> [--dry-run]`
- `update` - Add a dated observation and select its current photograph.
  - `abbey plant update <slug> --photo FILE --narrative TEXT [--care TEXT] [--status STATUS] [--date YYYY-MM-DD] [--dry-run]`
- `update-batch` - Prepare or apply a reviewable multi-plant update worksheet.
  - `abbey plant update-batch <prepare|apply> [options]`
- `validate` - Validate a plant workspace against the Plant Model.
  - `abbey plant validate <slug>`

**Examples**

```text
abbey plant new rocky-raccoon --name "Rocky Raccoon" --type orchid --photo incoming.jpg
abbey plant validate doctor-robert
abbey plant publish doctor-robert
abbey plant hero doctor-robert
abbey plant index doctor-robert
abbey plant update doctor-robert --photo incoming.jpg --narrative "Firm leaves and active roots." --care "Watered."
abbey plant rename-exports ~/incoming/photos --dry-run
abbey plant update-batch prepare ~/incoming/photos --date 2026-08-02
abbey plant update-batch apply working/plant-updates/2026-08-02.yml --dry-run
```

