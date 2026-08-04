---
title: "Bread Pitt Internal Staging"
description: "Provisioned and validated an internal Bread Pitt staging site on sites01 with isolated nginx hosting, release activation, and internal DNS."
date: 2026-08-04
status: pending
reviewed: false
session: bread-pitt-internal-staging
tags:
  - Abbey Root
  - Infrastructure
  - Static Sites
  - Bread Pitt
---

# Bread Pitt Internal Staging

## Objective

Stage the Bread Pitt Astro website on `sites01` under an internal hostname so
new site work can be reviewed independently of the production GitHub Pages
deployment.

## Definition of Done

- Bread Pitt has a separate nginx virtual host on `sites01`.
- The site uses its own release directory and `current` symlink.
- A validated Bread Pitt build is deployed and activated.
- The staging hostname resolves through internal Technitium DNS.
- Bread Pitt pages and static assets are available over normal HTTP requests.
- The existing Abbey Root site remains operational.
- The static-site Ansible role remains idempotent.
- Production `breadpitt.net`, GitHub Pages, and public DNS remain unchanged.

## Summary

Provisioned `breadpitt.sites01.home.arpa` as a second static site on `sites01`,
built the Bread Pitt Astro project, deployed release `20260804T225248Z`, and
activated it through the existing release-directory structure.

An internal CNAME now resolves the staging hostname to `sites01.home.arpa`. The
site is available at:

    http://breadpitt.sites01.home.arpa/

The deployment exposed a gap in Abbey's static-site workflow: release
preparation, validation, activation, and rollback are not yet represented as one
fail-closed command.

## Accomplishments

- Added `breadpitt.sites01.home.arpa` to the `sites01` static-site inventory.
- Preserved `abbeyroot.com` as the nginx default server.
- Used the existing `static_site_host` role to create:
  - `/srv/www/breadpitt.sites01.home.arpa/`
  - the `releases/` directory
  - the bootstrap release
  - the initial `current` symlink
  - a dedicated nginx virtual host
  - per-site access and error logs
- Built Bread Pitt with `abbey site build`.
- Confirmed the Astro build produced 15 pages with no errors, warnings, or
  hints.
- Restricted Bread Pitt's Umami tracking to `breadpitt.net` and
  `www.breadpitt.net` so staging traffic is excluded.
- Packaged and transferred the validated static artifact.
- Deployed and activated release `20260804T225248Z`.
- Added the internal DNS alias:

      breadpitt.sites01.home.arpa CNAME sites01.home.arpa

- Confirmed the staging hostname resolves to `192.168.1.84`.
- Confirmed the site is accessible without forced hostname resolution.

## Impact

Bread Pitt now has an isolated internal staging environment that can be used to
review site changes before they reach the public GitHub Pages deployment.

The implementation reuses the existing `sites01` release model and nginx role
without coupling Bread Pitt to Abbey Root's site content or publishing path.

Production hosting and public DNS were not modified.

## Validation

- `git diff --check` passed.
- `ansible-playbook --syntax-check playbooks/static-sites.yml` passed.
- Ansible check mode reported only the expected new Bread Pitt directories and
  nginx virtual host.
- The focused static-site playbook completed successfully.
- A subsequent normal run completed with:

      changed=0
      unreachable=0
      failed=0

- Bread Pitt's health check returned `ok`.
- The staging home page returned:

      <title>Bread Pitt</title>

- The staging recipe index returned:

      <title>Recipes · Bread Pitt</title>

- The deployed release contains the home page, recipe index, sample recipe, and
  Astro asset directory.
- The deployed home page contains the expected production-only Umami domain
  restriction.
- `abbeyroot.com` continued returning its existing site.
- Technitium returned:

      breadpitt.sites01.home.arpa CNAME sites01.home.arpa
      sites01.home.arpa A 192.168.1.84

- A normal HTTP request to `http://breadpitt.sites01.home.arpa/` succeeded.

## Lessons Learned

The release process needs transactional behavior.

The initial `ansible.builtin.unarchive` operation failed because `sites01` did
not have a supported extraction binary. The activation command was issued
separately and switched `current` to the empty release directory.

The site was immediately rolled back to the bootstrap release. The artifact was
then extracted with Python's hardened `tarfile` implementation, and activation
was retried only after release validation passed.

A standardized deployment workflow must validate all dependencies and release
contents before changing `current`. A failed preparation or validation step
must leave the existing active release untouched.

A CNAME is the appropriate internal DNS record for a name-based virtual host on
an existing web server. The server's canonical A and PTR records remain owned
by `sites01.home.arpa`.

## Next Steps

- Implement a fail-closed Abbey workflow for internal static-site releases.
- Commit the Abbey Root infrastructure and session records.
- Commit the Bread Pitt analytics-domain restriction separately in the Bread
  Pitt repository.
- Use the staging site to review future Bread Pitt content before production
  publication.

## Notes

- Active release:

      /srv/www/breadpitt.sites01.home.arpa/releases/20260804T225248Z

- Production `breadpitt.net` remains hosted through GitHub Pages.
- Public Bread Pitt DNS was not changed.
- The internal CNAME was created directly in Technitium because individual zone
  records are not currently managed by Abbey Ansible.
- The release archive was transferred through `rocky-ansible01`, the established
  Ansible control node.
