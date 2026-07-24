---
title: Fact-Lock Propose and Validate CLI
date: 2026-07-24
type: journal
tags:
  - abbey-root
  - research
  - fact-lock
  - cli
---

# Fact-Lock Propose and Validate CLI

The review-gated fact-lock process is now available through two public Abbey
commands.

`abbey research fact-lock propose` runs the canonical extraction prompt
against a request suite and preserves the raw proposal. `abbey research
fact-lock validate` checks that proposal and can emit canonical JSON for human
review.

Both commands explicitly preserve the control boundary: validation is not
approval. Approval and Voice Model application remain separate manual
workflow stages.

The research regression suite passed 72 tests with no failures. A real command
smoke test also generated, validated, and normalized a five-request proposal
through the new public interface.

The next useful increment is a read-only review summary, not an approval
shortcut.
