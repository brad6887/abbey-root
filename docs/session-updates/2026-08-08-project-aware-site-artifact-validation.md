---
title: "Project-Aware Site Artifact Validation"
description: "Added a read-only site gate for publication manifests, public derivatives, and generated routes."
date: 2026-08-08
status: complete
reviewed: false
session: project-aware-site-artifact-validation
tags:
  - Abbey Root
---

# Project-Aware Site Artifact Validation

## Objective

Prevent stale, unsafe, or cross-project media manifests and missing site routes
from reaching an Abbey project publishing target.

## Definition of Done

- Add `abbey site validate` as a read-only command.
- Load validation rules only from the active project's `.abbey/project.yml`.
- Verify publication-manifest ownership, paths, fingerprints, image facts, and
  privacy and source-integrity results.
- Verify configured generated routes.
- Run the same gate during site build and publish.
- Prove Abbey Root and Bread Pitt-style behavior and cross-project isolation.

## Summary

Added a project-aware validation boundary between media publication and site
deployment. Projects may now declare their public asset root, publication
manifests, and required routes under `site.validation`. The command performs no
writes and refuses missing, stale, unsafe, duplicated, or foreign artifacts.

## Accomplishments

- Added `abbey site validate` and registered it in CLI metadata.
- Added schema-version-1 publication-manifest validation.
- Required each configured manifest to name the active project.
- Restricted manifest, source, derivative, public-root, and site-output paths
  to the active project.
- Verified source and derivative SHA-256 fingerprints.
- Read PNG, JPEG, and WebP file headers to independently verify derivative
  format and dimensions without changing files.
- Rechecked canonical-source, metadata-removal, private-metadata, and
  source-integrity assertions.
- Rejected duplicate public derivative destinations across manifests.
- Verified root, directory-style, and file-style generated routes.
- Integrated the gate after `abbey site build` and before any publish preview
  or production change.
- Made the standalone npm build path stop immediately when its configured build
  command fails instead of continuing into artifact validation.
- Added an Abbey Root route requirement and Bread Pitt-style media and route
  fixtures.
- Added regression coverage proving foreign manifests and stale derivatives
  fail closed.

## Impact

Site publication now consumes the provenance created by Abbey media tooling
instead of trusting that generated files still match it. An Abbey project
cannot accidentally validate another project's publication manifest or publish
after a configured derivative or route disappears.

## Validation

- `tests/test-abbey-site.sh`: 41 passed, 0 failed.
- Python compilation passed for the site validator.
- Shell syntax validation passed for the site command and regression suite.
- The real Abbey Root Astro build could not run because npm was absent and the
  bundled package runner required a blocked registry fetch; no dependencies
  were installed and no network access was requested.

## Lessons Learned

- Publication provenance becomes materially safer when the publishing boundary
  independently checks it rather than relying on the generating command.
- Project ownership belongs in the manifest contract as well as path
  resolution; a safe local path can still describe the wrong project's data.
- Route requirements should be explicit project configuration because content
  models and URL structures differ across sites.

## Next Steps

- Configure Bread Pitt's real publication manifest and required routes when its
  media publication workflow is adopted in that repository.
- Extend validation only when another generated artifact type establishes a
  stable, project-owned manifest contract.

## Notes

No site was published and no production target was changed. No commit or push
was performed.
