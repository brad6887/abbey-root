---
title: "Research Framework and Ollama Runner"
description: "Built a reusable Ollama-backed research runner and established Abbey's raw-output, normalization, validation, and review architecture."
date: 2026-07-18
draft: false
tags:
  - Abbey Root
  - AI
  - Research
  - Ollama
  - Voice Analysis
---

# Research Framework and Ollama Runner

## Summary

What looked like a small voice-analysis side quest turned into the beginning of a reusable research platform.

Abbey can now combine a research prompt with one or more input documents, send the complete package to an Ollama model, preserve the raw Markdown response, and report useful runtime and token information.

The larger result was architectural rather than model-specific. The experiment established that the model should be responsible for analysis, while Abbey should be responsible for preservation, normalization, validation, provenance, and workflow.

## Accomplishments

- Added the `abbey research run` command.
- Added support for multiple research inputs.
- Added prompt and input validation.
- Added output overwrite protection.
- Added explicit Ollama context and output-token limits.
- Added runtime and token reporting.
- Added regression coverage for the research runner.
- Added a validator for observation headings, citations, provenance, and prohibited claims.
- Documented the general research framework and methodology.
- Captured Experiment 001 with its prompt, inputs, raw model result, and lessons.
- Migrated evidence documents from a temporary transfer directory into canonical research locations.
- Corrected the recurring narrative filename.
- Removed generated evidence that did not correspond to the established observation sequence.
- Confirmed that all remaining evidence numbers are unique and aligned.
- Ignored generated research working files and Python bytecode.

## Research Workflow

The experiment established the following pipeline:

```text
Prompt and inputs
        ↓
LLM analysis
        ↓
Raw artifact
        ↓
Normalization
        ↓
Validation
        ↓
Human review
```

The model owns interpretation and analysis.

Abbey owns preservation, normalization, validation, provenance, and workflow.

## Lessons Learned

The main lesson was that formatting is not an AI responsibility.

The first model output contained useful observations but also Unicode punctuation, malformed headings, and an unsupported citation. Tightening the prompt improved some behavior but eventually produced truncation and still did not guarantee valid structure.

Raw model output should remain unchanged as experimental evidence. Deterministic cleanup belongs after generation rather than inside increasingly complicated prompt instructions.

Another useful lesson came from Git. Evidence documents share enough structure that similarity-based rename detection can confidently report the wrong source and destination. Reviewing migrations with `--no-renames` exposed what was actually happening.

Plausible evidence is also not necessarily valid evidence. Several generated files sounded reasonable but did not match the established observation numbering. One claimed example did not actually demonstrate the stylistic feature it was meant to support. Those files were removed instead of being promoted merely because they looked finished.

Temporary directories can also become accidental sources of truth. Moving the research material into canonical locations clarified which documents Abbey should preserve and maintain.

## Validation

The following validation completed successfully:

```text
Abbey Research:        9 passed, 0 failed
Abbey AI:             22 passed, 0 failed
Abbey Next:           16 passed, 0 failed
Abbey Session Update: 18 passed, 0 failed
Abbey Doctor:         23 OK, 3 warnings, 0 failures
```

The doctor warnings were expected host-specific backup checks on `ubuntu-dev01`.

Additional validation confirmed:

- Shell syntax is valid.
- Python syntax is valid.
- Research command help works through both command paths.
- No duplicate evidence identifiers remain.
- Every removed transfer evidence file has a canonical replacement.
- No staged whitespace errors remain.
- No unstaged or untracked files remain after capture.

## Impact

Abbey now has the beginning of a general research platform rather than a voice-analysis-specific script.

The same runner and workflow can support future research involving:

- software evaluation
- AI model comparison
- product research
- writing analysis
- infrastructure decisions
- other document-grounded investigations

The voice-analysis experiment remains the first use case, but it no longer defines the architecture.

## Next Steps

- Design and implement a deterministic research Markdown normalizer.
- Define which normalization operations are universally safe.
- Add regression tests proving normalization does not change semantic content.
- Decide how `abbey research` should orchestrate generation, normalization, and validation without coupling the runner to voice analysis.
- Run the normalized Experiment 001 artifact through the validator.
- Review whether the observation validator should evolve into a configurable validation framework.
