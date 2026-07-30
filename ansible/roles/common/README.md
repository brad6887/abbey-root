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
