---
title: "Generated Backlog Statistics"
description: "Made Abbey Root's backlog completion summary deterministic and integrated its freshness into the session workflow."
date: 2026-07-26
draft: false
tags:
  - Abbey Root
  - Abbey Framework
  - Developer Toolkit
  - Planning
---

# Generated Backlog Statistics

## Summary

Abbey Root's backlog now begins with a generated summary of complete, pending,
and total task-list entries. The summary is derived from the backlog itself, so
it improves visibility without becoming a second source of planning truth.

The new `abbey backlog refresh` command owns only a clearly marked block.
`abbey review` warns when that block needs attention before commit, and
`abbey end` verifies it during final read-only session certification.

## Accomplishments

- Added deterministic backlog checkbox counting.
- Added safe refresh and read-only check commands.
- Preserved all human-maintained backlog content outside the generated markers.
- Rejected malformed and duplicate marker structures without rewriting them.
- Made repeated refreshes produce no file change.
- Added regression coverage for counts, formatting, missing and malformed
  blocks, stale data, and idempotence.
- Documented the generated planning interface and synchronized CLI metadata.

## Lessons Learned

- `abbey end` is a post-commit certification command, so it should verify
  generated planning data rather than mutate it.
- A reusable refresh command plus checks at workflow boundaries keeps ownership
  explicit and avoids duplicated counting logic.
- Portable shell tooling should not pass multiline values through macOS
  `awk -v`; rendering bounded lines individually is simpler and deterministic.

## Next Steps

- Evaluate the workflow messages through normal sessions before expanding this
  into a broader generated planning-summary command.
