---
title: "Doctor Robert content pipeline"
description: "Established a reusable workflow for documenting and publishing orchid rescue histories."
date: 2026-07-08
draft: false
tags:
  - Abbey Root
  - BradCooke.com
  - Orchid Rescue
  - Content Pipeline
---

# Doctor Robert content pipeline

## Summary

Today's session established the content pipeline for the Orchid Rescue project using Doctor Robert as the first complete example.

Rather than simply writing a webpage, the effort focused on developing a repeatable process for preserving the history of a rescue plant. Doctor Robert's journey was reconstructed from photographs, previous journals, and personal observations, resulting in a detailed historical record that can serve as the foundation for future storytelling and website content.

The session also explored long-term content architecture, separating factual records, narrative content, historical journals, and photo metadata into independent source documents that can eventually be assembled into a published page by Abbey Root or future AI Worker tooling.

## Accomplishments

- Reconstructed Doctor Robert's rescue history from March through July 2026.
- Organized the rescue into a chronological journal with observations, notes, and lessons learned.
- Restored metadata for recovered PNG images, including capture dates, descriptions, artist, and copyright information.
- Verified embedded metadata using ExifTool.
- Created a reusable workflow for documenting future Orchid Rescue plants.
- Defined separate roles for `history.md`, `story.md`, `facts.md`, and photo metadata files.
- Identified Doctor Robert as the reference implementation for future plant profiles.
- Began designing a reusable content pipeline that can eventually generate BradCooke.com pages from structured source material.

## Lessons Learned

- Photograph metadata is an important part of preserving a project's history and should be restored whenever original information is available.
- A chronological journal provides a stronger foundation for storytelling than writing directly for publication.
- Separating facts, history, and narrative creates a more maintainable content model.
- Doctor Robert proved that photographs, observations, and journal entries can be successfully reconstructed into a cohesive historical record.
- This workflow extends beyond orchids and can be applied to many future BradCooke.com projects.

## Next Steps

- Complete `story.md` as the public narrative for Doctor Robert.
- Create `facts.md` to serve as structured metadata for the website.
- Design the Orchid Rescue content model for BradCooke.com.
- Continue documenting the remaining orchids using the same workflow.
- Evaluate how AI Worker can assemble structured project content into publishable website pages while keeping the source material as the single source of truth.
