---
title: Sites01 Static Website Hosting
description: Provisioned a reproducible Rocky Linux static website host using native nginx, release-based content directories, SELinux, firewalld, and internal DNS.
date: 2026-08-03
status: complete
session: sites01-static-website-hosting
reviewed: false
tags:
  - infrastructure
  - ansible
  - nginx
  - static-sites
  - proxmox
  - dns
---

# Sites01 Static Website Hosting

## Summary

Provisioned sites01 as the Abbey Root lab's internal static website hosting platform.

The host runs Rocky Linux 10.2 with native nginx and is managed through the Abbey Root Ansible inventory. Static sites use release-oriented directories under /srv/www, with a current symlink identifying the active release.

The first managed site is abbeyroot.com, currently serving an internal bootstrap placeholder and health endpoint.

## Objective

Provision sites01 as a reproducible internal static-site hosting platform.

The host will eventually serve multiple independently deployed static sites, beginning with abbeyroot.com.

## Definition of Done

- [x] Clone the standard Rocky Linux Proxmox template.
- [x] Configure the VM as sites01.
- [x] Assign 2 vCPU, 2 GB RAM, and a 32 GB disk.
- [x] Generate a unique machine ID.
- [x] Establish passwordless SSH from rocky-ansible01.
- [x] Add sites01 to the Abbey Root Ansible inventory.
- [x] Apply the existing Linux host baseline.
- [x] Configure internal DNS and time synchronization.
- [x] Create a focused static-site-hosting Ansible role.
- [x] Install and configure native nginx.
- [x] Create the abbey-deploy deployment identity.
- [x] Create the release-oriented /srv/www directory structure.
- [x] Configure firewalld and persistent SELinux contexts.
- [x] Serve an abbeyroot.com placeholder site.
- [x] Validate the /healthz endpoint.
- [x] Validate hostname-based nginx routing.
- [x] Validate forward and reverse internal DNS.
- [x] Confirm a second Ansible run is idempotent.

## VM Configuration

The VM was cloned from the standard Rocky Linux template.

- Proxmox VM ID: 105
- Template VM ID: 100
- Hostname: sites01
- Operating system: Rocky Linux 10.2
- CPU: 2 vCPU
- Memory: 2 GB
- Disk: 32 GB
- Network bridge: vmbr0
- QEMU guest agent: enabled and active
- MAC address: BC:24:11:02:02:84
- Current address: 192.168.1.84

The current address was assigned through DHCP. It must be reserved for the VM MAC address when router administration is available again.

The cloned machine ID was regenerated before the VM was placed into service.

## Ansible Inventory

Added a new web inventory group containing sites01.

The host variables describe sites01 as a static website and production web-content host.

The existing host baseline configured:

- common operating-system tools,
- Abbey shell initialization,
- internal DNS,
- the home.arpa search domain,
- the America/Chicago timezone,
- chrony time synchronization,
- the Abbey MOTD,
- and the pre-login issue banner.

## Static Site Host Role

Added the static_site_host Ansible role.

The role:

- installs nginx,
- installs and enables firewalld,
- installs SELinux management utilities,
- creates the abbey-deploy user and group,
- creates static-site release directories,
- creates the initial bootstrap release,
- creates the initial current symlink,
- deploys nginx virtual-host configuration,
- permits HTTP through firewalld,
- defines persistent httpd_sys_content_t SELinux contexts,
- restores the correct SELinux labels,
- and validates nginx before service reloads.

The role is currently limited to Red Hat-family hosts.

## Release Layout

The initial site uses this structure:

    /srv/www/abbeyroot.com/
    ├── current -> /srv/www/abbeyroot.com/releases/bootstrap
    └── releases/
        └── bootstrap/
            └── index.html

The active current symlink is created only during initial provisioning.

Future deployment tooling can create uniquely identified releases and atomically replace the symlink without Ansible resetting it to the bootstrap release.

## Nginx Site

The initial nginx virtual host serves:

- abbeyroot.com
- www.abbeyroot.com
- sites01
- sites01.home.arpa

The configuration includes:

- an /srv/www/abbeyroot.com/current document root,
- disabled directory indexing,
- disabled nginx version tokens,
- per-site access and error logs,
- and a /healthz endpoint returning ok.

## Validation

Ansible connectivity succeeded.

The host baseline validated:

- hostname: sites01
- DNS server: 192.168.1.221
- search domain: home.arpa
- timezone: America/Chicago
- NTP synchronized: yes
- SSH service: active
- chronyd service: active
- QEMU guest agent: active

The static website host passed:

- nginx configuration validation,
- nginx active and enabled,
- firewalld active,
- permanent HTTP service allowed,
- bootstrap page available over HTTP,
- /healthz returned ok,
- release directory structure correct,
- current symlink correct,
- and website content labeled httpd_sys_content_t.

Hostname-based requests succeeded for:

- abbeyroot.com
- www.abbeyroot.com
- sites01.home.arpa

Forward and reverse internal DNS records were created and validated:

    sites01.home.arpa -> 192.168.1.84
    192.168.1.84 -> sites01.home.arpa

A second normal run of the focused static-site playbook completed with no changes or failures.

## Problems Resolved

### Candidate IP Already Occupied

192.168.1.89 was initially considered because it followed the existing server address sequence.

Network testing showed that it was already occupied, so it was not assigned to the VM.

### Remote Console Access

The VM was provisioned while remote from the lab.

The QEMU guest agent was active, but Proxmox guest command execution was disabled by guest-agent policy.

An SSH tunnel through ubuntu-dev01 provided access to the Proxmox web interface and VM console without publicly exposing the Proxmox management service.

### Initial Check-Mode Failure

The first Ansible check-mode run failed while attempting to create the current symlink.

Check mode reported that it would create the bootstrap release directory, but the directory did not actually exist when the symlink task ran.

The role was corrected so initial symlink creation is skipped during check mode when the target release directory does not already exist.

The following check-mode run completed successfully.

## Architecture Decisions

- Keep Rocky Linux 10.2 because it matches the current template and Ansible control node.
- Use native nginx rather than Docker.
- Keep Nginx Proxy Manager on ubuntu-dev01 during this session.
- Keep public DNS, TLS, and router changes out of scope.
- Build sites elsewhere and deploy only finished static artifacts.
- Use release directories with an atomic current symlink.
- Preserve the active release during subsequent Ansible runs.
- Keep deployment tooling separate from host provisioning.

## Security Note

An Ansible inventory inspection displayed decrypted Vault variables in terminal output during the session.

The affected credentials and application secrets must be rotated. Their values are intentionally not included in this session update.

Secret rotation should be completed before the hosting platform is exposed publicly.

## Out of Scope

This session did not:

- deploy the real Abbey Root site,
- configure public DNS,
- configure public TLS certificates,
- create Nginx Proxy Manager proxy hosts,
- move Nginx Proxy Manager to edge01,
- change router forwarding,
- implement abbey site deployment commands,
- deploy Bread Pitt,
- or configure additional static domains.

## Follow-up

1. Reserve 192.168.1.84 for MAC address BC:24:11:02:02:84.
2. Rotate the exposed Ansible and Umami secrets.
3. Regenerate inventory and infrastructure documentation.
4. Implement a reusable static-site deployment workflow.
5. Deploy the real abbeyroot.com build through the release structure.
6. Configure the existing Nginx Proxy Manager instance to proxy abbeyroot.com to sites01.
7. Evaluate moving public ingress to edge01 in a separate session.
