---
title: "Add SSH Release Site Publishing"
description: "Add a project-defined SSH release deployment backend for Abbey static site publishing."
date: 2026-08-12
status: complete
reviewed: true
session: add-ssh-release-site-publishing
tags:
  - Abbey Root
  - site publishing
  - ssh-release
  - sites01
  - Bread Pitt
---

# Add SSH Release Site Publishing

## Objective

Add a reusable `ssh-release` publishing backend to `abbey site publish` so Abbey projects can deploy validated static site artifacts to a remote host using project-owned configuration and transactional releases.

Preserve the existing `git-rsync` publishing workflow while allowing projects such as Bread Pitt to publish directly to `sites01` without falling back to another project's deployment path.

## Definition of Done

- Support `site.publish.method: ssh-release`.
- Resolve SSH deployment target, remote root, domain, and build artifact from the active project's `.abbey/project.yml`.
- Preserve existing `git-rsync` publishing behavior.
- Require a clean source repository for real publishes while allowing useful dry-run validation.
- Build and validate the site locally before modifying the remote target.
- Verify remote SSH connectivity and deployment permissions before release creation.
- Upload each deployment to a timestamped release directory.
- Validate the uploaded release against the locally validated artifact before activation.
- Atomically switch the remote `current` symlink only after validation succeeds.
- Verify the activated site through the target nginx virtual host.
- Automatically restore the previous release if post-activation verification fails.
- Prove the workflow against Bread Pitt on `sites01`.
- Leave the public Bread Pitt GitHub Pages deployment unchanged during validation.

## Summary

Extended `abbey site publish` with a second publishing backend named `ssh-release`.

The new backend uses project-owned publishing metadata to build and validate the active project, preflight a remote site root over SSH, create a timestamped release, transfer the generated artifact with rsync, verify the uploaded copy, atomically activate it through the site's `current` symlink, and verify the resulting nginx response.

Bread Pitt was used as the first real implementation proof against the canonical `/srv/www/breadpitt.net` site root on `sites01`.

## Accomplishments

- Added `ssh-release` as a supported `site.publish.method`.
- Added parsing for `user@host:path` and `host:path` deployment targets.
- Added SSH target and remote-root information to resolved site configuration output.
- Added remote deployment preflight checks for:
  - release directory existence
  - release directory write access
  - site-root write access
  - existing `current` symlink
- Added local build and Abbey site validation before any remote modification.
- Added timestamped release creation under:
  - `/srv/www/breadpitt.net/releases/<release-id>`
- Added rsync-based release upload.
- Added checksum-based comparison of the remote release against the validated local artifact.
- Added explicit remote `index.html` validation.
- Added atomic activation using a temporary symlink and `mv -Tf`.
- Added post-activation nginx verification using the configured domain as the Host header.
- Added automatic rollback to the previous release when post-activation verification fails.
- Added a meaningful `--dry-run` path that builds, validates, performs remote preflight, and previews rsync changes without modifying the remote site.
- Configured Bread Pitt with:
  - `method: ssh-release`
  - `target: abbey-deploy@sites01:/srv/www/breadpitt.net`
  - `domain: breadpitt.net`
- Successfully deployed Bread Pitt to `sites01`.
- Preserved the existing `bootstrap` release as the previous rollback target.

## Impact

Abbey projects can now publish static sites directly to an Abbey-managed web host without embedding deployment logic in the individual project.

Publishing remains project-aware and fail-closed: the active project owns its build method, publishing method, target, and domain.

The release-directory model prevents partially uploaded artifacts from becoming active. A release is only promoted after the local build passes, Abbey validation passes, the upload completes, and the remote copy matches the validated local artifact.

This also establishes a reusable publishing model for future Abbey-hosted static sites rather than creating a Bread Pitt-specific deployment script.

## Validation

- `bash -n tools/bin/abbey-site`
  - passed.
- `git diff --check`
  - passed.
- Bread Pitt `abbey site publish --dry-run`
  - built the Astro site successfully.
  - completed Astro diagnostics with zero errors, warnings, or hints.
  - passed Abbey site artifact validation.
  - passed SSH remote preflight.
  - previewed publishing without changing remote files.
- Bread Pitt real `abbey site publish`
  - created release `20260812T121353Z`.
  - uploaded approximately 24.9 MB of generated site content.
  - checksum validation confirmed the remote release matched the validated local artifact.
  - atomically changed `current` from `/srv/www/breadpitt.net/releases/bootstrap` to `/srv/www/breadpitt.net/releases/20260812T121353Z`.
  - nginx verification succeeded for `breadpitt.net`.
- Post-deployment route validation through nginx returned HTTP 200 for:
  - `/`
  - `/recipes/`
  - `/starter/`
  - `/bakes/`
  - `/bakes/bake001-first-big-role/`
- Public Bread Pitt DNS and GitHub Pages hosting were not changed during this session.

## Lessons Learned

The earlier manual staging experiment demonstrated that release preparation and activation must be separate operations. An incomplete or failed release must never be able to replace `current`.

The implementation therefore treats activation as the final step after build validation, upload completion, and remote artifact comparison.

The session also reinforced that `site.publish.method` is a useful abstraction. The project declares how and where it publishes while `abbey site publish` owns the reusable workflow.

Dry-run behavior is most useful when it exercises the same build, validation, target resolution, SSH preflight, and rsync comparison as a real publish while deliberately skipping all mutating operations.

## Next Steps

- Review whether release-retention cleanup should become part of the standard `ssh-release` workflow.
- Consider adding an explicit Abbey rollback command for selecting a previous release.
- Add regression coverage for `git-rsync` and `ssh-release` publishing methods.
- Add automated coverage proving an external project cannot fall back to Abbey Root or `bradcooke.com` publishing configuration.
- Review the tracked `logs/abbey-site.log` behavior separately so routine development-server activity does not dirty project repositories.

## Notes

Bread Pitt remains publicly hosted through GitHub Pages. The new `sites01` deployment is currently a validated internal deployment target and can be cut over independently when desired.

The active `sites01` Bread Pitt release at the end of this session is:

`/srv/www/breadpitt.net/releases/20260812T121353Z`

The previous release remains available at:

`/srv/www/breadpitt.net/releases/bootstrap`
