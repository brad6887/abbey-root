---
title: "Bread Pitt Internal Staging"
description: "Bread Pitt now has an isolated internal staging site on sites01 for reviewing changes before public deployment."
date: 2026-08-04
draft: false
tags:
  - Abbey Root
  - Infrastructure
  - Bread Pitt
---

# Bread Pitt Internal Staging

## Summary

Bread Pitt now has a working internal staging site at:

    http://breadpitt.sites01.home.arpa/

The site is hosted on `sites01` in its own nginx virtual host and release
directory. It is separate from both the Abbey Root website and Bread Pitt's
public GitHub Pages deployment.

## Accomplishments

- Added a dedicated Bread Pitt site definition to the `sites01` inventory.
- Provisioned the nginx virtual host and release structure through Ansible.
- Built and deployed the current Bread Pitt Astro site.
- Activated release `20260804T225248Z`.
- Added an internal Technitium DNS alias pointing the staging hostname to
  `sites01.home.arpa`.
- Verified the home page, recipe index, health endpoint, DNS resolution, and
  Abbey Root regression.
- Confirmed the Ansible role remains idempotent.
- Restricted Umami analytics to the public Bread Pitt domains so staging visits
  are not counted.

## Lessons Learned

The first archive extraction failed because the remote server lacked a supported
extraction command. Since release activation was a separate command, it was
still possible to point `current` at the empty release.

The site was rolled back immediately and redeployed successfully after
validating the extracted files.

This should become a standard Abbey deployment workflow that prepares and
validates a complete release before it can activate the new `current` symlink.

## Next Steps

- Add a safe internal static-site deployment workflow to Abbey.
- Commit the Abbey Root staging configuration and session documentation.
- Commit the Bread Pitt analytics restriction in the Bread Pitt repository.
- Begin using the internal staging site for Bread Pitt content reviews.
