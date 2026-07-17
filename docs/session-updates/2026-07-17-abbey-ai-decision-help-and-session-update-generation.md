---
title: "Abbey AI Decision Help and Session Update Generation"
description: "Added metadata-driven Abbey AI decision help and a reusable command for generating standardized session updates."
date: 2026-07-17
status: complete
reviewed: true
session: primary
tags:
  - Abbey Root
  - Abbey Framework
  - Developer Toolkit
  - Session Workflow
  - Artificial Intelligence
  - Automation
---

# Abbey AI Decision Help and Session Update Generation

## Objective

Improve two recurring Abbey workflows:

1. Make `abbey ai decide` self-documenting by generating its available decision listing from decision-definition metadata.
2. Add `abbey session update` to create standardized session updates without manually recreating the template.

## Definition of Done

### Abbey AI Decision Help

- `abbey ai decide --help` exits successfully.
- `abbey ai decide help` exits successfully.
- Running `abbey ai decide` without a decision displays useful guidance and exits with an error.
- Available decision IDs, friendly names, and descriptions are loaded from `decision.json` metadata.
- Invalid or incomplete decision directories are ignored safely.
- Existing decision execution continues to work.
- Regression tests protect the help and discovery behavior.

### Session Update Generation

- `abbey session update <slug>` creates a dated session update.
- `--title TITLE` supports an explicit human-readable title.
- A readable title is derived automatically when no title is supplied.
- Generated files use the repository's standard session update structure.
- Existing files are never overwritten.
- Invalid slugs and unsupported options produce clear errors.
- CLI metadata and command help document the new subcommand.
- Regression tests protect the generation behavior.

## Summary

Abbey Root now provides discoverable help for structured AI decisions and a reusable command for creating session updates.

The AI decision workflow no longer relies on hardcoded or directory-only output when users need to discover available decisions. Help output is generated from each decision definition's metadata, preserving the metadata directory as the source of truth.

The session workflow now includes `abbey session update [--title TITLE] <slug>`.

The command creates a dated Markdown file under `docs/session-updates/` using a standard template and refuses to overwrite existing work.

Together, these changes reduce manual lookup, repeated formatting work, and inconsistency in two frequently used Abbey workflows.

## Accomplishments

### Metadata-Driven AI Decision Help

Added a reusable help renderer to `tools/bin/abbey-ai`.

The command now supports:

- `abbey ai decide --help`
- `abbey ai decide -h`
- `abbey ai decide help`

Help output includes:

- Command usage.
- Model override options.
- Available decision IDs.
- Friendly decision names.
- Decision descriptions.

Available decisions are discovered dynamically from:

`config/ai/decisions/*/decision.json`

The implementation ignores:

- Directories without `decision.json`.
- Invalid JSON metadata.
- Incomplete decision definitions.

Running `abbey ai decide` without a decision now displays the same useful help while preserving a nonzero exit status.

Existing execution was smoke-tested with:

`abbey ai decide --model gpt-oss:20b time-saver`

### Abbey AI Regression Coverage

Added:

`tests/test-abbey-ai.sh`

The test uses an isolated synthetic decision library containing:

- Two valid decisions.
- One invalid JSON definition.
- One incomplete directory.
- A fixture with no decision directory.

Coverage verifies:

- Help exit status.
- Usage output.
- Metadata-driven IDs, names, and descriptions.
- Safe handling of invalid metadata.
- Safe handling of incomplete directories.
- Missing-decision behavior.
- Unknown-option behavior.
- Empty decision-library behavior.

Final result:

- Passed: 16
- Failed: 0

### Session Update Generator

Extended `tools/bin/abbey-session` with:

`abbey session update [--title TITLE] <slug>`

The command:

- Derives the current date.
- Validates lowercase hyphenated slugs.
- Derives a readable title from the slug.
- Preserves common technical initialisms such as `AI` and `CLI`.
- Accepts an explicit title through `--title`.
- Creates the session-update directory when necessary.
- Writes through a temporary file.
- Applies standard file permissions.
- Refuses to overwrite an existing session update.
- Prints the created repository-relative path and the recommended next action.

Generated files include:

- YAML front matter.
- Objective.
- Definition of Done.
- Summary.
- Accomplishments.
- Impact.
- Validation.
- Lessons Learned.
- Next Steps.
- Notes.

### Session Update Regression Coverage

Added:

`tests/test-abbey-session-update.sh`

The regression fixture verifies:

- Help output.
- Missing-slug errors.
- File creation.
- Expected dated filename.
- Automatic title generation.
- Explicit title overrides.
- Standard metadata values.
- Required document sections.
- Overwrite protection.
- Invalid-slug rejection.

Final result:

- Passed: 18
- Failed: 0

### CLI Metadata

Updated `config/cli/cli.yml` to include the new subcommand:

`abbey session update [--title TITLE] <slug>`

Added the command to the session workflow examples.

### Planning Reconciliation

Marked the completed backlog item:

`Add discoverable abbey ai decide help and decision listing generated from decision-definition metadata.`

as complete.

## Impact

These improvements remove two recurring sources of manual work.

Users can now discover valid AI decisions directly from the command line without inspecting configuration directories or source code.

Session updates can now be initialized consistently with a single command instead of manually copying an older document and replacing its contents.

The implementation also reinforces Abbey's design principles:

- Metadata remains the source of truth.
- Common workflows are exposed through Abbey commands.
- Generated artifacts follow repository standards.
- Commands remain predictable and scriptable.
- Regression tests protect behavior before further automation is added.

## Validation

Completed validation included:

- `bash -n tools/bin/abbey-ai`
- `bash -n tools/bin/abbey-session`
- `bash -n tests/test-abbey-ai.sh`
- `bash -n tests/test-abbey-session-update.sh`
- `git diff --check`

Regression results:

- `tests/test-abbey-ai.sh`
  - Passed: 16
  - Failed: 0

- `tests/test-abbey-session-update.sh`
  - Passed: 18
  - Failed: 0

- `tests/test-abbey-next.sh`
  - Passed: 16
  - Failed: 0

Live command validation included:

- `abbey ai decide --help`
- `abbey ai decide --model gpt-oss:20b time-saver`
- `abbey session update --help`
- `abbey session help`

The real session update was successfully created using:

`abbey session update --title "Abbey AI Decision Help and Session Update Generation" abbey-ai-decision-help-and-session-update-generation`

## Lessons Learned

### Metadata-Driven Help Is a Platform Feature

Once a capability is defined through metadata, discovery should use that same metadata rather than maintaining a second hardcoded list.

This keeps command output synchronized automatically as new decisions are added.

### Generators Should Remain Small Initially

The first version of `abbey session update` intentionally avoids prompts, editor integration, and complex session-state inference.

A deterministic file generator is easier to test, reuse, and extend after real usage reveals which additional behavior is valuable.

### Overwrite Protection Is Essential

Session updates are historical engineering records.

A generator should fail clearly rather than silently replacing an existing document.

### Repository Standards Need Executable Workflows

Documenting the expected session-update structure is useful, but providing a command that creates the structure makes consistent adoption much more likely.

### Fixtures Improve CLI Testing

Allowing the session command to respect an externally supplied `ABBEY_ROOT` made isolated regression testing practical without modifying the live repository.

This pattern may be useful for testing other Abbey commands.

## Next Steps

- Use `abbey session update` during future sessions and refine the workflow through practical usage.
- Consider supporting optional descriptions or tags during session-update creation.
- Consider adding `abbey session validate` to verify session-update metadata and required sections.
- Continue expanding the Abbey AI decision framework with additional metadata validation.
- Continue adding reusable workflow commands that eliminate repetitive engineering tasks.

## Notes

This session began as a focused improvement to `abbey ai decide` help.

While preparing the required session documentation, the lack of a dedicated session-update creation command became an immediate example of recurring manual workflow overhead.

Rather than manually creating another session update, the session implemented and validated the reusable Abbey command first, then used that command to generate this document.
