# Fact-Locked Voice Application

Use the public voice workflow only for reviewed Facebook-writing requests that
have been promoted through the fact-lock approval process.

## Apply the Voice Model

```bash
abbey research voice apply \
  --model gpt-oss:20b \
  --fact-lock working/research/voice-analysis/fact-lock-approved.json \
  --output working/research/voice-analysis/voice-output.json \
  --report working/research/voice-analysis/voice-validation.json
```

The command confirms the lock is `approved_human_reviewed`, bound to
`VOICE-MODEL-001`, retains its review identity, and contains scenarios. It then
supplies the canonical Voice Model and approved lock to the reviewed application
prompt, writes structured JSON, and runs deterministic fact-lock validation.

Existing output and report files are protected. Use `--force` only when
replacement is intentional.

## Required Boundaries

This workflow is limited to the tested Facebook scope. It does not authorize
free generation or use in other formats.

A deterministic pass is not final approval. Run the existing semantic
verification workflow and complete human proposition review before using the
generated writing. Semantic verification remains advisory and cannot replace
human review.


## Second smoke-test finding
The second smoke test passed four of five scenarios. REQ-002 exposed a narrow serialization artifact: parsed response prose contained literal backslash-plus-quote characters, preventing the approved `marketed as "smart"` anchor from matching. The normalizer now removes only that artifact from response fields, preserves unrelated backslashes, and retains valid JSON serialization. A fresh corrected-003 smoke test was attempted without overwriting earlier diagnostics, but the configured Ollama service did not complete before timeout/interruption.


## First-real-use prompt generalization
The first real use exposed evaluation-specific prompt language: a fixed eight-scenario requirement, EVAL example IDs, and a Project Lantern-specific slot instruction. The canonical prompt now copies the supplied fact-lock and scenario IDs, preserves source order for any scenario count, and applies creative-slot rules generically. The approved lock, review chain, and deterministic validator were unchanged. Mocked regression coverage confirms a custom one-scenario lock reaches input validation, normalization, and deterministic validation.


## First-real-use typography replay
The first one-scenario generation preserved the propositions but substituted U+00A0 NO-BREAK SPACE and U+2011 NON-BREAKING HYPHEN inside protected literals. The normalizer now maps only those two characters in human-facing responses to ASCII space and hyphen-minus. A replay of the preserved failed output, written to new files without Ollama, passed deterministic validation for REQ-001 and retained the runtime model `gpt-oss:20b`; this was a deterministic replay, not fresh generation.
