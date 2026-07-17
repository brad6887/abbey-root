---
title: "Abbey Next Learns From Recent Sessions"

description: "Added a deterministic freshness layer so abbey next can distinguish authoritative plans from work that was recently completed or discovered."

date: 2026-07-17

draft: false

tags:

  - Abbey Root

  - Recommendation Engine

  - Developer Toolkit

  - Workflow

---

# Abbey Next Learns From Recent Sessions

## Summary

Extended `abbey next` so it can use unreconciled session updates as recent project evidence without allowing them to replace the authority of Abbey’s planning documents.

## Accomplishments

- Added parsing of session updates marked `reviewed: false`.

- Normalized completed statuses including `complete` and `completed`.

- Suppressed backlog work already completed in recent sessions.

- Used explicit Next Steps to strengthen existing backlog candidates.

- Added visible planning-conflict reporting.

- Tightened matching to prevent generic planning language from influencing recommendations.

- Expanded regression coverage from 10 tests to 16 passing tests.

- Validated the behavior against the live Abbey Root repository.

## Lessons Learned

Planning documents and session updates serve different purposes.

Planning documents define official direction and valid work. Session updates provide fresher evidence about what has already happened and what follow-up work was discovered.

The best recommendation model uses both while keeping their authority clearly separated.

Text matching also needs to become stricter as evidence becomes less structured. Curated planning language can support broader matching, while free-form session prose requires stronger coverage before it should affect a recommendation.

## Next Steps

- Reconcile the backlog conflict identified by `abbey next`.

- Catch up on unreconciled session updates.

- Generate recommendation-specific Definitions of Done.

- Continue refining the Recommendation Engine through practical use.

