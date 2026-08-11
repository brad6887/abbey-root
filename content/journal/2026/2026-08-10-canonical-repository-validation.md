---
title: "Canonical Repository Validation"
description: "Introduced one project-aware validation command after narrowing an over-broad AI backlog recommendation."
date: 2026-08-10
draft: false
tags:
  - Abbey Root
---

# Canonical Repository Validation

## Summary

The backlog-leverage decision found five adjacent toolkit items and treated
them as one session. Reviewing the implementation showed that adjacency was
doing too much work: a tree command, output styling, artifact reporting, and a
global test runner each establish distinct contracts across different parts of
the toolkit.

The bounded session became canonical repository validation. `abbey validate`
now checks the active Abbey project’s metadata, paths, planning structure, Git
state, and whitespace. In Abbey Root it also checks that CLI metadata,
dispatcher routes, implementations, and generated command documentation agree.

## Accomplishments

- Added and documented the metadata-driven `abbey validate` command.
- Kept external-project validation separate from Abbey Root toolkit checks.
- Added focused fixtures for valid and invalid initialized projects.
- Completed the project-validation and repository-consistency backlog items.
- Passed the focused, docs, CLI-context, init, and portability suites.

## Lessons Learned

- A useful AI recommendation still needs a human boundary check against the
  actual code architecture.
- Existing contracts should be reused directly; validation initially exposed
  the risk of defining a second `NEXT.md` schema.
- Focused regression coverage belongs with a new feature, but building a
  universal regression runner is a separate operational policy decision.

## Next Steps

- Evaluate `abbey-tree` independently.
- Inventory output and artifact-reporting behavior before standardizing it.
- Define which suites a future automated toolkit runner should include and
  how it handles optional system dependencies.
