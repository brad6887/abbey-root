---
title: Fact-Lock Review Init CLI
date: 2026-07-24
type: journal
tags:
  - abbey-root
  - research
  - fact-lock
  - cli
  - review
---

# Fact-Lock Review Init CLI

The fact-lock workflow can now create a blank, hash-bound review manifest with
`abbey research fact-lock review-init`.

The scaffold records the exact proposal and source-request hashes and creates
one item per scenario, but all decisions remain `undecided`, both future IDs
are null, and every note is blank. The existing approval tool therefore cannot
accept the scaffold without deliberate human completion.

The command validates before writing and refuses to overwrite an existing
review. The research regression suite passed 86 tests with no failures, and a
real five-scenario smoke test produced the expected undecided scaffold.

The next step is completed-review validation, not approval automation.
