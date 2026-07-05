# Abbey CLI

The Abbey Toolkit is the command-line front door for the Abbey Root lab.

It provides common commands for checking the lab, creating journal entries, building AI context, and inspecting local system status.

## Primary Command

```bash
abbey
```

The `abbey` command is installed from:

```text
tools/bin/abbey
```

On each lab machine, it should be linked into:

```text
~/.local/bin/abbey
```

## Navigation Shortcut

The old `abbey` alias has been replaced by:

```bash
cda
```

Use `cda` to change into the Abbey Root repository.

## Commands

### abbey doctor

Runs Abbey Root health checks.

```bash
abbey doctor
```

### abbey journal

Creates or opens a journal entry.

```bash
abbey journal "Working on Abbey AI"
```

### abbey status

Shows local system and project status.

```bash
abbey status
```

Current checks include:

- Hostname
- Uptime
- Kernel version
- Git branch
- Git working tree status
- Git remote
- Docker availability
- Running Docker containers
- Abbey tool availability

### abbey knowledge

Builds a generated knowledge snapshot for AI context.

```bash
abbey knowledge build
```

Generated files are written to:

```text
.abbey/knowledge/
```

The `.abbey/` directory is ignored by Git.

### abbey ai

Shows Open WebUI connection information and points to the current Abbey knowledge snapshot.

```bash
abbey ai
```

Current behavior is a manual bridge to Open WebUI. Future versions may connect directly to the Open WebUI API.

## Generated Files

Generated toolkit files belong under:

```text
.abbey/
```

This keeps generated artifacts separate from source documentation.

## Design Principles

- Keep reusable commands under `tools/bin/`.
- Expose functionality through the main `abbey` dispatcher.
- Keep generated output out of Git.
- Document new commands as they are added.
- Prefer simple, composable tools over large monolithic scripts.
- Build features incrementally and keep them reproducible.
