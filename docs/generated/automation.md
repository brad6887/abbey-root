# Abbey Root Automation

Generated automatically by Ansible.

## Playbooks

| Playbook | Description |
|----------|-------------|
| common.yml | Applies common baseline configuration to managed hosts. |
| docker.yml | Installs and configures Docker on Docker-capable hosts. |
| docs.yml | Generates Abbey Root project documentation. |
| facts.yml | Gathers and displays Ansible facts from managed hosts. |
| site.yml | Runs the main Abbey Root configuration and deployment workflow. |
| update.yml | Applies package updates to managed hosts. |
| validate.yml | No documentation found |

## Roles

| Role | Description |
|------|-------------|
| common | Applies baseline Linux configuration shared by all managed hosts. |
| docker | Installs and configures Docker for hosts that run containers. |
| documentation | Generates Abbey Root Markdown documentation from Ansible inventory, variables, roles, and playbooks. |
| facts | No README found |
| homepage | Deploys and manages the Homepage dashboard and its generated configuration files. |
| issue | Manages the system login banner in /etc/issue. |
| labtest | Deploys an Ansible-managed nginx test container. |
| motd | Manages the message of the day shown after login. |
| time | Configures system timezone and time synchronization. |
| update | No README found |
