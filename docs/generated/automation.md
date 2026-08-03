# Abbey Root Automation

Generated automatically by Ansible.

## Playbooks

| Playbook | Description |
|----------|-------------|
| common.yml | Applies common baseline configuration to managed hosts. |
| docker.yml | Installs and configures Docker on Docker-capable hosts. |
| docs.yml | Generates Abbey Root project documentation. |
| facts.yml | Gathers and displays Ansible facts from managed hosts. |
| git-audit.yml | No documentation found |
| git-sync.yml | No documentation found |
| lab-check.yml | No documentation found |
| sensors.yml | No documentation found |
| site.yml | Runs the main Abbey Root configuration and deployment workflow. |
| ssh-audit.yml | No documentation found |
| ssh-sync.yml | No documentation found |
| static-sites.yml | No documentation found |
| umami.yml | No documentation found |
| update.yml | Applies package updates to managed hosts. |
| validate.yml | No documentation found |

## Roles

| Role | Description |
|------|-------------|
| common | Applies baseline Linux configuration shared by all managed hosts. |
| dns_client | Configures managed Abbey lab hosts to use the authoritative internal DNS |
| docker | Installs and configures Docker for hosts that run containers. |
| documentation | Generates Abbey Root Markdown documentation from Ansible inventory, variables, roles, and playbooks. |
| facts | No README found |
| git_config | Installs the authoritative global Git policy for the managed Abbey user. |
| homepage | Deploys and manages the Homepage dashboard and its generated configuration files. |
| issue | Manages the system login banner in /etc/issue. |
| labtest | Deploys an Ansible-managed nginx test container. |
| motd | Manages the message of the day shown after login. |
| sensor | Configures Abbey environmental sensor nodes for USB serial sensors. |
| static_site_host | Configures internal Rocky Linux hosts for static website hosting with native |
| time | Configures system timezone and time synchronization. |
| umami | Deploys Umami and PostgreSQL as a private Docker Compose project on `ubuntu-dev01`. |
| update | No README found |
