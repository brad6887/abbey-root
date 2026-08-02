---
title: "August 2 Multi-Plant Updates"
description: "Used a real Apple Photos export to update and publish seven orchid histories through Abbey's new batch workflow."
date: 2026-08-02
draft: false
tags:
  - Abbey Root
  - BradCooke.com
  - Orchid Rescue
  - Plant Model
---

# August 2 Multi-Plant Updates

## Summary

Today the plant update workflow moved from design into normal use.

I started with one Apple Photos export containing photographs from several orchids. The captions entered on the iPhone traveled with the photos in XMP sidecars. Abbey combined those captions with the original capture dates to create descriptive filenames.

The first dry run found the intentionally uncaptained test photo and refused to rename anything. It also revealed macOS AppleDouble files that looked like photos but were only filesystem metadata. After Abbey learned to ignore those files, the real batch renamed cleanly.

The next step grouped the August 2 photos into a worksheet. This exposed two more useful distinctions. A plant without a photo that day did not need an empty update, and a plant already documented that day did not need a second one. Abbey now warns and skips both cases.

The completed worksheet contained seven plant updates and eleven photographs. After adding the narratives and choosing current images, the complete batch passed its dry run and applied successfully.

## Accomplishments

- Renamed exported photographs from iPhone captions and capture dates.
- Kept every image paired with its XMP sidecar.
- Verified that missing captions block the rename safely.
- Ignored macOS AppleDouble metadata files.
- Prepared a reviewable August 2 worksheet.
- Skipped Doctor Robert and Something because their updates already existed.
- Skipped Martha My Dear because there was no August 2 photograph.
- Updated Bungalow Bill, Helter Skelter, Honey Pie, Lady Madonna, Mother Nature's Son, Phal McCartney, and Revolution.
- Added eleven photographs across the seven plant histories.
- Selected current photographs for every multi-photo update.
- Validated every affected plant workspace with zero failures.
- Published all seven plant profiles.
- Built 149 website pages successfully.
- Captured the complete procedure in the Plant Website Updates runbook.

## Lessons Learned

The most useful automation distinguishes between normal absence, already completed work, malformed input, and real inconsistencies.

A missing plant photo is not an error. Sometimes that plant was documented the day before, and sometimes there is simply nothing new to report.

An incoming photo is not proof that an update remains pending. The canonical history is the authority.

A filename can identify the plant and date, but it cannot decide which photograph is the best current image or explain what changed. Those decisions belong in a human-reviewed worksheet.

XMP sidecars remain with the incoming originals, canonical images remain in the plant workspaces, and the publisher creates sanitized public derivatives without exposing private camera or location metadata.

## Next Steps

- Commit and push the seven completed plant updates and generated outputs.
- Use the new runbook for the next plant maintenance session.
- Consider creating canonical workspaces for the additional photographed orchids.
- Refine the workflow only when normal use exposes a concrete need.
