```markdown
---
title: Abbey Research Status Implementation
date: 2026-07-22
session: abbey-research-status-implementation
status: complete
reviewed: false
type: session-update
tags:
  - abbey-root
  - research
  - cli
  - deterministic-workflows
  - voice-analysis
---

# Abbey Research Status Implementation

## Objective

Implement the first deterministic `abbey research status` command based on the approved research status architecture.

## Definition of Done

- Register `abbey research status` through existing Abbey CLI conventions.
- Discover formal research artifacts from supported research directories.
- Parse required YAML frontmatter fields.
- Index artifacts by `artifact_id`.
- Resolve corpus, experiment, and parent relationships.
- Report the three current Voice Analysis artifact chains.
- Report legacy references as provenance information rather than failures.
- Ignore supporting Markdown files that are not formal artifacts.
- Keep the command deterministic and read-only.
- Add regression coverage using the real repository.
- Preserve existing research command behavior.

## Work Completed

Implemented the new `abbey research status` subcommand.

Updated `tools/bin/abbey-research` to:

- Include `abbey research status` in command help.
- Provide dedicated `status --help` output.
- Dispatch the status command to the deterministic Python implementation.
- Reject unsupported status options.

Updated `config/cli/cli.yml` to:

- Register the `status` research subcommand.
- Update the research command description.
- Add `abbey research status` to command examples.

Created:

```text
scripts/abbey_research_status.py
```

The implementation:

- Scans projects beneath `docs/research`.
- Searches only supported artifact directories:
  - `corpus`
  - `experiments`
  - `observations`
  - `evidence`
  - `hypotheses`
  - `validation`
- Reads YAML frontmatter from Markdown files.
- Requires the following formal artifact fields:
  - `artifact_id`
  - `artifact_type`
  - `title`
  - `version`
  - `status`
- Ignores Markdown files without formal artifact metadata.
- Validates artifact type against its containing directory.
- Indexes discovered artifacts by `artifact_id`.
- Reads corpus, experiment, and parent references from `source` metadata.
- Builds deterministic observation-to-validation chains.
- Separates unresolved legacy parent references into provenance reporting.
- Produces a read-only Abbey-style status report.

## Current Repository Results

The command currently discovers one formal research project:

```text
voice-analysis
```

Formal artifact counts:

```text
Corpus:       1
Experiments:  1
Observations: 3
Evidence:     3
Hypotheses:   3
Validations:  3
```

Total formal artifacts:

```text
14
```

Complete chains:

```text
OBS-001 -> EVID-001 -> HYP-001 -> VAL-001
OBS-002 -> EVID-002 -> HYP-002 -> VAL-002
OBS-003 -> EVID-003 -> HYP-003 -> VAL-003
```

Chain summary:

```text
Complete chains:      3
Incomplete chains:    0
```

Legacy provenance references:

```text
EVID-001 -> EVIDENCE004-deadpan-delivery
EVID-002 -> EVIDENCE003-preference-for-concise-writing
EVID-003 -> EVIDENCE005-recurring-narrative-elements
OBS-001 -> OBSERVATION004-deadpan-delivery
OBS-002 -> OBSERVATION003-preference-for-concise-writing
OBS-003 -> OBSERVATION005-recurring-narrative-elements
```

These six references are reported as informational provenance rather than broken formal relationships.

## Testing

Expanded `tests/test-abbey-research.sh` with regression coverage for:

- Status command visibility in help.
- Successful execution against the real repository.
- Voice Analysis project discovery.
- Formal artifact count.
- All three complete artifact chains.
- Complete-chain summary.
- Legacy provenance reporting.

The research regression suite increased from 17 tests to 26 tests.

Validation results:

```text
Passed: 26
Failed: 0
```

Additional validation completed:

```bash
bash -n tools/bin/abbey tools/bin/abbey-review tools/bin/abbey-research
python3 -m py_compile scripts/abbey_research_status.py
tests/test-abbey-research.sh
abbey help
abbey research status
git diff --check
```

All checks passed.

## Files Changed

```text
M  config/cli/cli.yml
M  docs/planning/NEXT.md
M  tests/test-abbey-research.sh
M  tools/bin/abbey-research
A  scripts/abbey_research_status.py
```

## Design Decisions

The first implementation intentionally focuses on the current repository happy path.

Unresolved parent references that do not match discovered formal artifact IDs are treated conservatively as legacy provenance references. This avoids incorrectly classifying historical identifiers as broken relationships.

The command remains deterministic and read-only. It does not modify research artifacts, planning documents, or generated indexes.

Supporting Markdown files are ignored unless they contain the required formal artifact frontmatter.

## Deferred Work

The following architecture cases were intentionally deferred to a focused refinement session:

- Duplicate artifact IDs.
- Malformed YAML frontmatter.
- Formal artifacts missing required fields.
- Directory and artifact-type mismatches.
- Broken formal corpus references.
- Broken formal experiment references.
- Broken formal parent references.
- Missing expected chain stages.
- Multiple competing children within a chain.
- Synthetic fixtures for warning and failure exit states.
- Full architecture-defined severity and exit-code behavior.

## Suggested Next Step

Create a focused `abbey research status` refinement session that adds synthetic fixtures and deterministic reporting for invalid, incomplete, duplicate, and broken artifact states.
```
