---
title: "Abbey Contributor Workflow"
description: "Implemented and isolated-tested the contributor account lifecycle with explicit per-host access, public keys, password-required sudo, reversible revocation, and guarded purge."
date: 2026-09-07
status: pending
reviewed: false
session: abbey-contributor-workflow
journal: "content/journal/2026/2026-09-07-abbey-contributor-workflow.md"
tags:
  - Abbey Root
  - Ansible
  - Linux
  - Contributors
---

# Abbey Contributor Workflow

## Objective

Create the reusable Abbey contributor/user workflow in
`/home/bcooke/git/abbey-root` on `ubuntu-dev01`, accessed remotely through
`ubuntu-tail`. Keep the session limited to account lifecycle tooling; do not
create the broader onboarding document or provision a real contributor.

## Definition of Done

- A reusable per-contributor definition and inert example exist.
- Only contributor-generated ED25519 public keys are referenced and managed.
- Ansible can create/restore the account idempotently.
- Host-specific sudo defaults to none and uses validated sudoers files.
- Revoke preserves the account/home while disabling access.
- Purge is separate, confirmed, and requires `--remove-home` for deletion.
- `abbey contributor plan/apply/status/revoke/purge` have explicit semantics.
- Relevant help, metadata, and operational documentation are current.
- Scoped validation passes and the session is captured before commit.
- The final review identifies remaining personal inputs and v1 limitations.

## Summary

Implemented a dedicated contributor lifecycle through the existing Bash
dispatcher, a Python helper, CLI metadata, and a focused Ansible playbook/role.
The definition is the source of truth for both host entitlements and lifecycle
state. Explicit actions save intended state before remote convergence.
Read-only plan/status/check commands do not edit that definition.

Review covered repository instructions, authoritative project status and next
steps, Abbey session/CLI architecture, current inventory and roles, SSH key
management, existing check/apply patterns, generated documentation, and tests.
The working tree started clean on `main` at `830f1c0`.

## Accomplishments

- Added `scripts/abbey_contributor.py`, `tools/bin/abbey-contributor`, and the
  dispatcher route and canonical CLI registration.
- Added `ansible/contributors/example.yml.example` and a public-key-only storage
  directory. No real contributor definition or key is included.
- Added `ansible/playbooks/contributor.yml`, the `contributor` role, and the
  read-only `abbey_contributor_info` module.
- Validated names, exact inventory hosts, explicit login flags, allowed sudo
  values, existing supplementary groups, unique YAML keys, public-key wire
  format/fingerprint, and confined public-key references.
- Refused administrative, system, unmanaged, and unsafe-path account adoption.
- Added all-host preflight, immediate per-host revalidation, serial convergence,
  and post-apply managed-state verification.
- Forced SSH connections so the inventory's controller-local entry cannot
  accidentally target Ubuntu when the workflow runs there.
- Added lifecycle intent persistence with atomic state updates, comment
  preservation, concurrent-edit detection, and per-checkout contributor locks.
- Implemented exclusive public authorization and supplementary-group policy,
  explicit password-required sudoers, password-preserving restore, account
  expiry/locking/nologin revocation, and confirmed non-forced purge.
- Added the focused Contributor Workflow runbook, Ansible entrypoint reference,
  and role documentation.
- Regenerated `docs/generated/CLI_REFERENCE.md` and
  `docs/generated/DOCUMENTATION_INDEX.md` through `abbey docs generate`.
  The generated legacy command reference remained unchanged.
- Used `abbey session capture` to create the session and linked journal entry.

## Impact

The first real contributor can be introduced with data rather than changes to
the implementation. Hosts do not become accessible merely because they appear
in the lab inventory. Revoke preserves work and can be reversed through apply.

The operational procedure and schema have one authoritative home:
[Contributor Workflow](../runbooks/CONTRIBUTOR_WORKFLOW.md).
Strategic planning and the broader onboarding document were not rewritten.

## Validation

Passed:

- `python3 tests/test-abbey-contributor.py`: 15 offline CLI tests covering
  safe dispatch/help, rejected arguments, inventory bounds, public-key
  fingerprints, invalid/duplicate YAML, state transitions, check-mode
  read-only behavior, concurrent edits, purge confirmation, missing-key
  revocation, and retained desired intent after an Ansible failure.
- `tests/test-ansible-contributor.sh`: 31 real lifecycle assertions in a
  disposable Ubuntu 24.04 container with Ansible Core 2.16.16, matching the
  installed lab controller version.
- The same 31 assertions passed on Ubuntu with Ansible Core 2.18.19 during
  development.
- `tests/test-ansible-contributor.sh --rocky`: the same 31 assertions passed
  on Rocky Linux 9 with Ansible Core 2.16.16.
- Container tests exercised actual ED25519 SSH login, password-disabled account
  creation, password-required full sudo, exact groups, second-run idempotency,
  read-only account-file snapshots, status drift, all-host preflight failure,
  unmanaged account refusal, revoke/restore, confirmation refusal, retained
  homes, explicit home deletion, and symlink refusal.
- An explicit Ansible `--syntax-check` of `playbooks/contributor.yml`.
- Shell syntax and Python compilation for all new code and fixture drivers.
- Existing `test-abbey-docs.sh`, `test-abbey-validate.sh`,
  `test-abbey-cli-context.sh`, `test-abbey-lab.sh`, and
  `test-abbey-session-capture.sh` regression suites.
- `abbey docs check`, `abbey validate`, and `git diff --check`.
- Final working-tree and scoped diff review before staging/commit.

Existing validation debt:

- `test-abbey-portability.sh` reports 28 passes and two failures both in the
  working checkout and in an isolated archive of unchanged `HEAD`.
- The failures are the existing `mapfile` use in
  `tools/bin/abbey-newsroom:156` and existing `sed -i` uses in
  `tests/test-abbey-plant.sh:844,873`.
- These are unchanged, unrelated portability issues, not contributor
  regressions. They were documented and excluded from the scoped commit gate;
  no unrelated implementation or tests were changed to hide them.

Validation boundaries:

- No contributor playbook was applied to lab hosts and no real accounts were
  created, revoked, or deleted. Account mutations and test credentials stayed
  in disposable containers with the checkout mounted read-only and external
  networking disabled during execution.
- Rocky Linux 10 containers could not start on Ubuntu's exposed virtual CPU
  because they require x86-64-v3. Rocky Linux 9 supplied the Red Hat-family
  lifecycle validation; a first real Rocky 10 application still requires
  normal host preview and verification.
- Ubuntu lacked Ansible. An ignored local validation environment was created
  under `.abbey/validation/contributor/`; normal CLI execution still expects
  an equipped Ansible controller. No system-wide Ansible installation was made.
- The unrelated full repository/website suites and production publication were
  outside scope.

## Design Decisions

- `state` is stored in contributor YAML. Apply saves active, revoke saves
  revoked, and purge saves absent. Failed runs retain intent and are retried
  with the same action; plan can preview a transition through `--action`.
- Default sudo is none. Full requires an administrator-established local
  password on each host. No passwords or hashes are stored in contributor data.
- Privileged supplementary groups are never inherited automatically; generic
  sudo/wheel/admin/root grants are rejected.
- Revocation removes all supplementary memberships and managed authorization,
  locks the password, expires the account, and disables interactive login.
- Existing sessions/processes and independent sudo/credential grants remain
  outside v1; this is an account lifecycle, not incident-response automation.
- Purge preserves homes by default without automatic archiving or UID
  reservation. Recreating an account over retained home data is deliberately
  refused until an administrator archives or recovers it.
- Previously configured hosts must remain in the definition with
  `login: false` when removing their entitlement. Unlisted hosts are untouched.
- Status reports managed local state and drift, not an exhaustive effective
  authorization audit. Drift is informational; inspection failures are nonzero.

## Lessons Learned

Linux account comments cannot contain colon characters; the ownership marker
uses `Abbey contributor <username>`.

Ansible accepts account expiry in epoch seconds, while Linux shadow stores
days. Using 86400 yields a stable, explicitly expired day instead of the
ambiguous epoch-zero value.

A new-account check run cannot create users/directories needed by subsequent
ownership operations. Read-only preflight reports every dependent change while
check mode avoids tasks whose prerequisites do not exist yet.

Account lifecycle validation needs actual account and SSH behavior. The
disposable tests caught defects that syntax checks alone could not find.

The broader portability suite has existing debt. Comparing it with the
unchanged baseline kept this session's validation honest without expanding
the implementation scope.

## Next Steps

Brad must supply the intended non-administrator username, the contributor's
dedicated ED25519 public key and verified fingerprint, explicit desired host
access, existing groups per allowed host, and sudo policy per host.

Start with sudo none. If full sudo is required, arrange private local password
setup after the first sudo-free apply.

Make the validated checkout/commit available on the chosen Ansible controller,
prepare the real contributor definition, preview it, and perform the first
intentional application with status and SSH verification.

Build the wider contributor onboarding document in a separate session.

## Notes

Work was performed in the requested Ubuntu checkout over `ubuntu-tail`.
No push, website publication, or lab account deployment was performed.
This session is prepared as one scoped commit after the validations above.
The pending metadata marks future planning reconciliation, not unfinished
contributor implementation.

Development logs and isolated baseline/Ansible environments are ignored under
`.abbey/validation/contributor/`. The contributor files and operational
runbook remain the durable sources.
