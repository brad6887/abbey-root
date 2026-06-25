# Abbey Root Services

Generated automatically by Ansible.

## ai-worker01

### AI

| Service | URL | Description | Container |
|---------|-----|-------------|-----------|
| Open WebUI | http://192.168.1.87:3000 | Local AI Interface | N/A |
| Ollama | http://192.168.1.87:11434 | RTX 4060 AI Server | N/A |
| Portainer Agent | http://192.168.1.87:9001 | AI Worker Docker Agent | N/A |

## rocky-ansible01

### Automation

| Service | URL | Description | Container |
|---------|-----|-------------|-----------|
| Rocky Ansible | N/A | Ansible Control Node | N/A |

## ubuntu-dev01

### Infrastructure

| Service | URL | Description | Container |
|---------|-----|-------------|-----------|
| Proxmox | https://192.168.1.55:8006 | Hypervisor | N/A |
| Portainer | https://192.168.1.86:9443 | Docker Management | portainer |
| Homepage | http://192.168.1.86:3000 | Lab Dashboard | homepage |
| Nginx Proxy Manager | http://192.168.1.86:81 | Reverse Proxy | nginx-proxy-manager |

### Lab Tests

| Service | URL | Description | Container |
|---------|-----|-------------|-----------|
| Nginx Lab Test | http://192.168.1.86:8088 | Ansible-managed test container | nginx-labtest |

### Monitoring

| Service | URL | Description | Container |
|---------|-----|-------------|-----------|
| Uptime Kuma | http://192.168.1.86:3001 | Service Monitoring | uptime-kuma |

### Development

| Service | URL | Description | Container |
|---------|-----|-------------|-----------|
| GitHub | https://github.com | Repositories | N/A |
| BradCooke.com | https://bradcooke.com | Website | N/A |
| ChatGPT | https://chatgpt.com | AI Assistant | N/A |

### Future Services

| Service | URL | Description | Container |
|---------|-----|-------------|-----------|
| Grafana | N/A | Metrics | N/A |
| Prometheus | N/A | Monitoring | N/A |
| Watchtower | N/A | Docker Updates | N/A |
| Immich | N/A | Photos | N/A |
| n8n | N/A | Automation | N/A |

