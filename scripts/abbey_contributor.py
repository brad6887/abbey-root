#!/usr/bin/env python3
"""Manage contributor intent and invoke focused, inventory-bounded Ansible runs."""

from __future__ import annotations

import argparse
import base64
import copy
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

import yaml

ROOT = Path(__file__).resolve().parent.parent
STATES = {"apply": "active", "revoke": "revoked", "purge": "absent"}
NAME = re.compile(r"[a-z_][a-z0-9_-]{0,30}\Z")
HOST = re.compile(r"[A-Za-z0-9][A-Za-z0-9_.-]*\Z")
RESERVED = {"root", "bcooke", "bradcooke", "nobody", "ansible", "abbey-deploy"}
FORBIDDEN_GROUPS = {"root", "sudo", "wheel", "admin"}


class DefinitionError(ValueError):
    pass


class UniqueLoader(yaml.SafeLoader):
    """Reject duplicate keys instead of silently dropping access policy."""


def unique_mapping(loader, node, deep=False):
    result = {}
    for key_node, value_node in node.value:
        key = loader.construct_object(key_node, deep=deep)
        if not isinstance(key, str) or key in result:
            raise DefinitionError("Mapping keys must be unique strings.")
        result[key] = loader.construct_object(value_node, deep=deep)
    return result


UniqueLoader.add_constructor(
    yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, unique_mapping
)


def mapping(value, allowed, required, label):
    if not isinstance(value, dict):
        raise DefinitionError(f"{label} must be a mapping.")
    if set(value) - allowed or required - set(value):
        raise DefinitionError(f"{label} requires {sorted(required)}; allowed fields: {sorted(allowed)}.")


def public_key(path):
    """Only accept one bare ED25519 public key; never print rejected content."""
    text = path.read_text(encoding="utf-8").strip()
    lines = text.splitlines()
    fields = text.split()
    if len(lines) != 1 or len(fields) < 2 or fields[0] != "ssh-ed25519":
        raise DefinitionError("Key file must contain one bare ED25519 public key, never a private key.")
    try:
        blob = base64.b64decode(fields[1], validate=True)
        # SSH wire format: algorithm string followed by the 32-byte public key.
        if len(blob) != 51 or blob[:19] != b"\x00\x00\x00\x0bssh-ed25519\x00\x00\x00\x20":
            raise ValueError()
    except ValueError as exc:
        raise DefinitionError("Invalid ED25519 public key encoding.") from exc
    key = f"ssh-ed25519 {fields[1]}"
    fingerprint = "SHA256:" + base64.b64encode(hashlib.sha256(blob).digest()).decode().rstrip("=")
    return key, fingerprint


def load_definition(root, username, action=None):
    if not NAME.fullmatch(username) or username in RESERVED:
        raise DefinitionError("Use a non-administrator Linux contributor username (up to 31 characters).")
    directory = root / "ansible/contributors"
    path = directory / f"{username}.yml"
    if directory.is_symlink() or path.is_symlink() or not path.is_file():
        raise DefinitionError(f"Missing regular contributor definition: {path}")
    raw = path.read_text(encoding="utf-8")
    data = yaml.load(raw, Loader=UniqueLoader)
    mapping(data, {"username", "state", "ssh_public_key", "access"},
            {"username", "state", "ssh_public_key", "access"}, "Contributor")
    if data["username"] != username or not isinstance(data["state"], str) or data["state"] not in {"active", "revoked", "absent"}:
        raise DefinitionError("Filename and username must agree; state must be active, revoked, or absent.")
    if not isinstance(data["access"], dict) or not data["access"]:
        raise DefinitionError("access must contain at least one explicit inventory hostname.")
    spec = copy.deepcopy(data)
    spec["state"] = STATES.get(action, data["state"])
    for host, policy in spec["access"].items():
        if not isinstance(host, str) or not HOST.fullmatch(host) or host in {"all", "ungrouped", "localhost"}:
            raise DefinitionError("Access keys must be individual inventory hostnames, never host patterns.")
        mapping(policy, {"login", "groups", "sudo"}, {"login"}, f"Access for {host}")
        if type(policy["login"]) is not bool:
            raise DefinitionError(f"{host}: login must be true or false.")
        policy.setdefault("groups", [])
        policy.setdefault("sudo", "none")
        groups = policy["groups"]
        if (not isinstance(groups, list) or
                any(not isinstance(g, str) or not NAME.fullmatch(g) for g in groups) or
                len(set(groups)) != len(groups)):
            raise DefinitionError(f"{host}: groups must be a list of unique Linux group names.")
        if FORBIDDEN_GROUPS.intersection(groups) or username in groups:
            raise DefinitionError(f"{host}: use the sudo field; primary/admin groups are not supplementary entitlements.")
        if not isinstance(policy["sudo"], str) or policy["sudo"] not in {"none", "full"}:
            raise DefinitionError(f"{host}: sudo must be none or full.")
        if not policy["login"] and (groups or policy["sudo"] != "none"):
            raise DefinitionError(f"{host}: login=false cannot carry groups or sudo grants.")
        policy["state"] = ("absent" if spec["state"] == "absent" else
                           "active" if spec["state"] == "active" and policy["login"] else "revoked")
    reference = data["ssh_public_key"]
    if not isinstance(reference, str) or not re.fullmatch(r"keys/[A-Za-z0-9_.-]+\.pub", reference):
        raise DefinitionError("ssh_public_key must reference keys/<name>.pub relative to contributors/.")
    key_path = directory / reference
    if ((directory / "keys").is_symlink() or not key_path.resolve().is_relative_to((directory / "keys").resolve()) or key_path.is_symlink()):
        raise DefinitionError("Public key references must stay inside contributors/keys/.")
    # The reference is controller-only data; never pass a user-authored path to Jinja.
    spec.pop("ssh_public_key")
    needs_key = any(p["state"] == "active" for p in spec["access"].values())
    if key_path.is_file():
        spec["public_key"], spec["fingerprint"] = public_key(key_path)
    elif needs_key:
        raise DefinitionError(f"Missing public key: {key_path}")
    else:
        spec["public_key"], spec["fingerprint"] = "", "unavailable (not needed to disable access)"
    return path, raw, data, spec


def save_state(path, original, state):
    """Keep comments/layout while atomically changing the single top-level state."""
    matches = list(re.finditer(r"^state:[^\n]*(?:\n|$)", original, re.MULTILINE))
    if len(matches) != 1:
        raise DefinitionError("Use a single top-level 'state: active|revoked|absent' line.")
    match = matches[0]
    comment = match.group().partition("#")[2].strip()
    replacement = f"state: {state}" + (f"  # {comment}" if comment else "") + "\n"
    updated = original[:match.start()] + replacement + original[match.end():]
    if path.read_text(encoding="utf-8") != original:
        raise DefinitionError("Contributor definition changed during this run; retry after reviewing it.")
    if updated == original:
        return
    fd, temporary = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as handle:
            handle.write(updated)
            handle.flush()
            os.fsync(handle.fileno())
        os.chmod(temporary, path.stat().st_mode & 0o777)
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def environment(root):
    env = os.environ.copy()
    env.setdefault("ANSIBLE_CONFIG", str(root / "ansible/ansible.cfg"))
    env["ANSIBLE_ROLES_PATH"] = str(root / "ansible/roles")
    env["ANSIBLE_LIBRARY"] = str(root / "ansible/library")
    return env


def inventory_hosts(root, env):
    result = subprocess.run(
        ["ansible-inventory", "-i", str(root / "ansible/inventory/hosts.yml"), "--list"],
        cwd=root / "ansible", env=env, text=True, capture_output=True, check=True,
    )
    inventory = json.loads(result.stdout)
    # Include hosts with no variables; do not interpret groups as access grants.
    hosts = set(inventory.get("_meta", {}).get("hostvars", {}))
    for name, group in inventory.items():
        if name != "_meta" and isinstance(group, dict):
            hosts.update(group.get("hosts", []))
    return hosts, inventory.get("_meta", {}).get("hostvars", {})


def preview(spec, command, remove_home):
    print(f"Contributor: {spec['username']}", flush=True)
    print(f"Desired lifecycle: {spec['state']} ({command})")
    print(f"Public key: ED25519 {spec['fingerprint']}")
    for host, policy in sorted(spec["access"].items()):
        groups = ",".join(policy["groups"]) if policy["state"] == "active" else ""
        sudo = policy["sudo"] if policy["state"] == "active" else "none"
        print(f"  {host}: state={policy['state']} login={policy['login']} "
              f"groups={groups or '(primary only)'} sudo={sudo}")
    print("Unlisted hosts receive no account or access changes.")
    if spec["state"] == "absent":
        print("PURGE: " + ("remove account, home and mailbox" if remove_home else "remove account; preserve home"))
    print(flush=True)


def parser():
    result = argparse.ArgumentParser(
        prog="abbey contributor",
        description="Manage Abbey contributor accounts from ansible/contributors/<username>.yml.",
        epilog="Run on an Ansible control node. See docs/runbooks/CONTRIBUTOR_WORKFLOW.md.",
    )
    commands = result.add_subparsers(dest="command")
    for action in ("plan", "apply", "status", "revoke", "purge"):
        p = commands.add_parser(action)
        p.add_argument("username")
        if action == "plan":
            p.add_argument("--action", choices=tuple(STATES), help="Preview a lifecycle transition without saving it")
        if action == "purge":
            p.add_argument("--confirm", required=True, metavar="USERNAME", help="Must exactly match the username")
        if action in {"plan", "purge"}:
            p.add_argument("--remove-home", action="store_true", help="Purge home and mailbox; requires purge intent")
        if action in {"apply", "revoke", "purge"}:
            p.add_argument("--check", action="store_true", help="Preview only; do not save state or change hosts")
        p.add_argument("--ask-become-pass", "-K", action="store_true")
    return result


def run(args, root=ROOT):
    action = getattr(args, "action", None) if args.command == "plan" else args.command
    readonly = args.command in {"plan", "status"} or getattr(args, "check", False)
    remove_home = getattr(args, "remove_home", False)
    if args.command == "purge" and args.confirm != args.username:
        raise DefinitionError("--confirm must exactly match the contributor username.")
    if remove_home and action != "purge":
        raise DefinitionError("--remove-home requires purge or plan --action purge.")
    for command in ("ansible-inventory", "ansible-playbook"):
        if not shutil.which(command):
            raise DefinitionError(f"{command} is required. Run from an Abbey Ansible control node.")
    env = environment(root)
    # Serialize every lifecycle transition against this checkout without locking/replacing the YAML inode.
    # Read-only commands create no repository files.
    lock = None
    try:
        if not readonly:
            lock_dir = root / ".abbey/contributor-locks"
            lock_dir.mkdir(parents=True, exist_ok=True)
            # Validate the name before using it in a lock path.
            if not NAME.fullmatch(args.username):
                raise DefinitionError("Invalid contributor username.")
            lock = (lock_dir / f"{args.username}.lock").open("a")
            fcntl.flock(lock.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        path, original, data, spec = load_definition(root, args.username, action)
        hosts, hostvars = inventory_hosts(root, env)
        unknown = set(spec["access"]) - hosts
        if unknown:
            raise DefinitionError(f"Unknown inventory hosts: {', '.join(sorted(unknown))}")
        for host in spec["access"]:
            variables = hostvars.get(host, {})
            if args.username in {variables.get("admin_user"), variables.get("ansible_user")}:
                raise DefinitionError(f"{host}: refusing to manage an administrator/connection account.")
        preview(spec, args.command, remove_home)
        variables = {
            "abbey_contributor": spec,
            "abbey_contributor_targets": sorted(spec["access"]),
            "abbey_contributor_status_only": args.command == "status",
            "abbey_contributor_remove_home": remove_home,
            "abbey_contributor_purge_confirm": args.username if action == "purge" else "",
            # The inventory marks rocky-ansible01 local for its own controller.
            # Always use SSH here so running from Ubuntu never targets the wrong machine.
            "ansible_connection": "ssh",
        }
        with tempfile.NamedTemporaryFile(mode="w", suffix=".json", encoding="utf-8") as handle:
            json.dump(variables, handle)
            handle.flush()
            cmd = ["ansible-playbook", "-i", str(root / "ansible/inventory/hosts.yml"),
                   str(root / "ansible/playbooks/contributor.yml"), "--extra-vars", f"@{handle.name}"]
            if readonly:
                cmd.append("--check")
            if args.ask_become_pass:
                cmd.append("--ask-become-pass")
            # Catch missing dependencies/playbook problems before persisting intent.
            subprocess.run(cmd + ["--syntax-check"], cwd=root / "ansible", env=env, check=True)
            if not readonly:
                save_state(path, original, spec["state"])
                print(f"Saved desired state '{spec['state']}' to {path}.", flush=True)
            result = subprocess.run(cmd, cwd=root / "ansible", env=env)
            if result.returncode and not readonly:
                print("Desired state is retained. Review failed hosts; rerun the same command to converge.", file=sys.stderr)
            return result.returncode
    finally:
        if lock is not None:
            lock.close()


def main():
    p = parser()
    args = p.parse_args(["--help"] if sys.argv[1:] == ["help"] else None)
    if args.command is None:
        p.print_help()
        return 0
    try:
        return run(args)
    except (DefinitionError, OSError, yaml.YAMLError, ValueError, subprocess.CalledProcessError) as exc:
        # Never echo malformed YAML/key content; parse errors may include private data.
        if isinstance(exc, yaml.YAMLError):
            detail = "Invalid contributor YAML."
        elif isinstance(exc, subprocess.CalledProcessError):
            detail = f"Ansible preflight failed (exit {exc.returncode})."
        else:
            detail = str(exc)
        print(f"FAIL {detail}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
