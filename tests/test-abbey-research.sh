#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOL="$ROOT/tools/bin/abbey-research"

passed=0
failed=0

pass() {
  printf 'PASS %s\n' "$1"
  passed=$((passed + 1))
}

fail() {
  printf 'FAIL %s\n' "$1"
  failed=$((failed + 1))
}

assert_status() {
  local name="$1"
  local actual="$2"
  local expected="$3"

  if [[ "$actual" -eq "$expected" ]]; then
    pass "$name"
  else
    fail "$name"
    printf '     Expected status: %s\n' "$expected"
    printf '     Actual status:   %s\n' "$actual"
  fi
}

assert_contains() {
  local name="$1"
  local output="$2"
  local expected="$3"

  if grep -Fq -- "$expected" <<<"$output"; then
    pass "$name"
  else
    fail "$name"
    printf '     Expected: %s\n' "$expected"
  fi
}

printf 'Abbey Research Regression Tests\n'
printf '===============================\n\n'

if bash -n "$TOOL"; then
  pass "tool syntax"
else
  fail "tool syntax"
fi

set +e
output="$("$TOOL" --help 2>&1)"
status=$?
set -e

assert_status \
  "--help exits successfully" \
  "$status" \
  0

assert_contains \
  "--help shows run usage" \
  "$output" \
  "abbey research run"

assert_contains \
  "--help shows generation budget option" \
  "$output" \
  "--max-tokens N"

assert_contains \
  "--help shows status usage" \
  "$output" \
  "abbey research status"

assert_contains \
  "--help shows review validation usage" \
  "$output" \
  "abbey research validate-review"

assert_contains \
  "--help shows discovery validation usage" \
  "$output" \
  "abbey research validate-discovery"

assert_contains \
  "--help shows discovery workflow usage" \
  "$output" \
  "abbey research discover"

set +e
output="$("$TOOL" status 2>&1)"
status=$?
set -e

assert_status \
  "status exits successfully for repository artifacts" \
  "$status" \
  0

assert_contains \
  "status reports Voice Analysis project" \
  "$output" \
  "OK   voice-analysis"

assert_contains \
  "status reports formal artifact count" \
  "$output" \
  "Formal artifacts:     18"

assert_contains \
  "status reports first complete chain" \
  "$output" \
  "OBS-001 → EVID-001 → HYP-001 → VAL-001"

assert_contains \
  "status reports second complete chain" \
  "$output" \
  "OBS-002 → EVID-002 → HYP-002 → VAL-002"

assert_contains \
  "status reports third complete chain" \
  "$output" \
  "OBS-003 → EVID-003 → HYP-003 → VAL-003"

assert_contains \
  "status reports fourth complete chain" \
  "$output" \
  "OBS-004 → EVID-004 → HYP-004 → VAL-004"

assert_contains \
  "status reports four complete chains" \
  "$output" \
  "Complete chains:      4"

assert_contains \
  "status reports no incomplete chains" \
  "$output" \
  "Incomplete chains:    0"

assert_contains \
  "status reports legacy provenance" \
  "$output" \
  "INFO OBS-001 → OBSERVATION004-deadpan-delivery"

set +e
output="$(
  python3 "$ROOT/tools/research/validate_voice_model.py" \
    --model \
      "$ROOT/docs/research/voice-analysis/models/VOICE-MODEL-001.json" \
    --evaluation \
      "$ROOT/docs/research/voice-analysis/models/VOICE-MODEL-001-EVALUATION.json" \
    --run \
      "$ROOT/docs/research/voice-analysis/models/VOICE-MODEL-001-EVALUATION-RUN-001.json" \
    --run \
      "$ROOT/docs/research/voice-analysis/models/VOICE-MODEL-001-EVALUATION-RUN-002.json" \
    --run \
      "$ROOT/docs/research/voice-analysis/models/VOICE-MODEL-001-EVALUATION-RUN-003.json" \
    2>&1
)"
status=$?
set -e

assert_status \
  "Voice Model validation exits successfully" \
  "$status" \
  0

assert_contains \
  "Voice Model validation reports PASS" \
  "$output" \
  "Result: PASS"

set +e
output="$(
  python3 "$ROOT/tools/research/validate_fact_locked_voice_output.py" \
    --spec \
      "$ROOT/docs/research/voice-analysis/models/VOICE-MODEL-001-FACT-LOCK.json" \
    --output \
      "$ROOT/docs/research/voice-analysis/models/VOICE-MODEL-001-EVALUATION-RUN-003.json" \
    2>&1
)"
status=$?
set -e

assert_status \
  "fact-locked Voice Model output validation exits successfully" \
  "$status" \
  0

assert_contains \
  "fact-locked Voice Model output validation reports PASS" \
  "$output" \
  "Result: PASS"

set +e
output="$(
  python3 "$ROOT/tools/research/validate_fact_locked_voice_verification.py" \
    --spec \
      "$ROOT/docs/research/voice-analysis/models/VOICE-MODEL-001-FACT-LOCK.json" \
    --verification \
      "$ROOT/docs/research/voice-analysis/models/VOICE-MODEL-001-EVALUATION-RUN-003-VERIFICATION.json" \
    2>&1
)"
status=$?
set -e

assert_status \
  "fact-lock semantic verification validation exits successfully" \
  "$status" \
  0

assert_contains \
  "fact-lock semantic verification validation reports VALID" \
  "$output" \
  "Result: VALID"

set +e
output="$(
  python3 "$ROOT/tools/research/validate_voice_fact_lock_proposal.py" \
    --suite \
      "$ROOT/docs/research/voice-analysis/evaluations/VOICE-FACT-EXTRACTION-EVAL-001.json" \
    --proposal \
      "$ROOT/docs/research/voice-analysis/models/VOICE-FACT-LOCK-PROPOSAL-001-REVISION-009.json" \
    2>&1
)"
status=$?
set -e

assert_status \
  "voice fact-lock proposal validation exits successfully" \
  "$status" \
  0

assert_contains \
  "voice fact-lock proposal validation reports PASS" \
  "$output" \
  "Result: PASS"

set +e
output="$(
  python3 "$ROOT/tools/research/validate_fact_locked_voice_output.py" \
    --spec \
      "$ROOT/docs/research/voice-analysis/models/VOICE-FACT-LOCK-002.json" \
    --output \
      "$ROOT/docs/research/voice-analysis/evaluations/VOICE-FACT-EXTRACTION-EVAL-001-RUN-001.json" \
    2>&1
)"
status=$?
set -e

assert_status \
  "extracted fact-lock generation validation exits successfully" \
  "$status" \
  0

assert_contains \
  "extracted fact-lock generation reports PASS" \
  "$output" \
  "Result: PASS"

set +e
output="$(
  python3 "$ROOT/tools/research/validate_fact_locked_voice_verification.py" \
    --spec \
      "$ROOT/docs/research/voice-analysis/models/VOICE-FACT-LOCK-002.json" \
    --verification \
      "$ROOT/docs/research/voice-analysis/evaluations/VOICE-FACT-EXTRACTION-EVAL-001-RUN-001-VERIFICATION.json" \
    2>&1
)"
status=$?
set -e

assert_status \
  "extracted fact-lock semantic verification exits successfully" \
  "$status" \
  0

assert_contains \
  "extracted fact-lock semantic verification reports VALID" \
  "$output" \
  "Result: VALID"

set +e
output="$("$TOOL" run 2>&1)"
status=$?
set -e

assert_status \
  "missing model exits with error" \
  "$status" \
  1

assert_contains \
  "missing model reports required option" \
  "$output" \
  "Missing required option: --model"

set +e
output="$("$TOOL" run --max-tokens nope 2>&1)"
status=$?
set -e

assert_status \
  "invalid generation budget exits with error" \
  "$status" \
  1

assert_contains \
  "invalid generation budget is reported" \
  "$output" \
  "Option --max-tokens requires a positive integer."

set +e
output="$("$TOOL" validate-review 2>&1)"
status=$?
set -e

assert_status \
  "missing review manifest exits with error" \
  "$status" \
  1

assert_contains \
  "missing review manifest is reported" \
  "$output" \
  "Missing required option: --manifest"

set +e
output="$("$TOOL" validate-discovery 2>&1)"
status=$?
set -e

assert_status \
  "missing discovery manifest exits with error" \
  "$status" \
  1

assert_contains \
  "missing discovery manifest is reported" \
  "$output" \
  "Missing required option: --manifest"

set +e
output="$(
  "$TOOL" run \
    --model test-model \
    --prompt /missing/prompt.md \
    --output /tmp/abbey-research-result.md \
    2>&1
)"
status=$?
set -e

assert_status \
  "missing prompt file exits with error" \
  "$status" \
  1

assert_contains \
  "missing prompt file is reported" \
  "$output" \
  "Prompt file not found:"

fixture_root="$(mktemp -d)"
trap 'rm -rf "$fixture_root"' EXIT

mkdir -p \
  "$fixture_root/tools/bin" \
  "$fixture_root/tools/lib" \
  "$fixture_root/tools/research" \
  "$fixture_root/scripts" \
  "$fixture_root/config" \
  "$fixture_root/working"

set +e
output="$(
  python3 "$ROOT/tools/research/approve_voice_fact_lock.py" \
    --proposal \
      "$ROOT/docs/research/voice-analysis/models/VOICE-FACT-LOCK-PROPOSAL-001-REVISION-009.json" \
    --review \
      "$ROOT/docs/research/voice-analysis/reviews/VOICE-FACT-LOCK-PROPOSAL-001-REVIEW-008.json" \
    --output \
      "$fixture_root/working/approved-fact-lock.json" \
    2>&1
)"
status=$?
set -e

assert_status \
  "voice fact-lock approval promotion exits successfully" \
  "$status" \
  0

assert_contains \
  "voice fact-lock approval promotion reports PASS" \
  "$output" \
  "Result: PASS"

cp "$TOOL" \
  "$fixture_root/tools/bin/abbey-research"

cp "$ROOT/tools/lib/config.sh" \
  "$fixture_root/tools/lib/config.sh"

cp "$ROOT/scripts/abbey_research_status.py" \
  "$fixture_root/scripts/abbey_research_status.py"

cp "$ROOT/tools/research/validate_discovery_manifest.py" \
  "$fixture_root/tools/research/validate_discovery_manifest.py"

cp "$ROOT/tools/research/run_observation_discovery.py" \
  "$fixture_root/tools/research/run_observation_discovery.py"

cp "$ROOT/tools/research/build_quoted_language_candidates.py" \
  "$fixture_root/tools/research/build_quoted_language_candidates.py"

cp "$ROOT/tools/research/normalize_quoted_language_classification.py" \
  "$fixture_root/tools/research/normalize_quoted_language_classification.py"

cp "$ROOT/tools/research/build_quoted_language_review_manifest.py" \
  "$fixture_root/tools/research/build_quoted_language_review_manifest.py"

cp "$ROOT/tools/research/calculate_quoted_language_validation.py" \
  "$fixture_root/tools/research/calculate_quoted_language_validation.py"

cat > "$fixture_root/config/abbey.conf" <<'CONFIG'
OLLAMA_URL="http://localhost:11434"
CONFIG

printf '# Prompt\n' \
  > "$fixture_root/working/prompt.md"

printf '# Existing result\n' \
  > "$fixture_root/working/result.md"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-research" run \
    --model test-model \
    --prompt "$fixture_root/working/prompt.md" \
    --output "$fixture_root/working/result.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "existing output exits with error" \
  "$status" \
  1

assert_contains \
  "existing output reports overwrite protection" \
  "$output" \
  "Use --force to replace it."


cat > "$fixture_root/working/valid-normalized.md" <<'MARKDOWN'
# Research Result

## Summary

A recurring humorous writing structure was identified.

## Observations

Each post begins with a mundane statement followed by an exaggerated comment.

## Evidence

Three supplied posts use the same two-clause structure.

## Conclusions

The pattern appears intentional and recurring.

## Limitations

The sample contains only three posts.

## Open Questions

Whether the pattern appears consistently in a larger corpus remains unknown.
MARKDOWN

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-research" validate \
    --input "$fixture_root/working/valid-normalized.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "valid normalized artifact passes validation" \
  "$status" \
  0

assert_contains \
  "valid normalized artifact reports PASS" \
  "$output" \
  "Result: PASS"

cat > "$fixture_root/working/missing-section.md" <<'MARKDOWN'
# Research Result

## Summary

Summary text.

## Observations

Observation text.

## Evidence

Evidence text.

## Conclusions

Conclusion text.

## Limitations

Limitation text.
MARKDOWN

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-research" validate \
    --input "$fixture_root/working/missing-section.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "missing section fails validation" \
  "$status" \
  1

assert_contains \
  "missing section is reported" \
  "$output" \
  "Missing required section: ## Open Questions"

cat > "$fixture_root/working/empty-section.md" <<'MARKDOWN'
# Research Result

## Summary

Summary text.

## Observations

Observation text.

## Evidence

## Conclusions

Conclusion text.

## Limitations

Limitation text.

## Open Questions

Question text.
MARKDOWN

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-research" validate \
    --input "$fixture_root/working/empty-section.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "empty section fails validation" \
  "$status" \
  1

assert_contains \
  "empty section is reported" \
  "$output" \
  "Section is empty: ## Evidence"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-research" normalize \
    --model test-model \
    --input "$fixture_root/working/valid-normalized.md" \
    --output "$fixture_root/working/result.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "normalize protects existing output" \
  "$status" \
  1

assert_contains \
  "normalize reports overwrite protection" \
  "$output" \
  "Use --force to replace it."

mkdir -p \
  "$fixture_root/working/discovery/batches" \
  "$fixture_root/working/discovery/output/results"

cat > "$fixture_root/working/discovery/corpus.csv" <<'CSV'
source_id,datetime,year,status,content_type,post_type,word_count,text
1,2020-01-01T00:00:00,2020,clean,authored_text,short_post,1,Alpha
2,2020-01-02T00:00:00,2020,clean,authored_text,short_post,1,Beta
CSV

cat > "$fixture_root/working/discovery/batches/batch-001.md" <<'MARKDOWN'
# Voice-Eligible Chronological Batch

1. [FB-000001] 2020-01-01T00:00:00

Alpha

2. [FB-000002] 2020-01-02T00:00:00

Beta
MARKDOWN

cat > "$fixture_root/working/discovery/batches/manifest.json" <<'JSON'
{
  "batches": [
    {
      "batch": 1,
      "path": "batch-001.md"
    }
  ]
}
JSON

printf '# Test prompt\n' \
  > "$fixture_root/working/discovery/prompt.md"

corpus_hash="$(
  sha256sum "$fixture_root/working/discovery/corpus.csv" \
    | awk '{print $1}'
)"

cat > \
  "$fixture_root/working/discovery/output/results/batch-001.json" <<JSON
{
  "schema_version": 1,
  "batch_id": "batch-001",
  "status": "candidate_discovery_human_review_required",
  "corpus": {
    "artifact_id": "test-corpus",
    "sha256": "$corpus_hash"
  },
  "model": "test-model",
  "prompt": "test-prompt",
  "candidates": [
    {
      "candidate_id": "B001-C01",
      "label": "Brief labels",
      "description": "Posts contain brief labels.",
      "citations": [
        {"source_id": "FB-000001", "text": "Alpha"},
        {"source_id": "FB-000002", "text": "Beta"}
      ],
      "scope_note": "Limited to this fixture.",
      "boundary_note": "Only two fixture posts are available."
    }
  ]
}
JSON

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$fixture_root/tools/bin/abbey-research" discover \
    --model test-model \
    --prompt "$fixture_root/working/discovery/prompt.md" \
    --corpus "$fixture_root/working/discovery/corpus.csv" \
    --batch-manifest \
      "$fixture_root/working/discovery/batches/manifest.json" \
    --output-dir "$fixture_root/working/discovery/output" \
    --validate-only \
    2>&1
)"
status=$?
set -e

assert_status \
  "discovery validate-only exits successfully" \
  "$status" \
  0

assert_contains \
  "discovery validate-only reports one passing batch" \
  "$output" \
  "PASS batches:    1"

if [[ -f \
  "$fixture_root/working/discovery/output/candidate-index.json" ]]; then
  pass "discovery creates candidate index"
else
  fail "discovery creates candidate index"
fi

if [[ -f \
  "$fixture_root/working/discovery/output/review-scaffold.json" ]]; then
  pass "discovery creates review scaffold"
else
  fail "discovery creates review scaffold"
fi

cat > "$fixture_root/working/quoted-language.csv" <<'CSV'
source_id,datetime,text,research_status,platform_context
1,2020-01-01T00:00:00,"Calls this ""Alpha"".",eligible,
2,2020-01-02T00:00:00,Don’t,eligible,
3,2020-01-03T00:00:00,"Calls this ""Excluded"".",eligible,facebook_status_prompt_completion
CSV

set +e
output="$(
  python3 \
    "$fixture_root/tools/research/build_quoted_language_candidates.py" \
    --corpus "$fixture_root/working/quoted-language.csv" \
    --output "$fixture_root/working/quoted-language.json" \
    2>&1
)"
status=$?
set -e

assert_status \
  "quoted-language candidate build exits successfully" \
  "$status" \
  0

assert_contains \
  "quoted-language candidate build applies research scope" \
  "$output" \
  "Eligible rows: 2"

assert_contains \
  "quoted-language candidate build excludes contraction" \
  "$output" \
  "Candidates:    1"

cat > "$fixture_root/working/quote-batch.json" <<'JSON'
{
  "batch_id": "quote-evidence-001",
  "candidates": [
    {"source_id": "FB-000001"},
    {"source_id": "FB-000002"}
  ]
}
JSON

cat > "$fixture_root/working/quote-raw.json" <<'JSON'
```json
{
  "schema_version": 1,
  "review_type": "quoted_language_classification",
  "items": {
    "FB-000001": "SD-S",
    "FB-000002": "TP-C"
  }
}
```
JSON

set +e
output="$(
  python3 \
    "$fixture_root/tools/research/normalize_quoted_language_classification.py" \
    --input "$fixture_root/working/quote-batch.json" \
    --raw-result "$fixture_root/working/quote-raw.json" \
    --output "$fixture_root/working/quote-normalized.json" \
    2>&1
)"
status=$?
set -e

assert_status \
  "quoted-language classification normalization succeeds" \
  "$status" \
  0

assert_contains \
  "quoted-language classification requires complete batch" \
  "$output" \
  "PASS candidates: 2"

cat > "$fixture_root/working/validation-definition.json" <<'JSON'
{
  "schema_version": 1,
  "validation_id": "VAL-TEST",
  "hypothesis": "HYP-TEST",
  "canonical_supporting_ids": [],
  "canonical_comparison_ids": [],
  "expected": {
    "candidate_count": 2,
    "rejected_count": 0,
    "holdout_count": 2
  },
  "core_codes": ["SD-S", "IR-S"],
  "thresholds": {
    "minimum_core_rate": 0.5,
    "minimum_distancing_count": 1,
    "minimum_renaming_count": 0,
    "minimum_passing_bands": 1,
    "minimum_comparison_count": 1
  },
  "chronological_bands": [
    {
      "band_id": "2020",
      "start_year": 2020,
      "end_year": 2020
    }
  ]
}
JSON

cat > "$fixture_root/working/validation-review.json" <<JSON
{
  "schema_version": 1,
  "corpus": {"sha256": "$corpus_hash"},
  "items": [
    {
      "evidence_role": "supporting",
      "decision": "retain",
      "note": "Retained. Classification: SD-S.",
      "citations": [
        {"source_id": "FB-000001", "text": "Alpha"}
      ]
    },
    {
      "evidence_role": "comparison",
      "decision": "retain",
      "note": "Comparison. Classification: TP-C.",
      "citations": [
        {"source_id": "FB-000002", "text": "Beta"}
      ]
    }
  ]
}
JSON

set +e
output="$(
  python3 \
    "$fixture_root/tools/research/calculate_quoted_language_validation.py" \
    --definition "$fixture_root/working/validation-definition.json" \
    --review "$fixture_root/working/validation-review.json" \
    --corpus "$fixture_root/working/discovery/corpus.csv" \
    --output "$fixture_root/working/validation-result.json" \
    2>&1
)"
status=$?
set -e

assert_status \
  "quoted-language deterministic validation succeeds" \
  "$status" \
  0

assert_contains \
  "quoted-language deterministic validation reports PASS" \
  "$output" \
  "Result:      PASS"

printf '\nPassed: %d\n' "$passed"
printf 'Failed: %d\n' "$failed"

if (( failed > 0 )); then
  exit 1
fi
