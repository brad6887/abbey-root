---
title: "Document Existing Project Migration Workflow"
description: "Turn the completed Artificial Ignorance migration into Abbey's canonical workflow for adopting established repositories."
date: 2026-08-18
status: complete
reviewed: false
session: document-existing-project-migration-workflow
tags:
  - Abbey Framework
  - project migration
  - documentation
  - Artificial Ignorance
---

# Document Existing Project Migration Workflow

## Objective

Create the canonical Abbey Framework migration guide for established
repositories using the completed Artificial Ignorance migration as the
validated reference workflow.

Clearly separate existing-project migration from `abbey init` and general
framework adoption while preserving the principle that established repositories
retain ownership of their application structure, history, validation, and
project-specific workflows.

## Definition of Done

- Create a dedicated existing-project migration guide.
- Clearly distinguish migration from `abbey init` and framework adoption.
- Document the validated Artificial Ignorance migration sequence.
- Preserve existing repository organization as the default migration behavior.
- Include migration certification checks.
- Document Git history and remote preservation as migration safety without
  making GitHub an Abbey requirement.
- Record the `abbey init help` defect as separate follow-up work.
- Record the external-project `abbey review` commit-wording defect as separate
  follow-up work.
- Decide whether current evidence justifies an `abbey adopt` command.
- Do not implement `abbey adopt` without evidence for a stable automation
  contract.
- Reconcile the completed migration-guide backlog item.
- Regenerate deterministic documentation and validate Abbey Root before commit.

## Summary

The completed Artificial Ignorance adoption was used as the first full
reference migration of an established repository into the Abbey Framework.

Artificial Ignorance began as an independent Python repository with existing
source code, tests, scripts, generated data, README content, Git history, and
runtime conventions. Its migration showed that Abbey can be introduced without
restructuring a working project or copying toolkit implementation into the
repository.

That real workflow is now documented in
`docs/guide/FRAMEWORK_MIGRATION.md`.

The guide distinguishes three related concepts:

- `abbey init` creates a new Abbey project in an empty destination.
- Framework adoption defines what an Abbey project owns and how it participates
  in shared Abbey workflows.
- Framework migration describes how an established repository safely reaches
  that adopted state while preserving existing project ownership.

The documented workflow covers baseline preservation, remote and history
safety, use of a disposable `abbey init` project as a reference contract,
project-boundary decisions, `.abbey/project.yml`, session guidance, planning
documents, ignore rules, existing validation, nested project discovery,
capability isolation, runtime-state isolation, session workflow validation,
review, commit, and migration certification.

The guide was automatically added to the generated documentation index through
the existing `abbey docs` workflow.

## Accomplishments

- Added `docs/guide/FRAMEWORK_MIGRATION.md`.
- Documented the complete validated existing-project migration workflow.
- Established Artificial Ignorance as the first reference migration.
- Documented the pre-migration Artificial Ignorance baseline:
  - repository already contained a working application;
  - commit `a175210` was preserved as the clean pre-migration state;
  - existing history was pushed before migration;
  - the project was later adopted in commit `46659ad`.
- Documented safe use of `abbey init` against a temporary destination as a
  reference generator for established projects.
- Documented that generated initializer files should be reviewed individually
  rather than copied blindly into an existing repository.
- Defined project-boundary review for:
  - project identity;
  - existing documentation;
  - validation commands;
  - runtime directories;
  - journal policy;
  - infrastructure and DNS ownership;
  - site and publishing workflows;
  - media workflows;
  - project-specific commands.
- Documented conservative `.abbey/project.yml` defaults for migrated projects.
- Documented preservation of existing README and application organization.
- Documented reuse of existing project validation as the Abbey validation
  contract.
- Added nested project discovery and capability-isolation checks to migration
  certification.
- Added project-local Abbey runtime-state checks.
- Added the first-session capture and post-migration clean-tree checks to the
  certification workflow.
- Added a migration certification checklist.
- Added the migration guide to the authoritative references in
  `FRAMEWORK_ADOPTION.md`.
- Marked the framework migration-guide backlog item complete.
- Added separate backlog items for two toolkit defects found during the real
  Artificial Ignorance migration:
  - `abbey init help` treats `help` as a project destination;
  - `abbey review` suggests `Update Abbey Root session work` for external
    projects.
- Updated `PROJECT_STATUS.md` to record that the existing-project migration
  workflow is validated through real use.
- Regenerated the deterministic documentation index, which discovered the new
  migration guide automatically.

## Impact

Abbey now has a documented and validated path for bringing established
repositories into the framework.

The framework no longer relies only on new-project initialization or general
adoption guidance. Existing projects now have a specific migration procedure
that preserves their prior engineering investment while adding the minimum
Abbey project contract.

The migration guide also strengthens the separation between toolkit and project
ownership:

- Abbey Root owns reusable framework implementation.
- The migrated repository owns its metadata, planning, validation, and domain
  behavior.
- Optional capabilities are enabled only when the project explicitly owns them.
- Existing project structure remains authoritative unless a separate change
  justifies restructuring it.

The Artificial Ignorance migration also provided evidence that an `abbey adopt`
command is premature. Several important migration decisions remain
project-specific and human-directed.

## Validation

- `git diff --check`
  - passed.
- `abbey backlog check`
  - passed after backlog reconciliation.
- `abbey docs generate`
  - regenerated deterministic documentation successfully.
- `abbey docs check`
  - CLI reference current;
  - command reference current;
  - documentation index current.
- `abbey validate`
  - project metadata valid;
  - required project metadata present;
  - Git repository detected;
  - whitespace validation passed;
  - configured directories present;
  - planning contract passed;
  - all registered commands dispatched;
  - all registered commands have implementations;
  - generated command documentation current.
- `docs/generated/DOCUMENTATION_INDEX.md`
  - automatically includes `Abbey Framework Migration Guide`.
- `docs/guide/FRAMEWORK_MIGRATION.md`
  - heading structure reviewed;
  - Markdown formatting corrected after the initial heredoc output contained
    nested-fence formatting problems.

## Lessons Learned

A real migration exposed useful boundaries that were difficult to identify from
the initializer alone.

`abbey init` remains the correct tool for new projects. For established
repositories, it is also useful as a disposable reference generator because it
shows the current Abbey project contract without touching the real repository.

The mechanical part of adoption is relatively small. The harder decisions are
project-specific:

- what the project owns;
- which existing documents remain authoritative;
- which validation commands matter;
- which capabilities should remain disabled;
- whether a journal is useful;
- whether a remote is needed;
- and how planning documents should describe the project's real state.

Those decisions should remain visible and deliberate.

One successful migration is enough to document the workflow. It is not enough
evidence to automate the entire workflow as `abbey adopt`.

Additional migrations should be used to identify which repeated steps are
stable, mechanical, and safe to automate.

The session also confirmed the value of real-use migration testing. Artificial
Ignorance exposed two toolkit problems that were unrelated to migration
correctness but would have been easy to miss in synthetic fixtures.

## Next Steps

- Use `FRAMEWORK_MIGRATION.md` for the next established-repository migration.
- Evaluate the workflow again after another real project migration.
- Consider `abbey adopt` only after repeated migrations establish a smaller,
  stable automation contract.
- Fix `abbey init help` in a separate bounded Abbey Root session.
- Make `abbey review` suggested commit wording project-aware in a separate
  bounded Abbey Root session.
- Continue normal Artificial Ignorance development within its own Abbey-managed
  repository.
- Continue framework adoption work without duplicating migration guidance in
  other documents.

## Notes

Artificial Ignorance remains independently managed at:

`/home/bcooke/git/artificial-ignorance`

Its Abbey toolkit resolves from:

`/home/bcooke/git/abbey-root`

The migration guide intentionally recommends preserving Git history and a
durable pre-migration baseline, but GitHub is not a framework requirement.

The generated documentation index remains the authoritative discovery surface
for the new guide rather than maintaining a separate manual guide index.
