---
title: "Generated Documentation Index"
description: "Added a generated durable-document index without replacing Abbey's human documentation guide."
date: 2026-08-10
draft: false
tags:
  - Abbey Root
---

# Generated Documentation Index

## Summary

The time-saver decision recommended automating a documentation index, but its
claim that one was manually maintained every week was not supported by the
repository. The useful core remained: durable documentation should be
discoverable without maintaining parallel lists by hand.

The solution extends the existing `abbey docs generate/check` contract rather
than adding another command. `docs/README.md` remains the curated introduction;
the new generated index is a complete, deterministic navigation surface for
durable documentation.

## Accomplishments

- Generated titles, categories, and relative links for durable Markdown.
- Excluded session history and research collections at every directory depth.
- Added read-only freshness checks and idempotent regeneration.
- Preserved external-project behavior through the shared toolkit.
- Expanded documentation and portability regression coverage.

## Lessons Learned

- A sound backlog direction can survive a weak AI rationale, but the rationale
  should not be repeated as project fact.
- Generated navigation and human orientation serve different purposes.
- Downstream generated files need temporary upstream overlays for truthful,
  non-mutating freshness checks.

## Next Steps

- Use the index normally before deciding whether separate ADR or framework
  indexes provide distinct value.
