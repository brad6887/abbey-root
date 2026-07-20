---
title: "Research Framework and Ollama Runner"
description: "Built a reusable Abbey research workflow that runs structured analysis through Ollama and validates preserved research artifacts."
date: 2026-07-18
status: complete
reviewed: false
session: primary
tags:
  - Abbey Root
  - AI Research
  - Ollama
  - Developer Toolkit
---

# Research Framework and Ollama Runner

## Status

Pending Review

## Objective

Build a reusable, domain-independent Abbey research workflow that combines structured prompts and source documents, runs analysis through Ollama, preserves raw model output, and validates generated research artifacts.

## Definition of Done

- A reusable `abbey research run` command accepts a model, prompt, inputs, and output path.
- Ollama requests support sufficient context and output limits for substantial research tasks.
- Raw model responses are preserved without silently rewriting their analysis.
- Generated observations can be validated for structure, citations, provenance, and prohibited language.
- Research architecture and methodology are documented independently of the initial voice-analysis use case.
- Experiment 001 captures its prompt, inputs, result, and lessons.
- Temporary transfer documents are migrated to canonical research locations.
- Generated working research artifacts are excluded from Git.
- Syntax checks, regression tests, and repository validation pass.

## Accomplishments

- Added `abbey research run` and registered it with the Abbey command dispatcher.
- Implemented prompt and input validation, overwrite protection, Ollama request handling, and raw Markdown output.
- Added explicit Ollama context and generation limits to prevent premature truncation.
- Added runtime, prompt-token, and output-token reporting.
- Added a nine-test regression suite for the research command.
- Added an observation validator that checks required headings, source identifiers, corpus provenance, and prohibited language.
- Documented the reusable research framework and methodology.
- Captured the first voice-analysis experiment, including its prompt, inputs, raw model result, and lessons learned.
- Established the research pipeline:

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

- Clarified that the model owns analysis while Abbey owns preservation, normalization, validation, provenance, and workflow.
- Migrated tracked evidence documents from `working/transfer/` into canonical `docs/research/` locations.
- Corrected the misspelled `narative` observation filename.
- Removed generated or mismatched evidence documents that did not align with the established observation sequence.
- Added stable Facebook source identifiers as evidence headings.
- Ignored generated research inputs and model outputs under `working/research/`.
- Added repository ignore rules for Python bytecode and cache directories.

## Validation

The following validation completed successfully:

    bash -n tools/bin/abbey
    bash -n tools/bin/abbey-research
    bash -n tests/test-abbey-research.sh
    python3 -m py_compile tools/research/validate_observation.py
    tests/test-abbey-research.sh
    tests/test-abbey-ai.sh
    tests/test-abbey-next.sh
    tests/test-abbey-session-update.sh
    abbey research --help
    abbey research run --help
    git diff --cached --check
    abbey doctor
    abbey review

Results:

- Abbey Research tests: 9 passed, 0 failed
- Abbey AI tests: 22 passed, 0 failed
- Abbey Next tests: 16 passed, 0 failed
- Abbey Session Update tests: 18 passed, 0 failed
- Abbey Doctor: 23 OK, 3 expected host-specific warnings, 0 failures
- No duplicate evidence identifiers remain.
- All migrated transfer evidence has a canonical destination.
- No staged whitespace errors remain.

## Impact

Abbey now has the beginning of a general research platform rather than a voice-analysis-specific script.

The same runner and workflow can support future research involving:

- software evaluation
- AI model comparison
- product research
- writing analysis
- infrastructure decisions
- other document-grounded investigations

The first experiment also demonstrated an important framework boundary: formatting defects should be handled through deterministic normalization and validation rather than increasingly complicated prompt instructions.

## Lessons Learned

- Large research prompts require explicit Ollama context and output-token settings.
- A syntactically valid model response can still contain unsupported citations or structurally incorrect output.
- Prompt engineering alone is not a reliable formatting layer.
- Raw model output should remain immutable as experimental evidence.
- Deterministic cleanup belongs after generation, not inside the analytical prompt.
- Numbered evidence documents must be checked against their corresponding observations before becoming canonical.
- Git similarity-based rename detection can misidentify template-heavy research documents, so migrations should be reviewed using `--no-renames`.
- Temporary repository locations can become accidental sources of truth unless canonical ownership is made explicit.
- Plausible model-generated evidence should not become canonical until its numbering, subject, and actual support for the observation have been reviewed.

## Next Steps

- Design and implement a deterministic research Markdown normalizer.
- Define which normalization operations are universally safe.
- Add regression tests proving normalization does not change semantic content.
- Decide how `abbey research` should orchestrate generation, normalization, and validation without coupling the runner to voice analysis.
- Run the normalized Experiment 001 artifact through the validator.
- Review whether the observation validator should evolve into a configurable validation framework.
