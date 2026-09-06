# Monthly Linux Patching

## Purpose

Use this runbook for the monthly operating system patch cycle for the Abbey Root
Linux lab.

The workflow provides:

- Explicit confirmation before disruptive patching
- Global preflight before package changes
- Deterministic one-host-at-a-time patching
- Reboot only when updates were installed and the operating system requires it
- Post-reboot systemd startup settling
- Strict post-patch health validation
- D-state process detection
- Stop-on-first-failure behavior
- Timestamped logs and reports
- Email notifications

rocky-ansible01 is intentionally patched manually after all managed hosts
complete successfully.

## Standard Commands

Run from rocky-ansible01:

    cd ~/git/abbey-root
    abbey lab patch

Run validation without installing packages or rebooting:

    abbey lab patch --preflight-only

Display help:

    abbey lab patch --help

For intentional noninteractive execution:

    abbey lab patch --yes

Do not use --yes for routine interactive maintenance. It bypasses the
interactive safety confirmation and is intended for future controlled
automation.

## Interactive Confirmation

A normal patch run does not begin immediately.

The command displays the systems that will be patched and requires:

    Type PATCH to continue:

Only the exact response:

    PATCH

allows the workflow to continue.

Any other response cancels the operation before preflight, package changes, or
reboots occur.

A noninteractive invocation without --yes is rejected.

## Patch Order

Managed hosts are patched in this explicit order:

1. sensor01
2. sites01
3. ai-worker01
4. ubuntu-dev01
5. edge01

The wrapper invokes a separate Ansible playbook run for each host. Patch order
therefore does not depend on Ansible inventory ordering.

edge01 is patched last among managed hosts because it provides lab
infrastructure services.

After all five managed hosts succeed, patch rocky-ansible01 manually.

## Global Preflight

No managed host is patched unless every patch target passes the global
preflight.

The strict health gate verifies:

- Supported Debian or Red Hat operating system family
- Ansible connectivity and fact gathering
- Privilege escalation
- At least 2 GiB free on the root filesystem
- No processes stuck in uninterruptible sleep (D state)
- No failed systemd units
- Package repository availability

APT or DNF package metadata may be refreshed during preflight.

The command:

    abbey lab patch --preflight-only

runs these checks without installing packages or rebooting hosts.

## Package Updates

Distribution-specific package updates remain implemented through the existing
Ansible update role.

For Debian and Ubuntu:

- APT metadata is refreshed.
- dist-upgrade installs available packages.
- Abbey records whether package installation changed the host.

For Rocky and RHEL:

- DNF installs available package updates.
- Abbey records whether package installation changed the host.

Refreshing package metadata alone does not count as a package change.

## Reboot Decision

A host is rebooted only when both of these conditions are true:

1. Packages changed during the current patch run.
2. The operating system reports that those changes require a reboot.

If no packages changed, the host is never rebooted.

If packages changed but no reboot is required, the host remains running and
proceeds directly to post-patch validation.

### Debian and Ubuntu

When packages changed, Abbey checks:

    /var/run/reboot-required

The host reboots only when that file exists.

### Rocky and RHEL

When packages changed, Abbey runs:

    dnf needs-restarting -r

Return code 1 means a reboot is recommended.

Return code 0 means no reboot is required.

A reboot indication is ignored when no packages changed during the current
run. This prevents a no-op patch run from unexpectedly rebooting a host.

## Managed Host Workflow

For each managed host, Abbey performs the following sequence:

1. Run the strict health gate immediately before patching.
2. Record the current kernel.
3. Apply available operating system updates.
4. Record whether packages changed.
5. Determine whether those changes require a reboot.
6. Reboot only when required.
7. Gather fresh Ansible facts.
8. If rebooted, wait for systemd startup to settle.
9. If rebooted, verify systemd reached a stable startup state.
10. Run the strict health gate again.
11. Record package-change and reboot status.
12. Continue to the next host.

A host is not considered successfully patched merely because SSH has returned.

## Systemd Startup Settling

After a reboot, Abbey waits up to 360 seconds for:

    systemctl is-system-running --wait

A running state proceeds normally.

A degraded state is allowed to continue to the strict health gate so that the
failed-unit check can report the actual failed service.

Other unstable startup states stop the workflow.

## D-State Protection

Processes stuck in uninterruptible sleep are a hard patch failure.

The strict health gate checks for D-state processes:

- During global preflight
- Immediately before patching a host
- During final post-patch validation

The workflow will not advance to another host while D-state processes exist.

## Failure Behavior

The workflow stops immediately if a host fails during:

- Global preflight
- Immediate pre-patch validation
- Package installation
- Reboot decision
- Reboot
- Reconnection
- Systemd startup settling
- Post-patch D-state validation
- Post-patch failed-unit validation
- Package repository validation

Hosts later in the patch sequence are not modified.

A failure report is written and an email notification is sent.

## ai-worker01 NVIDIA Driver Hang

ai-worker01 has an open intermittent NVIDIA driver issue documented in:

    docs/issues/ISSUE-0001-ai-worker01-nvidia-driver-hang.md

The known failure signature includes:

- nvidia-persistenced startup timeout
- NVIDIA kernel processes stuck in D state
- llama-server processes stuck in D state
- nvidia-smi hanging or entering D state
- High system load with mostly idle CPUs

The issue recurred on September 5, 2026 after an accidental second patch run
rebooted ai-worker01 shortly after an earlier successful reboot.

The patch workflow now includes three protections discovered from that incident:

- Interactive confirmation before disruptive patching
- D-state processes are a hard patch failure
- Post-reboot validation waits for systemd startup to settle

Conditional reboot handling also prevents a no-op patch run from rebooting
ai-worker01 or any other host.

The currently known recovery procedure for a wedged NVIDIA driver is a physical
power cycle of ai-worker01 followed by:

    uptime
    uname -r
    systemctl --failed
    nvidia-smi

Then run:

    cd ~/git/abbey-root
    abbey lab check

Do not repeatedly invoke nvidia-smi when the NVIDIA driver is already known to
be wedged. The command itself may become stuck in D state.

## Logs and Reports

Patch state is retained outside the Git repository under:

    ~/.local/state/abbey/patch/

Each run receives a timestamped log such as:

    patch-20260905_101208.log

Completed or failed patch runs also create a report file.

Notifications are sent to:

    brad6887@gmail.com
    alerts@abbeyroot.com

A failure notification is sent when the workflow stops.

A successful managed-host report explicitly notes that rocky-ansible01 remains
the manual final step.

## Patch the Controller

After abbey lab patch reports success for all managed hosts, update
rocky-ansible01 manually:

    sudo dnf upgrade --refresh -y

Reboot the controller only when its installed updates require a reboot.

After any controller reboot, verify:

    uptime
    uname -r
    systemctl --failed
    df -h /

There should be no failed systemd units and adequate free space on /.

## Final Lab Validation

After completing the controller maintenance, run:

    cd ~/git/abbey-root
    abbey lab check

Review the output for:

- All inventory hosts reachable
- Zero failed Ansible tasks
- Zero failed systemd units
- Zero D-state processes
- Expected network interfaces present
- Healthy NVIDIA status on ai-worker01
- Active Ollama service on ai-worker01
- Docker available on configured Docker hosts
- Zero unhealthy Docker containers

A clean abbey lab check completes the monthly patch cycle.

## Validated Behavior

The conditional reboot behavior was directly validated on September 6, 2026.

### No-Op Patch

sensor01 had no available package updates.

The patch playbook reported:

    Packages changed: False
    Reboot required: False
    Reboot performed: False

The reboot task was skipped.

The boot ID before and after the patch run remained:

    1dd6ac1e-3622-4ed5-b1d4-f9530f24ff97

This confirmed that a no-op patch run does not reboot the host.

### Reboot-Required Patch

sites01 had a Rocky Linux kernel update available.

The patch workflow installed the update, detected that a reboot was required,
and rebooted the host.

After the reboot, sites01 was running:

    6.12.0-211.51.1.el10_2.x86_64

with a new boot time and boot ID.

A final abbey lab check passed after the controlled tests.

## Implementation

The operator-facing command is:

    abbey lab patch

The workflow is implemented by:

    tools/bin/abbey-lab
    tools/abbey-ansible-patch
    ansible/inventory/hosts.yml
    ansible/playbooks/patch-preflight.yml
    ansible/playbooks/patch-host.yml
    ansible/tasks/patch-health-gate.yml
    ansible/roles/update/tasks/main.yml

The existing Ansible update role remains the source of truth for
distribution-specific package updates.

The legacy abbey-ansible-update helper is deprecated and fails closed so it
cannot bypass the safer patch workflow.

## V1 Boundaries

### Controller Self-Patching

rocky-ansible01 does not currently patch itself automatically.

A future focused Abbey session may add a durable systemd handoff that:

1. Persists patch run state.
2. Starts the local controller patch.
3. Updates rocky-ansible01.
4. Reboots only when required.
5. Resumes validation after boot when a reboot occurred.
6. Finalizes the report.
7. Sends the final completion notification.

### Notification Configuration

Outbound notification mail is currently configured locally on
rocky-ansible01 using s-nail and msmtp.

A future infrastructure session should make the non-secret mail configuration
reproducible through Ansible and keep SMTP credentials in an appropriate secret
store such as Ansible Vault.

### Scheduling

The patch workflow remains manually initiated.

Run it manually through additional monthly cycles before introducing automated
scheduling.
