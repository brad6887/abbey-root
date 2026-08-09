---
title: "August 9 Multi-Plant Updates"
description: "Updated and published eleven orchid histories from sixteen photographs while finding an important serialization rule in the publishing workflow."
date: 2026-08-09
draft: false
tags:
  - Abbey Root
  - BradCooke.com
  - Orchid Rescue
  - Plant Model
---

# August 9 Multi-Plant Updates

## Summary

This week's orchid update started with eighteen captioned photographs and ended with eleven updated plant histories, sixteen canonical photos, and 169 successfully built website pages.

The first rename preview caught three names without matching workspaces. Martha was simply captioned too briefly, so I corrected her metadata to Martha My Dear. All Together Now and Sun King are real future projects, but they are not ready for publication. Their original photo and XMP pairs were moved aside intact for later onboarding.

The remaining photographs grouped cleanly into an August 9 worksheet. Every orchid was fertilized. Phal McCartney was repotted, Doctor Robert had dead roots removed, and Martha My Dear and Revolution each dropped a yellow leaf during the week. The worksheet preserved every existing status while recording those changes.

All eleven plant workspaces validated with zero failures. Publication created twenty-seven affected public derivatives, each with its canonical source preserved, its source hash unchanged, and no detected private metadata.

The final site build generated 169 pages successfully.

## Accomplishments

- Validated the complete incoming export before renaming anything.
- Deferred All Together Now and Sun King without deleting their source material.
- Corrected Martha My Dear's shortened caption.
- Renamed sixteen active photo and XMP pairs.
- Updated Bungalow Bill, Doctor Robert, Helter Skelter, Honey Pie, Lady Madonna, Martha My Dear, Mother Nature's Son, Phal McCartney, Revolution, Rocky Raccoon, and Something.
- Recorded fertilizing for all eleven orchids.
- Documented Phal McCartney's repot and Doctor Robert's root cleanup.
- Documented the yellow-leaf drops for Martha My Dear and Revolution.
- Selected current images for the two multi-photo observations.
- Validated and published all eleven orchid profiles.
- Verified canonical-source preservation and metadata removal for twenty-seven affected derivatives.
- Built all 169 website pages successfully.

## Lessons Learned

Valid metadata still needs context. All Together Now and Sun King had usable captions, but their missing workspaces correctly stopped them from silently entering the established collection.

The publisher also exposed a less obvious operational rule. It cannot safely be treated as a normal multi-item shell loop or run concurrently. The Abbey wrapper exits after one plant, while concurrent publication shares temporary output state. Separate serialized invocations produced the correct pages and clean generated files.

A successful site build is only one checkpoint. The more useful final proof is that every intended page contains the new observation and every affected publication record confirms source preservation and public metadata removal.

## Next Steps

- Review, commit, and push the complete August 9 update.
- Consider adding a dedicated serialized multi-plant publishing workflow.
- Onboard All Together Now and Sun King in their own focused sessions.
