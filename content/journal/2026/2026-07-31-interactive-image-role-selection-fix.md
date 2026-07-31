---
title: "Interactive Image Role Selection Fix"
description: "Validated the portable image-role workflow through real use and fixed interactive selection cancelling immediately."
date: 2026-07-31
draft: false
tags:
  - Abbey Root
  - Abbey Framework
  - Developer Toolkit
  - Plant Model
---

# Interactive Image Role Selection Fix

## Summary

The new portable image-role command worked through its non-interactive options,
but its first normal interactive test exposed a problem.

Running:

    abbey plant hero martha-my-dear

listed the available photographs and then immediately cancelled instead of
waiting for a numbered selection.

The embedded Python program was being passed through standard input with
`python3 -`. The program later tried to use that same standard input for
`input()`, but the Python source heredoc had already consumed it.

The selector now reads its embedded Python program from file descriptor 3,
leaving standard input available for the person running the command.

## Accomplishments

- Reproduced the interactive cancellation through normal command use.
- Identified the conflict between the Python source heredoc and user input.
- Changed `abbey-image` to load its Python program from `/dev/fd/3`.
- Confirmed interactive selection now waits for input.
- Confirmed numbered selection and confirmation work normally.
- Added a regression test that selects an image interactively without using
  `--select`.
- Increased the image-selection regression suite from 46 to 49 passing
  assertions.
- Selected Martha My Dear photo 4 through the real workflow.
- Confirmed the canonical `facts.yaml` value updated correctly.
- Confirmed Plant Model validation passed.
- Published the selected image to the stable public hero path.
- Verified the source image and public hero had matching SHA-256 hashes.
- Completed a successful Astro production build containing 138 pages.
- Restarted the local preview server and confirmed the visible hero change.
- Restored the temporary Martha My Dear test changes.

## Impact

Interactive image-role selection now works through the intended command:

    abbey plant hero <slug>

The user can choose a numbered image and confirm the change without supplying
non-interactive command-line options.

Because the correction is in the generic image-role selector, future configured
image roles receive the same fixed behavior.

The real test also validated the complete publishing chain from canonical
metadata through the built website.

## Lessons Learned

End-to-end testing found a defect that the initial fixture tests missed.

The earlier tests covered cancellation and non-interactive selection, but they
did not prove that a person could enter a number at the prompt. Interactive
commands need at least one test that follows the same standard-input path used
during normal operation.

An embedded program should not consume standard input when it also needs to
prompt the user. Giving the program source its own file descriptor keeps those
two input streams separate.

The stable public hero filename also means a browser may continue displaying a
cached image after publishing. Restarting the preview server or performing a
hard refresh makes the replacement visible.

## Next Steps

- Complete Abbey review and validation for the fix.
- Commit and merge the regression-backed correction.
- Continue using the selector during normal plant publishing.
- Reconsider visual contact sheets only after more filename-based use.

