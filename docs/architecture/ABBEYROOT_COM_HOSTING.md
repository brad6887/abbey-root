# AbbeyRoot.com Hosting Architecture

## Purpose

Define how AbbeyRoot.com is built, validated, hosted, and eventually exposed as
a public site without coupling publication to every source push.

## Current Architecture

AbbeyRoot.com uses Abbey's managed static-hosting platform on `sites01`.

- Source repository: `abbey-root`
- Astro source: `site/`
- Build output: `site/dist/`
- Hosting server: `sites01`
- Deployment identity: `abbey-deploy`
- Site root: `/srv/www/abbeyroot.com`
- Active release: `/srv/www/abbeyroot.com/current`
- Release storage: `/srv/www/abbeyroot.com/releases/<release-id>`
- nginx host names: `abbeyroot.com`, `www.abbeyroot.com`, `sites01`, and
  `sites01.home.arpa`

The Ansible `static_site_host` role owns nginx, the release-directory layout,
the deployment identity, HTTP firewall access, SELinux contexts, and the
bootstrap release. It does not own site builds, release uploads, public DNS,
router forwarding, or TLS.

## Validation and Publication

GitHub Actions validates pull requests and pushes to `main` when AbbeyRoot.com
source, journal content, site metadata, or its workflow changes. CI installs the
locked dependencies, builds the Astro site, and verifies the homepage and
journal index. It does not publish.

Publication remains an explicit operator action:

```bash
abbey site publish --dry-run
abbey site publish
```

The project-owned `ssh-release` configuration targets:

```text
abbey-deploy@sites01:/srv/www/abbeyroot.com
```

The publishing workflow builds and validates locally, uploads into a new
timestamped release, verifies the uploaded artifact, atomically updates the
`current` link, checks nginx through the `abbeyroot.com` host name, and restores
the previous release if activation validation fails.

## Public Domain Cutover

The `abbeyroot.com` domain is not yet configured for this service. Public
cutover is a separate future operation and should include:

1. Confirm the desired public network path to `sites01`.
2. Configure public DNS for `abbeyroot.com` and `www.abbeyroot.com`.
3. Add an HTTPS termination point and certificate management.
4. Validate HTTP-to-HTTPS behavior and both host names externally.
5. Add production analytics only after the final domain is live.
6. Record rollback and availability expectations before announcing the site.

Public DNS or TLS work does not need to block internal release publishing and
validation on `sites01`.

## Safety Boundaries

- A successful GitHub Actions build does not publish the site.
- An Astro build does not authorize a release upload.
- Ansible validation does not authorize applying infrastructure changes.
- Public DNS and TLS remain intentionally deferred until explicitly requested.
- `brad6887.github.io` is exclusively the BradCooke.com production target and
  must never be used by AbbeyRoot.com.

