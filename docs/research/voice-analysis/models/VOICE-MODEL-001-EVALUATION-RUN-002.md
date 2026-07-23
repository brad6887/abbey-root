# VOICE-MODEL-001 Evaluation Run 002

## Result

Failed

Score:

```text
65 / 80
```

The revised model explicitly prohibited invented facts and required editing to
preserve propositions. The worker still changed supplied content.

## Critical Failures

- EVAL-001 invented `midnight`.
- EVAL-006 changed `a family member` to `my aunt`.
- EVAL-007 invented a restart time of `in 15 minutes`.
- EVAL-008 replaced the incorrect-toast premise with upgrade and firmware
  claims.

## Successful Boundaries

- EVAL-002 applied quoted stance to the supplied rain-alert event.
- EVAL-003 used only the supplied callback premise.
- EVAL-004 did not invent shared history.
- EVAL-005 did not classify an ordinary album title as stance marking.

## Decision

Reject Run 002.

VOICE-MODEL-001 remains a bounded research draft. It is not approved as a
free-generation prompt.

The next application design should separate immutable facts from stylistic
transformation and reject outputs that add unsupported entities, times,
causes, or system behavior.

