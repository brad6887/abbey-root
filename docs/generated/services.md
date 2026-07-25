# Abbey Root Services

Generated automatically by Ansible.

## ai-worker01

### AI

| Service | URL | Description | Container |
|---------|-----|-------------|-----------|
| Open WebUI | http://192.168.1.87:3000 | Local AI Interface | open-webui |
| Ollama | http://192.168.1.87:11434 | RTX 4060 AI Server | ollama |
| Portainer Agent | http://192.168.1.87:9001 | AI Worker Docker Agent | portainer-agent |

## edge01

### Infrastructure

| Service | URL | Description | Container |
|---------|-----|-------------|-----------|
| Technitium DNS | http://192.168.1.221:5380 | Internal DNS server | N/A |

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
| Umami | http://192.168.1.86:3002 | Web Analytics | umami |

### Development

| Service | URL | Description | Container |
|---------|-----|-------------|-----------|
| GitHub | https://github.com | Repositories | N/A |
| BradCooke.com | https://bradcooke.com | Website | N/A |
| ChatGPT | https://chatgpt.com | AI Assistant | N/A |

