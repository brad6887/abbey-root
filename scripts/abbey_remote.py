#!/usr/bin/env python3
"""Resolve a named Tailscale peer and connect to it with SSH."""

from __future__ import annotations

import argparse
import ipaddress
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Tuple

import yaml


def fail(message: str) -> None:
    print(f"FAIL {message}", file=sys.stderr)
    raise SystemExit(1)


def tailscale_command() -> str:
    command = shutil.which("tailscale")
    if command:
        return command

    macos_app_command = Path("/Applications/Tailscale.app/Contents/MacOS/Tailscale")
    if macos_app_command.is_file() and os.access(str(macos_app_command), os.X_OK):
        return str(macos_app_command)

    fail("Tailscale is not installed or is not available on PATH.")
    return ""  # Unreachable; keeps static type checkers satisfied.


def load_tailscale_status(command: str) -> Dict[str, Any]:
    result = subprocess.run(
        [command, "status", "--json"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    if result.returncode != 0:
        detail = result.stderr.strip() or result.stdout.strip()
        message = "Unable to read Tailscale status. Open Tailscale and confirm it is connected."
        if detail:
            message = f"{message} ({detail})"
        fail(message)

    try:
        status = json.loads(result.stdout)
    except json.JSONDecodeError as exc:
        fail(f"Tailscale returned invalid status data: {exc}")

    if not isinstance(status, dict):
        fail("Tailscale returned an unexpected status response.")

    backend_state = status.get("BackendState")
    if backend_state and backend_state != "Running":
        fail(
            f"Tailscale is not connected (state: {backend_state}). "
            "Open Tailscale and connect before retrying."
        )

    return status


def peer_names(peer: Dict[str, Any]) -> Iterable[str]:
    hostname = peer.get("HostName")
    if isinstance(hostname, str) and hostname:
        yield hostname.rstrip(".")

    dns_name = peer.get("DNSName")
    if isinstance(dns_name, str) and dns_name:
        normalized = dns_name.rstrip(".")
        yield normalized
        yield normalized.split(".", 1)[0]


def status_peers(status: Dict[str, Any]) -> Iterable[Dict[str, Any]]:
    self_node = status.get("Self")
    if isinstance(self_node, dict):
        yield self_node

    peers = status.get("Peer", {})
    if isinstance(peers, dict):
        for peer in peers.values():
            if isinstance(peer, dict):
                yield peer


def resolve_peer(status: Dict[str, Any], requested_name: str) -> Dict[str, Any]:
    normalized_name = requested_name.rstrip(".").casefold()
    matches = []

    for peer in status_peers(status):
        names = {name.casefold() for name in peer_names(peer)}
        if normalized_name in names:
            matches.append(peer)

    if not matches:
        fail(f"No Tailscale peer named '{requested_name}' was found.")
    if len(matches) > 1:
        fail(f"Tailscale peer name '{requested_name}' is ambiguous.")

    peer = matches[0]
    if peer.get("Online") is False:
        fail(f"Tailscale peer '{requested_name}' is offline.")
    return peer


def peer_ipv4(peer: Dict[str, Any], requested_name: str) -> str:
    addresses = peer.get("TailscaleIPs", [])
    if isinstance(addresses, list):
        for address in addresses:
            if not isinstance(address, str):
                continue
            try:
                parsed = ipaddress.ip_address(address)
            except ValueError:
                continue
            if parsed.version == 4:
                return address

    fail(f"Tailscale peer '{requested_name}' does not have an IPv4 address.")
    return ""  # Unreachable; keeps static type checkers satisfied.


def find_inventory_user(value: Any, host_name: str) -> Optional[str]:
    if not isinstance(value, dict):
        return None

    hosts = value.get("hosts")
    if isinstance(hosts, dict) and host_name in hosts:
        host_data = hosts[host_name]
        if isinstance(host_data, dict):
            user = host_data.get("ansible_user")
            if isinstance(user, str) and user.strip():
                return user.strip()

    for child in value.values():
        user = find_inventory_user(child, host_name)
        if user:
            return user
    return None


def inventory_user(inventory_path: Path, host_name: str) -> Optional[str]:
    try:
        inventory = yaml.safe_load(inventory_path.read_text(encoding="utf-8")) or {}
    except (OSError, yaml.YAMLError) as exc:
        fail(f"Unable to read Abbey inventory: {exc}")
    return find_inventory_user(inventory, host_name)


def connect(args: argparse.Namespace, toolkit_root: Path) -> None:
    if not shutil.which("ssh"):
        fail("ssh is not installed or is not available on PATH.")

    status = load_tailscale_status(tailscale_command())
    peer = resolve_peer(status, args.name)
    address = peer_ipv4(peer, args.name)

    inventory_path = toolkit_root / "ansible/inventory/hosts.yml"
    ssh_user = args.user or inventory_user(inventory_path, args.name)
    if not ssh_user:
        fail(
            f"No SSH user is configured for '{args.name}' in the Abbey inventory. "
            "Pass --user USER to connect explicitly."
        )

    target = f"{ssh_user}@{address}"

    print(f"Tailscale peer: {args.name}")
    print(f"Tailscale IPv4: {address}")
    print(f"SSH target: {target}")
    print()
    print("Connecting...", flush=True)
    os.execvp("ssh", ["ssh", target])


def parsers() -> Tuple[argparse.ArgumentParser, argparse.ArgumentParser]:
    top_level = argparse.ArgumentParser(
        prog="abbey remote",
        description="Connect to named Abbey hosts through Tailscale.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""connection options:
  --name NAME   Required Tailscale and Abbey inventory host name.
  --user USER   Override the SSH user from the Abbey inventory.

examples:
  abbey remote connect --name ubuntu-dev01
  abbey remote connect --name ubuntu-dev01 --user bcooke

Run 'abbey remote connect help' for command-specific help.""",
    )
    subcommands = top_level.add_subparsers(dest="command")
    connect_parser = subcommands.add_parser(
        "connect",
        help="Resolve a Tailscale peer and connect with SSH.",
        description=(
            "Resolve a named online Tailscale peer, read its SSH user from "
            "Abbey inventory, and start an interactive SSH session."
        ),
        epilog="""examples:
  abbey remote connect --name ubuntu-dev01
  abbey remote connect --name ubuntu-dev01 --user bcooke""",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    connect_parser.add_argument(
        "--name",
        required=True,
        help="Required Tailscale and Abbey inventory host name.",
    )
    connect_parser.add_argument(
        "--user",
        help="Override the SSH user from the Abbey inventory.",
    )
    subcommands.add_parser("help", help="Show remote command help.")
    return top_level, connect_parser


def main(argv: Optional[List[str]] = None) -> int:
    arguments = list(argv) if argv is not None else sys.argv[1:]
    top_level, connect_parser = parsers()

    if not arguments or arguments == ["help"]:
        top_level.print_help()
        return 0

    if arguments == ["connect", "help"]:
        connect_parser.print_help()
        return 0

    args = top_level.parse_args(arguments)
    if args.command == "help":
        top_level.print_help()
        return 0

    toolkit_root = Path(__file__).resolve().parent.parent
    connect(args, toolkit_root)
    return 0


if __name__ == "__main__":
    sys.exit(main())
