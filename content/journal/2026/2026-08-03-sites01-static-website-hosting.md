---
title: Sites01 Static Website Hosting
description: Journal of provisioning and validating the Abbey Root static website host.
date: 2026-08-03
session: sites01-static-website-hosting
reviewed: false
tags:
  - journal
  - infrastructure
  - ansible
  - nginx
  - proxmox
---

# Sites01 Static Website Hosting

Today I built the first dedicated static website host for the Abbey Root lab.

The immediate reason for the server is abbeyroot.com, but the larger purpose is to create one reusable hosting platform for the collection of static sites.

Abbey Root will be the first site, followed later by Bread Pitt and the other standalone domains.

## Review

The first step was checking the actual environment instead of relying on older architecture assumptions.

The repository showed that:

- rocky-ansible01 is the Ansible control node.
- edge01 currently provides internal DNS.
- Nginx Proxy Manager currently runs on ubuntu-dev01.
- The global Ansible baseline already manages common packages, internal DNS, time synchronization, MOTD, and login banners.
- There was no existing native static-site role.

That corrected the earlier assumption that public ingress was already running on edge01.

Rather than expand the session into moving Nginx Proxy Manager, I kept the work focused on provisioning the static host.

Public ingress can continue through ubuntu-dev01 until a separate migration is designed and validated.

## Define

The host design was kept intentionally small:

- Rocky Linux
- 2 vCPU
- 2 GB RAM
- 32 GB disk
- native nginx
- no Docker
- one dedicated deployment identity
- one release tree per domain
- atomic current symlink
- build elsewhere and deploy finished static artifacts

The definition of done was a reproducible host that could serve an internal abbeyroot.com placeholder and pass Ansible, DNS, firewall, SELinux, nginx, and HTTP validation.

## Build

### VM Provisioning

I cloned Proxmox template VM 100 into VM 105 and named it sites01.

The template already had the desired resource allocation:

    CPU:    2 vCPU
    Memory: 2 GB
    Disk:   32 GB
    NIC:    VirtIO on vmbr0
    Agent:  QEMU guest agent enabled

The clone received MAC address:

    BC:24:11:02:02:84

I booted it with the virtual network disconnected so that a cloned static address could not conflict with an existing machine.

Inside the console, I changed the hostname to sites01 and regenerated /etc/machine-id.

The older /var/lib/dbus/machine-id path did not exist on this Rocky image, so only the systemd machine ID under /etc needed to be regenerated.

### Network Access

The first candidate address, 192.168.1.89, was already in use.

A ping returned replies and the neighbor table identified an active MAC address, so the candidate was rejected.

Router administration was unavailable because the gateway access code was not working.

Rather than guess at an unused static address, I changed the VM network profile to DHCP.

I was away from home and could not directly reach the Proxmox web interface.

The QEMU guest agent was active, but guest command execution was disabled:

    Agent error: Command guest-exec has been disabled

I tunneled the Proxmox interface through ubuntu-dev01, opened the VM console remotely, reconnected the NIC, and activated the DHCP connection.

The VM received:

    192.168.1.84

I successfully connected over SSH and authorized the rocky-ansible01 SSH key.

The address remains DHCP-assigned and needs a permanent router reservation.

### Inventory and Baseline

I added a new Ansible inventory group:

    web:
      hosts:
        sites01:
          ansible_host: 192.168.1.84
          ansible_user: bcooke

The host variables describe sites01 as a static website and production web-content host.

Ansible connectivity passed:

    sites01 | SUCCESS
    ping: pong

The standard site playbook applied only the shared host roles because sites01 is not part of the Docker or application groups.

The baseline configured:

- common tools,
- Abbey shell initialization,
- internal DNS,
- the home.arpa search domain,
- timezone and chrony,
- MOTD,
- and the issue banner.

The host resolved edge01.home.arpa through Technitium at 192.168.1.221, and NTP synchronization was healthy.

### Static Site Role

I added a focused static_site_host role and a static-sites.yml playbook.

The role installs:

    nginx
    firewalld
    policycoreutils-python-utils

It creates:

    User:  abbey-deploy
    Group: abbey-deploy
    Root:  /srv/www

The first site uses:

    /srv/www/abbeyroot.com/
    ├── current -> /srv/www/abbeyroot.com/releases/bootstrap
    └── releases/
        └── bootstrap/
            └── index.html

The bootstrap release contains a simple placeholder confirming that the hosting platform is online.

The role also configures:

- an nginx virtual host,
- an nginx /healthz endpoint,
- persistent SELinux file contexts,
- restored httpd_sys_content_t labels,
- permanent HTTP access through firewalld,
- and nginx configuration validation before reload.

### Check-Mode Correction

The first check-mode run found a real workflow issue.

Ansible reported that it would create the bootstrap release directory, but because check mode does not actually create it, the following symlink task failed when it attempted to point current at a nonexistent target.

I did not use force because that would weaken the safety of the real task.

Instead, the symlink task now skips initial creation during check mode when the target release does not already exist.

The following check-mode run completed with no failures.

## Validate

The host passed all functional checks.

### Services

    nginx:            active and enabled
    firewalld:        active
    sshd:             active
    chronyd:          active
    qemu-guest-agent: active

### Firewall

The permanent firewalld HTTP service returned:

    yes

### SELinux

The site root, release directory, symlink, and placeholder content all received:

    httpd_sys_content_t

### Nginx

The configuration test succeeded:

    nginx: configuration file /etc/nginx/nginx.conf test is successful

The placeholder was available at:

    http://192.168.1.84/

The health endpoint returned:

    ok

Hostname-based tests succeeded for:

    abbeyroot.com
    www.abbeyroot.com
    sites01.home.arpa

### DNS

Forward and reverse Technitium records were added and validated:

    sites01.home.arpa -> 192.168.1.84
    192.168.1.84 -> sites01.home.arpa

### Idempotency

A second normal run of the focused static-site playbook completed without changes.

That confirms the role converges cleanly after the initial deployment.

## Decisions

The main decisions from this session were:

1. Keep Rocky Linux 10.2 because it matches the current template and Ansible control node.
2. Use native nginx instead of Docker.
3. Keep Nginx Proxy Manager on ubuntu-dev01 during this session.
4. Keep public DNS, TLS, and router changes out of scope.
5. Build sites elsewhere and deploy only finished static artifacts.
6. Use release directories and an atomic current symlink.
7. Treat the DHCP address as temporary until it is reserved by MAC address.
8. Keep real deployment tooling separate from the host-provisioning role.

## Security Observation

A full Ansible inventory dump displayed decrypted Vault variables.

No secret values are recorded in project documentation, but the exposed credentials and Umami secrets must be rotated before the hosting platform is exposed publicly.

This also reinforces that ansible-inventory --host should not be used casually when encrypted group variables are loaded.

The graph view is safer for ordinary inventory review.

## Result

sites01 is now a functioning, reproducible static website host.

The host can serve abbeyroot.com internally, and the implementation establishes the directory, user, firewall, SELinux, nginx, health-check, and Ansible patterns needed to add more static sites later.

The next session should deploy the real Abbey Root website through this release structure.

It should not combine that deployment with moving the public reverse proxy.

## Follow-up

- Reserve 192.168.1.84 for BC:24:11:02:02:84.
- Rotate the exposed Ansible and Umami secrets.
- Regenerate generated inventory documentation.
- Build a reusable artifact deployment workflow.
- Deploy the real Abbey Root site.
- Configure the existing Nginx Proxy Manager instance.
- Evaluate moving public ingress to edge01 separately.
