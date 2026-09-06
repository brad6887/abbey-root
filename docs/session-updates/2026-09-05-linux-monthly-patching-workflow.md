---
title: "Linux Monthly Patching Workflow"
description: "Built and live-validated a safe monthly Linux patch workflow with conditional reboots, health gates, deterministic sequencing, reporting, and operator safeguards."
date: 2026-09-05
status: pending
reviewed: false
session: linux-monthly-patching-workflow
journal: "content/journal/2026/2026-09-05-linux-monthly-patching-workflow.md"
tags:
  - Abbey Root
  - Ansible
  - Linux
  - Patching
  - Home Lab
---

# Linux Monthly Patching Workflow

## Objective

Build and validate a repeatable monthly Linux patch workflow for the Abbey Root
home lab using Ansible.

The workflow must safely determine when hosts need updates and reboots, validate
hosts before and after maintenance, retain durable reports, and provide a simple
operator-facing Abbey command.

## Definition of Done

- Preflight all remote patch targets before changing any system.
- Patch remote hosts one at a time in a deterministic order.
- Stop immediately when a host fails.
- Install available operating system updates.
- Reboot only when packages changed during the current run and the operating
  system reports that a reboot is required.
- Never reboot a host during a no-op patch run.
- Wait for systemd startup to settle after a reboot.
- Treat D-state processes as a hard patch failure.
- Validate each host before advancing to the next host.
- Retain timestamped logs and reports.
- Send immediate email notification on failure.
- Send a final report after all remote targets succeed.
- Send notifications to both brad6887@gmail.com and alerts@abbeyroot.com.
- Keep rocky-ansible01 outside the automated patch sequence for v1.
- Provide abbey lab patch as the public operator command.
- Require explicit confirmation before a disruptive interactive patch run.
- Provide a safe preflight-only mode.
- Document and live-validate the workflow before considering scheduling.

## Summary

Implemented and live-tested the first Abbey Root monthly Linux patch workflow.

A patch_targets inventory group defines the five remotely managed patch
targets. A strict reusable health gate verifies operating system support,
privilege escalation, root filesystem free space, D-state processes, failed
systemd units, and package repository availability.

The workflow performs a global preflight before changing any host. It then
patches hosts through separate Ansible playbook invocations in this explicit
order:

1. sensor01
2. sites01
3. ai-worker01
4. ubuntu-dev01
5. edge01

Each host receives another strict health check immediately before package
maintenance.

The existing Ansible update role remains the source of truth for
distribution-specific updates. It now records whether package installation
actually changed the host.

A reboot occurs only when both conditions are true:

1. Packages changed during the current patch run.
2. The operating system reports that those changes require a reboot.

Debian and Ubuntu use /var/run/reboot-required.

Rocky and RHEL use:

    dnf needs-restarting -r

After a reboot, Abbey waits for systemd startup to settle before running the
strict post-patch health gate.

The workflow is exposed through:

    abbey lab patch

Safe validation without package installation or rebooting is available through:

    abbey lab patch --preflight-only

Interactive patching requires the operator to type:

    PATCH

The --yes option exists only for intentional noninteractive execution.

rocky-ansible01 remains intentionally outside the automated remote sequence in
v1 and is maintained manually as the final host.

## Accomplishments

- Added the patch_targets Ansible inventory group.
- Added a reusable strict patch health gate.
- Added global patch preflight.
- Added guarded single-host patch execution.
- Added deterministic host sequencing independent of Ansible inventory order.
- Added stop-on-first-failure behavior.
- Added package-change detection to the existing update role.
- Separated APT metadata refresh from Debian and Ubuntu package upgrades.
- Added conditional reboot decisions.
- Added Debian and Ubuntu reboot detection using /var/run/reboot-required.
- Added Rocky and RHEL reboot detection using dnf needs-restarting -r.
- Prevented no-op patch runs from rebooting hosts.
- Added systemd startup settling after actual reboots.
- Added D-state process detection as a hard patch health failure.
- Added timestamped patch logs and human-readable reports.
- Added failure and remote-success email notifications.
- Configured notifications for brad6887@gmail.com and alerts@abbeyroot.com.
- Added the public abbey lab patch command.
- Added abbey lab patch --preflight-only.
- Added abbey lab patch --yes for intentional future automation.
- Added interactive PATCH confirmation before disruptive maintenance.
- Registered the command in canonical Abbey CLI metadata.
- Regenerated deterministic CLI documentation.
- Deprecated and fail-closed the legacy abbey-ansible-update helper.
- Added the monthly Linux patching runbook.
- Updated ISSUE-0001 with the second observed ai-worker01 NVIDIA driver hang.

## First Live Patch Cycle

The first complete remote patch cycle ran on September 5, 2026.

Remote run:

    Run ID: 20260905_101208
    Started: Sat Sep 5 10:12:08 AM CDT 2026
    Finished: Sat Sep 5 10:47:09 AM CDT 2026
    Status: REMOTE PATCH SUCCESS

    sensor01: SUCCESS
    sites01: SUCCESS
    ai-worker01: SUCCESS
    ubuntu-dev01: SUCCESS
    edge01: SUCCESS

The remote portion completed in approximately 35 minutes.

rocky-ansible01 was then patched and rebooted manually.

A full abbey lab check passed across all six Linux hosts.

## Accidental Second Patch Run

A second abbey lab patch invocation occurred accidentally later on September 5.

Because the first implementation rebooted every host unconditionally after the
update role, all five remote hosts rebooted even though no new packages were
installed.

This exposed two workflow defects:

- A bare abbey lab patch invocation was too easy to start accidentally.
- Reboots were unconditional rather than based on package changes and actual
  reboot requirements.

The second run also triggered another occurrence of the existing ai-worker01
NVIDIA driver hang documented in ISSUE-0001.

## ai-worker01 NVIDIA Recurrence

During the accidental second run, ai-worker01 rebooted shortly after an earlier
successful reboot.

Observed timing included:

- nvidia-persistenced started at approximately 11:11:33 CDT.
- The patch workflow reported success at 11:12:58 CDT.
- nvidia-persistenced reached its initial startup timeout at 11:13:03 CDT.
- systemd attempted SIGTERM and later SIGKILL.
- The service was formally marked failed at 11:16:03 CDT.
- NVIDIA and Ollama processes remained stuck in uninterruptible sleep.

D-state processes included:

- udev-worker
- nv_open_q
- nvidia-persistenced
- Multiple llama-server processes
- nvidia-smi

Kernel messages showed tasks blocked inside NVIDIA driver operations.

The incident closely matched the July ISSUE-0001 failure signature.

A physical power cycle recovered ai-worker01.

After recovery:

- No failed systemd units were present.
- No D-state processes were present.
- nvidia-smi responded normally.
- NVIDIA driver 595.84 initialized normally.
- Ollama was active.
- Docker was healthy.
- A complete abbey lab check passed.

The recurrence strengthens the theory that repeated or closely spaced reboot
cycles may contribute to the intermittent NVIDIA initialization failure.

## Safety Improvements From the Incident

The accidental run resulted in four immediate workflow improvements.

### Interactive Confirmation

A normal:

    abbey lab patch

now displays the patch targets and requires:

    Type PATCH to continue:

Any other response cancels before preflight, updates, or reboots.

The cancellation path was tested with NO and returned exit code 1 without
changing any host.

### D-State Hard Failure

The strict patch health gate now rejects any host with processes stuck in
uninterruptible sleep.

This applies during:

- Global preflight
- Immediate pre-patch validation
- Final post-patch validation

### Systemd Startup Settling

After an actual reboot, Abbey waits for:

    systemctl is-system-running --wait

with a 360-second timeout.

This prevents a host from being declared healthy immediately after SSH returns
while services are still starting or timing out.

A running system proceeds normally.

A degraded system proceeds to the strict health gate so failed service details
can be reported.

Other unstable startup states fail the patch workflow.

### Conditional Reboots

The update role now explicitly records whether package installation changed a
host.

A reboot occurs only when packages changed and the operating system reports a
reboot requirement.

This prevents a no-op maintenance run from creating unnecessary reboot risk.

## Conditional Reboot Validation

Conditional reboot behavior was directly tested on September 6, 2026.

### sensor01 No-Op Test

Before the test, apt simulation showed:

    PENDING=0

The patch playbook then reported:

    Packages changed: False
    Reboot required: False
    Reboot performed: False

The reboot task was skipped.

The sensor01 boot ID remained identical before and after the run:

    1dd6ac1e-3622-4ed5-b1d4-f9530f24ff97

Its boot time also remained unchanged.

This directly proved that a no-op patch run no longer reboots the host.

### sites01 Reboot-Required Test

sites01 had a new Rocky Linux kernel available:

    6.12.0-211.51.1.el10_2

The patch playbook installed the available updates.

DNF reported that a reboot was required, and Abbey rebooted the host.

After the run, sites01 reported:

    6.12.0-211.51.1.el10_2.x86_64

Its boot time changed to:

    2026-09-06 06:36:24

and its boot ID changed, confirming that the reboot occurred.

A final abbey lab check passed after the controlled tests.

## Impact

Monthly Linux maintenance now has a reproducible Abbey workflow instead of a
collection of ad hoc update commands.

The workflow reduces risk by:

- Refusing to begin disruptive maintenance without explicit confirmation.
- Requiring every target to pass global preflight.
- Patching only one host at a time.
- Rebooting only when required.
- Waiting for boot services to settle.
- Rejecting D-state processes.
- Rejecting failed systemd units.
- Validating each host before advancing.
- Stopping before later hosts are touched when a failure occurs.

The explicit order keeps low-impact systems first and edge01, an infrastructure
host, last among the managed targets.

The public abbey lab patch interface also separates the stable operator
experience from the underlying implementation.

## Validation

The completed workflow was validated through:

- Ansible syntax checks for patch-preflight.yml and patch-host.yml.
- Shell syntax checks for tools/abbey-ansible-patch and tools/bin/abbey-lab.
- Global preflight across all five remote patch targets.
- D-state health-gate execution across all five targets.
- systemctl is-system-running --wait validation across all five targets.
- Interactive cancellation test with no host changes.
- abbey lab patch --help routing through the public CLI.
- abbey lab patch --preflight-only with no packages installed or hosts rebooted.
- abbey docs generate.
- abbey validate.
- git diff --check.
- First full live remote patch cycle.
- Manual rocky-ansible01 patch and reboot.
- Controlled sensor01 no-op patch test proving no reboot.
- Controlled sites01 kernel update proving reboot-required behavior.
- Multiple complete abbey lab check runs.

Final lab validation reported all six hosts reachable and healthy with:

- Zero failed Ansible tasks.
- Zero failed systemd units.
- Zero D-state processes.
- Healthy Docker services.
- Zero unhealthy Docker containers.
- Healthy NVIDIA status on ai-worker01.
- Active Ollama service on ai-worker01.

## Lessons Learned

Ansible inventory source order should not be relied on for safety-sensitive
maintenance sequencing. Explicit one-host-at-a-time invocation is clearer and
deterministic.

SSH returning after a reboot does not prove that a host has completed startup.
Services may still be starting or approaching timeout conditions. Post-reboot
validation must wait for systemd to settle.

D-state processes are a particularly important signal for infrastructure
health. They are now a hard patch failure rather than only an informational
warning.

Package metadata refresh and actual package installation must be distinguished
when determining whether a host changed.

A maintenance workflow should never equate "patch command executed" with
"reboot required."

No-op reruns are important validation cases. The accidental second patch run
revealed that unconditional reboot behavior did not match the original design.

Interactive confirmation is appropriate for a command capable of rebooting
multiple infrastructure systems.

The ai-worker01 NVIDIA problem remains intermittent. The September recurrence
provides stronger evidence that reboot timing or NVIDIA initialization during
boot may be part of the trigger.

The existing abbey lab check remains useful as broad post-maintenance
validation, while the stricter patch gate determines whether maintenance may
proceed.

## Next Steps

- Continue investigating ISSUE-0001 and the intermittent ai-worker01 NVIDIA
  initialization deadlock.
- Design a focused v2 workflow for self-patching rocky-ansible01 using durable
  systemd handoff and post-reboot continuation.
- Preserve conditional reboot behavior when controller self-patching is added.
- Make non-secret SMTP configuration reproducible through Ansible while
  protecting credentials with the existing secret-management workflow.
- Consider adding package-change counts to patch reports.
- Include reboot-performed status in the final multi-host report.
- Consider adding kernel-before and kernel-after values to the final report.
- Continue running the workflow manually before introducing monthly scheduling.
- Consider scheduling only after additional normal monthly cycles demonstrate
  reliable behavior.

## Notes

The public operator interface is:

    abbey lab patch

Safe preflight is:

    abbey lab patch --preflight-only

Intentional noninteractive execution is:

    abbey lab patch --yes

The first validated remote run log is:

    /home/bcooke/.local/state/abbey/patch/patch-20260905_101208.log

The accidental second run was:

    20260905_110828

rocky-ansible01 remains a deliberate manual final step in v1.

Outbound mail currently uses local mail configuration on rocky-ansible01. SMTP
credentials remain outside the Git repository.
