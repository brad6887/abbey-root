---
title: "Helter Skelter Plant Publishing Workflow"
description: "Published Helter Skelter through the Plant Model workflow and expanded the publisher to support timeline photographs."
date: 2026-07-11
draft: false
tags:
  - Abbey Root
  - BradCooke.com
  - Plant Model
  - Orchid Rescue
---

# Helter Skelter Plant Publishing Workflow

## Summary

Published Helter Skelter as the second complete Plant Model implementation and used the process to verify that the plant publishing workflow is reusable beyond Doctor Robert.

The session created a canonical workspace from imported photographs and an exported conversation, reconstructed missing photo dates, embedded verified metadata into recovered PNG files, and published the finished plant profile to BradCooke.com.

Testing the second plant exposed one real gap in the publishing workflow: photographs referenced inside `history.md` were being displayed as filenames rather than images. The publisher was expanded to copy referenced timeline photographs into the public site and replace those references with rendered Markdown images.

Doctor Robert was then republished through the improved workflow so both plant profiles use the same publishing behavior.

## Accomplishments

- Created `working/plants/helter-skelter/` from the Plant Model template.
- Identified Helter Skelter correctly as a Dendrobium orchid.
- Imported the source conversation PDF into:
  - `working/plants/helter-skelter/sources/`
- Imported 12 photographs and their matching XMP sidecars into:
  - `working/plants/helter-skelter/photos/`
- Installed `poppler-utils` to support extracting text from source PDFs.
- Extracted and reviewed the Helter Skelter conversation history.
- Verified original metadata for four JPEG photographs.
- Reconstructed dates for eight recovered PNG photographs from Apple Photos and XMP sidecars.
- Embedded the reconstructed dates into the PNG files with ExifTool.
- Documented two date discrepancies between journal labels and photo metadata.
- Completed:
  - `facts.yaml`
  - `story.md`
  - `history.md`
  - `photo-metadata.md`
  - `inventory.md`
- Selected the first photograph as the hero image.
- Selected the July 5 photograph as the current-condition image.
- Validated the workspace with `abbey plant validate helter-skelter`.
- Published Helter Skelter with `abbey plant publish helter-skelter`.
- Built the Astro site successfully.
- Visually reviewed the completed Helter Skelter page.

## Publishing Workflow Improvement

The second plant exposed a reusable publishing issue.

The original publisher copied only the configured hero and current images. Photographs listed inside `history.md` remained plain filename references and therefore did not render on the published page.

The publisher was updated to:

- Detect image filenames referenced in plant history files.
- Support Markdown bullet references and photograph headings.
- Copy only referenced history images into the public site.
- Generate stable public filenames such as:
  - `photo-01.jpeg`
  - `photo-02.png`
- Replace source filename references with Markdown images.
- Generate descriptive alt text from the plant name and timeline heading.
- Continue leaving XMP sidecars and unreferenced source files private.

The updated workflow published:

- 20 timeline photographs for Doctor Robert.
- 12 timeline photographs for Helter Skelter.

Doctor Robert was republished after the improvement so both plant pages now use the same behavior.

## Validation

The following commands completed successfully:

```text
abbey plant validate helter-skelter
abbey plant publish helter-skelter
abbey plant publish doctor-robert
abbey site build
git diff --check
