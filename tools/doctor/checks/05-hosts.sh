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

with open(path, "r", encoding="utf-8") as handle:
    data = yaml.safe_load(handle) or {}

found = {}

def walk(node):
    if not isinstance(node, dict):
        return

    hosts = node.get("hosts", {})
    if isinstance(hosts, dict):
        for name, values in hosts.items():
            values = values if isinstance(values, dict) else {}
            found[name] = values.get("ansible_host", name)

    children = node.get("children", {})
    if isinstance(children, dict):
        for child in children.values():
            walk(child)

walk(data.get("all", data))

for name in sorted(found):
    print(f"{name}\t{found[name]}")
PY
)"

if [ -z "$hosts" ]; then
  warn "No hosts found in inventory"
  echo
  return
fi

while IFS=$'\t' read -r host target; do
  if doctor_ping_host "$target"; then
    if [ "$host" = "$target" ]; then
      ok "Host reachable: $host"
    else
      ok "Host reachable: $host ($target)"
    fi
  else
    if [ "$host" = "$target" ]; then
      fail "Host unreachable: $host"
    else
      fail "Host unreachable: $host ($target)"
    fi
  fi
done <<< "$hosts"

echo
