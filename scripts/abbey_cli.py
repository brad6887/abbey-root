#!/usr/bin/env python3

import os
import sys
from collections import defaultdict
from pathlib import Path

import yaml


REPO_ROOT = Path(__file__).resolve().parent.parent
METADATA_FILE = REPO_ROOT / "config/cli/cli.yml"
CLI_REFERENCE = Path(
    os.environ.get(
        "ABBEY_CLI_REFERENCE",
        REPO_ROOT / "docs/generated/CLI_REFERENCE.md",
    )
)


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



def grouped_commands(commands):
    grouped = defaultdict(list)

    for command_name, command_data in commands.items():
        category = command_data.get("category", "other")
        grouped[category].append((command_name, command_data))

    return grouped


def visible_subcommands(command_data):
    return {
        name: data
        for name, data in command_data.get("subcommands", {}).items()
        if not data.get("hidden", False)
    }


def render_context(project_root):
    data = load_metadata()

    categories = data.get("categories", {})
    commands = visible_commands(data.get("commands", {}))
    active_project_root = Path(project_root).expanduser().resolve()

    print("## Abbey CLI Architecture")
    print()
    print(
        "Abbey uses a shared toolkit for command implementation while the active "
        "project owns its project-specific configuration, planning, content, and "
        "session data."
    )
    print()
    print(f"- Toolkit root (`ABBEY_TOOLKIT_ROOT`): `{REPO_ROOT}`")
    print(f"- Active project root (`ABBEY_ROOT`): `{active_project_root}`")
    print("- Dispatcher: `tools/bin/abbey`")
    print("- Command registry: `config/cli/cli.yml`")
    print("- Command implementations: `tools/bin/`")
    print("- Generated CLI reference: `docs/generated/CLI_REFERENCE.md`")
    print()
    print(
        "The dispatcher, command registry, implementations, and generated CLI "
        "reference are toolkit-owned. Commands resolve project data from the "
        "active project root."
    )
    print()
    print("## Registered Commands")
    print()
    print(
        "The following visible commands are generated from "
        "`config/cli/cli.yml`."
    )
    print()

    grouped = grouped_commands(commands)

    rendered_categories = set()

    for category_name in categories:
        if category_name not in grouped:
            continue

        rendered_categories.add(category_name)
        print(f"### {category_title(categories, category_name)}")
        print()

        for command_name, command_data in sorted(grouped[category_name]):
            description = command_data.get("description", "")
            print(f"- `abbey {command_name}` — {description}")

            subcommands = visible_subcommands(command_data)
            for subcommand_name, subcommand_data in sorted(subcommands.items()):
                subcommand_description = subcommand_data.get("description", "")
                print(
                    f"  - `abbey {command_name} {subcommand_name}` — "
                    f"{subcommand_description}"
                )

        print()

    for category_name in sorted(set(grouped) - rendered_categories):
        print(f"### {category_title(categories, category_name)}")
        print()

        for command_name, command_data in sorted(grouped[category_name]):
            description = command_data.get("description", "")
            print(f"- `abbey {command_name}` — {description}")

            subcommands = visible_subcommands(command_data)
            for subcommand_name, subcommand_data in sorted(subcommands.items()):
                subcommand_description = subcommand_data.get("description", "")
                print(
                    f"  - `abbey {command_name} {subcommand_name}` — "
                    f"{subcommand_description}"
                )

        print()

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

    grouped = grouped_commands(commands)

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

    grouped = grouped_commands(commands)

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
            subcommands = visible_subcommands(command_data)

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
                    options = subcommand_data.get("options", {})
                    if isinstance(options, dict):
                        for option, option_description in options.items():
                            lines.append(
                                f"  - `{option}` - {option_description}"
                            )
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
    elif command == "context":
        if len(sys.argv) == 2:
            project_root = REPO_ROOT
        elif len(sys.argv) == 4 and sys.argv[2] == "--project-root":
            project_root = sys.argv[3]
        else:
            print(
                "ERROR: context accepts only --project-root PATH.",
                file=sys.stderr,
            )
            print(
                "Usage: scripts/abbey_cli.py context "
                "[--project-root PATH]",
                file=sys.stderr,
            )
            sys.exit(1)

        render_context(project_root)
    else:
        print(f"ERROR: Unknown abbey_cli.py command: {command}", file=sys.stderr)
        print(
            "Usage: scripts/abbey_cli.py "
            "[help|markdown|context [--project-root PATH]]",
            file=sys.stderr,
        )
        sys.exit(1)


if __name__ == "__main__":
    main()
