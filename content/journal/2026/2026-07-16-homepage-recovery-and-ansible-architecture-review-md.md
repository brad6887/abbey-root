---
title: "Homepage Recovery and Ansible Architecture Review"
description: "Restored Homepage, integrated edge01 into the operational dashboard, and identified the next evolution of the Abbey Ansible architecture."
date: 2026-07-16
draft: false
tags:
  - Abbey Root
  - Homepage
  - Ansible
  - Infrastructure
---

# Homepage Recovery and Ansible Architecture Review

## Summary

A Homepage update introduced new host validation, preventing the dashboard from loading. The issue was resolved through the authoritative Ansible configuration by adding the required `HOMEPAGE_ALLOWED_HOSTS` environment variable rather than making manual changes to the running container.

While reviewing the Homepage configuration, I also integrated `edge01` into the Ansible inventory and Homepage dashboard, added Technitium DNS as an infrastructure service, and cleaned up outdated dashboard content.

The session naturally evolved into an architectural review of the Ansible playbook structure. Testing the new Raspberry Pi appliance demonstrated that the current "common" role has grown beyond a true universal baseline and should eventually be decomposed into smaller purpose-driven roles.

## Accomplishments

- Restored Homepage after the host validation change.
- Updated the Homepage Ansible role with `HOMEPAGE_ALLOWED_HOSTS`.
- Validated deployments using Ansible `--check --diff` before applying changes.
- Added `edge01` to the Ansible inventory.
- Added Technitium DNS to the Homepage dashboard.
- Added `edge01` to the Servers section.
- Removed the duplicate Rocky Ansible service card.
- Removed the obsolete Planned Services section.
- Configured passwordless SSH access from the Ansible control node to `edge01`.
- Verified Ansible connectivity to the Raspberry Pi.
- Reviewed the current Ansible architecture and identified opportunities for improvement.

## Lessons Learned

- Check mode continues to prove its value before infrastructure changes.
- Every new managed host helps validate the assumptions built into the automation framework.
- Operational dashboards should represent deployed infrastructure instead of future plans.
- A single "common" role eventually becomes too broad as infrastructure grows and host purposes diversify.

## Next Steps

- Review the long-term Ansible architecture.
- Define host classes and the true universal host baseline.
- Split the existing `common` role into smaller purpose-specific roles.
- Create focused playbooks for routine operational tasks while preserving `site.yml` as the complete deployment playbook.
- Continue expanding Homepage as the operational dashboard for the Abbey lab.
