---
title: "Remote Connect Help Consistency"
description: "Made remote connection help follow Abbey's canonical help spelling and document every connection option."
date: 2026-08-14
status: complete
reviewed: false
session: remote-connect-help-consistency
tags:
  - Abbey Root
---

# Remote Connect Help Consistency

## Objective

Make `abbey remote` help consistent with the Abbey CLI standard and ensure an
operator can discover the correct host and user option syntax without relying
on `-h`.

## Definition of Done

- `abbey remote help` succeeds and shows command usage, connection options,
  examples, and the command-specific help path.
- `abbey remote connect help` succeeds and documents `--name` and `--user`.
- The generated CLI reference derives option documentation from CLI metadata.
- Focused regression tests and canonical Abbey validation pass.
- The change is committed and pushed directly to `main` as requested.

## Summary

Added canonical `help` routing at both levels of the remote command and expanded
the human-readable output with the required host option, optional SSH-user
override, behavior description, and complete examples. Extended the metadata
documentation generator so subcommand options appear in the generated CLI
reference instead of living only in implementation-specific help text.

## Accomplishments

- Added `abbey remote help`.
- Added `abbey remote connect help`.
- Preserved `-h` and `--help` as compatibility aliases while making `help` the
  documented Abbey path.
- Documented `--name NAME` as required and `--user USER` as an override.
- Added structured subcommand-option metadata and deterministic rendering.
- Expanded focused help and connection regression coverage from 10 to 16
  passing checks.

## Impact

Operators can now discover the working form directly from the standard command:

```bash
abbey remote help
```

The output distinguishes the Tailscale/inventory host name from the SSH user,
which prevents the easy mistake of passing a login name as a second `--name`.

## Validation

- `tests/test-abbey-remote.sh` — 16 passed, 0 failed.
- Shell syntax validation passed.
- Python compilation passed for the CLI metadata renderer and remote command.
- `git diff --check` passed.
- `abbey docs generate` completed successfully.
- `abbey validate` passed all repository consistency checks.

## Lessons Learned

Supporting argparse's conventional `-h` is not sufficient for an Abbey command.
Canonical word-based help must be routed intentionally at both the command-group
and subcommand levels, and option descriptions belong in the same metadata that
owns generated reference documentation.

## Next Steps

- Use the canonical help paths as regression expectations for future Abbey
  command groups.

## Notes

This follow-up changes help and generated documentation only; remote resolution
and SSH connection behavior remain unchanged.
