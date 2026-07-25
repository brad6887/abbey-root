---
title: Fact-Locked Voice Application CLI
date: 2026-07-24
session: fact-locked-voice-application-cli
status: complete
reviewed: true
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


## First-real-use prompt generalization
The first real use exposed evaluation-specific prompt language: a fixed eight-scenario requirement, EVAL example IDs, and a Project Lantern-specific slot instruction. The canonical prompt now copies the supplied fact-lock and scenario IDs, preserves source order for any scenario count, and applies creative-slot rules generically. The approved lock, review chain, and deterministic validator were unchanged. Mocked regression coverage confirms a custom one-scenario lock reaches input validation, normalization, and deterministic validation.


## First-real-use typography replay
The first one-scenario generation preserved the propositions but substituted U+00A0 NO-BREAK SPACE and U+2011 NON-BREAKING HYPHEN inside protected literals. The normalizer now maps only those two characters in human-facing responses to ASCII space and hyphen-minus. A replay of the preserved failed output, written to new files without Ollama, passed deterministic validation for REQ-001 and retained the runtime model `gpt-oss:20b`; this was a deterministic replay, not fresh generation.


## Human review of first real voice application
Brad reviewed the normalized first-real-use candidate and the supporting diagnostic artifacts.

- Factual preservation: pass.
- Deterministic validation: pass.
- Voice resemblance: partial; Brad rated the resemblance “somewhat” and would not use the candidate unchanged.
- Publication readiness: reject.
- The post repeats “Abbey Root” twice in a very short space.
- The wording is too formal, too plain, and lacks distinctive voice.
- The duplicate name is partly caused by independently enforced F001 and F003 anchors, both of which require “Abbey Root.”

The approved fact lock is not weakened or retroactively altered. With only four validated voice observations, this limitation is expected. The public fact-locked application workflow is operational, while VOICE-MODEL-001 remains an early bounded model requiring more voice evidence and evaluation. The generated candidate and all diagnostic artifacts are preserved; no replacement candidate was generated.
