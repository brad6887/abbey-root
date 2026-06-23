ABBEY ROOT - CURRENT ENVIRONMENT
================================

Purpose
-------
Home Linux lab for learning, automation, AI, and website development.

Hypervisor
-----------
Proxmox
IP Address: 192.168.1.55

Repository
----------
GitHub Repository:
git@github.com:brad6887/abbey-root.git

Primary Goals
-------------
- Linux administration
- Docker
- Proxmox
- Ansible
- Multiple Linux distributions
- AI technologies
- Website development
- Automation
- Monitoring
- Security

--------------------------------------------------
VIRTUAL MACHINES
--------------------------------------------------

ubuntu-dev01
-------------
Role:
Infrastructure and management server

Purpose:
- Docker host
- Dashboard
- Monitoring
- Reverse proxy
- Container management
- General Linux development

Docker Containers:

Homepage
Image:
ghcr.io/gethomepage/homepage

Purpose:
Dashboard

Ports:
3000

Status:
Healthy


Uptime Kuma
Image:
louislam/uptime-kuma

Purpose:
Monitoring

Ports:
3001

Status:
Healthy


Portainer CE
Image:
portainer/portainer-ce

Purpose:
Docker management

Ports:
9443
8000

Status:
Running


Nginx Proxy Manager
Image:
jc21/nginx-proxy-manager

Purpose:
Reverse proxy and SSL management

Ports:
80
81
443

Status:
Running


nginx-test
Image:
nginx

Purpose:
Sandbox and experimentation

Ports:
8080

Status:
Running


--------------------------------------------------

ai-worker01
-----------
Role:
AI services host

Purpose:
- AI experimentation
- LLM services
- Open WebUI
- Future Ollama server

Docker Containers:

Open WebUI
Image:
ghcr.io/open-webui/open-webui

Purpose:
Web interface for AI models

Ports:
3000 -> 8080

Status:
Healthy


Portainer Agent
Image:
portainer/agent

Purpose:
Remote management from Portainer

Ports:
9001

Status:
Running


--------------------------------------------------
CURRENT ARCHITECTURE
--------------------------------------------------

Internet
    |
Router
    |
Proxmox (192.168.1.55)
    |
+------------------------------------------------+
|                                                |
| ubuntu-dev01                                   |
| Infrastructure Services                        |
|                                                |
| - Homepage                                     |
| - Uptime Kuma                                  |
| - Portainer CE                                 |
| - Nginx Proxy Manager                          |
| - nginx-test                                   |
|                                                |
+------------------------------------------------+

                    |

+------------------------------------------------+
|                                                |
| ai-worker01                                    |
| AI Services                                    |
|                                                |
| - Open WebUI                                   |
| - Portainer Agent                              |
|                                                |
+------------------------------------------------+


--------------------------------------------------
CURRENT INVENTORY
--------------------------------------------------

Hypervisors:
1

Virtual Machines:
2

Docker Hosts:
2

Running Containers:
7

GitHub Repositories:
1

Dashboard:
Homepage

Monitoring:
Uptime Kuma

Reverse Proxy:
Nginx Proxy Manager

Container Management:
Portainer CE + Portainer Agent

AI Platform:
Open WebUI


--------------------------------------------------
PLANNED FUTURE WORK
--------------------------------------------------

Infrastructure
--------------
- Ansible
- DNS
- Backup strategy

Additional Linux Systems
------------------------
- Debian
- Rocky Linux
- AlmaLinux
- Fedora
- Kali Linux

AI
--
- Ollama
- Additional models
- Self-hosted AI tools
- GPU experimentation

Monitoring
----------
- Prometheus
- Grafana
- Loki

Website
-------
- Rebuild BradCooke.com
- Git-based workflow
- AI-assisted development

Security
--------
- Kali Linux
- Vulnerability assessment
- Container security
- Linux hardening

Guiding Principle
-----------------
Progress over perfection.

Break things.
Fix things.
Document what was learned.

sudo make me a sandwich.
