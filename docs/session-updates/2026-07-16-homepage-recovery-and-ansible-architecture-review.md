---
title: "Homepage Recovery and Ansible Architecture Review"
description: "Restored Homepage through Ansible, added edge01 to the lab inventory, and reviewed the long-term Ansible architecture."
date: 2026-07-16
status: complete
reviewed: true
session: primary
tags:
  - Homepage
  - Ansible
  - Infrastructure
  - Edge01
  - Abbey Root
---

# Homepage Recovery and Ansible Architecture Review

## Objective

Restore the Homepage dashboard after it stopped responding and review the surrounding Ansible architecture.

## Definition of Done

- Restore Homepage using the authoritative Ansible configuration.
- Add `edge01` to the Ansible inventory and Homepage.
- Review Homepage organization.
- Evaluate whether the current Ansible architecture remains appropriate as the lab grows.

## Accomplishments

### Homepage Recovery

Homepage stopped responding after a container update. Investigation showed the latest Homepage release introduced host validation, causing requests to `192.168.1.86:3000` to be rejected.

Rather than modifying the running container, the Ansible Homepage role was updated to include the required `HOMEPAGE_ALLOWED_HOSTS` environment variable.

The deployment was validated using Ansible check mode before being applied.

Homepage was successfully redeployed and verified operational.

### Homepage Review

Reviewed the operational dashboard and simplified several areas.

Completed improvements included:

- Added `edge01` to the Ansible inventory.
- Added Technitium DNS as an Infrastructure service.
- Added `edge01` to the Servers section.
- Removed the duplicate Rocky Ansible service card.
- Removed the obsolete Planned Services section so Homepage reflects deployed services rather than future ideas.

### edge01 Integration

Added `edge01` as a managed inventory host in its own `edge_services` inventory group.

Configured host variables describing the system and its role within the Abbey infrastructure.

Established passwordless SSH authentication from the Ansible control node and verified Ansible connectivity.

## Architecture Review

A review of the current playbook structure showed that `site.yml` remains valuable as the authoritative full convergence playbook, but the supporting role architecture has begun to outgrow its original design.

Testing `site.yml` against the new Raspberry Pi appliance demonstrated that the current `common` role combines several unrelated responsibilities including package installation, Git configuration, and Abbey shell customization.

These assumptions are appropriate for development systems but not for lightweight infrastructure appliances.

The review also demonstrated the value of targeted playbooks for routine operational work while preserving `site.yml` as the complete deployment entry point.

## Validation

Completed validation included:

- Homepage recovered successfully.
- Homepage returned HTTP 200 responses.
- `HOMEPAGE_ALLOWED_HOSTS` confirmed within the running container.
- Homepage container restarted cleanly.
- Ansible inventory validated successfully.
- `edge01` responded successfully to Ansible.
- Homepage deployment validated with `--check --diff` prior to production deployment.

## Lessons Learned

- Infrastructure changes should be previewed using Ansible check mode whenever practical.
- New infrastructure appliances are valuable validation targets because they expose assumptions hidden within existing automation.
- Operational dashboards should represent deployed infrastructure rather than future plans.

## Next Steps

- Review the long-term Ansible architecture.
- Define host classes and a true universal baseline.
- Split the current `common` role into smaller purpose-specific roles.
- Create focused playbooks for routine operational deployments while preserving `site.yml` as the authoritative full deployment playbook.
- Continue expanding Homepage as the operational dashboard for the Abbey lab.
