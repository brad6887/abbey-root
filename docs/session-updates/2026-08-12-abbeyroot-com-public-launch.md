---
title: "Launch AbbeyRoot.com Publicly"
description: "Published the redesigned AbbeyRoot.com site on sites01 and completed the public DNS, reverse-proxy, and HTTPS cutover."
date: 2026-08-12
status: complete
reviewed: true
session: abbeyroot-com-public-launch
journal: "content/journal/2026/2026-08-12-abbeyroot-com-public-launch.md"
tags:
  - Abbey Root
  - AbbeyRoot.com
  - sites01
  - publishing
  - DNS
  - HTTPS
---

# Launch AbbeyRoot.com Publicly

## Objective

Move the rebuilt AbbeyRoot.com site from an internal `sites01` release to a
publicly reachable production site using Abbey's established static-hosting and
reverse-proxy architecture.

## Definition of Done

- Configure AbbeyRoot.com with a project-owned `ssh-release` publishing target.
- Validate the Astro build and required routes locally and in GitHub Actions.
- Publish the validated artifact to a timestamped release on `sites01`.
- Preserve the bootstrap release as a rollback target.
- Configure Nginx Proxy Manager for `abbeyroot.com` and `www.abbeyroot.com`.
- Point public DNS at the existing home reverse-proxy address.
- Issue a Let's Encrypt certificate and force HTTPS.
- Verify both HTTPS host names and the HTTP-to-HTTPS redirect.
- Document the resulting architecture and remaining operational work.

## Summary

AbbeyRoot.com is now publicly hosted from `sites01` through the same controlled
ingress path already used by Abbey's public analytics service.

The Astro site builds on `ubuntu-dev01`, publishes through Abbey's
`ssh-release` workflow, and is served from the active release under
`/srv/www/abbeyroot.com`. Public traffic reaches Nginx Proxy Manager on
`ubuntu-dev01`, which terminates HTTPS and forwards the request to native nginx
on `sites01`.

## Accomplishments

- Added AbbeyRoot.com's publishing configuration:
  - method: `ssh-release`
  - target: `abbey-deploy@sites01:/srv/www/abbeyroot.com`
  - domain: `abbeyroot.com`
- Added the `AbbeyRoot.com Build` GitHub Actions workflow.
- Built 158 Astro pages and validated the required `/` and `/journal/` routes.
- Completed a publish dry run with successful SSH preflight and rsync preview.
- Published release `20260812T234126Z` to `sites01`.
- Confirmed the uploaded release matched the validated local artifact.
- Atomically moved `current` from the bootstrap release to the new release.
- Created an Nginx Proxy Manager host for:
  - `abbeyroot.com`
  - `www.abbeyroot.com`
- Forwarded both names to `http://192.168.1.84:80` with common-exploit
  protection enabled.
- Changed Hostinger's apex A record from its hosted-site address to the
  established public reverse-proxy address.
- Preserved the existing `www` CNAME to the apex.
- Issued a Let's Encrypt certificate covering both public host names.
- Enabled forced HTTPS and HTTP/2 while leaving HSTS disabled for safer early
  rollback.
- Updated the hosting architecture and completed the applicable backlog items.

## Architecture

The active request path is:

`public DNS -> router TCP 80/443 -> Nginx Proxy Manager on ubuntu-dev01 -> sites01:80 -> /srv/www/abbeyroot.com/current`

The router continues to expose only TCP ports 80 and 443 to the reverse-proxy
host. Nginx Proxy Manager administration, SSH, and the native `sites01` service
are not directly exposed by this cutover.

## Validation

- GitHub Actions `AbbeyRoot.com Build`:
  - completed the Astro build and required-route checks.
- `abbey site publish --dry-run`:
  - built 158 pages.
  - passed Abbey site artifact validation.
  - passed remote SSH preflight.
  - completed without changing remote files.
- `abbey site publish`:
  - uploaded approximately 2.2 MB of generated content.
  - matched the remote release against the validated local artifact.
  - activated release `20260812T234126Z`.
  - verified the `abbeyroot.com` nginx virtual host.
- Public DNS through Cloudflare's resolver returned the established reverse
  proxy address for both the apex and `www`.
- Direct reverse-proxy validation returned:
  - HTTP 301 from `http://abbeyroot.com/` to HTTPS.
  - HTTP/2 200 from `https://abbeyroot.com/`.
  - HTTP/2 200 from `https://www.abbeyroot.com/`.
- Nginx Proxy Manager reported the proxy host online with a Let's Encrypt
  certificate.
- Repository-wide `abbey validate` passed after the documentation update.

## Lessons Learned

The `ssh-release` workflow made the production deployment uneventful: the same
artifact that passed local validation was uploaded, compared, and only then
activated. Keeping publication separate from DNS and TLS also made each phase
independently testable.

Hostinger retained an older 50-second TTL value that its current editor no
longer accepts. The DNS update required raising that value to the current
60-second minimum.

Internal requests to the public address can time out because NAT loopback is
not reliable on the current router. That does not change the public ingress
architecture; internal access remains available through `sites01.home.arpa`.

## Next Steps

- Rotate the previously exposed Ansible credentials and Umami secrets recorded
  in the infrastructure backlog.
- Establish reliable internal resolution for public proxied services.
- Decide whether `www.abbeyroot.com` should remain a full alias or redirect to
  the apex as the canonical host.
- Add production analytics after confirming the desired measurement scope.
- Consider enabling HSTS after the public deployment has had an appropriate
  stabilization period.
- Document rollback and availability expectations for the public site.

## Rollback

The active site release can be returned to:

`/srv/www/abbeyroot.com/releases/bootstrap`

Public traffic can be withdrawn independently by restoring the previous apex A
record in Hostinger or disabling the AbbeyRoot.com proxy host in Nginx Proxy
Manager.

