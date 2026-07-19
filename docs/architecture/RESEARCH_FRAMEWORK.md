# Research Framework

## Purpose

The Abbey Research Framework provides a repeatable process for conducting AI-assisted research.

Rather than asking an AI for a single answer, Abbey manages a structured research workflow that is reproducible, evidence-based, and self-documenting.

The framework is domain-agnostic. A research project may analyze writing style, compare AI models, evaluate software, study infrastructure designs, research hardware, or investigate any other subject.

The research process remains the same regardless of the topic.

---

# Design Principles

## Research Before Automation

Abbey does not automate an undefined process.

Every workflow should first be performed manually until the methodology is understood and validated.

Automation is introduced only after the process has proven valuable and repeatable.

---

## Evidence Over Opinion

Research conclusions must be supported by evidence.

AI-generated opinions are not considered evidence.

Every conclusion should be traceable to source material whenever possible.

---

## Reproducibility

A research experiment should be repeatable.

Running the same experiment with the same inputs should produce comparable results.

All prompts, source material, model outputs, and evaluations should be preserved.

---

## Domain Independence

The framework is not specific to any research topic.

Research projects define the domain.

The framework defines the process.

---

# Research Hierarchy

Abbey organizes research into four levels.

```
Research Project
    ↓
Experiment
    ↓
Model Runs
    ↓
Evaluation
```

---

# Research Project

A research project defines the overall objective.

Examples include:

- Voice Analysis
- AI Model Comparison
- Linux Distribution Evaluation
- Network Switch Research
- Backup Software Evaluation

A project contains one or more experiments.

A project defines:

- research objective
- source material
- methodology
- documentation
- experiments

---

# Experiment

An experiment answers one specific research question.

Examples:

- Are observations 003, 004, 007, and 014 independent?
- Which local model produces the best evidence summaries?
- Can AI discover additional writing observations?
- Which network switch best satisfies a defined set of requirements?

Each experiment should be narrowly scoped.

Large research goals should be decomposed into multiple experiments.

---

# Inputs

Every experiment should explicitly define its inputs.

Possible inputs include:

- documents
- source corpus
- evidence files
- prompts
- configuration
- evaluation rubric

Nothing should be implied.

---

# Prompt

Every experiment uses a versioned prompt.

Prompt changes create a new experiment revision.

This ensures results remain reproducible.

---

# Model Runs

Each model receives identical inputs unless the experiment specifically tests prompt variation.

Every model run should preserve:

- model name
- model version
- prompt
- timestamp
- output

Raw output should never be modified.

---

# Evaluation

Evaluation compares model outputs rather than replacing them.

Evaluation criteria may include:

- instruction following
- evidence quality
- reasoning
- hallucinations
- novelty
- usefulness

Evaluation should be documented separately from model output.

---

# Artifacts

Every experiment produces artifacts.

Typical artifacts include:

- experiment definition
- prompt
- model outputs
- comparison
- conclusions

Artifacts should be preserved even when the experiment fails.

Failed experiments often provide valuable information.

---

# Human Role

Abbey assists research.

Humans remain responsible for:

- defining research questions
- validating evidence
- interpreting results
- deciding conclusions

AI supports research but does not replace human judgment.

---
# Research Quality

Every Abbey research project should strive to maximize:

## Reproducibility

Another person should be able to repeat the experiment.

## Transparency

Every conclusion should be traceable to evidence.

## Independence

Experiments should answer one question at a time.

## Incremental Progress

Each experiment should build upon previous work.

## Preservation

Nothing should be discarded.
Failed experiments remain valuable.

## Evolution

Research is expected to change.
Experiments may invalidate previous assumptions.
The framework encourages refinement rather than permanence.

# Future Direction

Future Abbey commands may automate portions of the research workflow.

Examples include:

- abbey research start
- abbey research run
- abbey research compare
- abbey research conclude

Automation should always preserve transparency and reproducibility.

The framework should remain understandable even when individual AI models are replaced.
