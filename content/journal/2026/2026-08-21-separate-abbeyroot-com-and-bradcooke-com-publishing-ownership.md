---
title: "Separate AbbeyRoot.com and BradCooke.com Publishing Ownership"
description: "Completed the publishing boundary between AbbeyRoot.com, BradCooke.com, and the shared Plant Model."
date: 2026-08-21
session_update: "docs/session-updates/2026-08-21-separate-abbeyroot-com-and-bradcooke-com-publishing-ownership.md"
draft: false
tags:
  - Abbey Root
  - BradCooke.com
  - publishing
---

# Separate AbbeyRoot.com and BradCooke.com Publishing Ownership

## Summary

AbbeyRoot.com and BradCooke.com now have separate, explicit publishing
ownership. The earlier site redesign had removed personal and plant pages from
Abbey Root, but BradCooke.com still existed only as generated GitHub Pages
output. This session restored its rebuildable Astro source and made it a
first-class Abbey project.

## Accomplishments

- Gave BradCooke.com its own Abbey project and site publishing configuration.
- Restored the personal pages, museum, projects, Orchid Rescue source, and all
  11 existing public plant profiles.
- Kept canonical plant workspaces and shared tools in Abbey Root.
- Changed plant publication into an explicit export that verifies the
  BradCooke.com project slug, domain, and destination paths before writing.
- Added a BradCooke.com-owned GitHub Pages build and deployment workflow.
- Built and validated both sites independently without publishing either one.

## Lessons Learned

- Separation is an ownership property, not just a routing change. A destination
  site needs its own source, configuration, validation, and deployment path.
- Cross-project exports should verify both ends of the contract and fail closed
  before creating directories or generated files.
- Preserving canonical plant history in Abbey Root works cleanly once
  BradCooke.com owns only its derived public representation.

## Next Steps

- Enable the repository's GitHub Actions Pages source.
- Validate one real plant export into BradCooke.com.
- Review and explicitly approve the first independent BradCooke.com deployment.
