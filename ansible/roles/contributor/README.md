# Contributor Role

Dedicated contributor account lifecycle, invoked by `abbey contributor` through
`playbooks/contributor.yml`.

The authoritative operator procedure, data schema, lifecycle transitions,
ownership boundary, and recovery limitations are documented in
[Contributor Workflow](../../../docs/runbooks/CONTRIBUTOR_WORKFLOW.md).

The CLI supplies a validated `abbey_contributor` snapshot and an explicit target
list. The playbook defaults to no hosts, runs a global preflight, and then
converges one host at a time. This role is intentionally not part of
`site.yml` or `common.yml`.

`library/abbey_contributor_info.py` is a read-only module used for preflight,
status, and post-apply drift validation. It returns password state only, never
shadow-file contents. Mutations use Ansible built-in modules.

Run `tests/test-ansible-contributor.sh` from the repository root for disposable
Linux lifecycle validation. Direct playbook execution is an internal interface;
operators should use the public CLI to keep saved desired state synchronized.
