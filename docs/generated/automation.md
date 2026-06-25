# Abbey Root Automation

Generated automatically by Ansible.

## Playbooks

- common.yml
- docker.yml
- docs.yml
- facts.yml
- site.yml
- update.yml

## Roles

| Role | Description |
|------|-------------|
| common | Applies baseline Linux configuration shared by all managed hosts. |
| docker | Installs and configures Docker for hosts that run containers. |
| documentation | Generates Abbey Root Markdown documentation from Ansible inventory, variables, roles, and playbooks. |
| homepage | Deploys and manages the Homepage dashboard and its generated configuration files. |
| issue | Manages the system login banner in /etc/issue. |
| labtest | Deploys an Ansible-managed nginx test container. |
| motd | Manages the message of the day shown after login. |
| time | Configures system timezone and time synchronization. |
