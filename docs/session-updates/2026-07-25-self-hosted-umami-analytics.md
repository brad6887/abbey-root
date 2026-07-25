---
title: "Self-Hosted Umami Analytics"
description: "Deployed an Ansible-managed Umami analytics service and published validated BradCooke.com tracking through its public HTTPS boundary."
date: 2026-07-25
status: complete
reviewed: true
session: self-hosted-umami-analytics
tags:
  - Abbey Root
  - Infrastructure
  - Ansible
  - Umami
  - BradCooke.com
journal: 2026-07-25-self-hosted-umami-analytics
---

# Self-Hosted Umami Analytics

## Objective

Deploy a self-hosted Umami v3 analytics service through Abbey's authoritative
Ansible configuration, expose it through a narrow public HTTPS boundary, and
prepare BradCooke.com to send production analytics without collecting local or
unrelated-host traffic.

## Definition of Done

- A dedicated Umami role manages Umami and PostgreSQL on `ubuntu-dev01`.
- Only the Umami application is published to the host; PostgreSQL remains on the
  project-private Compose network.
- Secret values come from encrypted inventory and rendered secret-bearing files
  have restrictive permissions.
- Focused syntax, check-mode, normal deployment, health, and idempotency
  validation pass.
- Public DNS, router forwarding, Nginx Proxy Manager, TLS, and application
  security boundaries are validated.
- BradCooke.com is registered in Umami and the shared Astro layout contains one
  production-domain-restricted tracker per generated page.
- Operational deployment, backup, restore, update, and dependency guidance is
  captured without disclosing secrets.
- The tracker is published and a real production pageview is confirmed in
  Umami.

## Summary

Added a dedicated `umami` Ansible role and focused playbook, deployed Umami with
PostgreSQL on `ubuntu-dev01`, and validated both containers and the application
heartbeat. The application is available internally on port 3002 while the
database has no host port.

Established `analytics.bradcooke.com` through Hostinger DNS, the existing AT&T
edge, Nginx Proxy Manager, and Let's Encrypt. Public HTTPS health validation
passes and HTTP redirects to HTTPS. Only public web ports are forwarded; the
proxy administration interface and internal application, monitoring, database,
and management ports remain unforwarded.

Registered BradCooke.com in Umami and added the supplied website tracker to the
shared Astro layout with a domain restriction for `bradcooke.com` and
`www.bradcooke.com`. Abbey Root source commit `3bcd098` was published through
production commit `2e0c7b3`. The live homepage contains the exact tracker, its
script returns HTTP 200, and a real cellular visit was recorded in Umami as one
visitor.

## Accomplishments

### Ansible Implementation

- Added `ansible/roles/umami` using Abbey's existing role conventions.
- Added a focused `ansible/playbooks/umami.yml` playbook for `ubuntu-dev01`.
- Added the role to the application-deployment section of `site.yml`.
- Added Umami to authoritative Homepage service metadata.
- Rendered the Compose project under `/home/bcooke/docker/umami`.
- Used the official Umami application and PostgreSQL 15 Alpine architecture,
  health checks, dependency ordering, private default network, and persistent
  database volume.
- Published only Umami at `192.168.1.86:3002`; PostgreSQL has no host port.
- Required `umami_database_password` and `umami_app_secret` from encrypted
  inventory without adding plaintext defaults.
- URL-encoded the password used in `DATABASE_URL` and protected the rendered
  Compose file with mode `0600` and Ansible `no_log` handling.
- Explicitly skipped the Compose handler in Ansible check mode while preserving
  normal change-triggered deployment and normal-mode failure reporting.

### Deployment and Validation

- Passed native Ansible syntax validation and focused check mode.
- Confirmed check mode reports expected file changes and skips deployment.
- Deployed Umami and PostgreSQL successfully on `ubuntu-dev01`.
- Confirmed both containers are healthy.
- Confirmed `/api/heartbeat` returns `{"ok":true}` locally.
- Confirmed a second normal Ansible run completed with `changed=0` and
  `failed=0`.

### Public HTTPS Boundary

- Published `analytics.bradcooke.com` through Hostinger DNS.
- Forwarded only TCP ports 80 and 443 through the AT&T router to
  `ubuntu-dev01`.
- Configured Nginx Proxy Manager and Let's Encrypt for the analytics hostname.
- Confirmed the public HTTPS heartbeat passes and HTTP redirects to HTTPS.
- Confirmed Nginx Proxy Manager administration and ports 81, 3002, 3000, 3001,
  5432, and 9443 are not forwarded.
- Disabled the previous internal Homepage, Uptime Kuma, and Portainer proxy
  hosts before enabling public forwarding.

### Application and Website Security

- Changed Umami's default administrator password.
- Registered BradCooke.com with website ID
  `285ce86c-dfd8-41d9-8f8b-3b718027334a`.
- Added the Umami tracker once to the shared Astro layout.
- Restricted tracking to `bradcooke.com,www.bradcooke.com` so local development
  and unrelated hosts do not create production analytics.
- Built 106 Astro pages and verified exactly one complete tracker in every
  generated HTML page.

### Operations Documentation

- Expanded the Umami role README with architecture, secret-variable names,
  deployment, health, idempotency, manual backup, destructive restore, update,
  and external-dependency procedures.
- Added focused backlog items for manual-backup validation before automation,
  reliable internal access to public proxy hostnames through Abbey DNS, and the
  reconciliation-only `abbey end` journal false positive.

### Publication and Live Validation

- Published BradCooke.com from Abbey Root source commit `3bcd098`.
- Successfully pushed production site commit `2e0c7b3`.
- Confirmed the live homepage contains the exact Umami tracker.
- Confirmed `https://analytics.bradcooke.com/script.js` returns HTTP 200.
- Reconfirmed the public HTTPS heartbeat and HTTP-to-HTTPS redirect.
- Confirmed a real cellular visit appeared in Umami as one visitor.

## Impact

Abbey Root now has a self-hosted, Ansible-managed analytics platform with a
narrow public boundary and documented operational procedures. BradCooke.com is
now publishing production-domain-restricted analytics to that platform, and
the complete path has been validated with a real external visit.

## Security Boundary

- PostgreSQL is private to the Compose project and has no host port.
- Only the Umami application is bound to the private host address and port.
- The router exposes only TCP 80 and 443 to the reverse proxy host.
- Nginx Proxy Manager administration and internal application, monitoring,
  database, and management ports are not forwarded.
- Secret values remain in encrypted inventory and the rendered Compose file;
  the latter is mode `0600` and suppressed from Ansible output.
- The Umami default administrator password was replaced.
- The Astro tracker is restricted to the two production BradCooke.com domains.

## External Configuration

The public service depends on configuration not managed by the Umami role:

- Hostinger DNS for `analytics.bradcooke.com`.
- AT&T router TCP 80/443 forwarding to `ubuntu-dev01`.
- Nginx Proxy Manager hostname routing.
- Let's Encrypt certificate issuance and renewal.
- Abbey DNS for reliable internal resolution and routing when NAT loopback is
  unavailable.

These external settings were configured and validated manually. No public IP
address or secret value is recorded in the repository documentation.

## Validation

- Native `ansible-playbook --syntax-check playbooks/umami.yml`: passed.
- Native `ansible-playbook --check --diff playbooks/umami.yml --limit ubuntu-dev01`:
  passed after the Compose handler was made check-mode aware.
- Normal focused deployment: passed.
- Second normal focused playbook run: `changed=0`, `failed=0`.
- Both Compose services: healthy.
- Local `/api/heartbeat`: `{"ok":true}`.
- Public HTTPS heartbeat: passed.
- Public HTTP-to-HTTPS redirect: passed.
- Router exposure review: only TCP 80 and 443 forwarded.
- First manual PostgreSQL backup: passed against the healthy live database.
- Backup validation confirmed a nonempty gzip file, a valid gzip stream, and a
  decompressed PostgreSQL dump header.
- The validated backup under `/home/bcooke/backups/umami/` was secured as mode
  `0600`; no restore was attempted against the live database.
- Astro production build: 106 pages generated successfully.
- Generated HTML tracker audit: exactly one expected tracker per page with the
  exact URL, website ID, and domain restriction.
- Abbey Root source commit `3bcd098`: published successfully.
- Production site commit `2e0c7b3`: pushed successfully.
- Live BradCooke.com homepage: exact tracker confirmed.
- Public tracker script: HTTP 200.
- Real cellular visit: recorded in Umami as one visitor.
- `git diff --check`: passed during implementation review.

## Lessons Learned

AT&T NAT loopback was intermittently unreliable during setup. Public success
from an external path did not guarantee reliable access to the same hostname
from inside the network. Abbey DNS should provide a deliberate internal path to
public proxied services instead of depending on router hairpin behavior.

Check mode can still notify handlers when preceding file tasks predict changes.
A handler that changes into a directory created earlier in the play must
explicitly skip check mode when that directory does not yet exist. The Umami
handler now encodes that boundary without hiding failures during normal runs.

`abbey end` incorrectly required a journal entry for a reconciliation-only
commit encountered during this session. That is recorded as a focused workflow
follow-up and was not repaired as part of the Umami work.

Shell redirection initially created the live test dump as mode `0664`; it was
corrected to `0600`. The documented procedure now establishes a restrictive
umask before redirection and verifies the resulting mode, showing that backup
security must be enforced at file creation rather than assumed from intent.

Operational documentation should separate a validated manual database backup
from an untested restore procedure and future automation. Backup scheduling
should wait until restore is validated safely without risking the live
database.

The first production push exposed a dangerous publication-workflow defect. The
local production checkout was behind `origin/main`, so `git push` failed, but
`abbey site publish` continued, printed a false success message, and accepted
an HTTP 200 response from the previously deployed site as verification. The
failed local commit was preserved on `recovery/umami-publish-34351a5`,
production `main` was safely reset to current `origin/main`, a fresh dry run
passed, and the second publication successfully pushed `2e0c7b3`. Publication
must fail immediately on push failure and verify the expected deployed
revisions rather than general site availability.

## Next Steps

- Commit and push this final reconciliation when explicitly authorized.
- Fix `abbey site publish` push-failure handling and revision-aware deployment
  verification in a separate focused session.
- Establish reliable internal access to public proxied services through Abbey
  DNS without depending on AT&T NAT loopback.
- Validate the documented Umami restore procedure in a safe non-production
  recovery test, then design backup automation.
- Investigate the reconciliation-only `abbey end` journal false positive in a
  separate workflow session.
- Regenerate inventory-derived documentation from authoritative host metadata
  using `ansible-playbook playbooks/docs.yml` from `ansible/`.

## Notes

The BradCooke.com tracker is published and a real production pageview is
confirmed. The recovery branch remains preserved. This final reconciliation
does not modify production history, republish the site, redeploy containers, or
change live external systems.
