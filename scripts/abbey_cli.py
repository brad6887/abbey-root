#!/usr/bin/env python3

import sys
from collections import defaultdict
from pathlib import Path

import yaml


METADATA_FILE = Path("config/cli/cli.yml")
CLI_REFERENCE = Path("docs/generated/CLI_REFERENCE.md")


def load_metadata():
    if not METADATA_FILE.exists():
        print(f"ERROR: Missing CLI metadata: {METADATA_FILE}", file=sys.stderr)
        sys.exit(1)

    with METADATA_FILE.open("r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def category_title(categories, category_name):
    return categories.get(category_name, {}).get("description", category_name).replace(" commands", "")


def visible_commands(commands):
    return {
        name: data
        for name, data in commands.items()
        if not data.get("hidden", False)
    }


def render_help():
    data = load_metadata()

    cli = data.get("cli", {})
    categories = data.get("categories", {})
    commands = visible_commands(data.get("commands", {}))

    print(cli.get("description", "Abbey Root Toolkit"))
    tagline = cli.get("tagline")
    if tagline:
        print()
        print(tagline)

    print()
    print("Usage:")
    print("  abbey <command> [options]")
    print()

    grouped = defaultdict(list)

    for command_name, command_data in commands.items():
        category = command_data.get("category", "other")
        grouped[category].append((command_name, command_data))

    print("Commands")
    print("--------")
    print()

    for category_name in categories:
        if category_name not in grouped:
            continue

        title = category_title(categories, category_name)
        print(title)
        print("-" * len(title))

        for command_name, command_data in sorted(grouped[category_name]):
            description = command_data.get("description", "")
            aliases = command_data.get("aliases", [])

            alias_text = ""
            if aliases:
                alias_text = f" Alias: {', '.join(aliases)}"

            print(f"  abbey {command_name:<16} {description}{alias_text}")

        print()

    print("Need help with a command?")
    print()
    print("  abbey <command> help")


def render_markdown():
    data = load_metadata()

    cli = data.get("cli", {})
    categories = data.get("categories", {})
    commands = visible_commands(data.get("commands", {}))

    lines = [
        "# Abbey Root CLI Reference",
        "",
        "*Generated automatically from `config/cli/cli.yml`. Do not edit directly.*",
        "",
        "## Overview",
        "",
        cli.get("description", "Abbey Root Toolkit"),
        "",
    ]

    tagline = cli.get("tagline")
    if tagline:
        lines.extend([tagline, ""])

    lines.extend([
        "```text",
        "abbey <command> [options]",
        "```",
        "",
    ])

    grouped = defaultdict(list)

    for command_name, command_data in commands.items():
        category = command_data.get("category", "other")
        grouped[category].append((command_name, command_data))

    for category_name in categories:
        if category_name not in grouped:
            continue

        lines.append(f"## {category_title(categories, category_name)}")
        lines.append("")

        for command_name, command_data in sorted(grouped[category_name]):
            description = command_data.get("description", "")
            usage = command_data.get("usage", f"abbey {command_name}")
            aliases = command_data.get("aliases", [])
            examples = command_data.get("examples", [])
            subcommands = command_data.get("subcommands", {})

            lines.append(f"### `abbey {command_name}`")
            lines.append("")
            lines.append(description)
            lines.append("")
            lines.append("**Usage**")
            lines.append("")
            lines.append("```text")
            lines.append(usage)
            lines.append("```")
            lines.append("")

            if aliases:
                lines.append("**Aliases**")
                lines.append("")
                for alias in aliases:
                    lines.append(f"- `abbey {alias}`")
                lines.append("")

            if subcommands:
                lines.append("**Subcommands**")
                lines.append("")
                for subcommand_name, subcommand_data in sorted(subcommands.items()):
                    sub_desc = subcommand_data.get("description", "")
                    sub_usage = subcommand_data.get("usage", f"abbey {command_name} {subcommand_name}")
                    lines.append(f"- `{subcommand_name}` - {sub_desc}")
                    lines.append(f"  - `{sub_usage}`")
                lines.append("")

            if examples:
                lines.append("**Examples**")
                lines.append("")
                lines.append("```text")
                for example in examples:
                    lines.append(example)
                lines.append("```")
                lines.append("")

    CLI_REFERENCE.parent.mkdir(parents=True, exist_ok=True)
    CLI_REFERENCE.write_text("\n".join(lines) + "\n", encoding="utf-8")

    print(f"Generated {CLI_REFERENCE}")


def main():
    command = sys.argv[1] if len(sys.argv) > 1 else "help"

    if command == "help":
        render_help()
    elif command in ("markdown", "docs", "cli-reference"):
        render_markdown()
    else:
        print(f"ERROR: Unknown abbey_cli.py command: {command}", file=sys.stderr)
        print("Usage: scripts/abbey_cli.py [help|markdown]", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
