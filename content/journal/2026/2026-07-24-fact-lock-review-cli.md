---
title: Fact-Lock Review CLI
date: 2026-07-24
type: journal
tags:
  - abbey-root
  - research
  - fact-lock
  - cli
  - review
---

# Fact-Lock Review CLI

The fact-lock workflow now has a deterministic read-only review command.

`abbey research fact-lock review` validates a suite and proposal, then displays
their hashes, every immutable proposition and anchor, all creative and factual
constraints, and focused attention labels for callback context, authorized
invention, sensitive messages, numbers, protected literals, and fixed formats.

The command does not generate a review decision or touch either input.
Regression tests confirm that the proposal checksum is unchanged.

The complete research regression suite passed 80 tests with no failures. A
real review of the accepted five-scenario evaluation proposal showed matching
source hashes, thirteen facts, and one bounded creative slot.

The next useful increment is a blank, hash-bound review-manifest scaffold. It
must require the human reviewer to enter every decision rather than supplying
approval defaults.
