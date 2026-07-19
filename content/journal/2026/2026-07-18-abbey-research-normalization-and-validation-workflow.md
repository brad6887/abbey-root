---
title: "abbey-research-normalization-and-validation-workflow"
description: "Implemented the first complete Abbey Research workflow from raw model output through normalization, validation, and human review."
date: 2026-07-18
draft: false
tags:
  - Abbey Root
  - AI
  - Research
  - Workflow
---

# Abbey Research Normalization and Validation Workflow

## Summary

Today the Abbey Research workflow moved beyond simply asking an LLM a question. The framework now supports the complete path from raw model output through normalization, deterministic validation, and finally human review.

Rather than designing additional architecture documents, the workflow was implemented as a practical vertical slice and exercised using an existing smoke-test research artifact.

## Accomplishments

- Added `abbey research normalize`.
- Added `abbey research validate`.
- Preserved raw research artifacts as immutable evidence.
- Implemented canonical research normalization.
- Added deterministic structural validation.
- Expanded regression coverage to seventeen passing tests.
- Executed the complete workflow successfully using a real research artifact.

## Lessons Learned

Running the workflow against a real artifact immediately exposed behavior that design discussions alone would not have revealed.

The first normalization passed structural validation but introduced unsupported conclusions. Human review identified the issue, leading to improvements in the normalization instructions that significantly reduced speculation while preserving the original research findings.

This reinforced the intended architecture:

- deterministic validation verifies the contract
- human review evaluates research quality

Each stage has a distinct responsibility.

## Next Steps

The workflow is now mature enough to begin real research sessions rather than additional framework design.

Future improvements should come from practical usage instead of speculative architecture.
