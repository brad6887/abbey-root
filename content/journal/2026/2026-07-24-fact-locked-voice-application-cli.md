---
title: Fact-Locked Voice Application CLI
date: 2026-07-24
---

Abbey Root now has the first public entry point for applying VOICE-MODEL-001: `abbey research voice apply`. The command refuses unapproved inputs, uses the canonical fact-locked application prompt, and gates its structured output through deterministic validation.

The workflow remains deliberately narrow: it is limited to the reviewed Facebook scope, and semantic verification and human review remain required after deterministic validation.


## Smoke-test correction
The first real smoke test correctly failed deterministic validation: three responses used propositionally related wording but omitted required lexical anchors, and the model returned fenced JSON with the model field set to `VOICE-MODEL-001`. The workflow now explicitly instructs required-anchor coverage, normalizes fenced JSON to standalone JSON, and overwrites the model metadata with the invoked runtime model. The original failed smoke-test output and report remain preserved as diagnostic evidence. A corrected Ollama smoke test was attempted with new filenames but the configured service did not complete before the run was interrupted; no candidate regeneration or fact-lock changes were made.


## Second smoke-test finding
The second smoke test passed four of five scenarios. REQ-002 exposed a narrow serialization artifact: parsed response prose contained literal backslash-plus-quote characters, preventing the approved `marketed as "smart"` anchor from matching. The normalizer now removes only that artifact from response fields, preserves unrelated backslashes, and retains valid JSON serialization. A fresh corrected-003 smoke test was attempted without overwriting earlier diagnostics, but the configured Ollama service did not complete before timeout/interruption.

## Deterministic replay validation
The preserved corrected-002 smoke output was replayed through normalization without invoking Ollama. A new replay artifact recorded `gpt-oss:20b`, removed only the visible quote-escape artifact, and passed deterministic validation for all five scenarios. This confirms the correction independently of fresh generation.
