# Contributor Workflow

## Purpose

Manage dedicated Abbey contributor accounts through explicit per-host policy.
This runbook covers account provisioning and removal only; the wider contributor
orientation and project tour are a separate workflow.

The public interface is:

```bash
abbey contributor plan <username>
abbey contributor apply <username>
abbey contributor status <username>
abbey contributor revoke <username>
abbey contributor purge <username> --confirm <username>
```

A bare `abbey contributor` displays help and performs no work.

## Controller and Requirements

Run from an Abbey Ansible control node with Python 3.10 or later, PyYAML,
Ansible Core 2.16 or later, SSH connectivity, and the existing inventory/vault
configuration. The lab controller is `rocky-ansible01`. Ubuntu can also execute
this workflow when those dependencies and credentials are available.

This lab command always uses its toolkit checkout's `ansible/` directory,
regardless of the current directory or an external project's `ABBEY_ROOT`.
Keep the contributor definition and implementation together on the executing
controller. No remote checkout synchronization is performed automatically.

The existing inventory marks `rocky-ansible01` as a local connection for its own
controller. Contributor runs explicitly use SSH for every target, so execution
from Ubuntu cannot mistake Ubuntu for the automation host. SSH and become
credentials are the controller's existing credentials; `-K` or
`--ask-become-pass` prompts for the administrator's become password when needed.

Targets must be Debian/Ubuntu or Red Hat-family Linux with the standard account
tools, Python, sudo/visudo for full sudo, and `/usr/sbin/nologin`.

## Contributor Definition

Copy `ansible/contributors/example.yml.example` to
`ansible/contributors/<username>.yml`. The example is deliberately not loadable
and contains no working key or real person's account details.

```yaml
username: contributor-example
state: active
ssh_public_key: keys/contributor-example.pub
access:
  ubuntu-dev01:
    login: true
    groups: []
    sudo: none
  ai-worker01:
    login: false
  sites01:
    login: false
  edge01:
    login: false
  rocky-ansible01:
    login: false
```

Use individual names from `ansible/inventory/hosts.yml`; inventory groups,
patterns, unknown hosts, and duplicate YAML fields are rejected.

- `login` is required for every declared host.
- `groups` defaults to an empty supplementary-group list. Approved groups must
  already exist on that host. Abbey creates only the private primary group.
- `sudo` defaults to `none`; the only other value is `full`.
- A denied host (`login: false`) cannot contain groups or a sudo grant.
- Unlisted hosts receive no account or access changes.
- Keep previously managed hosts in the definition and set `login: false` to
  remove their access. Deleting a host entry cannot revoke an account there.
- Accounts use `/home/<username>`, `/bin/bash`, and a private primary group.
  Administrator, connection, system, and existing unmanaged accounts are refused.

Abbey owns the entire supplementary-group list and
`~/.ssh/authorized_keys` for these dedicated accounts. An apply replaces
manual additions. Other home-directory work is preserved. An existing account
is recognized by the exact `Abbey contributor <username>` account comment,
a non-system UID, its own primary group, and the expected home path.
Do not change that marker manually. Existing symlinked access paths and unsafe
group/home adoption fail closed.

Membership in `sudo`, `wheel`, `admin`, or `root` is rejected; use the explicit
sudo field. Other privileged groups, including `docker`, may confer extensive
host control and should be granted only as an intentional host entitlement.

## Public Key Handoff

The contributor generates a dedicated ED25519 key on their own computer:

```bash
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519_abbey -C "username@abbeyroot"
```

Use a private-key passphrase. Give Brad only the resulting `.pub` file.
The private key stays on the contributor's computer and must never be copied
to Abbey, a server, or the repository.

Place that public file at `ansible/contributors/keys/<username>.pub`.
The reference is relative to `ansible/contributors/`. Abbey accepts one bare,
structurally valid ED25519 public key and displays its SHA256 fingerprint;
private keys, other key types, multiple keys, options, and escaping paths are
rejected. Compare the fingerprint with the contributor's
`ssh-keygen -lf ~/.ssh/id_ed25519_abbey.pub` output through a trusted channel.

## Source of Truth and Lifecycle

The YAML file contains both durable host entitlements and desired lifecycle
state. There is no competing lifecycle database.

| Command | Desired-state behavior | Host behavior |
| --- | --- | --- |
| `plan` | Reads the stored state | Runs Ansible check mode and reports planned changes |
| `apply` | Saves `active` | Creates/restores allowed accounts; disables existing denied accounts |
| `status` | Reads the stored state | Reports actual state and drift without mutations |
| `revoke` | Saves `revoked` | Disables existing accounts on all listed hosts |
| `purge` | Saves `absent` | Deletes managed accounts on all listed hosts |

Explicit lifecycle actions are transitions: `apply` intentionally changes a
previously revoked or absent definition back to active. To preview that
transition first, use:

```bash
abbey contributor plan <username> --action apply
abbey contributor plan <username> --action revoke
abbey contributor plan <username> --action purge
```

Plain `plan` previews the current stored state. `apply --check`,
`revoke --check`, and confirmed `purge --check` also preview without changing
the YAML or accounts.

Commands validate the definition, inventory targets, and playbook syntax before
saving intent. The state line is then changed atomically, preserving the rest
of the file. Every host receives a read-only preflight before any host changes;
each host is rechecked immediately before its changes.

If execution fails, intended state remains saved. Hosts may be partially
converged; inspect `status` and rerun the same action. Do not run `apply` to retry
a failed revoke or purge, because apply explicitly restores active intent.
Review and commit the definition through the normal Abbey session workflow.
The CLI never commits or pushes it.

Mutating runs are serialized per contributor within a checkout. Use one
authoritative execution checkout at a time; this is not a distributed lock.

## Apply and Sudo

Start with `sudo: none`. Preview, apply, and inspect status:

```bash
abbey contributor plan <username>
abbey contributor apply <username>
abbey contributor status <username>
```

New accounts receive an unusable password (`*`) and the dedicated public key.
Apply restores shell, expiry, and the password lock without replacing an
existing password. It never creates contributor private keys.

For full sudo on a particular host:

1. Create the account there with `sudo: none`.
2. As an administrator on that host, set the local password with
   `sudo passwd <username>` through an appropriate private handoff.
3. Set that host's `sudo: full` in the contributor definition.
4. Preview and apply again.

A full grant fails preflight until that host has a usable local password.
No password or password hash belongs in contributor YAML.

The managed file is `/etc/sudoers.d/abbey-<username>`, root-owned and mode
`0440`, containing:

```sudoers
# Managed by Abbey contributor
contributor-example ALL=(ALL:ALL) PASSWD: ALL
```

Abbey validates existing sudoers and uses `visudo -cf` to validate the new file
before installing it. It never emits `NOPASSWD`. Independent sudoers rules can
still grant access; v1 does not rewrite or prove the absence of those rules.
The workflow also leaves host-wide SSH authentication settings to existing
infrastructure policy; adding a local sudo password does not change sshd policy.

## Revoke

```bash
abbey contributor plan <username> --action revoke
abbey contributor revoke <username>
abbey contributor status <username>
```

Revoke removes the managed authorized-keys file and sudoers grant, removes all
supplementary memberships, locks the password, expires the account, and sets
`/usr/sbin/nologin`. It does not create accounts on previously unused hosts.
The account, UID, primary group, home, and other files remain.

Expiry supplements password locking and nologin because password locking alone
does not disable all authentication methods. Subsequent apply restores the
configured entitlements and preserves an existing password.

Existing sessions, running processes, cached credentials, and access previously
established through privileged groups are not terminated by v1. For an urgent
incident, separately terminate sessions/processes and inspect independent
credentials and grants. Ordinary revoke prevents new account access; it is
not a complete incident-response or process-termination workflow.

A missing public-key file does not prevent revoke or purge.

## Purge and Retained Homes

```bash
abbey contributor plan <username> --action purge
abbey contributor purge <username> --confirm <username>
```

The exact repeated username is required even for noninteractive execution.
The account is permanently deleted; the home remains at its existing path.
Its numeric ownership is retained. There is no automatic archive or UID
reservation, so review retained data before creating unrelated accounts.

To delete the account, home, and mailbox in the same operation:

```bash
abbey contributor plan <username> --action purge --remove-home
abbey contributor purge <username> --confirm <username> --remove-home
```

Purge never uses forced account deletion. Active processes can cause it to
fail, leaving intended state `absent` for operator review and retry.

After a preserving purge, a later apply refuses to adopt the orphaned home.
Archive or recover it explicitly first. Likewise, `--remove-home` does not
delete an orphaned home from an earlier purge: it operates together with a
still-present managed account. Files elsewhere on disk are not deleted.

## Status and Validation

Status reports the desired and actual lifecycle, authorized-key presence,
Abbey sudo policy, password state, supplementary groups, and drift. It never
returns password hashes. A revoked entitlement with no account is compliant.
An absent account does not need to be created simply to revoke it.

The status report describes managed local state, not a full SSH login probe,
independent sudoers audit, or running-session inventory. Drift is informational:
status returns success when inspection completes; unreachable or failed hosts
produce a nonzero Ansible result.

Repository validation:

```bash
python3 tests/test-abbey-contributor.py
tests/test-ansible-contributor.sh
tests/test-ansible-contributor.sh --rocky
abbey docs check
abbey validate
git diff --check
```

The container test builds a disposable Ubuntu image (or Rocky Linux with
`--rocky`), mounts the repository
read-only, disables external networking during execution, and exercises real
account creation, key-based SSH login, password-required sudo, idempotency,
check-mode snapshots, revocation/restoration, drift, and both purge modes.
Test credentials exist only in the disposable container. No lab account
provisioning is implied by running these tests.

## First Real Contributor

Brad must provide:

- The intended non-administrator username.
- The contributor-generated ED25519 public key and verified fingerprint.
- Explicit allowed and denied inventory hosts.
- Existing supplementary groups for each allowed host, or none.
- Sudo policy per host, defaulting to none.

If a host needs full sudo, arrange its local password setup after the first
sudo-free apply. The implementation does not require the first contributor's
personal details until an actual definition is prepared.
