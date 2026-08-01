---
title: "Plant Index Image Selection"
description: "Added independently selectable plant index photographs using the portable image-role framework."
date: 2026-07-31
status: complete
reviewed: true
session: plant-index-image-selection
tags:
  - Abbey Root
  - Abbey Framework
  - Developer Toolkit
  - Plant Model
  - BradCooke.com
---

# Plant Index Image Selection

## Objective

Add an independently selectable plant index photograph using the portable
image-role framework.

## Definition of Done

- `abbey plant index <slug>` supports interactive selection.
- `abbey plant index <slug> --select <number> --yes` supports non-interactive
  selection.
- The selected image is stored in canonical `facts.yaml` as `photos.index`.
- Selecting an index image does not change the hero or current image roles.
- Plant validation verifies `photos.index` when it is configured.
- An unset index image remains valid and does not create a warning.
- Plant publishing copies the selected image to a stable public index path.
- Generated plant frontmatter includes `indexImage`.
- The Orchid Rescue index prefers `indexImage`.
- Existing plants fall back to `currentImage` and then `heroImage`.
- Existing plant workspaces and the plant template support the new field.
- Regression tests pass.
- Documentation generation and validation pass.
- A real plant publish and Astro site build pass.

## Summary

The Plant Model now supports a dedicated image role for plant index pages.

Previously, the Orchid Rescue index used each plant's current image and then
fell back to its hero image. This meant the photograph representing the latest
condition of a plant also had to serve as the small, cropped index thumbnail.

A new `photos.index` field allows those purposes to be managed independently.

The new command is:

    abbey plant index <slug>

It uses the existing generic image-role selector, including interactive
numbered selection, confirmation, `--select`, and `--yes`.

Publishing now creates a stable public index image such as:

    /images/plants/martha-my-dear/index.jpg

The generated plant frontmatter records that path as `indexImage`. The Orchid
Rescue index now uses this fallback order:

    indexImage
    currentImage
    heroImage

Plants without a configured index image therefore retain their existing
behavior.

## Accomplishments

- Added the `index` image role to `.abbey/image-roles.yml`.
- Mapped the new role to canonical `photos.index` metadata.
- Added `abbey plant index <slug>` to the Plant Model command.
- Reused the generic image-role selector rather than creating a separate
  selection implementation.
- Added interactive and non-interactive index selection support.
- Confirmed index selection preserves the hero image role.
- Confirmed index selection preserves the current image role.
- Added `photos.index: null` to the plant workspace template.
- Added `photos.index: null` to all existing canonical plant workspaces.
- Preserved existing facts-file formatting during the migration.
- Updated plant validation to verify the configured index image exists.
- Kept the index field optional and silent when unset.
- Updated publishing to copy the configured image to a stable `index` filename.
- Added `indexImage` to generated plant frontmatter.
- Added `indexImage` to the Astro plant content schema.
- Updated the Orchid Rescue index to prefer the dedicated index image.
- Preserved fallback to the current image and then the hero image.
- Added CLI reference metadata and examples for `abbey plant index`.
- Regenerated deterministic CLI documentation.
- Added image-selector regression coverage for the plant index wrapper.
- Added Plant Model validation and publishing regression coverage.
- Selected Martha My Dear photo 5 through the real command.
- Published Martha My Dear's index image successfully.
- Verified the source and public index image SHA-256 hashes matched.
- Verified the built Orchid Rescue index referenced
  `/images/plants/martha-my-dear/index.jpg`.
- Restarted the local Astro preview server successfully.
- Completed a successful Astro production build containing 140 pages.

## Impact

Plant index thumbnails can now be chosen for how well they work inside a small
4:3 card without changing the photograph used elsewhere on the plant page.

The three image roles now have distinct purposes:

- `hero` represents the plant at the top of its individual page.
- `current` represents the plant's latest documented condition.
- `index` represents the plant on listing and index pages.

These roles may point to the same source photograph, but they can now be changed
independently.

The implementation remains project-configured and reusable. The Plant Model
wrapper delegates selection to the same generic image-role framework introduced
during the portable image-role session.

Existing published plants continue to work without requiring an index image.
Their index cards use the current image first and the hero image second until an
index image is explicitly selected.

## Validation

- `tests/test-abbey-image.sh`: 54 assertions passed.
- `tests/test-abbey-plant.sh`: 67 assertions passed.
- `tests/test-abbey-portability.sh`: 29 assertions passed.
- Shell syntax validation passed for `tools/bin/abbey-plant`.
- Shell syntax validation passed for `tests/test-abbey-image.sh`.
- Shell syntax validation passed for `tests/test-abbey-plant.sh`.
- `abbey docs generate` completed successfully.
- `abbey docs check` passed.
- `git diff --check` passed.
- `abbey plant index martha-my-dear` accepted interactive numbered input.
- Martha My Dear's canonical `photos.index` field was set to
  `photos/Martha - 5.JPG`.
- Martha My Dear's hero role remained `photos/Martha - 1.JPG`.
- Martha My Dear's current role remained `photos/Martha - 5.JPG`.
- `abbey plant validate martha-my-dear` completed with zero failures.
- The only validation warning was the existing unset optional
  `plant.species` field.
- `abbey plant publish martha-my-dear` completed successfully.
- Publishing created
  `site/public/images/plants/martha-my-dear/index.jpg`.
- The configured source and public index image had matching SHA-256 hashes:

      8fe1f86e832ba49d91d7218d8b3773aaba572755a8a91262f195ceb5f5468568

- Generated Martha My Dear frontmatter contained:

      indexImage: /images/plants/martha-my-dear/index.jpg

- The built Orchid Rescue index referenced:

      /images/plants/martha-my-dear/index.jpg

- `abbey site build` completed successfully.
- The production build generated 140 pages.
- The local site preview restarted successfully with PID 2017696.

## Lessons Learned

The index and current image roles are related but serve different presentation
needs.

A current image documents the latest state of a plant. An index image needs to
work well as a small, consistently cropped card thumbnail. Using one field for
both purposes was adequate initially, but became limiting once plant pages and
the Orchid Rescue index matured.

Optional image roles should provide a fallback rather than forcing immediate
content migration. Adding `photos.index: null` established the canonical field
without requiring every existing plant to select a new photograph.

The generic image-role framework made this feature small and maintainable. Most
of the work involved publishing, validation, schema, and presentation rather
than duplicating image-selection logic.

The first Plant Model test run exposed a fixture problem rather than a product
defect. The test fixture configured `photos/index.jpg` but did not create the
file. A manual validation isolated the issue, and adding the fixture image
resolved all seven failures.

End-to-end verification remained valuable even after the regression suites
passed. Confirming the built HTML referenced `index.jpg` proved that the entire
chain worked from canonical metadata through the final Astro page.

## Next Steps

- Use `abbey plant index <slug>` when a plant needs a thumbnail different from
  its current or hero image.
- Select dedicated index photographs for existing orchids when their current
  images do not crop well in the Orchid Rescue index.
- Complete the normal Abbey review, commit, pull request, and merge workflow.
- Return to the Abbey Research observation-candidate workflow after this focused
  session is complete.

## Notes

Martha My Dear photo 5 was selected as the first real index image.

Her current image also points to photo 5, so the visible photograph did not
change during this test. The important distinction is that the Orchid Rescue
index now references the independently published `index.jpg` path rather than
falling back to `current.jpg`.

No existing plant was forced to use a dedicated index image. All other plant
workspaces currently contain `photos.index: null` and retain the established
fallback behavior.
