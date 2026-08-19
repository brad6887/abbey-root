---
title: "Fix Session Review Help"
description: "Allow abbey session review help to work without requiring the Codex CLI."
date: 2026-08-19
status: pending
reviewed: false
session: fix-session-review-help
tags:
  - Abbey Root
  - CLI
  - Session Review
  - Codex
  - Portability
---

# Fix Session Review Help

## Objective

Allow `abbey session review` help to be displayed on hosts where the Codex CLI
is not installed.

## Definition of Done

- `abbey session review help` succeeds without Codex.
- `abbey session review -h` succeeds without Codex.
- `abbey session review --help` succeeds without Codex.
- Actual `abbey session review` execution continues to require Codex.
- Existing session-review behavior remains unchanged.
- Regression tests cover both help handling and the Codex dependency.
- Abbey validation remains green.

## Summary

`abbey session review` intentionally uses the Codex CLI to perform read-only
session reconciliation.

The command previously checked for Codex before interpreting the review
argument. On a host without Codex, even a request for help failed:

    abbey session review --help
    ERROR Codex CLI is not available.

The review command now handles its supported help forms before performing the
Codex dependency check.

Actual session review behavior remains Codex-backed and unchanged.

## Accomplishments

- Updated `session_review()` to recognize:
  - `help`
  - `-h`
  - `--help`
- Moved help handling ahead of the Codex availability check.
- Preserved the existing failure behavior for actual reviews when Codex is
  unavailable.
- Expanded `tests/test-abbey-session-review.sh` from prompt-content checks to
  include executable CLI behavior.
- Made the Codex-unavailable tests deterministic rather than dependent on the
  software installed on the test host.
- Verified all three review help forms directly on `ai-worker01`.

## Impact

Abbey session review is now self-describing even on partially provisioned
hosts.

Users can inspect the command and learn that it uses Codex without first
installing Codex.

This improves CLI consistency and portability while preserving the existing
review architecture.

## Validation

The session-review test suite passed:

    Passed: 13
    Failed: 0

Direct user-facing checks on `ai-worker01` produced:

    abbey session review help
    exit=0

    abbey session review -h
    exit=0

    abbey session review --help
    exit=0

Actual review execution still correctly requires Codex:

    abbey session review
    ERROR Codex CLI is not available.
    exit=1

Additional validation completed successfully:

    git diff --check
    abbey validate

## Lessons Learned

Optional runtime dependencies should be checked when the dependent operation
is actually executed, after basic command-line argument handling such as help.

A command should still be able to explain itself when an optional execution
dependency is unavailable.

Behavioral CLI tests are more valuable here than source-text checks alone
because they validate the actual user-facing contract.

## Next Steps

- Leave Codex installation on `ai-worker01` deferred until the desired host
  provisioning approach is decided.
- Keep `abbey session review` Codex-backed unless a separate future design
  session establishes a reason to support additional review providers.
- Continue using executable regression coverage for CLI behavior discovered
  through real external-project use.

## Notes

This session intentionally does not install Codex, add a fallback review
provider, or change the session-review architecture.

The scope is limited to correct help behavior and regression coverage.
