---
title: "Public Plant Image Metadata Proof"
description: "Proved that one canonical plant photo can retain its original metadata while a public derivative is orientation-normalized, re-encoded, stripped, and verified."
date: 2026-08-01
status: completed
reviewed: false
session: public-plant-image-metadata-proof
tags:
  - Abbey Root
---

# Public Plant Image Metadata Proof

## Objective

Sanitize one real plant photograph as a bounded proof of concept without
modifying the canonical original or integrating the process into the plant
publish workflow.

## Definition of Done

- Select one canonical plant photo containing private embedded metadata.
- Preserve and verify the source file's SHA-256 fingerprint.
- Create one correctly oriented public derivative with metadata omitted.
- Verify that the derivative contains no EXIF, GPS, device, comment, or XMP
  metadata.
- Record non-sensitive provenance for the source, transformation, derivative,
  and validation result.
- Validate the plant workspace and website build.

## Summary

Used Martha My Dear's August 1 current photograph to validate the proposed
canonical-original/public-derivative boundary. The source contains precise GPS
and device metadata, making it a representative privacy test. A distinct,
unreferenced proof derivative was generated without changing the source.

## Accomplishments

- Confirmed that the selected source contains GPS, timestamp, orientation, and
  device metadata.
- Recorded the source hash before processing and confirmed the same hash after
  processing.
- Applied EXIF orientation before re-encoding the image as an optimized,
  progressive, quality-88 sRGB JPEG.
- Verified zero EXIF tags, no GPS IFD, and no embedded EXIF, ICC, comment, XMP,
  or private-field matches in the derivative.
- Added a machine-readable provenance manifest without copying private metadata
  values into it.
- Kept the proof derivative disconnected from canonical plant metadata and site
  content references.

## Impact

The experiment demonstrates that Abbey Root can preserve rich canonical source
material and provenance while producing a safer public asset. It also provides
a concrete transformation and validation contract for a later publish-workflow
implementation.

## Validation

- Source SHA-256 before and after:
  `da7fd1a2dc0f93a8a5691f522ac5c6d8ba1d52ae5ba7e3e3ef9a61578dacdc92`.
- Derivative SHA-256:
  `94d0bf8bb5cd50d4eed8ce7b2ea4eac52864817cb03c7fe63df7bf2c1dc55dea`.
- Provenance manifest parses as valid JSON.
- `abbey plant validate martha-my-dear`: 20 OK, 1 unrelated optional-field
  warning, 0 failures.
- Direct metadata inspection: zero EXIF tags, zero EXIF/comment/ICC bytes, no
  GPS IFD, and no forbidden private metadata hits.
- Site reference search confirms the proof derivative is unreferenced.
- Astro production build: 142 pages built successfully.

## Lessons Learned

Orientation must be normalized before discarding EXIF because this source uses
EXIF orientation rather than physically rotated pixels. A new re-encoded file
also gives a clearer safety boundary than selectively deleting known GPS tags.

## Next Steps

- Use this validated transformation and verification contract when designing a
  reusable Abbey public-image profile and plant publish integration.
- Keep workflow integration, batch migration, and policy enforcement out of
  this proof-of-concept session.

## Notes

The standard `abbey site build` wrapper could not find `npm` in the Codex
environment, so the same configured Astro build was run directly with the
bundled Node runtime. No existing public plant image was replaced.
