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
