# AGENTS.md

## Project Purpose

Abbey Root is the reference implementation of the Abbey Framework.

It is both:

- A working Linux home lab and development platform.
- A reusable engineering framework for self-documenting, automation-friendly, AI-assisted projects.
- The source platform for BradCooke.com.
- A research and development environment for practices that may later be adopted by other Abbey-style repositories, including Power Infrastructure.

The project combines infrastructure-as-code, automation, documentation, publishing, developer tooling, structured content, and AI-assisted workflows.

When practical, improvements should strengthen reusable project practices rather than become one-off solutions.

## Core Principles

Work in this repository should follow these principles:

- Preserve one authoritative source for each fact.
- Generate derived information whenever practical.
- Keep human-written documentation focused on decisions, reasoning, workflows, and operational knowledge.
- Prefer small, focused components and documents.
- Keep implementation, documentation, and validation synchronized.
- Preserve readable source material even when it feeds generated outputs.
- Favor explicit, reviewable workflows over hidden automation.
- Automate repeated, understood workflows rather than speculative processes.
- Produce reviewable suggestions when facts are uncertain; do not silently resolve historical or provenance ambiguity.
- Allow AI to assist engineering judgment, not replace it.
- Improve the framework through real project experience rather than speculative abstraction.
- Avoid creating competing sources of truth.

## Instruction Scope

This file provides repository-wide instructions.

A more-specific `AGENTS.md` may provide additional or overriding instructions for files within its directory tree. The repository currently contains a verified nested instruction file at:

```text
site/AGENTS.md
```

Read all applicable instruction files before changing files. Keep repository-wide policy in this document and implementation-specific guidance in the appropriate nested instructions.

## Start Here

Before making significant changes, review the documentation relevant to the task.

Recommended starting points are:

- `docs/guide/START_HERE.md`
- `docs/README.md`
- `docs/planning/PROJECT_STATUS.md`
- `docs/planning/NEXT.md`

When available in the working environment, use `abbey session` to inspect the current project context and standard workflow.

## Authoritative Documentation Locations

Documentation is organized by responsibility.

### Guide

Location:

```text
docs/guide/
```

Guide documents contain onboarding and day-to-day usage guidance. They answer:

> How do I work with Abbey Root?

### Planning

Location:

```text
docs/planning/
```

Planning documents describe the current state and future direction of the project.

Important planning documents include:

- `docs/planning/PROJECT_STATUS.md`
- `docs/planning/NEXT.md`

Planning documents are structured interfaces consumed by developers, project tooling, and AI-assisted workflows.

### Framework

Location:

```text
docs/framework/
```

Framework documents define standards intended for Abbey-style repositories. They describe how Abbey-style projects should be built and are distinct from documents describing Abbey Root’s current implementation.

### Architecture

Location:

```text
docs/architecture/
```

Architecture documents describe how Abbey Root and its reusable engineering concepts are designed.

### Reference

Location:

```text
docs/reference/
```

Reference documents contain stable facts, schemas, naming rules, models, and implementation references.

Important references include:

- `docs/reference/PLANNING_SCHEMA.md`
- `docs/reference/PLANT_MODEL.md`

### Runbooks

Location:

```text
docs/runbooks/
```

Runbooks contain repeatable operational procedures. Update a runbook when the proven procedure changes.

### Session Updates

Location:

```text
docs/session-updates/
```

Session updates are operational records of development sessions. They capture completed work and become input for later planning reconciliation.

Do not treat session updates as permanent substitutes for authoritative architecture, reference, framework, or planning documents.

### Journal

Location:

```text
content/journal/
```

The journal contains the historical, published narrative of Abbey Root.

Journal entries should preserve accomplishments, decisions, problems, and lessons learned. Do not rewrite historical entries except to correct factual or formatting errors.

### Generated Documentation

Location:

```text
docs/generated/
```

Generated documentation is derived from authoritative metadata, inventory, or tooling. It is not itself the authoritative source.

### Architecture Decision Records

Location:

```text
docs/adr/
```

This is the repository location for architecture decision records. Use it for durable decisions when the task calls for an ADR.

## Repository Structure

The major repository areas are:

```text
.abbey/         Local generated context and knowledge artifacts
ansible/        Infrastructure inventory, playbooks, roles, and automation
config/         Project and CLI metadata
content/        Canonical publishable Markdown content
docs/           Project documentation and planning
homepage/       Homepage dashboard configuration
logs/           Local runtime logs
scripts/        Supporting scripts and utilities
site/           Astro website implementation
tools/          Abbey developer toolkit
working/        Canonical working source material
```

### Infrastructure

`ansible/` is the primary source for managed infrastructure automation.

Prefer changes to inventory, playbooks, roles, templates, and metadata over undocumented manual changes to managed systems.

Do not run mutating infrastructure automation unless the user explicitly requests execution or deployment.

### Configuration

Project configuration and metadata live under:

```text
config/
```

CLI metadata currently lives at:

```text
config/cli/cli.yml
```

Treat metadata as authoritative for the information it owns. Keep implementations and generated outputs synchronized with metadata changes.

### Canonical Content

Publishable Markdown content lives under:

```text
content/
```

Keep canonical content readable in Git, text editors, and AI tools.

Do not introduce unnecessary generated complexity into source prose.

### Canonical Working Material

Rich working source material lives under:

```text
working/
```

Plant workspaces currently live under:

```text
working/plants/
```

Use `docs/reference/PLANT_MODEL.md` as the authoritative model for plant workspaces.

Working material may include private notes, original photographs, source documents, sidecar metadata, inventories, and provenance records. Do not publish a working artifact merely because it exists.

When historical facts, dates, identity, or provenance are uncertain:

- Preserve the uncertainty.
- Record the available evidence.
- Present suggested interpretations for review.
- Do not invent precision.
- Do not silently choose between conflicting sources.

### Website

The website implementation lives under:

```text
site/
```

The verified `site/AGENTS.md` contains more-specific instructions for work within that directory. Keep website implementation details there rather than adding them to this repository-wide file.

### Developer Toolkit

The primary CLI dispatcher currently lives at:

```text
tools/bin/abbey
```

Developer tooling lives under:

```text
tools/
```

Supporting scripts live under:

```text
scripts/
```

Prefer consistent, discoverable `abbey` workflows over requiring users to remember internal script locations.

Preserve compatibility with existing tools unless the requested task explicitly includes migration or removal.

## Session Workflow

Development should follow the standard Abbey session workflow:

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

### 1. Review

Before changing files:

- Inspect the working tree.
- Identify existing user changes.
- Read all applicable `AGENTS.md` files.
- Review relevant planning, architecture, framework, and reference documents.
- Review recent applicable session updates.
- Determine which files are canonical and which are generated.
- Confirm the scope of the requested work.

Never overwrite, discard, or reformat unrelated user work.

### 2. Define

Choose one clear objective and a concrete definition of done.

Keep the change focused. Do not expand a task into unrelated framework, documentation, infrastructure, publishing, or cleanup work without authorization.

### 3. Build

Implement the smallest coherent change that satisfies the objective.

Prefer:

- Existing repository conventions.
- Metadata-driven behavior.
- Explicit transformations.
- Reviewable outputs.
- Existing helper commands and scripts.
- Reusable components justified by demonstrated use.

Automate a workflow after it is understood through repeated use. Do not introduce abstractions or workflow engines solely for hypothetical future needs.

### 4. Validate

Run validation appropriate to the files changed and the risks involved.

Do not claim that validation passed unless it was actually run successfully.

If validation cannot run, report:

- What was not run.
- Why it could not run.
- What risk remains.

### 5. Document

Update documentation when a change affects:

- Architecture.
- User workflows.
- CLI behavior.
- Infrastructure.
- Content models.
- Operational procedures.
- Planning state.
- Generated-output contracts.

Do not update unrelated documentation merely to make a change appear comprehensive.

### 6. Capture

When the active workflow calls for a session update, capture:

- Summary.
- Objective.
- Completed work.
- Validation.
- Design decisions.
- Impact.
- Lessons learned.
- Follow-up work.

Capture decisions and results rather than every command executed.

### 7. Commit

Preparing a clean, logical change is part of the workflow.

Creating a commit is not authorized unless the user explicitly requests it.

### 8. Review

Review the final diff, validation results, documentation effects, and remaining follow-up work.

Long-term planning reconciliation should be deliberate. Do not silently rewrite strategic planning based on inferred intent.

## Validation Expectations

Validation should be proportional to the change.

### General Validation

For most changes, inspect the working tree and final diff.

Common read-only checks include:

```bash
git status --short
git diff
git diff --check
```

Verify that:

- Only task-related files changed.
- Existing user changes were preserved.
- No unexpected generated or local files were added.
- Formatting checks pass.
- The implementation matches the requested scope.

### CLI Changes

For CLI changes, verify as applicable:

- The command is reachable through the intended interface.
- Help and usage output are accurate.
- Unknown or invalid arguments fail clearly.
- Exit status reflects success or failure correctly.
- CLI metadata matches implemented behavior.
- Generated CLI documentation is current.
- Existing commands remain compatible.
- Behavior does not depend unnecessarily on the caller’s current directory.
- Shared command concepts remain aligned with Abbey Framework conventions.

### Documentation Changes

For documentation changes, verify:

- Markdown is structurally valid and readable.
- Front matter is valid where required.
- Dates and filenames agree.
- Internal paths and command names are accurate.
- Stable headings were not renamed accidentally.
- Generated documents were regenerated from their source.
- Facts were not duplicated across competing authoritative locations.
- Uncertainty and provenance are represented honestly.

### Content Changes

For structured content changes, use the applicable documented model and repository command.

Verify:

- Canonical source material remains canonical.
- Generated outputs reflect the source.
- Only explicitly selected public material is published.
- Private working files and unselected assets remain private.
- Historical and provenance ambiguity is surfaced for review.
- Generated output was not hand-edited in place of fixing its source.

### Website Changes

For website changes, follow `site/AGENTS.md` and run the validation appropriate to that scope.

Building or previewing the site does not authorize publication.

### Infrastructure Changes

For infrastructure changes, use syntax, inventory, or playbook validation appropriate to the scope.

Validation does not authorize applying changes to managed systems.

### Generated Documentation

When changing metadata or a generator:

1. Update the authoritative source.
2. Regenerate the relevant output.
3. Inspect the generated diff.
4. Confirm that unrelated generated content did not change.

Do not manually make generated output agree with a broken source or generator.

## Canonical and Generated Content

Maintain a clear boundary between canonical sources and derived artifacts.

### Canonical Sources

Canonical sources include, depending on the subject:

- Infrastructure metadata and automation under `ansible/`.
- Project and CLI metadata under `config/`.
- Human-maintained documentation outside generated locations.
- Publishable source content under `content/`.
- Rich working source material under `working/`.

The exact authority depends on the documented model for the feature being changed.

### Tracked Generated Documentation

Tracked generated documentation lives under:

```text
docs/generated/
```

If generated documentation is wrong, fix its authoritative source or generator and regenerate it.

Do not hand-edit tracked generated documentation.

### Local Generated State

Local generated context and logs live under:

```text
.abbey/
logs/
```

Treat these as local artifacts. Do not commit them.

### Website Build Output

Website build output currently exists under:

```text
site/dist/
```

Treat it as derived output. Do not commit or publish it unless the user explicitly requests the applicable operation.

### Generated Plant Outputs

Generated plant content and public assets currently exist under:

```text
content/plants/
site/public/images/plants/
```

The corresponding canonical plant workspaces live under:

```text
working/plants/
```

Make factual and narrative source corrections in the canonical workspace, then use the documented publishing workflow.

Do not edit generated plant output as a substitute for correcting its canonical source or publisher.

### Safe Regeneration

Before regenerating files:

- Inspect the working tree.
- Identify existing user changes.
- Determine which source controls the output.
- Avoid overwriting unrelated work.

After regeneration:

- Inspect the diff.
- Confirm that the output is reproducible.
- Confirm that no private or unintended source material crossed into public output.

## Stable Document Headings

Planning documents and other structured Markdown files are interfaces consumed by people, scripts, and AI-assisted workflows.

Treat stable section headings as part of the document schema.

Before renaming, removing, reordering, or changing the level of a stable heading:

1. Review `docs/reference/PLANNING_SCHEMA.md`.
2. Search for scripts, commands, prompts, and documents that consume the heading.
3. Treat the change as an interface migration.
4. Update affected consumers and documentation together.
5. Validate that automation still recognizes the document.

Do not normalize headings casually for style.

When content changes but the section’s responsibility does not, preserve the existing heading text and level.

If the documented schema and current files disagree, do not silently choose one. Identify the drift and either:

- Make a task-scoped reconciliation when authorized, or
- Report the inconsistency and request an explicit decision.

Prefer predictable Markdown structures:

- Consistent heading levels.
- Stable section names.
- Lists for structured facts.
- Concise statements.
- Tables only when they materially improve clarity.

## Abbey and Power Alignment

Abbey Root’s `abbey` CLI and Power Infrastructure’s `pwr` CLI are sister interfaces.

Where practical, keep shared engineering concepts aligned across both projects.

Alignment may include:

- Universal command names.
- Command meanings.
- Help structure.
- Command categories.
- Terminology.
- Exit behavior.
- Metadata conventions.
- Session workflow.
- Documentation lifecycle.
- User experience.

Universal concepts should not acquire incompatible meanings without a documented reason.

Project-specific commands may differ when required by each project’s mission. Do not copy project-specific behavior into the shared framework merely to make the CLIs superficially identical.

When changing a shared CLI concept:

1. Review `docs/framework/CLI_STANDARD.md`.
2. Review `docs/architecture/CLI_FRAMEWORK.md`.
3. Consider the corresponding `pwr` behavior when that repository is available and in scope.
4. Preserve compatibility where practical.
5. Document intentional divergence.
6. Do not modify another repository unless the user explicitly includes it in scope.

Abbey Root is the reference implementation, but proven experience from Power Infrastructure may inform framework improvements.

## Git Safety Rules

Treat the working tree as shared user state.

Before making changes, inspect it with:

```bash
git status --short
```

Preserve all pre-existing modifications, staged changes, and untracked files.

### Actions Requiring Explicit Authorization

Do not perform any of the following unless the user explicitly requests it:

- Stage files.
- Create a commit.
- Amend a commit.
- Push to a remote.
- Pull or merge remote changes.
- Rebase.
- Create or delete branches.
- Create, modify, or delete tags.
- Force-push.
- Publish the website.
- Deploy infrastructure.
- Discard changes.
- Remove files solely because they appear obsolete.
- Modify another repository.

A request to implement, build, validate, document, or prepare a change does not imply permission to commit or push.

### Destructive Operations

Do not use destructive commands such as:

```bash
git reset --hard
git checkout -- <path>
git restore --source=<ref> <path>
git clean -fd
```

unless the user explicitly requests the destructive operation and its consequences are understood.

Do not use destructive commands to work around unrelated user changes.

### Commits

Only commit when explicitly requested.

When a commit is requested:

- Review the complete diff first.
- Include only task-related changes.
- Do not stage unrelated user work.
- Use a short, direct commit message describing the completed change.
- Prefer one logical commit unless the user requests another structure.
- Report the resulting commit identifier.

### Pushes

Only push when explicitly requested.

Before pushing:

- Confirm the intended repository, branch, and remote.
- Confirm required validation passed.
- Confirm the working tree and commit history are in the expected state.
- Do not force-push unless the user explicitly requests it.

### Publication and Deployment

Building and validating are not publication or deployment.

Do not:

- Publish website output.
- Change a production repository.
- Push generated production files.
- Apply infrastructure changes.

unless the user explicitly requests the applicable external action.

When a non-destructive preview is available and the user asks to review a prospective external change, prefer the preview before the mutating operation.

## Scope and Change Discipline

- Make only changes needed for the requested objective.
- Do not reorganize unrelated files.
- Do not reformat entire documents to change a few lines.
- Do not repair unrelated defects without authorization.
- Report important unrelated problems separately.
- Prefer read-only investigation for review, diagnosis, and explanation tasks.
- Do not create files when the user asks only for a proposal.
- Do not infer permission for external actions from permission to edit local files.
- Preserve uncertainty when evidence is incomplete.
- Prefer reviewable proposals over silent factual assumptions.

## Final Handoff

When work is complete, report:

- The outcome.
- Files changed.
- Important design decisions.
- Validation performed and its results.
- Validation not performed and why.
- Remaining risks or follow-up items.
- Whether generated files changed.
- Whether any commit, push, publication, or deployment occurred.

Unless explicitly requested, the expected final state is:

```text
Files may be modified only within the requested scope.
No commit created.
No push performed.
No publication performed.
No deployment performed.
```
