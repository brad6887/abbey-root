---
date: 2026-07-08
title: Abbey Framework Foundation
journal: 2026-07-08-abbey-framework-foundation
reviewed: true
---

# Session Update

## Summary

Today's session established the foundation of the Abbey Framework as a reusable engineering platform rather than simply a collection of project-specific tools.

Abbey Root now serves as the reference implementation of the framework, while Power Infrastructure has begun adopting the same standards and engineering practices. The session focused on standardizing the command-line interface, defining reusable project standards, and creating onboarding documentation that makes Abbey-style repositories approachable for new contributors.

## Completed

- Added `pwr session` to Power Infrastructure.
- Introduced metadata-driven CLI help to Abbey Root.
- Added the `abbey version` command.
- Generated CLI reference documentation from metadata.
- Created the Abbey Framework standards:
  - `CLI_STANDARD.md`
  - `PROJECT_STANDARD.md`
- Adopted the framework standards in Power Infrastructure.
- Introduced `docs/framework` as the home for framework specifications.
- Created the first onboarding guides:
  - `docs/guide/START_HERE.md`
  - `docs/guide/USING_THE_CLI.md`
- Created equivalent onboarding guides for Power Infrastructure.

## Impact

Abbey Root has evolved from a single development project into the reference implementation of a reusable engineering framework.

Power Infrastructure now shares the same engineering philosophy, documentation structure, CLI conventions, and workflow, making it the first production implementation of the Abbey Framework.

The project now has a documented foundation that can be reused when creating future repositories.

## Lessons Learned

- Universal commands should have consistent behavior across all Abbey-style projects.
- CLI metadata provides a single source of truth for help output and generated documentation.
- Framework standards are distinct from project architecture and deserve their own documentation area.
- Simple onboarding guides are just as valuable as detailed technical documentation.

## Next Steps

- Design the `abbey init` project bootstrap workflow.
- Continue aligning Abbey Root and Power Infrastructure with the framework standards.
- Expand the guide documentation with `WORKFLOW.md`, `PHILOSOPHY.md`, and additional onboarding material.
- Evaluate shared libraries for common CLI functionality between projects.
