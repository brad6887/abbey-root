# git_config

Installs the authoritative global Git policy for the managed Abbey user.

The role owns identity, fast-forward-only pulls, automatic remote pruning, and
SSH transport and published host-key trust for GitHub. Repository-specific
normalization remains explicit through `abbey git sync`.
