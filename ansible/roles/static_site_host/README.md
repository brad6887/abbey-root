# static_site_host

Configures internal Rocky Linux hosts for static website hosting with native
nginx.

The role:

- installs and enables nginx,
- creates the `abbey-deploy` deployment identity,
- creates release-oriented site directories under `/srv/www`,
- preserves the active `current` release link after initial provisioning,
- configures nginx virtual hosts,
- allows HTTP through firewalld, and
- assigns persistent SELinux contexts for static web content.

## Directory Layout

Each site uses:

```text
/srv/www/<domain>/
├── current -> releases/<release-id>
└── releases/
    └── bootstrap/
```

Ansible creates the initial `bootstrap` release and `current` link. Future
deployment tooling may create new release directories and atomically replace
the `current` link. Subsequent role runs do not reset an existing link.

## Configuration

Sites are declared through `static_site_host_sites`:

```yaml
static_site_host_sites:
  - domain: abbeyroot.com
    default_server: true
    server_names:
      - abbeyroot.com
      - www.abbeyroot.com
```

## Deployment

Run from the Ansible control node:

```bash
cd ~/git/abbey-root/ansible

ansible-playbook \
  --syntax-check \
  playbooks/static-sites.yml

ansible-playbook \
  --check \
  --diff \
  playbooks/static-sites.yml \
  --limit sites01

ansible-playbook \
  playbooks/static-sites.yml \
  --limit sites01
```

## Validation

```bash
curl --fail http://192.168.1.84/
curl --fail http://192.168.1.84/healthz

ssh bcooke@192.168.1.84 '
sudo nginx -t
systemctl is-active nginx
systemctl is-enabled nginx
sudo firewall-cmd --query-service=http
'
```

Repeat the focused playbook after deployment:

```bash
ansible-playbook \
  playbooks/static-sites.yml \
  --limit sites01
```

A converged run should report:

```text
changed=0
failed=0
unreachable=0
```

## Boundaries

This role does not manage:

- public DNS,
- router forwarding,
- Nginx Proxy Manager,
- TLS certificates,
- site builds,
- release uploads, or
- production deployment commands.
