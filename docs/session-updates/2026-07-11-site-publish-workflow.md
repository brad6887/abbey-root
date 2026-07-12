---
date: 2026-07-12
title: Site Publish Workflow
status: complete
session: standard
journal: 2026-07-12-site-publish-workflow
reviewed: false
---

# Session Update

## Summary

Implemented the first production publishing workflow for BradCooke.com.

Until this session, building the Astro site and publishing it to GitHub Pages required manually switching between two repositories and performing several repetitive steps. Those steps are now encapsulated in a single Abbey command.

The new `abbey site publish` command builds the website, validates both repositories, previews the production changes, preserves the custom domain configuration, updates the GitHub Pages repository, and publishes the site through a guided workflow.

A non-destructive `--dry-run` mode was also introduced, allowing publication to be previewed without modifying the production repository.

## Objectives Completed

- Added `abbey site publish`.
- Added `abbey site publish --dry-run`.
- Added production repository validation.
- Added Abbey Root repository validation.
- Preserved the production `CNAME` automatically.
- Integrated the production build into the publishing workflow.
- Added an `rsync` preview before publication.
- Added confirmation before modifying the production repository.
- Added confirmation before committing and pushing.
- Updated the CLI metadata.
- Regenerated the CLI reference documentation.
- Published the Museum of Dumb Ideas using the new workflow.

## Workflow

The publish command now performs the following sequence:

1. Verify the Abbey Root repository is clean.
2. Verify the production repository is clean.
3. Verify the production `CNAME`.
4. Build the Astro production site.
5. Preview the publication using `rsync`.
6. Support a safe `--dry-run` mode.
7. Copy the generated site into the production repository.
8. Preserve the custom domain configuration.
9. Display the production Git changes.
10. Confirm before committing.
11. Commit the generated site.
12. Push to GitHub.
13. Allow GitHub Pages to publish the updated site.

## Architecture

BradCooke.com intentionally uses two repositories.

### Abbey Root

Contains:

- Astro source code
- Content collections
- Stylesheets
- Components
- Documentation
- Publishing tooling

### brad6887.github.io

Contains only the generated static production website served by GitHub Pages.

This separation keeps generated files out of the source repository while allowing the website to remain a standard GitHub Pages site.

## Validation

The workflow was validated using the Museum of Dumb Ideas publication.

Validation confirmed:

- Astro production build completed successfully.
- The generated site copied correctly.
- The production repository remained clean after publication.
- GitHub Pages published successfully.
- `https://bradcooke.com/museum/omelet-you-finish/` returned HTTP 200.
- `https://omeletyoufinish.com/` permanently redirected to the published exhibit.

## Design Decisions

Publishing intentionally remains an explicit operation rather than automatically occurring after every build.

Separating `build` and `publish` allows content and layout changes to be reviewed locally before updating the public website.

The addition of `--dry-run` provides a safe way to verify exactly what will change before production is modified.

## Future Work

- Reduce noise in the `rsync` preview by highlighting only changed files.
- Display the Abbey Root commit hash being published.
- Automatically verify the live site after publication.
- Add `abbey site deploy-check` as a reusable pre-publication validation command.
- Expand publishing support as additional sections of BradCooke.com are developed.
