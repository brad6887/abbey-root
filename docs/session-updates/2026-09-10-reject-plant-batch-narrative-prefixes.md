---
title: "Reject Plant Batch Narrative Prefixes"
description: "Reject generated narrative prefixes in plant batch validation and apply."
date: 2026-09-10
status: pending
reviewed: false
session: reject-plant-batch-narrative-prefixes
journal: "content/journal/2026/2026-09-10-reject-plant-batch-narrative-prefixes.md"
tags:
  - Abbey Root
---

# Reject Plant Batch Narrative Prefixes

## Objective

Prevent an included plant narrative that begins with the generated `REQUIRED:`
prefix from passing worksheet validation or reaching canonical histories.

## Definition of Done

- Share the prefix check between validate, dry-run apply, and apply.
- Reject unchanged placeholders and prefixed completed prose before writes.
- Preserve ordinary prose and later occurrences of required or REQUIRED.
- Cover rejection, accepted prose, and whole-batch preservation in the existing tests.
- Clarify prefix removal and omission of plants without photos in the runbook.
- Validate and review a focused commit without altering existing plant material
  or publishing either website.

## Summary

Completed the process follow-up to the earlier plant narrative cleanup. The old
checks rejected only the complete generated placeholder sentence, so a completed
narrative with its marker still attached could validate and apply.

Both command paths now use one narrative validator. It trims surrounding
whitespace using the existing convention, rejects an empty narrative, and rejects
the exact case-sensitive generated prefix at the start. Preparation derives its
unchanged placeholder sentence from the same prefix constant.

## Accomplishments

- Replaced duplicate narrative checks in validate and apply with a shared helper.
- Kept whole-batch validation ahead of every canonical write.
- Added regression coverage to the existing shell suite, including an invalid
  final plant after a valid first plant and content-hash preservation checks.
- Retained the empty-narrative error and normal prose containing required,
  REQUIRED, or REQUIRED: later in the text.
- Recorded this session before updating the multi-plant runbook.
- Updated the runbook to require removal of the prefix, show explicit worksheet
  validation, and explain that plants skipped for no photos need no entry.

## Impact

Validate, dry-run apply, and apply return exit status 1 for a prefixed narrative
and report, for example:

```text
FAIL something: narrative starts with REQUIRED:; remove the prefix and provide an observation narrative
```

The final validation summary states that no files changed. The check does not
ban the word globally or reject a lowercase `required:` prefix. No plant content,
photo selection, worksheet generation format, export, or publication behavior
was changed.

## Validation

- Baseline `bash tests/test-abbey-plant-update-batch.sh`: 44 passed, 0 failed.
- Added regressions reproduced the old bug in disposable fixtures before the
  implementation change; the fixture apply wrote a prefixed narrative.
- Updated `bash tests/test-abbey-plant-update-batch.sh`: 94 passed, 0 failed.
- `bash tests/test-abbey-plant-update.sh`: 18 passed, 0 failed.
- `bash tests/test-abbey-plant.sh`: 135 passed, 0 failed.
- The public `abbey plant update-batch validate <worksheet>` command returned
  status 1 with the documented prefix error for an isolated fixture.
- `abbey docs check` and `abbey validate`: passed.
- `abbey site build`: passed; 166 pages and both required Abbey Root routes.
  This was a local build, with no publication.
- `abbey review`: passed; changed session metadata is valid. It reported
  pre-existing missing front matter in
  `docs/session-updates/2026-09-03-abbey-lab-healthcheck.md`, left unchanged.
- `git diff --check` passed; `git status` and `git diff` showed only this
  task's implementation, test, runbook, session update, and journal files.
- Preservation checks matched all 1,045 baseline files under canonical plants,
  plant worksheets, and incoming photos: file inventory, sizes, and modification
  times were unchanged, along with hashes for text, YAML, XMP, and JSON files.
- BradCooke.com remained clean. No tracked generated files changed.

## Lessons Learned

A required-field marker can remain in otherwise completed prose. Check the
generated prefix instead of only comparing the complete placeholder sentence,
and share that rule across preview and mutation paths.

A plant skipped for no photos is absent from the worksheet. It needs neither
a placeholder entry nor a narrative for that observation date.

## Next Steps

- Follow the clarified multi-plant runbook during the next observation cycle.
- No broad planning reconciliation is needed for this bounded validation fix.

## Notes

Live review on ubuntu-dev01 found Abbey Root clean at `0d853b0`
(`plant updates for bradcooke.com`), with an empty index and no untracked files.
BradCooke.com was also clean. The earlier cleanup session is historical evidence
and was left unchanged.

Created with `abbey session capture`, including the journal required by project
policy. The user conditionally authorized a focused commit when current state
makes it safe. Commit scope is limited to this session's five changed files. No push, website
publication, or deployment occurred.

Temporary baseline and validation evidence:
`/tmp/plant-batch-prefix-20260910-eluckze3`.
