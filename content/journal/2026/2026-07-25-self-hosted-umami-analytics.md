---
title: "Self-Hosted Umami Analytics"
description: "Established a self-hosted analytics platform for BradCooke.com with Ansible-managed Umami and a narrow public HTTPS boundary."
date: 2026-07-25
draft: false
tags:
  - Abbey Root
  - Infrastructure
  - Ansible
  - Umami
  - BradCooke.com
---

# Self-Hosted Umami Analytics

## Summary

Abbey Root now operates a self-hosted Umami analytics service for
BradCooke.com. Umami and its PostgreSQL database are deployed through a
dedicated Ansible role, with the database kept private and the application
published through the existing reverse-proxy boundary.

The public analytics hostname uses HTTPS with a valid certificate, redirects
HTTP traffic to HTTPS, and exposes only the normal web ports through the home
router. Administrative, database, monitoring, and direct application ports
remain private.

BradCooke.com has been registered in Umami, and its shared Astro layout now
contains a single tracker restricted to the production domains. The production
site build validates the tracker on all generated pages. The tracker is now
published, its public script loads successfully, and a real cellular visit was
recorded in Umami as one visitor.

## Accomplishments

- Added a dedicated Ansible role and focused playbook for Umami.
- Deployed healthy Umami and PostgreSQL containers on `ubuntu-dev01`.
- Kept PostgreSQL private to the Compose project.
- Validated Ansible syntax, check mode, normal deployment, and a fully
  idempotent second run.
- Made the Compose deployment handler explicitly safe in check mode.
- Established the public analytics hostname through DNS, reverse proxying, and
  HTTPS while preserving a narrow router exposure boundary.
- Replaced Umami's default administrator password.
- Registered BradCooke.com in Umami.
- Added one production-domain-restricted tracker through the shared Astro
  layout.
- Built and checked all 106 generated pages for exactly one tracker each.
- Published the tracker and confirmed it on the live BradCooke.com homepage.
- Confirmed the public tracker script and analytics heartbeat are healthy.
- Confirmed a real external visit appeared in Umami.
- Validated the first manual PostgreSQL backup and secured it as owner-only.
- Documented deployment, health, backup, destructive restore, update, and
  external dependency procedures.

## Lessons Learned

- Check mode can notify a deployment handler even when prerequisite directories
  exist only as predicted changes; handlers that depend on those directories
  need an explicit check-mode boundary.
- A public HTTPS check from outside the network does not prove the same hostname
  will work reliably inside it. AT&T NAT loopback was intermittent, so Abbey DNS
  needs a deliberate internal path for public proxied services.
- Shell redirection does not guarantee a sensitive backup receives restrictive
  permissions; the backup procedure now enforces and verifies owner-only mode.
- Database-backup automation should follow a validated manual backup and a safe
  non-production restore test rather than precede them.
- Publication verification must prove the intended revision was pushed and
  deployed. A generic HTTP 200 response can describe the previous site and must
  not turn a failed push into a reported success.
- Session tooling still has a reconciliation edge case: `abbey end` can require
  a journal where a reconciliation-only commit should not need one.

## Next Steps

- Commit and push the final reconciliation when explicitly authorized.
- Correct `abbey site publish` push-failure handling and revision-aware
  verification in a separate focused session.
- Establish reliable internal access to the analytics hostname through Abbey
  DNS.
- Validate the Umami restore procedure in a safe non-production recovery test
  before automating backups.
