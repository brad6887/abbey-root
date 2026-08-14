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
  "--help shows create usage" \
  "$output" \
  "abbey research create"

assert_contains \
  "--help shows review initialization usage" \
  "$output" \
  "abbey research review-init RUN-ID"

assert_contains \
  "--help shows review record validation usage" \
  "$output" \
  "abbey research review-validate RUN-ID"

assert_contains \
  "--help shows safe promotion usage" \
  "$output" \
  "abbey research promote RUN-ID [--confirm]"

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

assert_contains \
  "--help shows fact-lock proposal usage" \
  "$output" \
  "abbey research fact-lock propose"

assert_contains \
  "--help shows fact-lock validation usage" \
  "$output" \
  "abbey research fact-lock validate"

assert_contains \
  "--help shows fact-lock review usage" \
  "$output" \
  "abbey research fact-lock review"

assert_contains \
  "--help shows fact-lock review-init usage" \
  "$output" \
  "abbey research fact-lock review-init"

assert_contains \
  "--help shows fact-lock review-validate usage" \
  "$output" \
  "abbey research fact-lock review-validate"

assert_contains \
  "--help shows fact-lock revise usage" \
  "$output" \
  "abbey research fact-lock revise"

assert_contains \
  "--help shows fact-lock approve usage" \
  "$output" \
  "abbey research fact-lock approve"

set +e
output="$("$TOOL" fact-lock --help 2>&1)"
status=$?
set -e

assert_status \
  "fact-lock help exits successfully" \
  "$status" \
  0

assert_contains \
  "fact-lock help preserves approval boundary" \
  "$output" \
  "Proposal does not approve a fact lock."

set +e
output="$("$TOOL" fact-lock propose 2>&1)"
status=$?
set -e

assert_status \
  "fact-lock propose requires a model" \
  "$status" \
  1

assert_contains \
  "fact-lock propose reports missing model" \
  "$output" \
  "Missing required option: --model"

set +e
output="$(
  "$TOOL" fact-lock validate \
    --suite \
      "$ROOT/docs/research/voice-analysis/evaluations/VOICE-FACT-EXTRACTION-EVAL-001.json" \
    --proposal \
      "$ROOT/docs/research/voice-analysis/models/VOICE-FACT-LOCK-PROPOSAL-001-REVISION-009.json" \
    2>&1
)"
status=$?
set -e

assert_status \
  "fact-lock validate exits successfully" \
  "$status" \
  0

assert_contains \
  "fact-lock validate reports PASS" \
  "$output" \
  "Result: PASS"

assert_contains \
  "fact-lock validate preserves human review" \
  "$output" \
  "Human review is still required."

review_proposal="$ROOT/docs/research/voice-analysis/models/VOICE-FACT-LOCK-PROPOSAL-001-REVISION-009.json"
review_hash_before="$(sha256sum "$review_proposal" | awk '{print $1}')"

set +e
output="$(
  "$TOOL" fact-lock review \
    --suite \
      "$ROOT/docs/research/voice-analysis/evaluations/VOICE-FACT-EXTRACTION-EVAL-001.json" \
    --proposal "$review_proposal" \
    2>&1
)"
status=$?
set -e

assert_status \
  "fact-lock review exits successfully" \
  "$status" \
  0

assert_contains \
  "fact-lock review reports proposal hash" \
  "$output" \
  "Proposal SHA-256:"

assert_contains \
  "fact-lock review reports scenario detail" \
  "$output" \
  "REQ-003: callback"

assert_contains \
  "fact-lock review highlights authorized invention" \
  "$output" \
  "Review attention: supplied callback context, authorized invention"

assert_contains \
  "fact-lock review requires human decision" \
  "$output" \
  "HUMAN REVIEW REQUIRED"

assert_contains \
  "fact-lock review states read-only boundary" \
  "$output" \
  "This command did not create, modify, approve, or promote any artifact."

review_hash_after="$(sha256sum "$review_proposal" | awk '{print $1}')"
if [[ "$review_hash_before" == "$review_hash_after" ]]; then
  pass "fact-lock review does not modify proposal"
else
  fail "fact-lock review does not modify proposal"
fi

review_init_root="$(mktemp -d)"
review_scaffold="$review_init_root/review.json"

set +e
output="$(
  "$TOOL" fact-lock review-init \
    --suite \
      "$ROOT/docs/research/voice-analysis/evaluations/VOICE-FACT-EXTRACTION-EVAL-001.json" \
    --proposal "$review_proposal" \
    --output "$review_scaffold" \
    2>&1
)"
status=$?
set -e

assert_status \
  "fact-lock review-init exits successfully" \
  "$status" \
  0

assert_contains \
  "fact-lock review-init reports undecided boundary" \
  "$output" \
  "All review decisions are undecided."

scaffold_check="$(
  python3 - "$review_proposal" "$review_scaffold" <<'PYTHON'
import hashlib
import json
import sys

proposal = json.load(open(sys.argv[1], encoding="utf-8"))
review = json.load(open(sys.argv[2], encoding="utf-8"))
encoded = json.dumps(
    proposal,
    sort_keys=True,
    separators=(",", ":"),
    ensure_ascii=False,
).encode("utf-8")
expected_hash = hashlib.sha256(encoded).hexdigest()

safe = (
    review.get("review_id") is None
    and review.get("fact_lock_id") is None
    and review.get("decision") == "undecided"
    and review.get("proposal_sha256") == expected_hash
    and len(review.get("items", [])) == len(proposal.get("requests", []))
    and all(
        item.get("facts") == "undecided"
        and item.get("constraints") == "undecided"
        and item.get("note") == ""
        for item in review.get("items", [])
    )
)
print("SAFE" if safe else "UNSAFE")
PYTHON
)"

assert_contains \
  "fact-lock review-init creates safe blank scaffold" \
  "$scaffold_check" \
  "SAFE"

set +e
output="$(
  "$TOOL" fact-lock review-init \
    --suite \
      "$ROOT/docs/research/voice-analysis/evaluations/VOICE-FACT-EXTRACTION-EVAL-001.json" \
    --proposal "$review_proposal" \
    --output "$review_scaffold" \
    2>&1
)"
status=$?
set -e

assert_status \
  "fact-lock review-init protects existing output" \
  "$status" \
  1

assert_contains \
  "fact-lock review-init reports existing output" \
  "$output" \
  "output already exists:"

set +e
output="$(
  "$TOOL" fact-lock review-validate \
    --suite \
      "$ROOT/docs/research/voice-analysis/evaluations/VOICE-FACT-EXTRACTION-EVAL-001.json" \
    --proposal "$review_proposal" \
    --review "$review_scaffold" \
    2>&1
)"
status=$?
set -e

assert_status \
  "fact-lock review-validate rejects undecided scaffold" \
  "$status" \
  1

assert_contains \
  "fact-lock review-validate reports undecided decision" \
  "$output" \
  "review decision must equal approve or revise"

approval_review="$review_init_root/approval-review.json"
revision_review="$review_init_root/revision-review.json"

python3 - \
  "$review_scaffold" \
  "$approval_review" \
  "$revision_review" <<'PYTHON'
import copy
import json
import sys

scaffold = json.load(open(sys.argv[1], encoding="utf-8"))

approval = copy.deepcopy(scaffold)
approval["review_id"] = "REVIEW-TEST-APPROVE"
approval["fact_lock_id"] = "FACT-LOCK-TEST"
approval["decision"] = "approve"
for item in approval["items"]:
    item["facts"] = "approve"
    item["constraints"] = "approve"
    item["note"] = "Reviewed facts and constraints."

revision = copy.deepcopy(scaffold)
revision["review_id"] = "REVIEW-TEST-REVISE"
revision["decision"] = "revise"
for item in revision["items"]:
    item["facts"] = "approve"
    item["constraints"] = "approve"
    item["note"] = "Reviewed facts and constraints."
revision["items"][0]["facts"] = "revise"
revision["items"][0]["note"] = "Revise the first scenario facts."

with open(sys.argv[2], "w", encoding="utf-8") as stream:
    json.dump(approval, stream, indent=2)
    stream.write("\n")
with open(sys.argv[3], "w", encoding="utf-8") as stream:
    json.dump(revision, stream, indent=2)
    stream.write("\n")
PYTHON

set +e
output="$(
  "$TOOL" fact-lock review-validate \
    --suite \
      "$ROOT/docs/research/voice-analysis/evaluations/VOICE-FACT-EXTRACTION-EVAL-001.json" \
    --proposal "$review_proposal" \
    --review "$approval_review" \
    2>&1
)"
status=$?
set -e

assert_status \
  "fact-lock approval review validates" \
  "$status" \
  0

assert_contains \
  "fact-lock approval review reports decision" \
  "$output" \
  "Decision: approve"

set +e
output="$(
  "$TOOL" fact-lock review-validate \
    --suite \
      "$ROOT/docs/research/voice-analysis/evaluations/VOICE-FACT-EXTRACTION-EVAL-001.json" \
    --proposal "$review_proposal" \
    --review "$revision_review" \
    2>&1
)"
status=$?
set -e

assert_status \
  "fact-lock revision review validates" \
  "$status" \
  0

assert_contains \
  "fact-lock revision review reports decision" \
  "$output" \
  "Decision: revise"

approved_lock="$review_init_root/approved-lock.json"
set +e
output="$(
  "$TOOL" fact-lock approve \
    --suite \
      "$ROOT/docs/research/voice-analysis/evaluations/VOICE-FACT-EXTRACTION-EVAL-001.json" \
    --proposal "$review_proposal" \
    --review "$approval_review" \
    --output "$approved_lock" \
    2>&1
)"
status=$?
set -e

assert_status \
  "fact-lock approve branch exits successfully" \
  "$status" \
  0

assert_contains \
  "fact-lock approve branch reports output" \
  "$output" \
  "Approved fact lock:"

approved_check="$(
  python3 - "$approved_lock" <<'PYTHON'
import json
import sys

lock = json.load(open(sys.argv[1], encoding="utf-8"))
safe = (
    lock.get("status") == "approved_human_reviewed"
    and lock.get("fact_lock_id") == "FACT-LOCK-TEST"
    and lock.get("review_id") == "REVIEW-TEST-APPROVE"
    and len(lock.get("scenarios", [])) == 5
)
print("SAFE" if safe else "UNSAFE")
PYTHON
)"

assert_contains \
  "fact-lock approve branch preserves approved metadata" \
  "$approved_check" \
  "SAFE"

set +e
output="$(
  "$TOOL" fact-lock approve \
    --suite \
      "$ROOT/docs/research/voice-analysis/evaluations/VOICE-FACT-EXTRACTION-EVAL-001.json" \
    --proposal "$review_proposal" \
    --review "$revision_review" \
    --output "$review_init_root/rejected-lock.json" \
    2>&1
)"
status=$?
set -e

assert_status \
  "fact-lock approve rejects revision review" \
  "$status" \
  1

assert_contains \
  "fact-lock approve requires approval decision" \
  "$output" \
  "review decision must equal approve"

set +e
output="$(
  "$TOOL" fact-lock revise \
    --model gpt-oss:20b \
    --suite \
      "$ROOT/docs/research/voice-analysis/evaluations/VOICE-FACT-EXTRACTION-EVAL-001.json" \
    --proposal "$review_proposal" \
    --review "$approval_review" \
    --output "$review_init_root/rejected-revision.json" \
    2>&1
)"
status=$?
set -e

assert_status \
  "fact-lock revise rejects approval review" \
  "$status" \
  1

assert_contains \
  "fact-lock revise requires revision decision" \
  "$output" \
  "review decision must equal revise"

rm -r "$review_init_root"

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

cp "$ROOT/scripts/abbey_research_create.py" \
  "$fixture_root/scripts/abbey_research_create.py"

cp "$ROOT/scripts/abbey_research_promotion.py" \
  "$fixture_root/scripts/abbey_research_promotion.py"

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

create_fixture="$fixture_root/create-fixture"
create_runs="$fixture_root/working/research/runs"
mkdir -p "$create_fixture"

cat > "$create_fixture/stage-tool" <<'STAGE_TOOL'
#!/usr/bin/env bash
set -euo pipefail

command="$1"
shift

if [[ "${FAKE_FAIL_STAGE:-}" == "$command" ]]; then
  echo "Injected $command failure." >&2
  exit 9
fi

output=""
input=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)
      output="$2"
      shift 2
      ;;
    --input)
      input="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

case "$command" in
  run)
    cat > "$output" <<'MARKDOWN'
# Observation

## Question

Which recurring pattern appears in the supplied material?

## Corpus

The supplied test corpus.

## Method

Review the supplied records for repeated structures.

## Findings

The pattern appears in FB-000001.

## Interpretation

The finding is a candidate requiring human review.

## Questions Raised

Does the pattern appear in a broader sample?

## Status

Candidate.
MARKDOWN
    ;;
  normalize)
    cp "$input" "$output"
    ;;
  sanitize)
    exec "$REAL_RESEARCH_TOOL" sanitize \
      --input "$input" \
      --output "$output"
    ;;
  validate)
    exec "$REAL_RESEARCH_TOOL" validate \
      --type observation \
      --input "$input"
    ;;
  *)
    echo "Unexpected command: $command" >&2
    exit 2
    ;;
esac
STAGE_TOOL
chmod +x "$create_fixture/stage-tool"

cat > "$create_fixture/prompt.md" <<'MARKDOWN'
# Prompt

Create one cited observation candidate.
MARKDOWN

cat > "$create_fixture/input.md" <<'MARKDOWN'
FB-000001: Example source record.
MARKDOWN

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
  ABBEY_RESEARCH_RUN_ID="RUN-TEST-SUCCESS" \
  ABBEY_RESEARCH_STAGE_TOOL="$create_fixture/stage-tool" \
  REAL_RESEARCH_TOOL="$fixture_root/tools/bin/abbey-research" \
    "$fixture_root/tools/bin/abbey-research" create \
    --project test-project \
    --type observation \
    --corpus CORPUS-TEST \
    --experiment EXP-TEST \
    --model test-model \
    --prompt "$create_fixture/prompt.md" \
    --input "$create_fixture/input.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation create succeeds" \
  "$status" \
  0

assert_contains \
  "observation create reports review-ready state" \
  "$output" \
  "State:     review-ready"

assert_contains \
  "observation create preserves source citations" \
  "$(cat "$create_runs/RUN-TEST-SUCCESS/candidate.md")" \
  "FB-000001"

manifest_check="$(
  python3 - "$create_runs/RUN-TEST-SUCCESS/manifest.yaml" <<'PYTHON'
import json
import sys

manifest = json.load(open(sys.argv[1], encoding="utf-8"))
valid = (
    manifest["state"] == "review-ready"
    and manifest["artifact_type"] == "observation"
    and manifest["source"]["corpus"] == "CORPUS-TEST"
    and len(manifest["inputs"]) == 1
    and len(manifest["executions"]) == 4
    and all(item["status"] == "passed" for item in manifest["executions"])
)
print("VALID" if valid else "BROKEN")
PYTHON
)"

assert_contains \
  "observation create records complete manifest" \
  "$manifest_check" \
  "VALID"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
  ABBEY_RESEARCH_RUN_ID="RUN-TEST-NO-INPUT" \
  ABBEY_RESEARCH_STAGE_TOOL="$create_fixture/stage-tool" \
  REAL_RESEARCH_TOOL="$fixture_root/tools/bin/abbey-research" \
    "$fixture_root/tools/bin/abbey-research" create \
    --project test-project \
    --type observation \
    --corpus CORPUS-TEST \
    --experiment EXP-TEST \
    --model test-model \
    --prompt "$create_fixture/prompt.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation create supports no optional inputs" \
  "$status" \
  0

if [[ ! -w "$create_runs/RUN-TEST-SUCCESS/raw.md" ]]; then
  pass "observation create makes raw output immutable"
else
  fail "observation create makes raw output immutable"
fi

raw_hash_before="$(
  sha256sum "$create_runs/RUN-TEST-SUCCESS/raw.md" | awk '{print $1}'
)"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
  ABBEY_RESEARCH_RUN_ID="RUN-TEST-SUCCESS" \
  ABBEY_RESEARCH_STAGE_TOOL="$create_fixture/stage-tool" \
  REAL_RESEARCH_TOOL="$fixture_root/tools/bin/abbey-research" \
    "$fixture_root/tools/bin/abbey-research" create \
    --project test-project \
    --type observation \
    --corpus CORPUS-TEST \
    --experiment EXP-TEST \
    --model test-model \
    --prompt "$create_fixture/prompt.md" \
    --input "$create_fixture/input.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation create rejects an existing run" \
  "$status" \
  1

assert_contains \
  "observation create reports overwrite protection" \
  "$output" \
  "Existing run outputs will not be overwritten."

raw_hash_after="$(
  sha256sum "$create_runs/RUN-TEST-SUCCESS/raw.md" | awk '{print $1}'
)"

if [[ "$raw_hash_before" == "$raw_hash_after" ]]; then
  pass "observation create does not overwrite raw output"
else
  fail "observation create does not overwrite raw output"
fi

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
  ABBEY_RESEARCH_RUN_ID="RUN-TEST-GENERATION-FAILURE" \
  ABBEY_RESEARCH_STAGE_TOOL="$create_fixture/stage-tool" \
  REAL_RESEARCH_TOOL="$fixture_root/tools/bin/abbey-research" \
  FAKE_FAIL_STAGE="run" \
    "$fixture_root/tools/bin/abbey-research" create \
    --project test-project \
    --type observation \
    --corpus CORPUS-TEST \
    --experiment EXP-TEST \
    --model test-model \
    --prompt "$create_fixture/prompt.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation create reports generation failure" \
  "$status" \
  1

assert_contains \
  "generation failure records failure state" \
  "$(cat "$create_runs/RUN-TEST-GENERATION-FAILURE/manifest.yaml")" \
  '"state": "generation-failed"'

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
  ABBEY_RESEARCH_RUN_ID="RUN-TEST-STAGE-FAILURE" \
  ABBEY_RESEARCH_STAGE_TOOL="$create_fixture/stage-tool" \
  REAL_RESEARCH_TOOL="$fixture_root/tools/bin/abbey-research" \
  FAKE_FAIL_STAGE="normalize" \
    "$fixture_root/tools/bin/abbey-research" create \
    --project test-project \
    --type observation \
    --corpus CORPUS-TEST \
    --experiment EXP-TEST \
    --model test-model \
    --prompt "$create_fixture/prompt.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation create reports stage failure" \
  "$status" \
  1

assert_contains \
  "stage failure records normalization state" \
  "$(cat "$create_runs/RUN-TEST-STAGE-FAILURE/manifest.yaml")" \
  '"state": "normalization-failed"'

assert_contains \
  "stage failure preserves raw output" \
  "$(cat "$create_runs/RUN-TEST-STAGE-FAILURE/raw.md")" \
  "FB-000001"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
  ABBEY_RESEARCH_RUN_ID="RUN-TEST-UNSUPPORTED" \
  ABBEY_RESEARCH_STAGE_TOOL="$create_fixture/stage-tool" \
  REAL_RESEARCH_TOOL="$fixture_root/tools/bin/abbey-research" \
    "$fixture_root/tools/bin/abbey-research" create \
    --project test-project \
    --type evidence \
    --corpus CORPUS-TEST \
    --experiment EXP-TEST \
    --model test-model \
    --prompt "$create_fixture/prompt.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation create rejects unsupported type" \
  "$status" \
  1

assert_contains \
  "observation create reports supported type" \
  "$output" \
  "Supported types: observation"

canonical_project="$fixture_root/docs/research/test-project"
mkdir -p \
  "$canonical_project/corpus" \
  "$canonical_project/experiments" \
  "$canonical_project/observations"

cat > "$canonical_project/corpus/CORPUS-TEST.md" <<'MARKDOWN_CORPUS_TEST'
---
artifact_id: CORPUS-TEST
artifact_type: corpus
title: Test Corpus
version: 1
status: draft
---

# Test Corpus
MARKDOWN_CORPUS_TEST

cat > "$canonical_project/experiments/EXP-TEST.md" <<'MARKDOWN_EXPERIMENT_TEST'
---
artifact_id: EXP-TEST
artifact_type: experiment
title: Test Experiment
version: 1
status: draft

source:
  corpus: CORPUS-TEST
---

# Test Experiment
MARKDOWN_EXPERIMENT_TEST
cat > "$canonical_project/observations/OBS-001.md" <<'MARKDOWN_OBS_001'
---
artifact_id: OBS-001
artifact_type: observation
title: Existing Observation 1
version: 1
status: draft
---

# Existing Observation 1
MARKDOWN_OBS_001

cat > "$canonical_project/observations/OBS-003.md" <<'MARKDOWN_OBS_003'
---
artifact_id: OBS-003
artifact_type: observation
title: Existing Observation 3
version: 1
status: draft
---

# Existing Observation 3
MARKDOWN_OBS_003

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$canonical_project/observations" \
  ABBEY_RESEARCH_RUN_ID="RUN-TEST-CANONICAL-PATH" \
  ABBEY_RESEARCH_STAGE_TOOL="$create_fixture/stage-tool" \
  REAL_RESEARCH_TOOL="$fixture_root/tools/bin/abbey-research" \
    "$fixture_root/tools/bin/abbey-research" create \
    --project test-project \
    --type observation \
    --corpus CORPUS-TEST \
    --experiment EXP-TEST \
    --model test-model \
    --prompt "$create_fixture/prompt.md" \
    --input "$create_fixture/input.md" \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation create rejects canonical run paths" \
  "$status" \
  1

assert_contains \
  "observation create reports canonical path protection" \
  "$output" \
  "Research candidate runs cannot use canonical research paths."

if [[ ! -e "$canonical_project/observations/RUN-TEST-CANONICAL-PATH" ]]; then
  pass "canonical path rejection does not create a run workspace"
else
  fail "canonical path rejection does not create a run workspace"
fi

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
    "$fixture_root/tools/bin/abbey-research" review-init \
    RUN-TEST-SUCCESS \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation review initialization succeeds" \
  "$status" \
  0

assert_contains \
  "observation review starts undecided" \
  "$output" \
  "Decision: undecided"

review_path="$create_runs/RUN-TEST-SUCCESS/review.json"
review_scaffold_check="$(
  python3 - \
    "$review_path" \
    "$create_runs/RUN-TEST-SUCCESS/candidate.md" <<'PYTHON_REVIEW_SCAFFOLD'
import hashlib
import json
import sys

review_path, candidate_path = sys.argv[1:]
review = json.load(open(review_path, encoding="utf-8"))
manifest = json.load(
    open(review_path.replace("review.json", "manifest.yaml"), encoding="utf-8")
)
candidate_hash = hashlib.sha256(open(candidate_path, "rb").read()).hexdigest()
valid = (
    review["decision"] == "undecided"
    and review["candidate_sha256"] == candidate_hash
    and review["created_at"] == manifest["review"]["created_at"]
    and review["reviewer"] == ""
    and review["canonical_title"] == ""
    and set(review["checks"].values()) == {"undecided"}
    and manifest["review"]["candidate_sha256"] == candidate_hash
)
print("VALID" if valid else "BROKEN")
PYTHON_REVIEW_SCAFFOLD
)"

assert_contains \
  "observation review is hash-bound without implicit approval" \
  "$review_scaffold_check" \
  "VALID"

python3 - "$review_path" <<'PYTHON_TAMPER_REVIEW_ORIGIN'
import json
import sys

path = sys.argv[1]
review = json.load(open(path, encoding="utf-8"))
review["created_at"] = "2026-08-14T00:00:00+00:00"
with open(path, "w", encoding="utf-8") as stream:
    json.dump(review, stream, indent=2)
    stream.write("\n")
PYTHON_TAMPER_REVIEW_ORIGIN

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
    "$fixture_root/tools/bin/abbey-research" review-validate \
    RUN-TEST-SUCCESS \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation review rejects a changed creation anchor" \
  "$status" \
  1

assert_contains \
  "observation review reports a changed creation anchor" \
  "$output" \
  "Review creation timestamp does not match the run manifest anchor."

python3 - "$review_path" <<'PYTHON_RESTORE_REVIEW_ORIGIN'
import json
import sys

path = sys.argv[1]
review = json.load(open(path, encoding="utf-8"))
manifest = json.load(
    open(path.replace("review.json", "manifest.yaml"), encoding="utf-8")
)
review["created_at"] = manifest["review"]["created_at"]
with open(path, "w", encoding="utf-8") as stream:
    json.dump(review, stream, indent=2)
    stream.write("\n")
PYTHON_RESTORE_REVIEW_ORIGIN

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
    "$fixture_root/tools/bin/abbey-research" review-init \
    RUN-TEST-SUCCESS \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation review initialization protects an existing record" \
  "$status" \
  1

assert_contains \
  "observation review reports overwrite protection" \
  "$output" \
  "Review record already exists"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
    "$fixture_root/tools/bin/abbey-research" review-validate \
    RUN-TEST-SUCCESS \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation review validation rejects undecided records" \
  "$status" \
  1

assert_contains \
  "observation review reports undecided human decisions" \
  "$output" \
  "still contains undecided human decisions"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
  ABBEY_RESEARCH_STAGE_TOOL="$fixture_root/tools/bin/abbey-research" \
    "$fixture_root/tools/bin/abbey-research" promote \
    RUN-TEST-SUCCESS --confirm \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation promotion rejects undecided reviews" \
  "$status" \
  1

if [[ ! -e "$canonical_project/observations/OBS-004.md" ]]; then
  pass "undecided review creates no canonical artifact"
else
  fail "undecided review creates no canonical artifact"
fi

python3 - "$review_path" <<'PYTHON_REJECT_REVIEW'
import json
import sys

path = sys.argv[1]
review = json.load(open(path, encoding="utf-8"))
review.update(
    {
        "decision": "rejected",
        "reviewer": "Test Reviewer",
        "reviewed_at": "2026-08-14T12:00:00+00:00",
        "notes": "The interpretation needs revision.",
    }
)
review["checks"] = {
    "finding_wording_is_proportional": "rejected",
    "citations_are_representative": "approved",
    "interpretation_is_distinguished": "approved",
}
with open(path, "w", encoding="utf-8") as stream:
    json.dump(review, stream, indent=2)
    stream.write("\n")
PYTHON_REJECT_REVIEW

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
    "$fixture_root/tools/bin/abbey-research" review-validate \
    RUN-TEST-SUCCESS \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation review validation accepts explicit rejection" \
  "$status" \
  0

assert_contains \
  "observation review validation reports rejection" \
  "$output" \
  "Decision: rejected"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
  ABBEY_RESEARCH_STAGE_TOOL="$fixture_root/tools/bin/abbey-research" \
    "$fixture_root/tools/bin/abbey-research" promote \
    RUN-TEST-SUCCESS --confirm \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation promotion rejects a human rejection" \
  "$status" \
  1

assert_contains \
  "observation promotion requires explicit approval" \
  "$output" \
  "does not approve canonical promotion"

if [[ ! -e "$canonical_project/observations/OBS-004.md" ]]; then
  pass "rejected review creates no canonical artifact"
else
  fail "rejected review creates no canonical artifact"
fi

python3 - "$review_path" <<'PYTHON_APPROVE_REVIEW'
import json
import sys

path = sys.argv[1]
review = json.load(open(path, encoding="utf-8"))
review.update(
    {
        "decision": "approved",
        "reviewer": "Test Reviewer",
        "reviewed_at": "2026-08-14T12:15:00+00:00",
        "canonical_title": "Test Observation",
        "notes": "Approved after direct human review.",
    }
)
review["checks"] = {
    name: "approved" for name in review["checks"]
}
with open(path, "w", encoding="utf-8") as stream:
    json.dump(review, stream, indent=2)
    stream.write("\n")
PYTHON_APPROVE_REVIEW

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
    "$fixture_root/tools/bin/abbey-research" review-validate \
    RUN-TEST-SUCCESS \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation review validation accepts explicit approval" \
  "$status" \
  0

candidate_path="$create_runs/RUN-TEST-SUCCESS/candidate.md"
cp "$candidate_path" "$candidate_path.before-stale-test"
printf '%s\n' 'Changed after review.' >> "$candidate_path"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
    "$fixture_root/tools/bin/abbey-research" review-validate \
    RUN-TEST-SUCCESS \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation review validation rejects stale candidates" \
  "$status" \
  1

assert_contains \
  "stale candidate reports changed hash" \
  "$output" \
  "Candidate changed after the review record was created."

mv "$candidate_path.before-stale-test" "$candidate_path"

mv "$candidate_path" "$candidate_path.real"
ln -s "$(basename "$candidate_path.real")" "$candidate_path"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
    "$fixture_root/tools/bin/abbey-research" review-validate \
    RUN-TEST-SUCCESS \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation review validation rejects a symlinked candidate" \
  "$status" \
  1

assert_contains \
  "symlinked candidate reports unsafe run contract" \
  "$output" \
  "Candidate path is unavailable or outside the run contract."

rm "$candidate_path"
mv "$candidate_path.real" "$candidate_path"

cp \
  "$canonical_project/corpus/CORPUS-TEST.md" \
  "$canonical_project/corpus/CORPUS-TEST.md.before-metadata-test"
sed -i.bak \
  's/artifact_id: CORPUS-TEST/artifact_id: CORPUS-OTHER/' \
  "$canonical_project/corpus/CORPUS-TEST.md"
rm "$canonical_project/corpus/CORPUS-TEST.md.bak"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
  ABBEY_RESEARCH_STAGE_TOOL="$fixture_root/tools/bin/abbey-research" \
    "$fixture_root/tools/bin/abbey-research" promote \
    RUN-TEST-SUCCESS --confirm \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation promotion rejects mismatched canonical source metadata" \
  "$status" \
  1

assert_contains \
  "mismatched canonical source metadata is reported" \
  "$output" \
  "Canonical corpus metadata does not match: CORPUS-TEST.md"

mv \
  "$canonical_project/corpus/CORPUS-TEST.md.before-metadata-test" \
  "$canonical_project/corpus/CORPUS-TEST.md"

printf '%s\n' '# Invalid Identifier' \
  > "$canonical_project/observations/OBS-invalid.md"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
  ABBEY_RESEARCH_STAGE_TOOL="$fixture_root/tools/bin/abbey-research" \
    "$fixture_root/tools/bin/abbey-research" promote \
    RUN-TEST-SUCCESS \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation promotion rejects invalid canonical identifiers" \
  "$status" \
  1

assert_contains \
  "invalid canonical identifier is reported" \
  "$output" \
  "Invalid canonical observation identifier: OBS-invalid.md"

rm "$canonical_project/observations/OBS-invalid.md"

mv \
  "$canonical_project/observations" \
  "$canonical_project/observations-real"
mkdir "$fixture_root/working/redirected-observations"
ln -s \
  "$fixture_root/working/redirected-observations" \
  "$canonical_project/observations"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
  ABBEY_RESEARCH_STAGE_TOOL="$fixture_root/tools/bin/abbey-research" \
    "$fixture_root/tools/bin/abbey-research" promote \
    RUN-TEST-SUCCESS \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation promotion rejects a redirected canonical directory" \
  "$status" \
  1

assert_contains \
  "redirected canonical directory is reported as unsafe" \
  "$output" \
  "Canonical observations directory is unsafe."

rm "$canonical_project/observations"
mv \
  "$canonical_project/observations-real" \
  "$canonical_project/observations"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
  ABBEY_RESEARCH_STAGE_TOOL="$fixture_root/tools/bin/abbey-research" \
    "$fixture_root/tools/bin/abbey-research" promote \
    RUN-TEST-SUCCESS \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation promotion preview succeeds" \
  "$status" \
  0

assert_contains \
  "observation promotion allocates above the highest identifier" \
  "$output" \
  "Artifact:   OBS-004"

assert_contains \
  "observation promotion preview requires confirmation" \
  "$output" \
  "Preview only. No canonical artifact was written."

if [[ ! -e "$canonical_project/observations/OBS-004.md" ]]; then
  pass "promotion preview creates no canonical artifact"
else
  fail "promotion preview creates no canonical artifact"
fi

collision_check="$(
  python3 - \
    "$fixture_root/scripts/abbey_research_promotion.py" \
    "$fixture_root/working/collision-test" <<'PYTHON_COLLISION'
import importlib.util
import pathlib
import sys

script, root_value = sys.argv[1:]
spec = importlib.util.spec_from_file_location("promotion", script)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
root = pathlib.Path(root_value)
root.mkdir()
target = root / "OBS-004.md"
target.write_text("original\n", encoding="utf-8")
try:
    module.install_exclusive(target, "replacement\n")
except module.PromotionError:
    print("BLOCKED" if target.read_text() == "original\n" else "OVERWROTE")
else:
    print("NOT_BLOCKED")
PYTHON_COLLISION
)"

assert_contains \
  "canonical installation blocks a target collision without overwrite" \
  "$collision_check" \
  "BLOCKED"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
  ABBEY_RESEARCH_STAGE_TOOL="$fixture_root/tools/bin/abbey-research" \
    "$fixture_root/tools/bin/abbey-research" promote \
    RUN-TEST-SUCCESS --confirm \
    2>&1
)"
status=$?
set -e

assert_status \
  "confirmed observation promotion succeeds" \
  "$status" \
  0

assert_contains \
  "confirmed observation promotion reports canonical target" \
  "$output" \
  "Canonical artifact:"

promoted_path="$canonical_project/observations/OBS-004.md"
promoted_check="$(
  python3 - \
    "$promoted_path" \
    "$create_runs/RUN-TEST-SUCCESS/manifest.yaml" <<'PYTHON_PROMOTED'
import json
import sys

artifact_path, manifest_path = sys.argv[1:]
artifact = open(artifact_path, encoding="utf-8").read()
manifest = json.load(open(manifest_path, encoding="utf-8"))
valid = (
    "artifact_id: OBS-004" in artifact
    and 'title: "Test Observation"' in artifact
    and "run_id: \"RUN-TEST-SUCCESS\"" in artifact
    and 'model: "test-model"' in artifact
    and "prompt_sha256:" in artifact
    and "input_sha256:" in artifact
    and manifest["state"] == "promoted"
    and manifest["promotion"]["artifact_id"] == "OBS-004"
)
print("VALID" if valid else "BROKEN")
PYTHON_PROMOTED
)"

assert_contains \
  "promoted observation preserves identity and provenance" \
  "$promoted_check" \
  "VALID"

if [[ ! -w "$promoted_path" && ! -w "$review_path" ]]; then
  pass "promotion freezes the canonical artifact and review record"
else
  fail "promotion freezes the canonical artifact and review record"
fi

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
  ABBEY_RESEARCH_RUNS_DIR="$create_runs" \
  ABBEY_RESEARCH_STAGE_TOOL="$fixture_root/tools/bin/abbey-research" \
    "$fixture_root/tools/bin/abbey-research" promote \
    RUN-TEST-SUCCESS --confirm \
    2>&1
)"
status=$?
set -e

assert_status \
  "observation promotion refuses an already promoted run" \
  "$status" \
  1

if [[ ! -e "$canonical_project/observations/OBS-005.md" ]]; then
  pass "duplicate promotion creates no second canonical artifact"
else
  fail "duplicate promotion creates no second canonical artifact"
fi

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


voice_fixture="$(mktemp -d)"
voice_lock="$ROOT/docs/research/voice-analysis/models/VOICE-MODEL-001-FACT-LOCK.json"
mkdir -p "$voice_fixture"
printf 'old-output\n' > "$voice_fixture/output.json"
printf 'old-report\n' > "$voice_fixture/report.json"
set +e
output="$($TOOL voice apply --model test-model --fact-lock "$voice_lock" --output "$voice_fixture/output.json" --report "$voice_fixture/new-report.json" 2>&1)"; status=$?
set -e
assert_status "voice apply rejects existing output without force" "$status" 1
assert_contains "voice apply reports existing output" "$output" "Output file already exists"
set +e
output="$($TOOL voice apply --model test-model --fact-lock "$voice_lock" --output "$voice_fixture/new-output.json" --report "$voice_fixture/report.json" 2>&1)"; status=$?
set -e
assert_status "voice apply rejects existing report without force" "$status" 1
assert_contains "voice apply reports existing report" "$output" "Report file already exists"
set +e
output="$($TOOL voice apply --model test-model --fact-lock "$voice_lock" --output "$voice_fixture/output.json" --report "$voice_fixture/report.json" --force 2>&1)"; status=$?
set -e
assert_status "voice apply force reaches generation" "$status" 1
if [[ "$(cat "$voice_fixture/output.json")" == "old-output"* && "$(cat "$voice_fixture/report.json")" == "old-report"* ]]; then pass "generation failure preserves existing output and report"; else fail "generation failure preserves existing output and report"; fi
rm -rf "$voice_fixture"

voice_normalize_fixture="$(mktemp -d)"
printf '%s\n' '{"schema_version":1,"workflow":"fact_locked_voice_application","fact_lock_id":"VOICE-MODEL-001-FACT-LOCK-001","model":"VOICE-MODEL-001","items":[{"scenario_id":"REQ-002","response":"marketed as \\\"smart\\\"; keep C:\\temp\\file"}]}' > "$voice_normalize_fixture/input.json"
python3 "$ROOT/tools/research/normalize_voice_application.py" --input "$voice_normalize_fixture/input.json" --model gpt-oss:20b
python3 - "$voice_normalize_fixture/input.json" <<'PYTHON_VOICE_NORMALIZE_TEST'
import json, sys
value=json.load(open(sys.argv[1], encoding="utf-8"))
response=value["items"][0]["response"]
assert 'marketed as "smart"' in response
assert "\\temp\\file" in response
assert value["model"] == "gpt-oss:20b"
PYTHON_VOICE_NORMALIZE_TEST
pass "voice normalization removes literal quote escapes and preserves other backslashes"
rm -rf "$voice_normalize_fixture"

voice_prompt="$ROOT/docs/research/voice-analysis/prompts/fact-locked-voice-application.md"
if ! grep -Fq 'without assuming a fixed scenario count' "$voice_prompt" || grep -Fq 'Return all eight scenarios' "$voice_prompt" || grep -Fq 'Project Lantern' "$voice_prompt"; then fail "voice prompt is generic"; else pass "voice prompt is generic"; fi
one_fixture="$(mktemp -d)"
python3 - "$one_fixture" <<'PYTHON_ONE_SCENARIO'
import json, pathlib, sys
root=pathlib.Path(sys.argv[1])
lock={"schema_version":1,"fact_lock_id":"CUSTOM-LOCK-001","review_id":"CUSTOM-REVIEW-001","status":"approved_human_reviewed","voice_model":"VOICE-MODEL-001","scenarios":[{"scenario_id":"CUSTOM-REQ-001","task":"Write a Facebook-style post.","required_applied":[],"prohibited_applied":[],"immutable_facts":[{"fact_id":"CUSTOM-F001","proposition":"A lamp is on.","required_any":["lamp is on"]}],"protected_literals":[],"allowed_numbers":[],"forbidden_patterns":[],"creative_slots":[]}]}
output={"schema_version":1,"workflow":"fact_locked_voice_application","fact_lock_id":"CUSTOM-LOCK-001","model":"placeholder","items":[{"scenario_id":"CUSTOM-REQ-001","response":"The lamp is on.","used_fact_ids":["CUSTOM-F001"],"added_facts":[],"creative_slot_uses":[],"applied":[],"omitted":[],"rationale":"Direct statement."}]}
(root/'lock.json').write_text(json.dumps(lock)); (root/'output.json').write_text(json.dumps(output))
PYTHON_ONE_SCENARIO
python3 "$ROOT/tools/research/validate_voice_application_inputs.py" --model "$ROOT/docs/research/voice-analysis/models/VOICE-MODEL-001.json" --fact-lock "$one_fixture/lock.json" >/dev/null && python3 "$ROOT/tools/research/normalize_voice_application.py" --input "$one_fixture/output.json" --model test-model >/dev/null && python3 "$ROOT/tools/research/validate_fact_locked_voice_output.py" --spec "$one_fixture/lock.json" --output "$one_fixture/output.json" >/dev/null && pass "one-scenario lock reaches input, normalizer, and validator path" || fail "one-scenario lock reaches input, normalizer, and validator path"
rm -rf "$one_fixture"

typography_fixture="$(mktemp -d)"
printf '%s\n' '{"schema_version":1,"workflow":"fact_locked_voice_application","fact_lock_id":"TYPO-001","items":[{"scenario_id":"REQ-001","response":"Abbey Root fact‑locked — café"}]}' > "$typography_fixture/input.json"
python3 "$ROOT/tools/research/normalize_voice_application.py" --input "$typography_fixture/input.json" --model test-model >/dev/null
python3 - "$typography_fixture/input.json" <<'PYTHON_TYPOGRAPHY_TEST'
import json, sys
response=json.load(open(sys.argv[1], encoding="utf-8"))["items"][0]["response"]
assert "Abbey Root fact-locked" in response
assert "— café" in response
PYTHON_TYPOGRAPHY_TEST
pass "voice normalization fixes NBSP and non-breaking hyphen only"
rm -rf "$typography_fixture"

printf '\nPassed: %d\n' "$passed"
printf 'Failed: %d\n' "$failed"

if (( failed > 0 )); then
  exit 1
fi
