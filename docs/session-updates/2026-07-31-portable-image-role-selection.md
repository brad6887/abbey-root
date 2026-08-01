---
title: "Portable Image Role Selection"
description: "Added portable, project-configured image-role selection with the plant hero workflow as its first adopter."
date: 2026-07-31
status: complete
reviewed: true
session: portable-image-role-selection
tags:
  - Abbey Root
  - Abbey Framework
  - Developer Toolkit
  - Plant Model
---

# Portable Image Role Selection

## Objective

Implement a portable image-role selection foundation, with
`abbey plant hero <slug>` as the first real adopter.

## Definition of Done

- A generic Abbey command selects an image for a project-configured entity role.
- The active project defines entity paths, eligible image extensions, metadata
  files, and role fields.
- `abbey plant hero <slug>` provides a simple Plant Model wrapper.
- Selection updates the canonical plant workspace rather than generated Astro
  content.
- Cancellation and invalid input leave project files unchanged.
- Image sidecars and unsupported file types are excluded.
- The workflow operates correctly from an external Abbey project.
- Focused regression coverage passes.

## Summary

Added `abbey image select`, a project-neutral image-role selector driven by
`.abbey/image-roles.yml`. Added `abbey plant hero` as the first domain-specific
wrapper, allowing a plant hero photograph to be selected from the canonical
plant workspace without directly editing generated Astro content.

The first implementation presents a deterministic numbered filename list.
Visual contact-sheet generation remains deferred until a supported image
dependency is deliberately selected.

## Accomplishments

- Added the toolkit-owned `abbey-image` implementation.
- Added the public `abbey image select` dispatcher and CLI metadata.
- Added tracked Abbey Root image-role configuration.
- Defined the Plant Model hero role as `photos.hero` in `facts.yaml`.
- Added `abbey plant hero <slug>` as a thin wrapper over the generic selector.
- Limited discovery to configured image extensions.
- Excluded XMP sidecars and unrelated files.
- Identified the currently selected image in the numbered list.
- Supported interactive selection, cancellation, confirmation, and
  non-interactive `--select` and `--yes` operation.
- Preserved unrelated YAML content while updating only the configured scalar.
- Used an atomic metadata-file replacement.
- Protected configured paths from escaping their project and entity roots.
- Added external-project fixtures proving toolkit and project-root separation.

- Fixed an `abbey end` completion crash when the current branch has no
  configured upstream.

## Impact

Abbey projects can now define reusable image roles without embedding Astro,
orchid, Plant Model, or repository-specific paths in the generic command.

Plant hero selection now updates the canonical workspace at
`working/plants/<slug>/facts.yaml`. Existing `abbey plant publish` behavior
continues to generate the Astro page and stable public hero image from that
source.

## Validation

- `tests/test-abbey-image.sh`: 46 assertions passed.
- `tests/test-abbey-plant.sh`: 58 assertions passed.
- `tests/test-abbey-portability.sh`: 29 assertions passed.
- Interactive plant-wrapper cancellation left the real workspace unchanged.
- The selector listed six Martha My Dear JPG files and excluded six XMP
  sidecars.
- `working/plants/martha-my-dear/facts.yaml` retained its existing hero and
  current-image references.
- Shell syntax checks passed for the dispatcher, generic selector, Plant Model
  command, and new regression suite.
- `git diff --check` passed.
- `abbey docs generate` and `abbey docs check` passed.
- A real-project no-change selection correctly preserved Martha My Dear's
  existing hero assignment.
- `abbey review` found the current session documentation valid; reported
  historical metadata debt is pre-existing and non-blocking.

- `tests/test-abbey-end.sh`: 17 assertions passed after correcting the
  no-upstream completion path.
- The `abbey end` retest reached normal completion logic without an unbound
  variable error.

## Lessons Learned

Optional project capabilities do not all belong in `.abbey/project.yml`.
A separate tracked configuration file keeps the core project contract small
while allowing domain-specific workflows to remain portable.

The first useful selector does not require image-processing dependencies.
A numbered filename workflow proves the configuration, mutation, safety, and
portability contracts before visual contact sheets are added.

## Next Steps

- Evaluate visual contact-sheet support after selecting a portable image
  dependency and validating the filename-based workflow through normal use.
- Consider additional image roles only after another real workflow requires
  them.

## Notes

The session intentionally did not change Martha My Dear's selected hero image.
