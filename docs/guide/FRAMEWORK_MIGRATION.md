# Abbey Framework Migration Guide

## Purpose

This guide describes how to migrate an established Git repository into an
independently managed Abbey project without replacing its existing application
structure, project history, or domain-specific workflows.

Use this guide when the repository already contains meaningful project content.

For a new or empty project, use `abbey init`.

For the framework ownership model, project capabilities, metadata contract, and
adoption certification requirements, see
[FRAMEWORK_ADOPTION.md](FRAMEWORK_ADOPTION.md).

This workflow was first validated through the migration of Artificial Ignorance
from an existing standalone repository into an independent Abbey project.

## Migration Outcome

A successful migration preserves the existing repository while adding the
minimum project-owned Abbey contract required to participate in shared Abbey
workflows.

After migration:

- the existing Git history remains intact;
- the existing application structure remains authoritative;
- `.abbey/project.yml` becomes the canonical Abbey project marker;
- project planning, sessions, validation, and optional journal policy are
  project-owned;
- the installed Abbey toolkit remains external to the project;
- optional capabilities remain disabled unless explicitly owned;
- existing project validation remains authoritative; and
- Abbey discovers the project independently from Abbey Root.

## Migration vs Initialization vs Adoption

These workflows solve different problems.

### `abbey init`

Use `abbey init` for a new or empty destination.

It creates the default Abbey project foundation, including project metadata,
planning documents, session structure, ignore rules, and optional Git
initialization.

Do not run `abbey init` over an established repository.

### Framework Adoption

`FRAMEWORK_ADOPTION.md` defines what an Abbey project owns and the standards an
adopted project follows.

It is the framework contract.

### Framework Migration

Migration is the controlled process of bringing an established repository into
that adopted state while preserving existing project ownership.

The migration workflow uses the initialized project structure as a reference
contract rather than treating the default template as content that must replace
existing files.

## 1. Establish a Clean Baseline

Begin with a known-good repository state.

Run the project's existing validation before adding Abbey files.

At minimum:

    git status
    git log -1 --oneline
    git remote -v

The working tree should be clean before migration begins.

Record the baseline commit so the pre-migration state can always be identified.

If the project already has deterministic tests, builds, linting, or validation,
run them before changing the repository.

## 2. Preserve Repository History and Remote State

Migration must preserve the existing Git history.

A remote repository is recommended before migration when the only authoritative
copy exists on one development host. This provides a durable pre-migration
baseline.

GitHub is not required by the Abbey Framework.

The relevant requirement is preservation of project history and a known-good
baseline appropriate to the project.

When a remote is configured, verify:

    git remote -v
    git branch -vv
    git status

Do not rewrite repository history merely to adopt Abbey.

## 3. Generate a Disposable Abbey Reference Project

For an established repository, use `abbey init` only against a temporary
destination.

Example:

    rm -rf /tmp/project-abbey-reference

    abbey init /tmp/project-abbey-reference \
      --name "Project Name" \
      --description "Project description." \
      --journal-policy event-driven \
      --no-git \
      --dry-run

If the preview is correct, generate the temporary project:

    abbey init /tmp/project-abbey-reference \
      --name "Project Name" \
      --description "Project description." \
      --journal-policy event-driven \
      --no-git

Use the generated files as the current framework contract.

Do not copy them blindly into the existing repository.

Review each generated file against the repository's existing structure and
sources of truth.

## 4. Decide the Existing Project Boundary

Before adding Abbey metadata, identify what the repository already owns.

Review:

- project name and stable slug;
- project purpose;
- existing README and documentation;
- current tests and validation commands;
- existing planning or backlog material;
- runtime working directories;
- journal requirements;
- infrastructure ownership;
- internal DNS ownership;
- site build or publication workflows;
- media workflows; and
- existing project-specific commands.

Do not enable a capability simply because Abbey Root uses it.

Migration should describe the existing project accurately rather than reshape
the project around Abbey Root.

## 5. Add the Canonical Project Marker

Create:

    .abbey/project.yml

The file is the canonical Abbey project marker.

A conservative established-project configuration may begin with:

    schema_version: 1

    project:
      name: Project Name
      slug: project-name
      description: Project description.

    framework:
      name: Abbey
      schema_version: 1

    configuration:
      allow_toolkit_defaults: false

    capabilities:
      infrastructure: false
      internal_dns: false

    workflow:
      journal:
        policy: event-driven

    validation:
      commands:
        - git diff --check

    paths:
      planning: docs/planning
      session_updates: docs/session-updates
      journal: content/journal

Customize this metadata from evidence.

In particular:

- choose a stable project slug;
- keep toolkit defaults disabled unless explicitly needed;
- enable only capabilities the project owns;
- use the project's existing validation commands;
- choose the journal policy deliberately; and
- add site, media, or publishing configuration only when the project already
  has a defined contract for those workflows.

## 6. Add Repository-Owned Session Guidance

Create:

    .abbey/session-guidance.md

The guidance should preserve the standard Abbey Session Workflow:

1. Review
2. Define
3. Build
4. Validate
5. Document
6. Capture
7. Commit
8. Review

Add project-specific engineering principles only where they are durable and
useful across future sessions.

Do not copy Abbey Root-specific infrastructure, publishing, or content guidance
into unrelated projects.

## 7. Introduce Planning Structure

An Abbey project normally owns:

    docs/planning/PROJECT_STATUS.md
    docs/planning/NEXT.md
    docs/planning/BACKLOG.md
    docs/planning/ROADMAP.md
    docs/session-updates/

For an established project, write these from the project's real current state.

Do not replace existing authoritative project material with generic template
text.

Use the planning documents for distinct purposes:

- `PROJECT_STATUS.md` records durable current state.
- `NEXT.md` records the immediate focused objective.
- `BACKLOG.md` records finite unscheduled work.
- `ROADMAP.md` records major capability progression.
- `docs/session-updates/` records completed engineering sessions.

If the repository already has equivalent authoritative documents, reconcile
ownership deliberately rather than creating competing sources of truth.

## 8. Preserve Existing README and Documentation Ownership

Framework migration does not require rewriting the project README.

If the existing README already introduces the project, architecture, purpose,
or usage effectively, preserve it.

Abbey planning documents should own planning state rather than duplicate the
README.

Existing architecture, guides, runbooks, and references should remain in their
current structure unless a separate documentation migration is justified.

## 9. Merge Ignore Rules

Add only the Abbey-generated runtime paths required by the project.

Typical rules are:

    # Abbey generated working files
    working/session-context/*
    !working/session-context/.gitkeep

    # Generated Abbey runtime state
    .abbey/ai/
    .abbey/context/
    .abbey/knowledge/

    # Local Abbey configuration
    .abbey/config.conf

Merge these into the existing `.gitignore`.

Do not replace existing project-specific ignore rules.

Validate the resulting behavior with `git check-ignore`.

## 10. Preserve Existing Validation

Migration should reuse the project's proven validation workflow.

For example, Artificial Ignorance already used:

    .venv/bin/python -m unittest discover -q
    .venv/bin/python -m compileall -q src scripts tests
    git diff --check

Those commands became the project's Abbey validation contract.

Prefer commands that work without requiring hidden shell state. When practical,
use explicit project-owned interpreters or tool paths rather than assuming an
interactive environment is already activated.

Do not invent validation merely to resemble Abbey Root.

## 11. Validate Project Resolution

From the repository root:

    abbey project show

Confirm:

- active project name;
- project root;
- toolkit root;
- project configuration path; and
- toolkit-default policy.

The project root must resolve to the migrated repository.

The toolkit root should remain the installed Abbey toolkit.

Then repeat project discovery from a nested directory:

    cd src
    abbey project show

The same active project must be discovered.

## 12. Validate Capability Isolation

Run:

    abbey doctor

Confirm that undeclared project capabilities do not leak from Abbey Root.

For example, a project with:

    capabilities:
      infrastructure: false
      internal_dns: false

must not run Abbey Root infrastructure or internal-DNS health checks merely
because its toolkit is installed from Abbey Root.

Missing optional capability configuration should fail closed rather than
inherit unrelated toolkit behavior.

## 13. Validate the Project Contract

Run:

    abbey validate

Then run every project-specific command listed under:

    validation:
      commands:

Also verify repository whitespace:

    git diff --check

Migration is not complete if adopting Abbey breaks an existing project
workflow.

## 14. Validate Project-Local Runtime State

Generated Abbey runtime data should remain local to the active project and
ignored by Git.

Representative checks:

    git check-ignore -v \
      .abbey/ai/example \
      .abbey/context/example \
      .abbey/knowledge/example \
      .abbey/config.conf \
      working/session-context/example

The active project must not write its generated AI, context, knowledge, or
session runtime data into Abbey Root.

## 15. Exercise the Shared Session Workflow

Run:

    abbey session start

Confirm that the command reads the migrated project's own planning documents.

Capture the first real Abbey session through:

    abbey session capture --title "Adopt Project into Abbey"

Allow the configured journal policy to determine whether a journal entry is
created.

Do not create duplicate session or journal artifacts manually when Abbey
already owns that workflow.

## 16. Review and Commit the Migration

Before committing:

    abbey validate
    git diff --check
    abbey review
    git status
    git diff --stat

Stage the migration and inspect the complete staged diff:

    git add ...
    git diff --cached --stat
    git diff --cached

The migration commit should contain the project-owned Abbey foundation and any
required planning reconciliation without unrelated application changes.

After commit, push when the project uses a remote.

Verify:

    git status
    git log -2 --oneline
    abbey project show
    abbey validate

## Migration Certification Checklist

An established repository migration is certified when:

- [ ] A clean pre-migration Git baseline is identifiable.
- [ ] Existing repository history is preserved.
- [ ] Existing application organization is preserved unless separately changed
      for a documented reason.
- [ ] `.abbey/project.yml` identifies the intended project.
- [ ] Toolkit defaults are explicitly controlled.
- [ ] Only project-owned capabilities are enabled.
- [ ] Existing validation commands remain authoritative and pass.
- [ ] `abbey project show` resolves the project from the repository root.
- [ ] Project discovery succeeds from a nested directory.
- [ ] `abbey doctor` does not run undeclared Abbey Root capability checks.
- [ ] `abbey validate` passes.
- [ ] Project planning documents reflect real current state rather than generic
      initialization placeholders.
- [ ] Abbey-generated runtime state remains project-local and ignored by Git.
- [ ] `abbey session start` uses the migrated project's planning context.
- [ ] The first Abbey session is captured according to project policy.
- [ ] The migration is committed as a bounded project change.
- [ ] The post-migration working tree is clean.

## Reference Migration: Artificial Ignorance

Artificial Ignorance was the first repository used to validate this complete
existing-project migration workflow.

Before migration it was an established Python repository containing:

- application source;
- tests;
- scripts;
- grounded knowledge datasets;
- an existing README;
- an existing `.gitignore`;
- a Python virtual environment; and
- multiple completed development commits.

The repository existed only on `ai-worker01` when migration began.

Before changing the project, its complete history was pushed to a dedicated
remote and commit `a175210` was preserved as the clean pre-migration baseline.

A disposable project generated by `abbey init` was used to inspect the current
Abbey foundation.

The initializer was not run over the existing repository.

Artificial Ignorance then added its own:

- `.abbey/project.yml`;
- `.abbey/session-guidance.md`;
- planning documents;
- session-update directory;
- event-driven journal location;
- session-context location; and
- Abbey runtime ignore policy.

The application structure and existing README remained unchanged.

Its existing validation became the project-owned Abbey validation contract:

    .venv/bin/python -m unittest discover -q
    .venv/bin/python -m compileall -q src scripts tests
    git diff --check

Migration validation confirmed:

- 126 existing tests passed;
- `abbey validate` passed;
- project discovery worked from both the repository root and `src/`;
- the active project resolved to Artificial Ignorance;
- the toolkit continued to resolve to Abbey Root;
- toolkit defaults remained disabled;
- infrastructure and internal-DNS checks did not leak into the project;
- generated Abbey runtime paths were ignored locally; and
- `abbey session start` used Artificial Ignorance's own planning state.

The migration was committed as:

    46659ad Adopt Artificial Ignorance into Abbey

This validated the existing-project migration workflow without restructuring
the application or copying Abbey toolkit implementation into the repository.

## When to Consider Automation

This migration establishes a documented workflow.

It does not yet establish that the entire workflow should become an
`abbey adopt` command.

Several migration decisions remain intentionally human-directed:

- determining the project boundary;
- selecting the stable slug;
- choosing journal policy;
- selecting validation commands;
- deciding which capabilities the project owns;
- reconciling existing documentation;
- deciding whether existing files should be preserved, merged, or replaced;
- deciding whether a remote is required; and
- writing planning documents from real project state.

A future `abbey adopt` command should be considered only after additional
existing repositories are migrated and repeated use demonstrates a smaller,
stable mechanical contract that can be automated safely.

Until then, prefer this validated migration workflow over speculative
automation.

## Known Toolkit Follow-Up

The Artificial Ignorance migration exposed two unrelated Abbey toolkit issues:

- `abbey init help` is interpreted as a project destination rather than command
  help.
- `abbey review` prints the suggested commit description `Update Abbey Root
  session work` even when an external project is correctly active.

These do not invalidate the migration workflow.

They should be tracked and corrected separately in bounded Abbey Root sessions.

## Related Documentation

- [Framework Adoption Guide](FRAMEWORK_ADOPTION.md)
- [Project Standard](../framework/PROJECT_STANDARD.md)
- [Session Workflow](SESSION_WORKFLOW.md)
- [Documentation Standards](DOCUMENTATION.md)
- [CLI Standard](../framework/CLI_STANDARD.md)
