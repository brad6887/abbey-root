---
title: "August 9 Multi-Plant Updates"
description: "Completed and published eleven orchid observations from sixteen photographs while identifying a serialization requirement in the multi-plant publishing workflow."
date: 2026-08-09
status: complete
reviewed: true
session: august-9-multi-plant-updates
tags:
  - Abbey Root
  - BradCooke.com
  - Orchid Rescue
  - Plant Model
---

# August 9 Multi-Plant Updates

## Objective

Process the August 9 Apple Photos export through the established Abbey batch workflow, review and apply the weekly orchid observations, publish every affected profile, verify the public derivatives, and capture any workflow lessons exposed through normal use.

## Definition of Done

- Exported photos are validated and renamed from their XMP captions and capture dates.
- Photos for plants without canonical workspaces are preserved outside the active batch.
- The batch worksheet is reviewed before changing plant histories.
- Every included observation has a narrative, care note, and explicit current-photo choice when required.
- The complete batch passes a dry run before apply.
- Every affected plant validates and publishes with zero failures.
- Canonical source preservation and public metadata removal are verified.
- The complete website builds successfully.
- The final repository diff passes formatting validation and is ready for commit review.

## Summary

Completed the August 9 weekly update for eleven orchids using sixteen photographs.

The rename preview identified three captions without matching plant workspaces. Martha was corrected to Martha My Dear. All Together Now and Sun King are future plant projects, so their original photo and XMP pairs were preserved under `~/incoming/deferred-plants` and excluded from this batch.

The reviewed worksheet recorded fertilizing for every orchid, Phal McCartney's repot, dead-root removal for Doctor Robert, and mid-week yellow-leaf drops for Martha My Dear and Revolution. Bungalow Bill's first photo and Phal McCartney's fifth photo were selected as their current images.

All eleven workspaces validated with zero failures. Publication generated the eleven updated profiles and twenty-seven affected public derivatives. The manifests confirmed canonical-source preservation, unchanged source hashes, and no detected private metadata. Astro built 169 pages successfully.

Real use also exposed that multi-plant publication cannot be treated as an ordinary shell loop or run concurrently. The Abbey wrapper exits its shell after one publication, and concurrent publishers share temporary output state. Publishing each plant in a separate serialized invocation produced the correct result.

## Accomplishments

- Validated eighteen incoming photo and XMP pairs before changing filenames.
- Preserved All Together Now and Sun King for later onboarding.
- Corrected Martha My Dear's XMP caption before the bulk rename.
- Renamed sixteen active photo and XMP pairs deterministically.
- Prepared and reviewed an eleven-plant worksheet.
- Applied updates for:
  - Bungalow Bill
  - Doctor Robert
  - Helter Skelter
  - Honey Pie
  - Lady Madonna
  - Martha My Dear
  - Mother Nature's Son
  - Phal McCartney
  - Revolution
  - Rocky Raccoon
  - Something
- Recorded fertilizing for all eleven orchids.
- Recorded Phal McCartney's repot and selected the completed-repot photograph as current.
- Recorded dead-root removal for Doctor Robert.
- Recorded the yellow-leaf drops for Martha My Dear and Revolution.
- Copied sixteen photographs into canonical plant workspaces.
- Preserved all existing plant statuses.
- Published all eleven plant profiles through serialized invocations.
- Verified twenty-seven affected public derivatives.
- Built the complete website successfully.

## Impact

The weekly orchid workflow remains effective from captioned Apple Photos exports through reviewed canonical histories and sanitized public pages.

Unknown plant captions were handled without deleting or forcing incomplete workspaces. The deferred source pairs remain available for deliberate onboarding sessions.

The publication finding identifies a clear boundary for future automation: a true multi-plant publisher must serialize shared output work or provide isolated temporary state before parallel execution is safe.

## Validation

- Rename dry run validated eighteen media pairs before the two future projects were deferred.
- Final rename dry run validated sixteen active media pairs.
- Batch preparation produced eleven pending updates with no failures.
- Batch dry run validated all eleven updates and changed no canonical files.
- Batch apply completed eleven updates containing sixteen photos.
- All eleven plant workspaces passed validation with zero failures.
- Optional unknown species and rescue-date warnings remained informational.
- Every generated plant page contains the August 9 observation.
- All twenty-seven affected derivative records report `canonical_original_preserved: true`.
- All twenty-seven affected derivative records report `source_hash_unchanged: true`.
- All twenty-seven affected derivative records report `private_metadata_detected: false`.
- Direct metadata inspection found no GPS or camera serial fields in affected public derivatives.
- Astro built 169 pages successfully.
- Abbey site artifact validation passed.
- `git diff --check` passed.

## Lessons Learned

Caption validation remains an important review boundary. A valid caption can still name a future project or use a shortened name that does not match the canonical workspace slug.

Future plant photos should be moved aside intact rather than deleted or forced through the current batch.

The current `abbey plant publish` workflow should be invoked once per plant in separate, serialized processes. The wrapper exits the calling shell, and concurrent publication can collide through shared temporary output state.

A successful site build does not prove that every intended profile was freshly published. The final audit must confirm the observation date in every generated page and validate the corresponding manifest entries.

## Next Steps

- Review the final repository diff.
- Commit the canonical plant updates, session capture, and generated publication outputs together.
- Push the completed content session.
- Consider a dedicated serialized multi-plant publish command or documented helper.
- Onboard All Together Now and Sun King in separate focused sessions.

## Notes

The worksheet under `working/plant-updates` is intentionally ignored because it contains a machine-specific incoming path.

The original photo and XMP pairs for All Together Now and Sun King remain under `/home/bcooke/incoming/deferred-plants`.
