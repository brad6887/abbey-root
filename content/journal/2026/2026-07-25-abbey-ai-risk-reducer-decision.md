---
title: "Abbey AI Risk-Reducer Decision"
description: "Added an evidence-backed AI decision strategy for choosing bounded work that materially reduces project risk."
date: 2026-07-25
draft: false
tags:
  - Abbey Root
  - AI
  - Developer Toolkit
  - Planning
---

# Abbey AI Risk-Reducer Decision

## Summary

Added `abbey ai decide risk-reducer`, a metadata-driven strategy for finding
the smallest practical, one-session change that materially reduces an
operational or workflow risk.

The strategy requires a documented failure mode, durable risk reduction,
residual risk, backlog impact, evidence, and explicit repository review before
implementation.

## Accomplishments

- Added the `risk-reducer` decision metadata, prompt, and result schema.
- Required bounded one-session recommendations rather than broad hardening
  projects.
- Separated recommendation confidence from implementation confidence.
- Capped implementation confidence because planning documents do not reveal
  the repository architecture.
- Added repository-review requirements to the structured result.
- Extended the shared terminal reporter for the new risk fields.
- Added focused metadata-discovery and decision-contract regression coverage.
- Validated the strategy with the configured local model.

## Lessons Learned

The first model run chose a sensible risk reducer but was much too confident
about an implementation it had not inspected. A tighter prompt and schema made
that uncertainty visible in the second run: recommendation confidence remained
high while implementation confidence fell to 40 percent.

The local model still slipped in one unsupported source-file claim. Good
prompts can discourage implementation role-play, but they do not turn semantic
judgment into deterministic validation.

## Next Steps

- Evaluate additional recommendations through practical use.
- Consider shared semantic response review if unsupported implementation
  claims remain common across decision strategies.
