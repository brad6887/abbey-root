# Abbey Root Documentation

Abbey Root is a self-documenting home Linux lab managed with Git, Ansible, Docker, and generated documentation.

## Overview

- [Lab Summary](generated/lab-summary.md)

---

## Infrastructure

- [Servers](generated/servers.md)
- [Network](generated/network.md)
- [Inventory](generated/inventory.md)
- [Architecture](generated/architecture.md)
- Hardware
- Backup Strategy

## Applications

- [Services](generated/services.md)
- [Containers](generated/containers.md)

## Automation

- [Automation](generated/automation.md)

## Guides

- [Environment Overview](guides/environment-overview.md)

## Status

- [Project Status](status/PROJECT_STATUS.md)

## Regenerate Documentation

Run from the repository root:

```bash
./scripts/ansible-docs.sh
```
