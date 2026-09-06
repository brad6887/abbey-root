---
id: ISSUE-0001
title: ai-worker01 NVIDIA driver hang
status: investigating
priority: high
category: infrastructure
host: ai-worker01
opened: 2026-07-13
resolved:
session: abbey-lab-check
---

# Issue

## Summary

During development of `abbey lab check`, the AI worker developed what appears to be a GPU or NVIDIA driver deadlock while running Ollama.

The system reported a load average near 24 while CPUs remained almost completely idle. Numerous `llama-server` processes became stuck in uninterruptible sleep (`D` state), `nvidia-smi` hung indefinitely, and the machine failed to recover after a remote reboot.

Physical intervention was required to recover the system. After rebooting locally, the system returned to normal operation and has not yet reproduced the failure.

## Current Status

The host is currently operating normally.

Current observations:

- SSH functioning normally.
- 2.5 GbE networking restored.
- Docker healthy.
- Ollama functioning normally.
- `nvidia-smi` responds normally.
- GPU operating normally.
- No D-state processes observed.
- `abbey lab check` completes successfully.

A controlled GPU workload was executed successfully without reproducing the problem.

The failure has not yet been reproduced.

## Symptoms

During the original incident:

- Load average remained approximately 24.
- CPU remained approximately 99% idle.
- Numerous `llama-server` processes stuck in `D` state.
- NVIDIA kernel workers also stuck in `D` state.
- `nvidia-smi` never returned.
- Ollama service remained running.
- Docker containers remained healthy.
- Remote reboot never restored SSH connectivity.

## Impact

- AI workloads unavailable.
- Remote administration unavailable.
- Physical access required before additional investigation.

## Timeline

### 2026-07-13 — Initial Failure

- First observed during validation of `abbey lab check`.
- Health check reported load average of approximately 24.
- Process inspection showed numerous blocked `llama-server` processes.
- NVIDIA-related kernel workers were also blocked.
- `nvidia-smi` hung indefinitely.
- Ansible reboot initiated.
- Host failed to return to SSH.
- Physical intervention required.

### 2026-07-13 — Recovery

- Physical power cycle performed.
- Initial boot completed successfully.
- USB Ethernet adapter was found partially disconnected after moving equipment.
- Adapter reseated.
- Adapter returned to a USB 3.0 port, restoring 2.5 GbE connectivity.
- Host became reachable via SSH.
- `nvidia-smi` completed successfully.
- No D-state processes observed.
- `abbey lab check` completed successfully.

### 2026-07-13 — Baseline Validation

The recovered system was subjected to a controlled validation.

Observations:

- NVIDIA driver version: `595.71.05`
- CUDA version: `13.2`
- RTX 4060 detected normally.
- No NVIDIA Xid errors found in the current boot log.
- PCIe operating at Gen4 x8.
- GPU idle temperature approximately 36–37°C.

A sustained Ollama workload was then executed.

Results:

- Four concurrent requests were submitted.
- A single `llama-server` process serviced the workload.
- GPU utilization reached approximately 94%.
- GPU temperature peaked at approximately 59°C.
- Power remained near the configured 60 W limit.
- `nvidia-smi` remained responsive throughout testing.
- No D-state processes appeared.
- No additional `llama-server` processes accumulated.
- System load remained low.
- After inference completed, GPU utilization returned to idle while the model remained loaded for the expected Ollama keep-alive interval.

The original failure was not reproduced.

### 2026-09-05 - Second Observed Failure

The NVIDIA driver hang recurred following a second reboot of ai-worker01
during validation of the new monthly Linux patch workflow.

Earlier in the morning, ai-worker01 had completed a normal package update,
reboot, and post-reboot validation successfully.

An accidental second invocation of abbey lab patch later caused the host to
reboot again approximately 20 to 30 minutes after the first reboot.

The second patch run reported the host as successful, but the NVIDIA stack had
not yet completed initialization.

Observed timing:

- nvidia-persistenced started at approximately 11:11:33 CDT.
- The patch workflow completed and reported remote success at 11:12:58 CDT.
- nvidia-persistenced reached its initial startup timeout at 11:13:03 CDT.
- systemd attempted SIGTERM and later SIGKILL without successfully terminating
  the process.
- The service was formally marked failed at 11:16:03 CDT.
- NVIDIA-related processes remained blocked in uninterruptible sleep.

The failure signature closely matched the original July incident.

Observed D-state processes included:

- udev-worker
- nv_open_q
- nvidia-persistenced
- Multiple llama-server processes
- nvidia-smi

Kernel messages showed tasks blocked inside the NVIDIA kernel driver, including
os_acquire_rwlock_write, NVIDIA device initialization, and deferred NVIDIA open
operations.

nvidia-smi hung indefinitely and itself entered D state.

The host remained reachable through SSH, but the NVIDIA stack could not recover
and the blocked processes could not be terminated normally.

### 2026-09-05 - Recovery

A physical power cycle was performed.

After the power cycle:

- SSH returned normally.
- Kernel was 6.8.0-139-generic.
- No failed systemd units were present.
- No D-state processes were present.
- nvidia-smi returned normally.
- NVIDIA driver 595.84 initialized successfully.
- GPU temperature was approximately 38 C.
- Ollama was active.
- No llama-server processes were stuck.
- Docker was healthy.
- A complete abbey lab check passed across all six Linux hosts.

The physical power cycle therefore remains the known recovery procedure for
this failure mode.

### 2026-09-05 - Findings

This recurrence substantially strengthens the theory that the failure is
associated with NVIDIA driver initialization during boot.

The fact that the host completed one successful reboot and then failed during a
second reboot shortly afterward makes repeated or closely spaced reboot cycles
a stronger suspected trigger.

The incident also exposed a timing issue in the new patch workflow. The patch
workflow declared ai-worker01 successful approximately five seconds before
nvidia-persistenced reached its first startup timeout and more than three
minutes before systemd formally marked the service failed.

The current post-reboot health check can therefore run before all systemd
services have finished settling.

Planned patch-workflow improvements resulting from this incident include:

- Require explicit confirmation before a disruptive abbey lab patch run.
- Wait for systemd startup to settle before post-reboot health validation.
- Treat D-state processes as a hard failure during patch validation.
- Prevent a host from being declared successfully patched while critical
  services are still starting or timing out.

The underlying NVIDIA issue remains unresolved.

The failure is now best described as intermittent rather than a one-time event.
The exact conditions required to reproduce it deliberately are still unknown.

## Evidence

### Initial Failure

#### System

- Load average approximately `24.00`
- CPU idle approximately `99%`

#### Process State

Large numbers of processes observed in uninterruptible sleep (`D`):

- `llama-server`
- `nv_open_q`
- `kworker`
- `udev-worker`

#### Ollama

Ollama service remained active with many child `llama-server` processes.

#### NVIDIA

Driver version:

```text
595.71.05
```

`nvidia-smi` never returned.

#### Docker

Containers remained healthy.

### Recovery Validation

Following recovery:

- Driver initialized normally.
- GPU detected correctly.
- No NVIDIA Xid events found.
- `nvidia-smi` returned immediately.
- No D-state processes.
- Docker healthy.
- Ollama healthy.
- `abbey lab check` passed.

### Controlled Workload Validation

Healthy operating characteristics established:

- One active `llama-server`
- GPU utilization approximately 94%
- Temperature approximately 59°C
- GPU memory approximately 2.5 GB
- No blocked processes
- No driver hangs
- `nvidia-smi` responsive throughout workload

## Suspected Cause

Current theory remains a GPU driver deadlock involving the NVIDIA kernel driver while Ollama workloads were active.

However, subsequent stress testing did not reproduce the issue.

The triggering condition may instead involve one or more of:

- a specific reboot sequence
- driver initialization during boot
- GPU state following an abnormal shutdown
- repeated model loading/unloading
- prolonged runtime
- an intermittent NVIDIA driver defect

The exact trigger remains unknown.

## Recovery Procedure

Current recovery procedure:

1. Inspect local console.
2. Reboot the system if necessary.
3. Verify local network connectivity.
4. Confirm USB Ethernet adapter is fully seated.
5. Confirm negotiated 2.5 GbE link.
6. Verify SSH connectivity.
7. Verify `nvidia-smi`.
8. Verify Ollama.
9. Run `abbey lab check`.

## Completed Improvements

This incident resulted in the following platform improvements:

- [x] Added D-state process reporting to `abbey lab check`.
- [x] Added timeout-protected NVIDIA health check.
- [x] Created Abbey issue tracking framework.
- [x] Established baseline healthy GPU behavior.
- [x] Documented recovery procedure.

## Planned Investigation

High priority:

- Attempt to reproduce the slow boot condition.
- Capture diagnostics immediately after a slow boot.
- Compare healthy versus slow boot logs.
- Review previous boot journal using `journalctl -b -1`.

Additional investigation:

- Investigate repeated reboot hangs.
- Investigate NVIDIA driver deadlock.
- Review NVIDIA driver compatibility.
- Review Ollama shutdown behavior.
- Investigate `systemd-networkd-wait-online.service`.
- Determine whether the issue is correlated with reboot frequency.

## Future Improvements

- Automatic diagnostic capture when D-state processes appear.
- Automatic issue bundle generation.
- Additional GPU metrics in `abbey lab check`.
- Remote power management for physical lab systems.
- Long-term GPU health trend collection.
- Consider exposing overall lab health on BradCooke.com.

## Resolution

Not yet resolved.

A healthy baseline has now been established.

Future investigation should focus on reproducing the original failure and identifying the conditions that distinguish failed boots from healthy boots.

---

## Issue Metadata

```yaml
Current State:
  Reproducible: intermittent
  Workaround: Physical reboot
  Baseline Established: true
  Last Verified: 2026-09-05
  Next Review: 2026-08-01
```
