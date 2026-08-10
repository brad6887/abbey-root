---
title: "Rocky Raccoon Plant Publication"
description: "Created, validated, and published Rocky Raccoon's canonical plant profile through the new Abbey onboarding workflow."
date: 2026-08-02
status: complete
reviewed: true
session: rocky-raccoon-plant-publication
tags:
  - Abbey Root
  - Plant Toolkit
  - Orchid Rescue
---

# Rocky Raccoon Plant Publication

## Objective

Use `abbey plant new` for a real plant onboarding, correct any workflow defects exposed through normal use, and publish Rocky Raccoon's initial profile.

## Definition of Done

- Create Rocky Raccoon's workspace through `abbey plant new`.
- Preserve the original photograph and its XMP sidecar.
- Record verified plant facts without guessing unknown values.
- Replace all scaffold content with plant-specific history, inventory, story, and photo metadata.
- Validate the canonical workspace.
- Publish sanitized public image derivatives and generated site content.
- Build the site successfully.
- Review the complete Git change set before committing.

## Summary

Rocky Raccoon became the first plant onboarded through the new `abbey plant new` command during normal use on `ubuntu-dev01`.

The initial run exposed two workflow gaps: adjacent XMP sidecars were not imported, and validation could not distinguish untouched scaffold documents from completed plant content. Both defects were corrected with regression coverage before the workspace was recreated.

The completed profile records Rocky as a recovering Phalaenopsis orchid rescued from the Lowe's clearance rack in Keller, Texas. The species and hybrid status remain unknown rather than guessed.

## Accomplishments

- Corrected the plant name from the initial misspelling “Rocky Racoon” to “Rocky Raccoon” in the XMP metadata.
- Renamed the original photo and sidecar through `abbey plant rename-exports`.
- Created the canonical workspace through `abbey plant new`.
- Verified byte-for-byte preservation of the imported JPG and XMP sidecar.
- Recorded verified facts, current inventory, initial rescue history, public story, and photo provenance.
- Published the generated plant page and sanitized hero, current, and history images.
- Generated a non-public publication manifest with source hashes and transformation details.
- Confirmed that public derivatives contain no private metadata.
- Built the complete 154-page site successfully.

## Impact

Plant onboarding is now validated through a real use case. The workflow preserves adjacent photo metadata, reports unfinished scaffold content clearly, and produces reviewable canonical and public artifacts without exposing private image metadata.

Rocky Raccoon's profile is ready to enter version control and the Orchid Rescue site.

## Validation

- `tests/test-abbey-plant.sh` — 104 passed, 0 failed.
- `abbey plant validate rocky-raccoon` — 19 OK, 1 intentional unknown-species warning, 0 failures.
- Canonical JPG compared byte-for-byte with the incoming source.
- Imported XMP sidecar compared byte-for-byte with the corrected incoming source.
- Publication manifest reports `canonical_original_preserved: true`.
- Publication manifest reports `private_metadata_detected: false`.
- Public metadata inspection found no GPS or serial-number fields.
- `abbey site build` — 154 pages built successfully.

## Lessons Learned

A structurally valid workspace is not necessarily publication-ready. Validation should identify unfinished scaffold content without treating honest unknown facts as failures.

Preserving an original photograph also means preserving its adjacent metadata. A real onboarding run exposed that requirement more clearly than fixture-only testing.

Unknown species and hybrid information should remain explicit rather than being inferred from a generic retail tag.

## Next Steps

- Inspect Rocky's roots and confirm whether a nursery plug is present.
- Record any watering, trimming, root work, or repotting as a dated update.
- Select a dedicated index image later if a better photograph becomes available.
- Continue monitoring hydration, leaf firmness, and new growth.

## Notes

The remaining species warning is intentional because the Lowe's tag did not designate a species.
