# Abbey Framework Adoption Guide

## Purpose

This guide describes how an existing or new repository adopts the Abbey
Framework without copying Abbey Root or inheriting capabilities the project
does not own.

The process is based on three validated uses:

- Abbey Root is the reference implementation and toolkit source.
- Power Infrastructure is the first production project to adopt the shared
  documentation, CLI, and session standards.
- Bread Pitt is the first independent project to validate project discovery,
  macOS portability, project-local AI data, external-project certification,
  media workflows, and isolated site configuration.

This is an adoption guide, not a migration guide. It does not prescribe how to
convert every legacy file or command in an established repository.

## Adoption Outcome

An adopted project:

- has a valid `.abbey/project.yml` as its canonical project marker;
- owns its planning, session, journal, validation, and capability policy;
- uses the installed Abbey toolkit without copying toolkit implementation;
- follows the Abbey Session Workflow;
- keeps project-specific models and commands in the project; and
- fails closed instead of inheriting Abbey Root infrastructure or publishing
  behavior.

## 1. Decide the Project Boundary

Before creating files, identify what the repository owns.

Record:

- the project name, slug, and purpose;
- the first real workflow the project needs to support;
- whether the project owns infrastructure or internal DNS;
- when sessions require journal entries;
- which commands validate the project; and
- whether the project builds or publishes a site.

Do not adopt capabilities merely because Abbey Root has them. Bread Pitt
validated that an external project can use shared Abbey commands without
inheriting Abbey Root's infrastructure checks, content, or BradCooke.com
publishing target.

## 2. Preview and Create the Foundation

Use the default initializer for a new, empty destination. Preview the exact
files first:

```bash
abbey init /path/to/project \
  --name "Project Name" \
  --description "One-sentence project purpose." \
  --journal-policy event-driven \
  --dry-run
```

When the preview is correct, rerun without `--dry-run`:

```bash
abbey init /path/to/project \
  --name "Project Name" \
  --description "One-sentence project purpose." \
  --journal-policy event-driven
```

The initializer requires an empty destination, initializes Git on `main` by
default, validates the result, reports every created file, and creates neither
a commit nor a remote. Use `--no-git` only when Git ownership is managed
separately.

For an established repository, do not run the initializer over existing
content. Use its generated structure as the adoption contract and introduce
that structure in a focused migration session after reviewing possible path
and command conflicts.

## 3. Review Project Metadata

The generated `.abbey/project.yml` is the source of truth for project-aware
Abbey behavior. Confirm it with:

```bash
abbey project show
```

Review each metadata area deliberately:

| Metadata | Adoption decision |
| --- | --- |
| `project` | Stable name, slug, and concise description. |
| `framework` | Abbey framework identity and supported schema version. |
| `configuration.allow_toolkit_defaults` | Keep `false` unless the project intentionally accepts a documented toolkit default. |
| `capabilities` | Enable only dependencies the project owns. |
| `workflow.journal.policy` | Choose `required`, `event-driven`, or `optional`. |
| `validation.commands` | List deterministic commands appropriate to this project. |
| `paths` | Keep planning, session updates, and journals inside the project root. |
| `site` | Add only when the project has an explicit build or publication contract. |

Project-relative paths must remain inside the repository. Commands that need
missing or malformed configuration should fail rather than guess.

## 4. Establish the Documentation Contract

Keep the generated planning files small until real project use establishes
more detail:

- `PROJECT_STATUS.md` describes current durable state.
- `NEXT.md` contains the immediate focused objective.
- `BACKLOG.md` contains finite, verifiable unscheduled work.
- `ROADMAP.md` describes major capability progression.

Add other documentation categories only when they have a clear owner:

- `docs/guide/` for task-oriented use;
- `docs/architecture/` for system design;
- `docs/reference/` for facts needed while working;
- `docs/runbooks/` for validated operational procedures;
- `docs/generated/` for deterministic outputs; and
- `docs/session-updates/` for the engineering record.

Generated documents are derivatives, never the authority. Update their source
metadata or generator instead of editing them by hand.

## 5. Adopt the Shared Workflow

Every Abbey project follows the same session lifecycle:

1. Review current state.
2. Define one objective and its Definition of Done.
3. Build the bounded change.
4. Validate it.
5. Update durable documentation where necessary.
6. Capture the session update and policy-required journal.
7. Commit one logical change.
8. Review the completed session for planning reconciliation.

Start with:

```bash
abbey doctor
abbey validate
abbey session
```

Capture the result with a human-readable title:

```bash
abbey session capture --title "First Project Workflow"
```

The configured journal policy determines whether capture creates a journal.
When both artifacts are created, Abbey records reciprocal metadata links.

## 6. Validate the Common Command Boundary

The installed `abbey` command supplies shared framework behavior. The active
project supplies metadata and artifacts. Validate the boundary from both the
repository root and a nested directory:

```bash
abbey project show
abbey version
abbey doctor
abbey status
abbey validate
abbey session context --stdout
```

These commands must resolve the same active project while keeping generated
knowledge, context, and AI history project-local and ignored by Git.

A project-specific CLI is optional. Power Infrastructure demonstrates that a
domain CLI can add commands such as requests, playbooks, and reports while
preserving the meaning of common commands. Do not create wrappers that merely
duplicate installed Abbey behavior.

## 7. Add Capabilities Incrementally

Adopt one real project workflow before adding optional capabilities.

### Infrastructure and internal DNS

Enable `capabilities.infrastructure` or `capabilities.internal_dns` only when
the project owns those systems. External-project certification proved that
these flags prevent unrelated Abbey Root health checks from leaking into other
projects.

### Site build and publication

Declare `site.source` and `site.build` only after the artifact owner is known.
Publishing additionally requires an explicit method, target, and domain. Never
copy Abbey Root's publishing configuration as a placeholder: Bread Pitt proved
that missing publication configuration must fail closed rather than fall back
to BradCooke.com.

### Media and image roles

Add `.abbey/media.yml` or `.abbey/image-roles.yml` only for workflows the
project has modeled. Canonical inputs, generated derivatives, and publication
manifests must remain separate layers.

### AI and generated context

AI commands may use the shared toolkit, but knowledge sources, generated
context, decision history, and accepted project guidance remain owned by the
active project.

## Adoption Certification

Adoption is complete when all applicable checks below pass:

- [ ] `abbey project show` reports the intended project and toolkit roots.
- [ ] `.abbey/project.yml` contains only project-owned capabilities and paths.
- [ ] `abbey validate` passes from the project root.
- [ ] Project discovery works from a nested directory.
- [ ] `abbey doctor` does not run undeclared infrastructure or DNS checks.
- [ ] `abbey session` presents the project's own planning context.
- [ ] `abbey session capture` follows the configured journal policy.
- [ ] `abbey review` suggests the project's configured validation commands.
- [ ] Generated runtime state remains project-local and ignored by Git.
- [ ] Any site or media workflow uses explicit project-owned configuration.
- [ ] One real, bounded project workflow has completed the full session cycle.

## Evidence from the Three Projects

### Abbey Root

Abbey Root establishes the canonical project metadata, shared toolkit,
documentation model, universal command meanings, and complete session
lifecycle. It is the reference for framework behavior, not a template whose
domain-specific infrastructure and website configuration should be copied.

### Power Infrastructure

Power Infrastructure validates adoption of the common engineering philosophy,
documentation organization, metadata-driven CLI pattern, onboarding material,
and session workflow in a production engineering repository. Its domain
commands extend the common model without redefining it.

### Bread Pitt

Bread Pitt validates the independent-project boundary. Shared Abbey workflows
operate from a separate project root on macOS, keep runtime artifacts local,
honor project journal and capability policy, and cannot enter Abbey Root's
publishing path. Its domain and publishing model remain project-owned.

## What Adoption Does Not Include

Framework adoption does not automatically require:

- copying Abbey Root tools into the project;
- enabling infrastructure, DNS, publishing, media, or AI capabilities;
- creating a custom project CLI;
- importing historical work into Abbey planning documents;
- migrating every legacy file in one session; or
- creating additional project templates.

Those decisions require their own evidence and bounded objectives.

## Authoritative References

- [Project Standard](../framework/PROJECT_STANDARD.md)
- [CLI Standard](../framework/CLI_STANDARD.md)
- [Session Workflow](SESSION_WORKFLOW.md)
- [Documentation Guide](DOCUMENTATION.md)
- [Planning Document Schema](../reference/PLANNING_SCHEMA.md)
- [Generated CLI Reference](../generated/CLI_REFERENCE.md)
