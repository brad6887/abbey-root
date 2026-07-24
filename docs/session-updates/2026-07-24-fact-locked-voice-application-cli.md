---
title: Fact-Locked Voice Application CLI
date: 2026-07-24
session: fact-locked-voice-application-cli
status: complete
reviewed: false
type: session-update
tags:
  - abbey-root
  - research
  - voice-analysis
  - fact-lock
  - cli
---

# Fact-Locked Voice Application CLI

## Objective
Build the first usable public VOICE-MODEL-001 application command within the tested Facebook scope.

## Completed
- Added `abbey research voice apply` dispatch.
- Require and validate an approved human-reviewed fact lock before application.
- Route generation through the canonical application prompt and existing Ollama runner.
- Run deterministic fact-locked output validation and write a report.
- Added CLI metadata and preserved overwrite protection.

## Validation
- `bash -n tools/bin/abbey-research` passed.
- Full Ollama-backed application was not run because it requires the configured model service.

## Follow-up
Add dedicated mocked-run regression coverage before broadening beyond Facebook fact locks.


## Smoke-test correction
The first real smoke test correctly failed deterministic validation: three responses used propositionally related wording but omitted required lexical anchors, and the model returned fenced JSON with the model field set to `VOICE-MODEL-001`. The workflow now explicitly instructs required-anchor coverage, normalizes fenced JSON to standalone JSON, and overwrites the model metadata with the invoked runtime model. The original failed smoke-test output and report remain preserved as diagnostic evidence. A corrected Ollama smoke test was attempted with new filenames but the configured service did not complete before the run was interrupted; no candidate regeneration or fact-lock changes were made.


## Second smoke-test finding
The second smoke test passed four of five scenarios. REQ-002 exposed a narrow serialization artifact: parsed response prose contained literal backslash-plus-quote characters, preventing the approved `marketed as "smart"` anchor from matching. The normalizer now removes only that artifact from response fields, preserves unrelated backslashes, and retains valid JSON serialization. A fresh corrected-003 smoke test was attempted without overwriting earlier diagnostics, but the configured Ollama service did not complete before timeout/interruption.

## Deterministic corrected-002 replay
Replayed the preserved corrected-002 output through the voice normalizer into `corrected-002-replay-output.json`, supplying runtime metadata `gpt-oss:20b`, without invoking Ollama. The replay is standalone valid JSON, REQ-002 parses as `marketed as "smart"` without visible backslashes, and deterministic validation against `VOICE-FACT-LOCK-002` passed all five scenarios. This is a normalization replay, not a fresh generation run.
