#!/usr/bin/env bash

section "Host Reachability"

INVENTORY_FILE="$ABBEY_ROOT/ansible/inventory/hosts.yml"

if [ ! -f "$INVENTORY_FILE" ]; then
  warn "Inventory file not found: $INVENTORY_FILE"
  echo
  return
fi

hosts="$(python3 - "$INVENTORY_FILE" <<'PY'
import sys
import yaml

path = sys.argv[1]

with open(path, "r", encoding="utf-8") as f:
    data = yaml.safe_load(f) or {}

found = set()

def walk(node):
    if not isinstance(node, dict):
        return

    hosts = node.get("hosts", {})
    if isinstance(hosts, dict):
        for host in hosts:
            found.add(host)

    children = node.get("children", {})
    if isinstance(children, dict):
        for child in children.values():
            walk(child)

walk(data.get("all", data))

for host in sorted(found):
    print(host)
PY
)"

if [ -z "$hosts" ]; then
  warn "No hosts found in inventory"
  echo
  return
fi

for host in $hosts; do
  if ping -c 1 -W 1 "$host" >/dev/null 2>&1; then
    ok "Host reachable: $host"
  else
    fail "Host unreachable: $host"
  fi
done

echo
