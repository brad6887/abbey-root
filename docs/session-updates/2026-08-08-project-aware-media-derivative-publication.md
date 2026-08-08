---
title: "Project-Aware Media Derivative Publication"
description: "Added project-aware, transactional publication of privacy-safe media derivatives and deterministic manifests."
date: 2026-08-08
status: complete
reviewed: false
session: project-aware-media-derivative-publication
tags:
  - Abbey Root
---

# Project-Aware Media Derivative Publication

## Objective

Connect prepared media intake manifests to reusable, privacy-safe public image
derivatives and deterministic publication manifests.

## Definition of Done

- Add `abbey media publish <workflow> [--dry-run]`.
- Resolve named publication workflows from project-owned `.abbey/media.yml`.
- Require project-contained source, destination, intake-manifest, and
  publication-manifest paths.
- Reuse the existing verified derivative helper.
- Validate complete derivative provenance before committing outputs.
- Install derivatives and the publication manifest transactionally.
- Avoid file churn on unchanged reruns.
- Validate Abbey Root and Bread Pitt-style fixtures.

## Summary

Added named media publication workflows that consume the intake manifest from
`abbey media rename-exports`, generate sanitized public derivatives through the
existing image helper, and record deterministic source-to-public provenance.
Every derivative is staged and verified before outputs and the manifest are
installed through one rollback-capable transaction.

## Accomplishments

- Extended `.abbey/media.yml` with an optional `publish` workflow map.
- Added `abbey media publish <workflow> [--dry-run]` and registered it in CLI
  metadata.
- Added strict workflow-schema and safe project-path validation.
- Connected prepared media through its intake manifest rather than inferring
  publication state from directory contents.
- Reused `create_public_derivative.py` for orientation, resizing, re-encoding,
  metadata stripping, and private-metadata verification.
- Independently verified source and derivative SHA-256 fingerprints,
  dimensions, metadata-removal status, private-metadata status, and source
  integrity before publication.
- Added deterministic publication manifests containing captions, original and
  prepared names, source and derivative paths, dimensions, transformations,
  validation results, fingerprints, and tool provenance.
- Added staged, rollback-capable replacement of derivatives and manifests.
- Added unchanged-output detection that leaves current files untouched.
- Added focused Bread Pitt-style and Abbey-style fixtures, unsafe-path checks,
  and failure-preservation coverage.
- Updated the Project Standard, project status, CLI metadata, and generated CLI
  reference.

## Impact

Abbey now has a reusable bridge from caption-aware media preparation to public,
privacy-safe site assets. Projects can review the full plan through dry-run,
retain canonical sources unchanged, and rely on a deterministic manifest for
the next site-validation session.

## Validation

- `tests/test-abbey-media-publish.sh`: 23 passed, 0 failed.
- `tests/test-abbey-media.sh`: 22 passed, 0 failed.
- `tests/test-abbey-plant-rename-exports.sh`: 24 passed, 0 failed.
- Shell syntax validation passed for the media command and focused test suite.
- Python compilation passed for the publication orchestrator.
- `abbey docs check`: passed.
- `git diff --check`: passed.
- The real `tests/test-abbey-public-image.sh` helper suite could not run because
  ExifTool is not installed in this environment; its existing implementation
  remains unchanged, and orchestration tests use a deterministic controlled
  helper fixture.

## Lessons Learned

- The derivative helper already owned image-level sanitization and provenance;
  the reusable improvement was a project-aware batch transaction around it.
- Intake manifests provide a safer source list than directory inference and
  preserve captions and original-name provenance.
- A dry run can validate configuration and planned mappings without requiring
  ImageMagick or ExifTool, while real publication still delegates to the
  verified helper.
- Provenance from a helper should be verified before it is trusted as a
  publication safety decision.
- Tool versions belong in deterministic provenance; timestamps do not.

## Next Steps

- Make `abbey site validate` consume publication manifests and verify public
  derivatives and required routes before build or publish.
- Run the real derivative-helper suite in an environment with ExifTool and
  ImageMagick during final certification.

## Notes

No real media, site assets, deployment targets, or infrastructure were
changed. No commit or push was performed.
