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

AbbeyRoot.com is publicly exposed through the existing ingress path:

- Hostinger DNS points `abbeyroot.com` to the home public address, and
  `www.abbeyroot.com` is a CNAME to the apex.
- The router forwards only TCP ports 80 and 443 to Nginx Proxy Manager on
  `ubuntu-dev01`.
- Nginx Proxy Manager terminates HTTPS with a Let's Encrypt certificate,
  redirects HTTP to HTTPS, and proxies both host names to `sites01` at
  `192.168.1.84:80`.
- Native nginx on `sites01` serves the active AbbeyRoot.com release.

The site was validated through the proxy for both HTTPS host names and the
HTTP-to-HTTPS redirect. Direct access through the public address may fail from
inside the home network because NAT loopback is not reliable; internal access
continues to use `sites01.home.arpa`.

## Safety Boundaries

- A successful GitHub Actions build does not publish the site.
- An Astro build does not authorize a release upload.
- Ansible validation does not authorize applying infrastructure changes.
- Public DNS and TLS are managed outside Ansible through Hostinger and Nginx
  Proxy Manager.
- `brad6887.github.io` is exclusively the BradCooke.com production target and
  must never be used by AbbeyRoot.com.
