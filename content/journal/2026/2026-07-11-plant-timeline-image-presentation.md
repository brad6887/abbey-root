---
title: "plant-timeline-image-presentation"
description: "Improved shared image sizing and spacing across published plant timelines."
date: 2026-07-11
draft: false
tags:
  - Abbey Root
  - Plants
  - Astro
---

# plant-timeline-image-presentation

## Summary

Improved the shared presentation of timeline photographs across Abbey Root plant profiles.

Doctor Robert and Helter Skelter had confirmed that the Plant Model publishing workflow was reusable, but they also exposed a shared presentation issue. Photographs with different dimensions could display at inconsistent or excessively large sizes.

The issue was corrected in the shared Astro plant-page styling without changing the publisher, generated Markdown, Plant Model, or original source photographs.

## Accomplishments

- Added reusable styling for Markdown-generated images inside `.plant-content`.
- Limited timeline photographs to the width of the plant content area.
- Added a maximum image height of 650 pixels.
- Preserved the aspect ratio of portrait and landscape photographs.
- Prevented narrow photographs from being stretched across the full page.
- Centered timeline photographs and added consistent vertical spacing.
- Applied the existing plant-page border radius to timeline images.
- Visually reviewed Doctor Robert and Helter Skelter at desktop and narrow browser widths.
- Confirmed the Astro site build completed successfully with all 41 pages generated.
- Kept `abbey plant publish` and the wider Plant Model workflow unchanged.

## Lessons Learned

- The Plant Model and publisher were producing valid, reusable Markdown image markup.
- The inconsistent image presentation belonged in the shared Astro presentation layer.
- Astro component styles require `:global(img)` to target images generated from rendered Markdown content.
- Preserving original plant photographs as the source of truth does not prevent consistent web presentation.
- A small shared CSS rule solved the immediate problem without introducing an unnecessary image-processing or gallery system.

## Next Steps

- Continue publishing the remaining plant profiles using the existing workflow.
- After the initial plant collection is published, perform a separate editorial review.
- Rewrite selected plant narratives in Brad's voice.
- Review the order and placement of selected photographs during that editorial pass.
- Evaluate image file-size optimization, captions, lazy loading, or a gallery component only if later testing shows they are necessary.
