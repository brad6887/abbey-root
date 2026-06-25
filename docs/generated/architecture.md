# Abbey Root Architecture

Generated automatically by Ansible.

## Overview

                  Proxmox
                     |
     --------------------------------
     |              |               |
ubuntu-dev01   ai-worker01   rocky-ansible01
     |              |               |
   Docker         Docker          Ansible
     |              |               |
 Homepage       Open WebUI        Git
 Portainer      Ollama            Playbooks
 Uptime Kuma    Portainer Agent   Documentation
 Nginx Proxy
