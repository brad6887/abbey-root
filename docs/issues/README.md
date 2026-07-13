# Abbey Root Issues

This directory records unresolved and resolved operational issues discovered while building, operating, and maintaining Abbey Root.

Issues are used for failures, defects, recurring infrastructure problems, unexpected behavior, and investigations that need a durable technical record.

They are not a replacement for the project backlog.

- The backlog records future work and improvements.
- Session updates record work completed during a session.
- Issues record something that is broken, unreliable, or not yet understood.

---

## Issue Lifecycle

Each issue should move through one of these states:

- `open`
- `investigating`
- `mitigated`
- `resolved`
- `closed`

Resolved issues remain in this directory as operational knowledge.

---

## File Naming

```
ISSUE-NNNN-short-description.md
```

Example:

```
ISSUE-0001-ai-worker01-nvidia-driver-hang.md
```

Issue numbers should increase sequentially and should never be reused.

---

## Front Matter

```yaml
---
id: ISSUE-0001
title: Short descriptive title
status: open
priority: medium
category: infrastructure
host: hostname-or-null
opened: YYYY-MM-DD
resolved:
session:
---
```

---

## Standard Sections

Each issue should contain:

```
# Issue

## Summary

## Symptoms

## Impact

## Timeline

## Evidence

## Suspected Cause

## Recovery or Workaround

## Resolution

## Follow-up
```

---

## Purpose

Issues should contain enough information that someone can recognize, investigate, and resolve the problem again without relying on memory.

Capture:

- What happened
- When it happened
- What systems were affected
- Evidence collected
- Commands used
- Recovery procedure
- Root cause
- Permanent fix
- Lessons learned

---

## Future Automation

Possible future commands:

```
abbey issue list
abbey issue new
abbey issue show ISSUE-0001
abbey issue close ISSUE-0001
```

Automation should be added only after the manual workflow has been validated through real use.
