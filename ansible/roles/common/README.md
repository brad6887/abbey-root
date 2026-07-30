# common

Applies baseline Linux configuration shared by all managed hosts.

The common playbook also applies the `git_config` role, which installs the
authoritative Abbey Git policy for `admin_user`:

- `Brad Cooke <brad6887@gmail.com>` commit identity
- fast-forward-only pulls
- automatic remote pruning
- SSH transport and managed host-key trust for GitHub URLs

Use `abbey git audit` to inspect effective host and repository configuration.
Use `abbey git sync --check` before explicitly synchronizing existing checkouts.

## Abbey Shell Configuration

The role installs the authoritative Abbey aliases and shell initialization
under `/etc/profile.d/`.

It also manages a bounded block in the `admin_user` account's existing
`.bashrc`. The distribution-provided Bash configuration remains intact while
the managed block:

- sources the Abbey alias and initialization files when the user's Abbey toolkit checkout exists,
- avoids duplicate Abbey toolkit PATH entries, and
- sources `~/.bashrc.local` when present for untracked host-local
  customization.

The role removes only known legacy Abbey fragments previously maintained
directly in `.bashrc`. It does not replace the complete file.
