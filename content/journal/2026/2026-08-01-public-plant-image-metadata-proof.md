---
title: "Public Plant Image Metadata Proof"
description: "Validated a privacy-preserving public derivative from one canonical plant photo while retaining source integrity and provenance."
date: 2026-08-01
draft: false
tags:
  - Abbey Root
---

# Public Plant Image Metadata Proof

## Summary

Abbey Root now has a one-image proof that canonical plant photography can
remain unchanged while a separate public derivative is safely normalized and
stripped of private embedded metadata. The test used a real Martha My Dear
photo containing precise location and device information.

## Accomplishments

- Preserved the canonical source and verified its SHA-256 hash before and after
  processing.
- Applied the source's EXIF orientation before re-encoding an sRGB public JPEG.
- Verified that the derivative contains no EXIF tags, GPS data, device fields,
  comments, XMP, or embedded color profile.
- Recorded source and derivative fingerprints plus the transformation and
  verification results in a provenance manifest without copying private values.
- Kept the proof derivative unreferenced and outside the existing plant publish
  workflow.
- Passed plant validation and a 142-page Astro production build.

## Lessons Learned

- Orientation is itself metadata, so it must be applied before metadata is
  discarded.
- Re-encoding a new derivative creates a simpler and more auditable privacy
  boundary than editing selected location tags in place.
- Provenance can prove source integrity without reproducing sensitive source
  metadata.

## Next Steps

- Turn the proven transformation and verification contract into an Abbey image
  publication profile in a separate session.
- Add publisher enforcement only after the one-image workflow and desired
  policy are reviewed.
