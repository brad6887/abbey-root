---
title: "Site Publish Workflow"
description: "Implemented the first end-to-end production publishing workflow for BradCooke.com."
date: 2026-07-12
draft: false
tags:
  - Abbey Root
  - BradCooke.com
  - Astro
  - GitHub Pages
  - Automation
---

# Site Publish Workflow

## Summary

Implemented the first complete production publishing workflow for BradCooke.com.

Publishing the website previously required manually switching between the Abbey Root source repository and the separate GitHub Pages production repository. Those manual steps have now been encapsulated in a new `abbey site publish` command.

The workflow validates both repositories, builds the Astro site, previews the production changes, preserves the custom domain configuration, copies the generated site into the production repository, and guides the user through committing and publishing the changes.

A safe `--dry-run` mode was also introduced, allowing the entire workflow to be previewed without modifying production.

The workflow was immediately validated by publishing the new Museum of Dumb Ideas section and the first OmeletYouFinish.com exhibit.

## Accomplishments

- Implemented `abbey site publish`.
- Added `abbey site publish --dry-run`.
- Automated publication from the Astro source repository to the GitHub Pages repository.
- Automatically preserved the production `CNAME` file.
- Added validation to ensure both repositories are clean before publishing.
- Added an `rsync` preview before production changes are made.
- Added confirmation before modifying the production repository.
- Added confirmation before committing and pushing.
- Updated the CLI metadata and regenerated the CLI reference documentation.
- Successfully published the Museum of Dumb Ideas using the new workflow.
- Configured OmeletYouFinish.com to permanently redirect to its exhibit on BradCooke.com.

## Lessons Learned

- Publishing is a distinct workflow from building and deserves its own Abbey command.
- Keeping the Astro source repository separate from the generated GitHub Pages repository provides a clean separation between source and production artifacts.
- A `--dry-run` mode greatly increases confidence before publishing.
- Interactive confirmation steps strike a good balance between automation and protecting production.
- The publishing workflow reinforced one of Abbey Root's core principles: once a manual process has been repeated enough times, it should become an Abbey command.

## Next Steps

- Reduce the verbosity of the publish preview so it highlights only meaningful changes.
- Add automatic verification of the live site after publication.
- Implement `abbey site deploy-check` as a reusable pre-publication validation command.
- Continue refining the BradCooke.com publishing workflow as additional site sections are added.
- Use the new publishing workflow for all future BradCooke.com updates.
