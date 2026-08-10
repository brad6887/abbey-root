---
title: "Sanitized Public Plant Image Publishing"
description: "Added a reusable public-image derivative workflow that removes private metadata while preserving canonical plant photographs and publication provenance."
date: 2026-08-01
status: completed
reviewed: true
session: sanitized-public-plant-image-publishing
tags:
  - abbey
  - plants
  - publishing
  - images
  - privacy
  - provenance
---

# Sanitized Public Plant Image Publishing

## Objective

Prevent GPS coordinates, device information, capture timestamps, embedded
thumbnails, and other private metadata from being published with plant images
while preserving canonical originals and documented provenance.

## Definition of Done

- Canonical plant photographs remain unchanged.
- Public images are generated as sanitized derivatives instead of direct copies.
- Embedded orientation is applied before metadata removal.
- Public images are converted to sRGB.
- The longest image edge is limited to 2400 pixels.
- Private metadata is removed and verified absent.
- Publication fails safely when transformation or validation fails.
- Source and derivative hashes are recorded outside the public website tree.
- Existing public plant images are regenerated through the new workflow.
- Regression tests and the Astro site build pass.

## Summary

Implemented a reusable public-image derivative helper and integrated it with
`abbey plant publish`.

Canonical photographs under `working/plants/<slug>/photos/` remain the source
of truth and retain their original camera metadata. The publisher now creates
website-facing derivatives under `site/public/images/plants/<slug>/`.

Each public derivative is:

- auto-oriented
- resized to a maximum long edge of 2400 pixels
- converted to sRGB
- stripped of embedded metadata
- written atomically
- checked for potentially private metadata
- verified against the unchanged source hash

The workflow also creates a machine-generated publication manifest at
`generated/plant-publication/<slug>.json`.

This manifest supplements the human-maintained provenance in
`photo-metadata.md`; it does not replace it.

## Proof of Concept

The workflow was first tested using the August 1 Martha My Dear photograph.

The original contained:

- precise GPS coordinates
- iPhone make and model
- Apple MakerNotes
- capture timestamps
- a device photo identifier
- an embedded EXIF thumbnail
- an additional embedded image

The canonical source SHA-256 hash was:

    da7fd1a2dc0f93a8a5691f522ac5c6d8ba1d52ae5ba7e3e3ef9a61578dacdc92

The generated public derivative:

- preserved the correct portrait orientation
- measured 1800 by 2400 pixels
- was reduced from approximately 3.8 MB to approximately 603 KB
- contained no detected private metadata
- left the canonical source hash unchanged

## Implementation

Added:

- `tools/image/create_public_derivative.py`
- `tests/test-abbey-public-image.sh`

Updated:

- `tools/bin/abbey-plant`
- `tests/test-abbey-plant.sh`
- `docs/reference/PLANT_MODEL.md`
- `docs/planning/BACKLOG.md`

`abbey plant publish` now uses the shared derivative helper for:

- hero images
- current images
- index images
- timeline and history images

The publisher requires ImageMagick and ExifTool and fails before publication
when either dependency is unavailable.

The helper supports ImageMagick 6 through `convert` and ImageMagick 7 through
`magick`.

## Provenance

Each publication manifest records:

- repository-relative canonical source path
- canonical source SHA-256 hash
- repository-relative public derivative path
- derivative SHA-256 hash
- generated image dimensions
- output format
- transformation settings
- ImageMagick version
- ExifTool version
- publication role or history-image assignment
- source-integrity validation result
- private-metadata validation result

The manifests do not copy GPS coordinates or other removed private values.

## Existing Image Remediation

A metadata audit inspected 216 existing public plant images.

The audit identified 154 images containing camera or private metadata across
nine plant profiles:

- Bungalow Bill
- Doctor Robert
- Helter Skelter
- Honey Pie
- Lady Madonna
- Mother Nature's Son
- Phal McCartney
- Revolution
- Something

All nine profiles were republished through the new derivative workflow.

Martha My Dear had already been regenerated during the proof of concept.

Canonical photographs were hashed before republishing, and every source passed
the post-publication integrity check.

## Validation

The public-image helper regression suite passed:

    PASS: 8
    FAIL: 0

The plant regression suite passed:

    Passed: 72
    Failed: 0

Real Martha publication validation confirmed:

- 10 public image records
- 3 role images
- 7 history images
- all source and derivative hashes matched
- all public images contained no audited private metadata
- all public images were within the 2400-pixel limit

The final complete public-image audit confirmed:

- 216 public plant images inspected
- no audited private metadata detected
- no image exceeded the 2400-pixel limit
- every generated publication manifest matched its source and derivative files

Plant validation completed successfully with one existing optional-field
warning for Martha My Dear's unset species.

The Astro production build completed successfully with 142 pages built.

`git diff --check` completed without errors.

## Result

Public plant photographs are no longer direct copies of canonical originals.

The publishing workflow now preserves the complete private historical record
while producing smaller, correctly oriented, privacy-safe images for the
public website.

The backlog item to remove GPS and other private location metadata from
generated public plant images is complete.

## Next Steps

- Run `abbey backlog refresh`.
- Run `abbey review`.
- Review the complete image and manifest diff.
- Commit the sanitized publishing workflow and regenerated public images.
