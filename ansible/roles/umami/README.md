# umami

Deploys Umami and PostgreSQL as a private Docker Compose project on `ubuntu-dev01`.

## Architecture

The role renders the Compose project under `/home/bcooke/docker/umami` with two
services on the project-private default network:

- `umami` runs `ghcr.io/umami-software/umami:latest` and is the only service
  published to the host, using `192.168.1.86:3002:3000` by default.
- `db` runs `postgres:15-alpine`, stores its data in the `umami-db-data` named
  volume, and has no host port.

The application waits for the database health check, and both services use the
Abbey `unless-stopped` restart policy. PostgreSQL runs in UTC.

## Secrets

The role requires these variables from encrypted inventory:

- `umami_database_password`
- `umami_app_secret`

Do not add values for these variables to role defaults, documentation, or other
plaintext files. The generated `docker-compose.yml` contains both rendered
secrets. It must remain owned by the configured Umami owner and group with mode
`0600`, and its contents must not be copied into logs or support records.

## Deployment

Run Ansible from the repository's `ansible/` directory on the Abbey Ansible
control node.

Validate the focused playbook before deployment:

```bash
ansible-playbook --syntax-check playbooks/umami.yml
ansible-playbook --check --diff playbooks/umami.yml --limit ubuntu-dev01
```

Check mode renders the expected directory and template changes but explicitly
skips the Compose deployment handler. Apply the role with:

```bash
ansible-playbook playbooks/umami.yml --limit ubuntu-dev01
```

The same role is also included in `playbooks/site.yml` as part of the
application-deployment section.

## Health and Idempotency Validation

On `ubuntu-dev01`, verify the services and local application heartbeat:

```bash
cd /home/bcooke/docker/umami
docker compose ps
curl --fail --silent --show-error http://192.168.1.86:3002/api/heartbeat
```

The heartbeat should return `{"ok":true}`. Then repeat the focused playbook from
the Ansible control node:

```bash
ansible-playbook playbooks/umami.yml --limit ubuntu-dev01
```

A converged second run should report `changed=0` and `failed=0`.

## Database Backup

On `ubuntu-dev01`, create a gzip-compressed PostgreSQL custom-format dump under
the protected backup directory:

```bash
set -euo pipefail
install -d -m 0700 /home/bcooke/backups/umami
umask 077
backup_file="/home/bcooke/backups/umami/umami-$(date +%F-%H%M%S).dump.gz"

cd /home/bcooke/docker/umami
docker compose exec -T db pg_dump \
  --username umami \
  --dbname umami \
  --format custom \
  | gzip -c > "$backup_file"

test -s "$backup_file"
test "$(stat -c '%a' "$backup_file")" = "600"
gzip -t "$backup_file"
gzip -dc "$backup_file" \
  | docker compose exec -T db pg_restore --list > /dev/null
```

`set -euo pipefail` makes a failed `pg_dump`, compression, decompression, or
archive inspection fail the command sequence. The `077` umask ensures the shell
creates the redirected dump as owner-only from the beginning; the mode check
then verifies it is `0600`. The remaining checks require a nonempty file, a
valid gzip stream, and a readable PostgreSQL archive.

Store the dump only in a protected backup location. Analytics backups may
contain visitor and configuration data and must be handled as sensitive
operational records.

## Database Restore

> **Warning: this procedure is destructive.** It drops and recreates the live
> Umami database. Confirm the target host, Compose directory, backup file, and
> recovery window before running it. Preserve a current backup before replacing
> any database.

On `ubuntu-dev01`:

```bash
set -euo pipefail
cd /home/bcooke/docker/umami
docker compose stop umami
docker compose exec -T db dropdb --username umami --if-exists umami
docker compose exec -T db createdb --username umami --owner umami umami
gzip -dc /protected/path/to/umami-backup.dump.gz \
  | docker compose exec -T db pg_restore \
      --username umami \
      --dbname umami \
      --no-owner
docker compose start umami
```

After restoration, repeat the health checks and confirm expected Umami websites
and data before ending the recovery window.

## Updates

Review Umami release notes and preserve a current database backup before an
update. On `ubuntu-dev01`:

```bash
cd /home/bcooke/docker/umami
docker compose pull
docker compose up -d
docker compose ps
curl --fail --silent --show-error http://192.168.1.86:3002/api/heartbeat
```

Then rerun the focused Ansible playbook from the control node to confirm the
managed configuration remains converged.

## External Dependencies

Public service availability depends on configuration outside this role:

- Hostinger DNS publishes `analytics.bradcooke.com`.
- The AT&T router forwards only TCP ports 80 and 443 to `ubuntu-dev01`.
- Nginx Proxy Manager terminates the public HTTPS connection and proxies the
  analytics hostname to the private Umami host port.
- Let's Encrypt supplies the public certificate.
- Abbey DNS needs a reliable internal path to the public proxied hostname when
  router NAT loopback is unavailable or inconsistent.

This role does not manage DNS, router forwarding, Nginx Proxy Manager, TLS
certificates, public website publication, or database-backup scheduling.
