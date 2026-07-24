# VOICE-MODEL-001 Evaluation Run 003

## Result

Passed through the fact-locked workflow.

Score:

```text
78 / 80
```

Run 003 used the same eight scenarios as Runs 001 and 002, but separated
immutable propositions from stylistic transformation.

## Required Gates

- Deterministic fact-lock validation: passed, 8 of 8 scenarios
- Separate semantic verification: passed, 8 of 8 scenarios
- Human proposition review: passed, 8 of 8 scenarios
- Original evaluation rubric: passed, 78 of 80

Two restraint points were deducted: one for unnecessary hashtags in EVAL-001
and one for visible quote-escape artifacts in EVAL-002. Neither was a
factual-preservation failure.

## Comparison

| Run | Workflow | Score | Factual gate |
|---|---|---:|---|
| 001 | Free generation | 71 / 80 | Failed |
| 002 | Revised free generation | 65 / 80 | Failed |
| 003 | Fact-locked generation | 78 / 80 | Passed |

## Rejected Attempts During Workflow Development

- The first guarded attempt used the creative-slot IDs in the wrong JSON
  shape.
- A corrected attempt exhausted its output budget and produced partial JSON.
- A later candidate changed `assembling` to `assembled`; human review rejected
  it after the semantic verifier missed the change.
- Another candidate described the smart bulb as `refusing`, adding device
  agency; semantic verification rejected it.

These attempts remain in the untracked working directory as diagnostic
artifacts. They were not repaired or substituted into the accepted run.

## Decision

Approve VOICE-MODEL-001 for application only through the fact-locked workflow
and only within the tested Facebook scope.

Do not approve VOICE-MODEL-001 as a free-generation prompt. The fact lock,
deterministic gate, semantic verification, and human review are part of the
accepted application method.

The semantic verifier is advisory. It previously missed a tense change, so it
cannot replace deterministic constraints or human proposition review.
