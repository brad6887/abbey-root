# VOICE-MODEL-001 Application Evaluation

## Purpose

Test whether an AI worker can apply the bounded Voice Model to new scenarios
without copying source posts, stacking every characteristic, or using the
model outside its supported scope.

This evaluates model application, not whether generated text is identical to
the author.

## Evaluation Rules

- Use only VOICE-MODEL-001.
- Do not supply Facebook corpus posts to the worker.
- Generate new language.
- Apply only characteristics relevant to each scenario.
- Preserve factual clarity and audience needs.
- Do not invent callback history.
- Return a rationale naming the applied or deliberately omitted
  characteristics.

## Scenarios

### EVAL-001: Mundane Failure

Write a Facebook-style post about a smart light bulb that requires a firmware
update before it can turn off.

Targets:

- VM-C01
- VM-C02

### EVAL-002: Comic Feature Rename

Write a Facebook-style post reacting to a weather application that sends a
rain alert after the user is already soaked.

Targets:

- VM-C02
- VM-C04

### EVAL-003: Established Callback

Context supplied to the worker:

An earlier fictional post established that Project Lantern is an attempt to
train a porch light to recognize sarcasm.

Write a later Facebook-style update in which Project Lantern reaches a new but
unhelpful milestone.

Targets:

- VM-C02
- VM-C03

### EVAL-004: No Prior Context

Write a standalone Facebook-style post about assembling a new desk.

Targets:

- VM-C02 may apply
- VM-C03 must not be applied

### EVAL-005: Ordinary Title Boundary

Write a Facebook-style post saying that the writer listened to an album named
Midnight Arithmetic.

Targets:

- Quotation marks may identify the title
- VM-C04 must not be claimed unless the wording is genuinely questioned or
  renamed

### EVAL-006: Sensitive Context

Write a brief message informing friends that a planned gathering is postponed
because a family member is ill.

Targets:

- Clarity and restraint
- Do not force VM-C01 or VM-C04
- VM-C02 may apply only if essential context remains complete

### EVAL-007: Unfamiliar Technical Audience

Write a two-sentence maintenance notice explaining that a database restart
will make an internal application unavailable for five minutes.

Targets:

- Factual clarity
- Do not apply Facebook voice characteristics merely for stylistic effect

### EVAL-008: Edit for Restraint

Edit this invented draft:

> My "smart" toaster, which is allegedly intelligent and supposedly advanced,
> has once again made toast incorrectly, which is funny because the entire
> purpose of a toaster is making toast, and I am disappointed by this outcome.

Targets:

- VM-C02
- VM-C04
- Avoid redundant explanation

## Rubric

Score each dimension from 0 to 2.

### Context Fit

- 0: Applies characteristics in an unsuitable context.
- 1: Mostly appropriate, with unnecessary styling.
- 2: Uses or withholds characteristics appropriately.

### Characteristic Fidelity

- 0: Claimed characteristic is absent or misapplied.
- 1: Partially visible but overdone or unclear.
- 2: Clearly applies the targeted characteristic.

### Restraint

- 0: Stacks characteristics or explains the effect.
- 1: Minor excess.
- 2: Stops after the intended effect or necessary information.

### Clarity

- 0: Required meaning is lost.
- 1: Meaning is recoverable with effort.
- 2: Required meaning is clear for the scenario's audience.

### Originality

- 0: Copies or closely paraphrases a corpus post.
- 1: Uses a suspiciously distinctive source construction.
- 2: Uses new language and scenario-specific details.

Maximum:

- 10 points per scenario
- 80 points total

## Passing Criteria

- At least 64 of 80 points overall
- No scenario below 6 points
- No Originality score below 2
- EVAL-006 and EVAL-007 must each score 2 for Context Fit and Clarity
- EVAL-004 must not invent prior history
- EVAL-005 must not misclassify an ordinary title as stance marking

## Status

Ready for first AI-worker application run.

