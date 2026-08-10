#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
ABBEY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ABBEY_AI="$ABBEY_ROOT/tools/bin/abbey-ai"

passed=0
failed=0

pass() {
  echo "PASS $1"
  passed=$((passed + 1))
}

fail() {
  echo "FAIL $1"
  failed=$((failed + 1))
}

replace_in_file() {
  local old="$1"
  local new="$2"
  local file="$3"

  python3 - "$old" "$new" "$file" <<'PYTHON'
from pathlib import Path
import sys

old, new, filename = sys.argv[1:]
path = Path(filename)
text = path.read_text(encoding="utf-8")

if old not in text:
    raise SystemExit(f"Expected text not found in {filename}: {old}")

path.write_text(text.replace(old, new, 1), encoding="utf-8")
PYTHON
}

assert_contains() {
  local name="$1"
  local output="$2"
  local expected="$3"

  if grep -Fq -- "$expected" <<<"$output"; then
    pass "$name"
  else
    fail "$name"
    echo "     Expected: $expected"
  fi
}

assert_not_contains() {
  local name="$1"
  local output="$2"
  local unexpected="$3"

  if grep -Fq -- "$unexpected" <<<"$output"; then
    fail "$name"
    echo "     Unexpected: $unexpected"
  else
    pass "$name"
  fi
}

assert_status() {
  local name="$1"
  local actual="$2"
  local expected="$3"

  if [[ "$actual" -eq "$expected" ]]; then
    pass "$name"
  else
    fail "$name"
    echo "     Expected status: $expected"
    echo "     Actual status:   $actual"
  fi
}

create_fixture() {
  local fixture_root

  fixture_root="$(mktemp -d)"

  mkdir -p \
    "$fixture_root/.abbey" \
    "$fixture_root/tools/bin" \
    "$fixture_root/tools/lib" \
    "$fixture_root/scripts" \
    "$fixture_root/ansible/inventory" \
    "$fixture_root/ansible/playbooks" \
    "$fixture_root/ansible/roles" \
    "$fixture_root/docs/planning" \
    "$fixture_root/docs/generated" \
    "$fixture_root/docs/runbooks" \
    "$fixture_root/docs/guides" \
    "$fixture_root/content/journal" \
    "$fixture_root/config/ai/decisions/alpha" \
    "$fixture_root/config/ai/decisions/beta" \
    "$fixture_root/config/ai/decisions/broken" \
    "$fixture_root/config/ai/decisions/incomplete" \
    "$fixture_root/config/ai/decisions/next-project"

  cat > "$fixture_root/.abbey/project.yml" <<'YAML'
name: External Abbey Project
YAML

  cp "$ABBEY_ROOT/tools/bin/abbey-knowledge" \
    "$fixture_root/tools/bin/abbey-knowledge"

  cp "$ABBEY_ROOT/tools/lib/config.sh" \
    "$fixture_root/tools/lib/config.sh"

  cp "$ABBEY_ROOT/scripts/abbey_knowledge_manifest.py" \
    "$fixture_root/scripts/abbey_knowledge_manifest.py"

  cat > "$fixture_root/config/abbey.conf" <<'CONFIG'
OPEN_WEBUI_URL="http://project.example.test:3000"
ABBEY_KNOWLEDGE_FILE=".abbey/knowledge/snapshot.md"
ABBEY_AI_AUTO_BUILD_KNOWLEDGE="true"
CONFIG

  cat > "$fixture_root/ansible/inventory/hosts.yml" <<'YAML'
all:
  hosts:
    test01:
YAML

  for file in PROJECT_STATUS NEXT ROADMAP BACKLOG; do
    printf '# %s\n' "$file" \
      > "$fixture_root/docs/planning/$file.md"
  done

  printf '# Abbey CLI\n' \
    > "$fixture_root/docs/guides/abbey-cli.md"

  cat > "$fixture_root/config/ai/decisions/alpha/decision.json" <<'JSON'
{
  "name": "Alpha Decision",
  "description": "Choose the best alpha option."
}
JSON

  cat > "$fixture_root/config/ai/decisions/beta/decision.json" <<'JSON'
{
  "name": "Beta Decision",
  "description": "Choose the best beta option."
}
JSON

  cat > "$fixture_root/config/ai/decisions/broken/decision.json" <<'JSON'
{
  "name": "Broken Decision",
  "description":
}
JSON

  cat > "$fixture_root/config/ai/decisions/next-project/decision.json" <<'JSON'
{
  "name": "Project-Specific Next Project",
  "description": "Use the active project's custom decision definition."
}
JSON

  cp -R \
    "$ABBEY_ROOT/config/ai/decisions/easy-win" \
    "$fixture_root/config/ai/decisions/easy-win"

  cp -R \
    "$ABBEY_ROOT/config/ai/decisions/risk-reducer" \
    "$fixture_root/config/ai/decisions/risk-reducer"

  cp -R \
    "$ABBEY_ROOT/config/ai/decisions/workflow-friction" \
    "$fixture_root/config/ai/decisions/workflow-friction"

  cp -R \
    "$ABBEY_ROOT/config/ai/decisions/backlog-leverage" \
    "$fixture_root/config/ai/decisions/backlog-leverage"

  printf '%s\n' "$fixture_root"
}

echo "Abbey AI Regression Tests"
echo "========================="
echo

fixture_root="$(create_fixture)"
trap 'rm -rf "${fixture_root:-}"' EXIT
toolkit_root="$ABBEY_ROOT"

config_output="$(
  ABBEY_ROOT="$fixture_root" \
    ABBEY_TOOLKIT_ROOT="$toolkit_root" \
    bash -c '
      source "$ABBEY_TOOLKIT_ROOT/tools/lib/config.sh"
      load_abbey_config
      printf "%s\n%s\n%s\n" \
        "$OPEN_WEBUI_URL" \
        "$OLLAMA_URL" \
        "$ABBEY_AI_DECISION_MODEL"
    '
)"

assert_contains \
  "external project inherits toolkit Ollama URL" \
  "$config_output" \
  "http://192.168.1.87:11434"

assert_contains \
  "external project inherits toolkit decision model" \
  "$config_output" \
  "gpt-oss:20b"

assert_contains \
  "external project tracked config overrides toolkit defaults" \
  "$config_output" \
  "http://project.example.test:3000"

set +e
output="$(
  cd "$fixture_root" &&
    "$ABBEY_ROOT/tools/bin/abbey" ai decide --help 2>&1
)"
status=$?
set -e

assert_status \
  "external project help resolves toolkit libraries" \
  "$status" \
  0

assert_contains \
  "external project help uses project decision metadata" \
  "$output" \
  "Alpha Decision"

assert_contains \
  "external project help inherits toolkit decision metadata" \
  "$output" \
  "Time Saver"

assert_contains \
  "external project decision metadata overrides toolkit metadata" \
  "$output" \
  "Project-Specific Next Project"

set +e
output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_AI" decide --help 2>&1)"
status=$?
set -e

assert_status \
  "--help exits successfully" \
  "$status" \
  0

assert_contains \
  "--help shows command usage" \
  "$output" \
  "abbey ai decide [--model MODEL] <decision>"

assert_contains \
  "--help lists synthetic decision id" \
  "$output" \
  "alpha"

assert_contains \
  "--help lists friendly decision name" \
  "$output" \
  "Alpha Decision"

assert_contains \
  "--help lists metadata description" \
  "$output" \
  "Choose the best alpha option."

assert_contains \
  "--help lists second metadata decision" \
  "$output" \
  "Beta Decision"

assert_contains \
  "--help discovers easy-win decision metadata" \
  "$output" \
  "easy-win"

assert_contains \
  "--help describes easy-win selection boundary" \
  "$output" \
  "fully closes existing backlog checkboxes"

assert_contains \
  "--help discovers blocker decision metadata" \
  "$output" \
  "blocker"

assert_contains \
  "--help discovers AI Worker candidate metadata" \
  "$output" \
  "ai-worker-candidate"

assert_contains \
  "--help describes AI Worker delegation boundary" \
  "$output" \
  "delegated AI-worker research or implementation"

ai_worker_prompt="$(
  cat "$ABBEY_ROOT/config/ai/decisions/ai-worker-candidate/prompt.md"
)"

assert_contains \
  "AI Worker prompt distinguishes research candidates" \
  "$ai_worker_prompt" \
  '`research`: investigate a documented question'

assert_contains \
  "AI Worker prompt distinguishes implementation candidates" \
  "$ai_worker_prompt" \
  '`implementation`: complete a bounded, already-defined repository change'

assert_contains \
  "AI Worker prompt prohibits automatic operational work" \
  "$ai_worker_prompt" \
  "Reject work requiring live deployment, destructive changes"

assert_contains \
  "AI Worker prompt labels the proposed command as future work" \
  "$ai_worker_prompt" \
  "not an executable command in the current toolkit"

assert_contains \
  "AI Worker prompt assigns the command to the correct field" \
  "$ai_worker_prompt" \
  'Put that command concept in `proposed_command`.'

ai_worker_schema="$(
  cat "$ABBEY_ROOT/config/ai/decisions/ai-worker-candidate/schema.json"
)"

assert_contains \
  "AI Worker schema requires candidate classification" \
  "$ai_worker_schema" \
  '"candidate_type"'

assert_contains \
  "AI Worker schema permits no-candidate results" \
  "$ai_worker_schema" \
  '"none"'

assert_contains \
  "AI Worker schema requires a proposed command field" \
  "$ai_worker_schema" \
  '"proposed_command"'

assert_contains \
  "AI Worker schema rejects extra output fields" \
  "$ai_worker_schema" \
  '"additionalProperties": false'

assert_contains \
  "shared report presents AI Worker candidate type" \
  "$(cat "$ABBEY_AI")" \
  '("Candidate Type", "candidate_type")'

assert_contains \
  "shared report presents proposed AI Worker command" \
  "$(cat "$ABBEY_AI")" \
  '("Proposed Command", "proposed_command")'

assert_contains \
  "shared report presents AI Worker inputs" \
  "$(cat "$ABBEY_AI")" \
  '("Inputs", "inputs")'

assert_contains \
  "shared report presents AI Worker deliverables" \
  "$(cat "$ABBEY_AI")" \
  '("Deliverables", "deliverables")'

assert_contains \
  "AI Worker result validates candidate and command agreement" \
  "$(cat "$ABBEY_AI")" \
  "AI Worker proposed command does not match its candidate type."

assert_contains \
  "--help describes blocker dependency boundary" \
  "$output" \
  "not independently actionable because prerequisite work remains unfinished"

blocker_prompt="$(
  cat "$ABBEY_ROOT/config/ai/decisions/blocker/prompt.md"
)"

assert_contains \
  "blocker prompt requires an exact pending primary item" \
  "$blocker_prompt" \
  'Name one exact pending checkbox as `primary_backlog_item`.'

assert_contains \
  "blocker prompt requires prerequisite checkboxes" \
  "$blocker_prompt" \
  "must be completed before the"

assert_contains \
  "blocker prompt recognizes regression-before-capability failures" \
  "$blocker_prompt" \
  "Regression coverage for a capability that planning still records as"

assert_contains \
  "blocker prompt rejects adjacency-only inference" \
  "$blocker_prompt" \
  "Do not infer a dependency solely because checkboxes are near each other."

assert_contains \
  "blocker prompt requires repository review for uncertain implementation" \
  "$blocker_prompt" \
  "repository review needed to confirm it"

blocker_schema="$(
  cat "$ABBEY_ROOT/config/ai/decisions/blocker/schema.json"
)"

assert_contains \
  "blocker schema requires a primary backlog item" \
  "$blocker_schema" \
  '"primary_backlog_item"'

assert_contains \
  "blocker schema requires at least one blocking item" \
  "$blocker_schema" \
  '"minItems": 1'

blocker_checkbox_pattern_count="$(
  grep -Fc '"pattern": "^- \\[ \\] .+$"' \
    "$ABBEY_ROOT/config/ai/decisions/blocker/schema.json"
)"

if [[ "$blocker_checkbox_pattern_count" -eq 2 ]]; then
  pass "blocker schema enforces pending checkbox syntax"
else
  fail "blocker schema enforces pending checkbox syntax"
fi

assert_contains \
  "blocker schema caps implementation confidence" \
  "$blocker_schema" \
  '"maximum": 0.25'

assert_contains \
  "blocker schema rejects extra output fields" \
  "$blocker_schema" \
  '"additionalProperties": false'

easy_win_prompt="$(
  cat "$ABBEY_ROOT/config/ai/decisions/easy-win/prompt.md"
)"

assert_contains \
  "easy-win prompt requires parent checkbox completion" \
  "$easy_win_prompt" \
  "Fully complete at least one existing pending parent checkbox"

assert_contains \
  "easy-win prompt includes all required child work" \
  "$easy_win_prompt" \
  "Include every nested child item required to mark that parent complete."

assert_contains \
  "easy-win prompt rejects material advancement" \
  "$easy_win_prompt" \
  "Merely advance, enable, investigate, or partially complete a backlog item."

assert_contains \
  "easy-win prompt rejects open-ended backlog parents" \
  "$easy_win_prompt" \
  "Select an open-ended or recurring parent"

assert_contains \
  "easy-win prompt requires finite completion criteria" \
  "$easy_win_prompt" \
  "explicit nested criteria define a finite state"

assert_contains \
  "easy-win prompt requires zero new backlog items" \
  "$easy_win_prompt" \
  'Set `new_backlog_items_expected` to zero.'

assert_contains \
  "easy-win prompt verifies net reduction arithmetic" \
  "$easy_win_prompt" \
  '`expected_net_backlog_reduction` equals the number of unique parent'

assert_contains \
  "easy-win prompt prohibits invented implementation details" \
  "$easy_win_prompt" \
  "Do not name"

assert_contains \
  "easy-win prompt prohibits invented commands" \
  "$easy_win_prompt" \
  "broad workflow item into a specific command or feature design."

assert_contains \
  "easy-win prompt requires repository review" \
  "$easy_win_prompt" \
  "implementation details as assumptions and list the repository review required"

assert_contains \
  "easy-win prompt caps implementation confidence" \
  "$easy_win_prompt" \
  "keep implementation confidence at"

assert_contains \
  "easy-win prompt leaves implementation unknown" \
  "$easy_win_prompt" \
  '`unknown-pending-repository-review`'

assert_contains \
  "easy-win prompt prohibits guessed solutions in all output" \
  "$easy_win_prompt" \
  "must not fill"

easy_win_schema="$(
  cat "$ABBEY_ROOT/config/ai/decisions/easy-win/schema.json"
)"

assert_contains \
  "easy-win schema requires closed backlog parents" \
  "$easy_win_schema" \
  '"backlog_parents_closed"'

assert_contains \
  "easy-win schema requires exact completion checkboxes" \
  "$easy_win_schema" \
  '"completion_checkboxes"'

checkbox_pattern_count="$(
  grep -Fc '"pattern": "^- \\[ \\] .+$"' \
    "$ABBEY_ROOT/config/ai/decisions/easy-win/schema.json"
)"

if [[ "$checkbox_pattern_count" -eq 2 ]]; then
  pass "easy-win schema enforces pending checkbox syntax in both arrays"
else
  fail "easy-win schema enforces pending checkbox syntax in both arrays"
fi

assert_contains \
  "easy-win schema requires child scope" \
  "$easy_win_schema" \
  '"required_subtasks"'

assert_contains \
  "easy-win schema requires excluded optional work" \
  "$easy_win_schema" \
  '"optional_work_excluded"'

assert_contains \
  "easy-win schema caps new backlog items at zero" \
  "$easy_win_schema" \
  '"maximum": 0'

assert_contains \
  "easy-win schema requires positive net reduction" \
  "$easy_win_schema" \
  '"expected_net_backlog_reduction"'

assert_contains \
  "easy-win schema separates recommendation confidence" \
  "$easy_win_schema" \
  '"recommendation_confidence"'

assert_contains \
  "easy-win schema separates implementation confidence" \
  "$easy_win_schema" \
  '"implementation_confidence"'

assert_contains \
  "easy-win schema caps implementation confidence" \
  "$easy_win_schema" \
  '"maximum": 0.25'

assert_contains \
  "easy-win schema fixes implementation approach" \
  "$easy_win_schema" \
  '"unknown-pending-repository-review"'

assert_contains \
  "easy-win schema prohibits undocumented implementation details" \
  "$easy_win_schema" \
  '"documented_implementation_details"'

assert_contains \
  "easy-win schema prohibits extra output fields" \
  "$easy_win_schema" \
  '"additionalProperties": false'

assert_not_contains \
  "easy-win schema omits free-form summary" \
  "$easy_win_schema" \
  '"summary"'

assert_not_contains \
  "easy-win schema omits free-form priority reason" \
  "$easy_win_schema" \
  '"priority_reason"'

assert_not_contains \
  "easy-win schema omits speculative assumptions" \
  "$easy_win_schema" \
  '"assumptions"'

assert_contains \
  "easy-win schema requires repository review" \
  "$easy_win_schema" \
  '"repository_review_required"'

assert_contains \
  "shared report presents backlog parents closed" \
  "$(cat "$ABBEY_AI")" \
  '("Backlog Parents Closed", "backlog_parents_closed")'

assert_contains \
  "shared report presents completion checkboxes" \
  "$(cat "$ABBEY_AI")" \
  '("Completion Checkboxes", "completion_checkboxes")'

assert_contains \
  "shared report presents required subtasks" \
  "$(cat "$ABBEY_AI")" \
  '("Required Subtasks", "required_subtasks")'

assert_contains \
  "shared report presents excluded optional work" \
  "$(cat "$ABBEY_AI")" \
  '("Optional Work Excluded", "optional_work_excluded")'

assert_contains \
  "shared report presents new backlog expectation" \
  "$(cat "$ABBEY_AI")" \
  '("New Backlog Items Expected", "new_backlog_items_expected")'

assert_contains \
  "shared report presents expected net reduction" \
  "$(cat "$ABBEY_AI")" \
  '("Expected Net Backlog Reduction", "expected_net_backlog_reduction")'

assert_contains \
  "shared report renders empty easy-win scope explicitly" \
  "$(cat "$ABBEY_AI")" \
  '"optional_work_excluded",'

assert_contains \
  "shared report preserves checkbox formatting" \
  "$(cat "$ABBEY_AI")" \
  'and item.startswith("- [")'

assert_contains \
  "shared report preserves blocker checkbox formatting" \
  "$(cat "$ABBEY_AI")" \
  '"blocking_items",'

assert_contains \
  "shared report presents unknown implementation approach" \
  "$(cat "$ABBEY_AI")" \
  '("Implementation Approach", "implementation_approach")'

assert_contains \
  "shared report presents documented implementation details" \
  "$(cat "$ABBEY_AI")" \
  '("Documented Implementation Details", "documented_implementation_details")'

assert_contains \
  "--help discovers risk-reducer decision metadata" \
  "$output" \
  "risk-reducer"

assert_contains \
  "--help describes risk-reducer selection boundary" \
  "$output" \
  "smallest practical, one-session change"

assert_contains \
  "risk-reducer prompt prohibits invented implementation details" \
  "$(cat "$ABBEY_ROOT/config/ai/decisions/risk-reducer/prompt.md")" \
  "Do not name implementation"

assert_contains \
  "risk-reducer prompt requires repository review" \
  "$(cat "$ABBEY_ROOT/config/ai/decisions/risk-reducer/prompt.md")" \
  "List the repository review required before implementation."

assert_contains \
  "risk-reducer prompt caps implementation confidence" \
  "$(cat "$ABBEY_ROOT/config/ai/decisions/risk-reducer/prompt.md")" \
  "implementation confidence must not exceed 0.5"

risk_reducer_schema="$(
  cat "$ABBEY_ROOT/config/ai/decisions/risk-reducer/schema.json"
)"

assert_contains \
  "risk-reducer schema separates recommendation confidence" \
  "$risk_reducer_schema" \
  '"recommendation_confidence"'

assert_contains \
  "risk-reducer schema separates implementation confidence" \
  "$risk_reducer_schema" \
  '"implementation_confidence"'

assert_contains \
  "risk-reducer schema caps implementation confidence" \
  "$risk_reducer_schema" \
  '"maximum": 0.5'

assert_contains \
  "risk-reducer schema requires repository review" \
  "$risk_reducer_schema" \
  '"repository_review_required"'

assert_contains \
  "--help discovers workflow-friction decision metadata" \
  "$output" \
  "workflow-friction"

assert_contains \
  "--help describes workflow-friction selection boundary" \
  "$output" \
  "most costly recurring manual step"

assert_contains \
  "--help discovers backlog-leverage decision metadata" \
  "$output" \
  "backlog-leverage"

assert_contains \
  "--help describes backlog-leverage selection boundary" \
  "$output" \
  "largest coherent set of backlog items"

backlog_leverage_prompt="$(
  cat "$ABBEY_ROOT/config/ai/decisions/backlog-leverage/prompt.md"
)"

assert_contains \
  "backlog-leverage prompt requires one bounded outcome" \
  "$backlog_leverage_prompt" \
  "one bounded outcome"

assert_contains \
  "backlog-leverage prompt prohibits unrelated task bundling" \
  "$backlog_leverage_prompt" \
  "Combine independent tasks solely to increase the coverage count."

assert_contains \
  "backlog-leverage prompt ranks completion above enablement" \
  "$backlog_leverage_prompt" \
  "as weaker coverage than completion"

assert_contains \
  "backlog-leverage prompt requires coverage-count verification" \
  "$backlog_leverage_prompt" \
  "confirmed coverage count equals the number"

backlog_leverage_schema="$(
  cat "$ABBEY_ROOT/config/ai/decisions/backlog-leverage/schema.json"
)"

assert_contains \
  "backlog-leverage schema requires confirmed coverage count" \
  "$backlog_leverage_schema" \
  '"confirmed_coverage_count"'

assert_contains \
  "backlog-leverage schema requires coverage map" \
  "$backlog_leverage_schema" \
  '"coverage_map"'

assert_contains \
  "backlog-leverage schema classifies completion" \
  "$backlog_leverage_schema" \
  '"completes"'

assert_contains \
  "backlog-leverage schema classifies material advancement" \
  "$backlog_leverage_schema" \
  '"materially-advances"'

assert_contains \
  "backlog-leverage schema classifies direct enablement" \
  "$backlog_leverage_schema" \
  '"directly-enables"'

assert_contains \
  "shared report presents backlog shared outcome" \
  "$(cat "$ABBEY_AI")" \
  '("Shared Outcome", "shared_outcome")'

assert_contains \
  "shared report presents primary backlog item" \
  "$(cat "$ABBEY_AI")" \
  '("Primary Backlog Item", "primary_backlog_item")'

assert_contains \
  "shared report presents confirmed coverage" \
  "$(cat "$ABBEY_AI")" \
  '("Confirmed Coverage", "confirmed_coverage_count")'

assert_contains \
  "shared report presents backlog coverage map" \
  "$(cat "$ABBEY_AI")" \
  'coverage_map = result.get("coverage_map", [])'

workflow_friction_prompt="$(
  cat "$ABBEY_ROOT/config/ai/decisions/workflow-friction/prompt.md"
)"

assert_contains \
  "workflow-friction prompt prioritizes recurring friction" \
  "$workflow_friction_prompt" \
  "not a one-off annoyance"

assert_contains \
  "workflow-friction prompt distinguishes evidence from assumptions" \
  "$workflow_friction_prompt" \
  "Distinguish evidence from assumptions explicitly."

assert_contains \
  "workflow-friction prompt prohibits invented implementation details" \
  "$workflow_friction_prompt" \
  "Do not name implementation"

assert_contains \
  "workflow-friction prompt separates confidence values" \
  "$workflow_friction_prompt" \
  "implementation confidence must not exceed 0.5"

assert_contains \
  "workflow-friction prompt requires repository review" \
  "$workflow_friction_prompt" \
  "List the repository review required before implementation."

assert_contains \
  "workflow-friction prompt requires improvement classification" \
  "$workflow_friction_prompt" \
  "Classify the bounded improvement as exactly one of:"

workflow_friction_schema="$(
  cat "$ABBEY_ROOT/config/ai/decisions/workflow-friction/schema.json"
)"

assert_contains \
  "workflow-friction schema requires recurrence evidence" \
  "$workflow_friction_schema" \
  '"recurrence_evidence"'

assert_contains \
  "workflow-friction schema requires bounded improvement" \
  "$workflow_friction_schema" \
  '"bounded_improvement"'

assert_contains \
  "workflow-friction schema separates recommendation confidence" \
  "$workflow_friction_schema" \
  '"recommendation_confidence"'

assert_contains \
  "workflow-friction schema caps implementation confidence" \
  "$workflow_friction_schema" \
  '"maximum": 0.5'

assert_contains \
  "workflow-friction schema requires repository review" \
  "$workflow_friction_schema" \
  '"repository_review_required"'

assert_contains \
  "workflow-friction schema classifies an Abbey command" \
  "$workflow_friction_schema" \
  '"abbey-command"'

assert_contains \
  "workflow-friction schema classifies a standardized workflow" \
  "$workflow_friction_schema" \
  '"standardized-workflow"'

assert_contains \
  "workflow-friction schema classifies a local fix" \
  "$workflow_friction_schema" \
  '"local-fix"'

assert_contains \
  "shared report presents recurring workflow" \
  "$(cat "$ABBEY_AI")" \
  '("Recurring Workflow", "recurring_workflow")'

assert_contains \
  "shared report presents improvement classification" \
  "$(cat "$ABBEY_AI")" \
  '("Classification", "improvement_classification")'

assert_contains \
  "shared report presents recurrence evidence" \
  "$(cat "$ABBEY_AI")" \
  '("Recurrence Evidence", "recurrence_evidence")'

assert_not_contains \
  "--help ignores invalid JSON" \
  "$output" \
  "Broken Decision"

assert_not_contains \
  "--help ignores directories without metadata" \
  "$output" \
  "incomplete"

set +e
output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_AI" decide help 2>&1)"
status=$?
set -e

assert_status \
  "help argument exits successfully" \
  "$status" \
  0

assert_contains \
  "help argument shows decision listing" \
  "$output" \
  "Alpha Decision"

set +e
output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_AI" decide 2>&1)"
status=$?
set -e

assert_status \
  "missing decision exits with error" \
  "$status" \
  1

assert_contains \
  "missing decision still shows help" \
  "$output" \
  "Available decisions:"

set +e
output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_AI" decide --bogus 2>&1)"
status=$?
set -e

assert_status \
  "unknown option exits with error" \
  "$status" \
  1

assert_contains \
  "unknown option reports the option" \
  "$output" \
  "Unknown option: --bogus"

mv \
  "$fixture_root/config/ai/decisions" \
  "$fixture_root/config/ai/decisions.saved"

set +e
output="$(ABBEY_ROOT="$fixture_root" "$ABBEY_AI" decide --help 2>&1)"
status=$?
set -e

assert_status \
  "missing decisions directory help exits successfully" \
  "$status" \
  0

assert_contains \
  "missing project decisions inherit toolkit defaults" \
  "$output" \
  "Next Project"


ABBEY_ROOT="$fixture_root" \
  "$fixture_root/tools/bin/abbey-knowledge" build \
  >/dev/null

initial_hash="$(
  python3 -c '
import json
import sys
print(json.load(open(sys.argv[1]))["repository_hash"])
' "$fixture_root/.abbey/knowledge/metadata.json"
)"

printf '\n- auto-build freshness change\n' \
  >> "$fixture_root/docs/planning/BACKLOG.md"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$ABBEY_AI" context 2>&1
)"
status=$?
set -e

rebuilt_hash="$(
  python3 -c '
import json
import sys
print(json.load(open(sys.argv[1]))["repository_hash"])
' "$fixture_root/.abbey/knowledge/metadata.json"
)"

set +e
ABBEY_ROOT="$fixture_root" \
  "$fixture_root/tools/bin/abbey-knowledge" status \
  >/tmp/abbey-ai-auto-status.out 2>&1
auto_status=$?
set -e

assert_status \
  "AI context succeeds when auto-build refreshes stale knowledge" \
  "$status" \
  0

if [[ "$rebuilt_hash" != "$initial_hash" ]]; then
  pass "AI context rebuilds stale knowledge when auto-build is enabled"
else
  fail "AI context rebuilds stale knowledge when auto-build is enabled"
fi

assert_status \
  "auto-built knowledge reports fresh" \
  "$auto_status" \
  0

replace_in_file \
  'ABBEY_AI_AUTO_BUILD_KNOWLEDGE="true"' \
  'ABBEY_AI_AUTO_BUILD_KNOWLEDGE="false"' \
  "$fixture_root/config/abbey.conf"

disabled_hash_before="$(
  python3 -c '
import json
import sys
print(json.load(open(sys.argv[1]))["repository_hash"])
' "$fixture_root/.abbey/knowledge/metadata.json"
)"

printf '\n- disabled freshness change\n' \
  >> "$fixture_root/docs/planning/BACKLOG.md"

set +e
output="$(
  ABBEY_ROOT="$fixture_root" \
    "$ABBEY_AI" context 2>&1
)"
status=$?
set -e

disabled_hash_after="$(
  python3 -c '
import json
import sys
print(json.load(open(sys.argv[1]))["repository_hash"])
' "$fixture_root/.abbey/knowledge/metadata.json"
)"

assert_status \
  "AI context exits nonzero when stale auto-build is disabled" \
  "$status" \
  1

assert_contains \
  "disabled auto-build reports stale knowledge" \
  "$output" \
  "WARN Abbey knowledge is stale"

if [[ "$disabled_hash_after" == "$disabled_hash_before" ]]; then
  pass "disabled auto-build leaves knowledge metadata unchanged"
else
  fail "disabled auto-build leaves knowledge metadata unchanged"
fi

echo
echo "Passed: $passed"
echo "Failed: $failed"

if [[ "$failed" -gt 0 ]]; then
  exit 1
fi
