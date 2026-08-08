# CLI Framework

## Purpose

Defines the command-line architecture for Abbey Root.

The CLI Framework provides a consistent user experience while exposing reusable engineering capabilities through the `abbey` command.

## Scope

The CLI Framework standardizes command hierarchy, terminology, and behavior across Abbey Root.

Where practical, the `abbey` CLI should remain aligned with the `pwr` CLI used by Power Infrastructure.

## Design Goals

The CLI should be:

- discoverable
- consistent
- project-aware
- self-documenting
- automation-friendly
- extensible

## Command Hierarchy

Current commands include:

- doctor
- status
- session
- journal
- knowledge
- ai

Long-term commands may include:

- workflow
- docs
- reports
- inventory
- request

## Command Philosophy

Commands should represent engineering concepts rather than implementation details.

For example:

```text
abbey session
```

is preferred over

```text
abbey create-session-update
```

The CLI should describe *what* the user wants to accomplish, not *how* the implementation works.

## Sister CLI Philosophy

Abbey Root and Power Infrastructure should evolve as sister CLIs.

Shared concepts should use consistent:

- command names
- help output
- terminology
- workflows
- user experience

Project-specific commands should exist only where required by each project's mission.

## Design Principles

- One command should have one responsibility.
- Commands should compose naturally.
- Output should be suitable for both humans and automation.
- Help should encourage discovery.
- Prefer stable interfaces over clever shortcuts.

## Project Context

The Abbey toolkit and the active Abbey project are separate runtime concepts:

- `ABBEY_TOOLKIT_ROOT` locates shared command implementations and toolkit
  metadata.
- `ABBEY_ROOT` locates the active project's configuration and artifacts.

The shared project library discovers `.abbey/project.yml` by walking upward
from the working directory. Project-aware commands must validate that metadata
and fail when required local configuration is absent or unsafe. They must not
substitute the toolkit repository for a missing active project.

Use `abbey project show` to inspect the resolved context. An explicit
`--project` path selects an exact Abbey project root for diagnostics. Optional
project-relative configuration paths are normalized and rejected if they
escape the project root.

## Open Questions

- Which commands belong in both Abbey and Power?
- Which commands are project-specific?
- Should plug-ins be supported?
- How should workflows expose CLI entry points?
- Should commands support interactive and non-interactive modes?

## Related Documents

- Engineering Framework
- Session Framework
- Workflow Engine
- Architecture Principles

## Status

Draft
