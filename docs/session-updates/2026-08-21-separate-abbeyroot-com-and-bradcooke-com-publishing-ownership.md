---
title: "Separate AbbeyRoot.com and BradCooke.com Publishing Ownership"
description: "Made BradCooke.com an independent Abbey project and moved plant publication behind an explicit cross-project ownership boundary."
date: 2026-08-21
status: complete
reviewed: true
session: separate-abbeyroot-com-and-bradcooke-com-publishing-ownership
journal: "content/journal/2026/2026-08-21-separate-abbeyroot-com-and-bradcooke-com-publishing-ownership.md"
tags:
  - Abbey Root
  - BradCooke.com
  - publishing
  - plants
---

# Separate AbbeyRoot.com and BradCooke.com Publishing Ownership

## Objective

Complete the separation of AbbeyRoot.com and BradCooke.com publishing
ownership while preserving canonical plant data and existing public plant
content.

## Definition of Done

- BradCooke.com is a first-class Abbey project with its own site configuration.
- Plant publishing has an explicit, validated BradCooke.com target.
- Abbey Root can publish only its AbbeyRoot.com site.
- Plant and Orchid Rescue workflows no longer pass through Abbey Root's site.
- Existing plant Markdown, public derivatives, and manifests are preserved.
- Both Astro sites build and validate independently.

## Summary

BradCooke.com's last complete Astro source and generated plant inputs were
restored into the production repository. Abbey Root now exports plant output
only after verifying the destination's Abbey identity, configured domain, and
project-owned paths. Each site owns its own build and deployment configuration.

## Accomplishments

- Added explicit plant export ownership to Abbey Root's project metadata.
- Made the plant publisher resolve all generated output inside the configured
  BradCooke.com project.
- Added source-project and target-project identity to plant publication
  manifests.
- Added a project-aware GitHub Pages publishing backend to the shared site
  command.
- Restored BradCooke.com's Astro source, content, museum, projects, Orchid
  Rescue pages, plant assets, and publication manifests.
- Added BradCooke.com Abbey metadata and a project-owned Pages workflow.
- Updated architecture, Plant Model, content ownership, and operational
  guidance.

## Impact

Abbey Root and BradCooke.com can now evolve and publish independently.
Canonical plant history stays with the Plant Model, while the public website
owns only derived, reviewable output.

## Validation

- Abbey plant regression suite: 127 passed, 0 failed.
- New GitHub Pages publishing cases passed in the site regression suite.
- AbbeyRoot.com Astro build: 159 pages.
- BradCooke.com Astro build: 179 pages.
- AbbeyRoot.com required-route validation passed.
- BradCooke.com required-route validation passed.
- BradCooke.com preserves 11 plant profiles, 11 public image directories, and
  11 publication manifests.
- No Orchid Rescue, museum, or public plant paths were generated in the Abbey
  Root site.
- `git diff --check` passed in both repositories.

## Lessons Learned

The August 10 site split removed BradCooke.com from Abbey Root correctly, but a
publishing separation is incomplete until the destination repository owns
rebuildable source and plant output is routed through explicit project
metadata. A generated production checkout alone is not an independent project.

## Next Steps

- Enable GitHub Actions as the Pages publishing source before the first
  BradCooke.com deployment.
- Perform one reviewed `abbey plant publish` against the real BradCooke.com
  checkout.
- Run a BradCooke.com publish dry run, then explicitly approve the first live
  Pages handoff.

## Notes

No push, live publication, or deployment occurred in this session.
