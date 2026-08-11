# Abbey Root Ansible

Run commands from this directory:

cd ~/git/abbey-root/ansible

## Helper Scripts

Run from the repository root.

abbey-ansible-site
abbey-ansible-update
abbey-ansible-facts
abbey-ansible-docker

## Network Interface Expectations

`abbey lab check` validates stable network hardware identities declared in a
managed host's `inventory/host_vars/<host>.yml` file:

```yaml
expected_network_interfaces:
  - role: primary lab network
    mac_address: "00:11:22:33:44:55"
```

Declarations are opt-in because interface identity is hardware-specific. The
check compares normalized MAC addresses with gathered Ansible facts, reports a
missing or replaced interface as a warning, includes the interfaces it did
observe for diagnosis, and continues reporting health for every reachable
host. Hosts without authoritative expectations are reported as skipped.
