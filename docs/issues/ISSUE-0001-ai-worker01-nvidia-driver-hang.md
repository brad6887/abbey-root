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

Physical intervention is currently required.

## Symptoms

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

### 2026-07-13

- First observed during validation of `abbey lab check`.
- Health check reported load average of approximately 24.
- Process inspection showed numerous blocked `llama-server` processes.
- NVIDIA-related kernel workers were also blocked.
- `nvidia-smi` hung indefinitely.
- Ansible reboot initiated.
- Host failed to return to SSH.
- Physical intervention required.

## Evidence

### System

- Load average approximately `24.00`
- CPU idle approximately `99%`

### Process state

Large number of processes observed in uninterruptible sleep (`D`):

- `llama-server`
- `nv_open_q`
- `kworker`
- `udev-worker`

### Ollama

Ollama service remained active with many child `llama-server` processes.

### NVIDIA

Driver version:

```
595.71.05
```

`nvidia-smi` did not return.

### Docker

Containers remained healthy.

## Suspected Cause

Current theory is a GPU driver deadlock involving the NVIDIA kernel driver while Ollama workloads were active.

The exact sequence is still unknown.

## Recovery or Workaround

Current recovery requires physical access.

Planned recovery:

1. Inspect console.
2. Attempt graceful shutdown if possible.
3. Force power off if necessary.
4. Boot normally.
5. Verify SSH.
6. Verify `nvidia-smi`.
7. Verify Ollama.
8. Run `abbey lab check`.

## Resolution

Not yet resolved.

When resolved, document:

- Root cause.
- Permanent fix.
- Verification steps.
- Commands used.
- Lessons learned.

## Follow-up

- Add D-state process count to `abbey lab check`.
- Add timeout-protected NVIDIA health check.
- Investigate repeated reboot hangs.
- Investigate accumulation of `llama-server` processes.
- Review NVIDIA driver compatibility.
- Review Ollama shutdown behavior.
- Investigate failed `systemd-networkd-wait-online.service`.
- Evaluate remote power management for physical lab systems.
- Consider exposing overall lab health on BradCooke.com.
