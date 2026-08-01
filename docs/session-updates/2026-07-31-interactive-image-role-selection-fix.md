---
title: "Interactive Image Role Selection Fix"
description: "Validated portable image-role selection through a real plant publish and fixed interactive selection cancelling immediately."
date: 2026-07-31
status: complete
reviewed: true
session: interactive-image-role-selection-fix
tags:
  - Abbey Root
  - Abbey Framework
  - Developer Toolkit
  - Plant Model
---

# Interactive Image Role Selection Fix

## Objective

Validate the portable image-role selection workflow through normal end-to-end
plant publishing use and fix any defect exposed by that validation.

## Definition of Done

- `abbey plant hero <slug>` accepts interactive numbered input.
- The selected image updates the canonical plant workspace.
- `abbey plant validate <slug>` passes after selection.
- `abbey plant publish <slug>` copies the selected source image to the stable
  public hero path.
- The selected source and public hero image have matching hashes.
- The Astro production build passes.
- The updated hero is visible through the local preview.
- Temporary Martha My Dear content changes are restored after testing.
- Focused regression coverage protects the interactive workflow.

## Summary

The portable image-role selector was exercised through a real Martha My Dear
plant publishing workflow.

The first normal interactive run exposed a defect. Running
`abbey plant hero martha-my-dear` without `--select` immediately cancelled
instead of waiting for keyboard input.

The embedded Python program was supplied through standard input with
`python3 -`. When the program later called `input()`, standard input had already
been consumed by the Python source heredoc. The prompt therefore received an
immediate end-of-file condition.

The selector now reads its embedded Python program from file descriptor 3.
Standard input remains available for interactive selection and confirmation
prompts.

A focused regression test now performs a real numbered selection and
confirmation without using `--select`.

## Accomplishments

- Reproduced the immediate interactive cancellation through normal command use.
- Identified the conflict between the embedded Python heredoc and interactive
  standard input.
- Changed the selector to load its Python program from `/dev/fd/3`.
- Preserved standard input for numbered selection and confirmation prompts.
- Confirmed interactive cancellation still works normally.
- Confirmed interactive numbered selection and confirmation now work.
- Added regression coverage for interactive numbered selection.
- Increased the image-selection regression suite from 46 to 49 passing
  assertions.
- Selected Martha My Dear photo 4 through the real command.
- Confirmed `working/plants/martha-my-dear/facts.yaml` recorded
  `photos/Martha - 4.JPG`.
- Confirmed Plant Model validation passed after the selection.
- Published the selected image through `abbey plant publish`.
- Verified the selected source image and stable public `hero.jpg` had identical
  SHA-256 hashes.
- Completed an Astro production build containing 138 pages.
- Restarted the local preview server successfully.
- Confirmed the updated hero through the local preview workflow.
- Restored Martha My Dear's temporary canonical and public-image test changes.

## Impact

Interactive image-role selection now works as originally intended.

Users can run:

    abbey plant hero <slug>

The command now waits for a numbered selection and confirmation without
requiring non-interactive options.

The fix remains inside the generic image-role implementation. Every future
project-configured image role benefits from the corrected interactive behavior.

The real plant test also confirmed the complete source-of-truth chain:

    facts.yaml
    abbey plant validate
    abbey plant publish
    stable public hero image
    Astro production build
    local preview

## Validation

- `tests/test-abbey-image.sh`: 49 assertions passed.
- `tests/test-abbey-plant.sh`: 58 assertions passed.
- `tests/test-abbey-portability.sh`: 29 assertions passed.
- Shell syntax validation passed for `tools/bin/abbey-image`.
- Shell syntax validation passed for `tests/test-abbey-image.sh`.
- `git diff --check` passed.
- Interactive cancellation waited for input and exited without changing files.
- Interactive numbered selection accepted a photo number and confirmation.
- Martha My Dear photo 4 passed Plant Model validation.
- `abbey plant publish martha-my-dear` completed successfully.
- The selected source and published public hero had matching SHA-256 hashes.
- `abbey site build` completed successfully with 138 generated pages.
- The local Astro preview server restarted successfully.
- Temporary Martha My Dear content and public-image changes were restored.

## Lessons Learned

End-to-end use found a defect that non-interactive regression tests could not
detect.

A command can appear fully tested when fixtures exercise only piped
cancellation and explicit command-line selection. Interactive standard input
must also be tested through the same path a person uses.

Embedded programs should not consume standard input when the program itself
needs to prompt the user. A separate file descriptor keeps program input and
user input independent without introducing a temporary source file.

The stable public-image filename means the generated content page does not need
to change when a different hero photograph is selected. Publishing replaces
the file behind that stable path. A hard refresh may be required when a browser
has cached the previous image.

## Next Steps

- Complete the normal Abbey review, validation, commit, and merge workflow for
  the fix.
- Continue using the numbered selector during normal plant publishing.
- Revisit visual contact-sheet support only after the filename-based workflow
  has more real-world use.

## Notes

The real end-to-end test used Martha My Dear photo 4 because the preview was
already showing photo 2. This made the visual change easy to confirm.

The photo selection was temporary. No permanent Martha My Dear hero change is
part of this session.
