#!/usr/bin/env python3
"""Run a metadata-driven, interactive single-plant update."""

import argparse
import datetime
import re
import subprocess
import sys
import uuid
from collections import defaultdict
from pathlib import Path

import yaml


IMAGE_SUFFIXES = {".jpg", ".jpeg", ".png", ".webp"}
VALID_STATUSES = {"recovering", "thriving", "blooming", "dormant", "deceased"}


def error(message, status=1):
    print("ERROR: {}".format(message))
    raise SystemExit(status)


def metadata(tag, path):
    try:
        result = subprocess.run(
            ["exiftool", "-s3", tag, str(path)],
            check=False,
            capture_output=True,
            text=True,
        )
    except OSError as exc:
        raise ValueError("Could not run ExifTool: {}".format(exc))
    if result.returncode != 0:
        detail = result.stderr.strip() or "ExifTool exited with status {}".format(
            result.returncode
        )
        raise ValueError("Could not read metadata from {}: {}".format(path.name, detail))
    return result.stdout.strip()


def slugify(value):
    return re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")


def discover(root, incoming):
    plants_dir = root / "working" / "plants"
    xmp_by_stem = defaultdict(list)
    for path in incoming.iterdir():
        if (
            path.is_file()
            and not path.name.startswith("._")
            and path.suffix.lower() == ".xmp"
        ):
            xmp_by_stem[path.stem.casefold()].append(path)

    records = []
    warnings = []
    images = sorted(
        (
            path
            for path in incoming.iterdir()
            if path.is_file()
            and not path.name.startswith("._")
            and path.suffix.lower() in IMAGE_SUFFIXES
        ),
        key=lambda path: (path.name.casefold(), path.name),
    )
    for image in images:
        sidecars = xmp_by_stem[image.stem.casefold()]
        if not sidecars:
            warnings.append("{}: adjacent XMP sidecar is missing".format(image.name))
            continue
        if len(sidecars) > 1:
            names = ", ".join(sorted(path.name for path in sidecars))
            warnings.append(
                "{}: multiple matching XMP sidecars found ({})".format(image.name, names)
            )
            continue

        sidecar = sidecars[0]
        try:
            caption = metadata("-XMP-dc:Description", sidecar)
            date_text = metadata("-DateTimeOriginal", image)
        except ValueError as exc:
            warnings.append(str(exc))
            continue
        if not caption:
            warnings.append(
                "{}: XMP-dc:Description caption is missing".format(sidecar.name)
            )
            continue

        match = re.match(r"^(\d{4}):(\d{2}):(\d{2})(?:[ T].*)?$", date_text)
        if not match:
            warnings.append(
                "{}: DateTimeOriginal is missing or invalid".format(image.name)
            )
            continue
        try:
            capture_date = datetime.date(*(int(value) for value in match.groups()))
        except ValueError:
            warnings.append(
                "{}: DateTimeOriginal is missing or invalid".format(image.name)
            )
            continue

        slug = slugify(caption)
        facts_path = plants_dir / slug / "facts.yaml"
        if not facts_path.is_file():
            warnings.append(
                "{}: caption '{}' does not match a plant workspace".format(
                    sidecar.name, caption
                )
            )
            continue
        try:
            facts = yaml.safe_load(facts_path.read_text(encoding="utf-8"))
        except (OSError, yaml.YAMLError) as exc:
            warnings.append("{}: could not read facts.yaml: {}".format(slug, exc))
            continue
        if not isinstance(facts, dict):
            warnings.append("{}: facts.yaml must contain a YAML mapping".format(slug))
            continue

        records.append(
            {
                "image": image,
                "sidecar": sidecar,
                "caption": caption,
                "slug": slug,
                "date": capture_date.isoformat(),
                "date_time": date_text,
                "facts": facts,
            }
        )

    groups = defaultdict(list)
    for record in records:
        groups[(record["slug"], record["date"])].append(record)
    for group in groups.values():
        group.sort(
            key=lambda record: (
                record["date_time"],
                record["image"].name.casefold(),
                record["image"].name,
            )
        )
        for index, record in enumerate(group, start=1):
            suffix = "-{:02d}".format(index) if len(group) > 1 else ""
            stem = "{}-{}{}".format(record["slug"], record["date"], suffix)
            record["image_target"] = incoming / "{}{}".format(
                stem, record["image"].suffix.lower()
            )
            record["sidecar_target"] = incoming / "{}.xmp".format(stem)

    return records, warnings


def prompt(message, default=None, required=False):
    suffix = " [{}]".format(default) if default is not None else ""
    while True:
        try:
            value = input("{}{}: ".format(message, suffix)).strip()
        except EOFError:
            error("Interactive input ended before the update was complete.", 2)
        if value:
            return value
        if default is not None:
            return default
        if not required:
            return ""
        print("A value is required.")


def confirm(message, default=False):
    marker = "Y/n" if default else "y/N"
    value = prompt("{} [{}]".format(message, marker)).lower()
    if not value:
        return default
    return value in {"y", "yes"}


def select_record(records):
    print("Incoming Plant Photos")
    print("=====================")
    for index, record in enumerate(records, start=1):
        print(
            "{}. {} — {} — {} ({})".format(
                index,
                record["image"].name,
                record["caption"],
                record["date"],
                record["slug"],
            )
        )
    print()

    if len(records) == 1:
        print("Selected the only matching photo.")
        return records[0]

    while True:
        value = prompt("Choose a photo", default="1")
        try:
            index = int(value)
        except ValueError:
            print("Enter a number from 1 to {}.".format(len(records)))
            continue
        if 1 <= index <= len(records):
            return records[index - 1]
        print("Enter a number from 1 to {}.".format(len(records)))


def rename_pair(record):
    pairs = (
        (record["image"], record["image_target"]),
        (record["sidecar"], record["sidecar_target"]),
    )
    sources = {source for source, _target in pairs}
    for _source, target in pairs:
        if target.exists() and target not in sources:
            error("Rename destination already exists: {}".format(target))

    staged = []
    try:
        for source, target in pairs:
            if source == target:
                continue
            temporary = source.parent / ".abbey-rename-{}".format(uuid.uuid4().hex)
            source.rename(temporary)
            staged.append((source, temporary, target))
        for source, temporary, target in staged:
            if target.exists():
                error("Rename destination appeared during apply: {}".format(target))
            temporary.rename(target)
    except BaseException:
        for source, temporary, target in reversed(staged):
            current = temporary if temporary.exists() else target
            if current.exists() and not source.exists():
                current.rename(source)
        raise


def update_command(args, record, photo, title, narrative, care, status, dry_run):
    command = [
        str(args.plant_command),
        "update",
        record["slug"],
        "--photo",
        str(photo),
        "--title",
        title,
        "--narrative",
        narrative,
        "--date",
        record["date"],
    ]
    if care:
        command.extend(["--care", care])
    if status:
        command.extend(["--status", status])
    if dry_run:
        command.append("--dry-run")
    return subprocess.run(command, check=False).returncode


def parse_args():
    parser = argparse.ArgumentParser(prog="abbey plant update")
    parser.add_argument("--root", type=Path, required=True, help=argparse.SUPPRESS)
    parser.add_argument(
        "--plant-command", type=Path, required=True, help=argparse.SUPPRESS
    )
    parser.add_argument(
        "--incoming", type=Path, default=Path.home() / "incoming" / "photos"
    )
    return parser.parse_args()


def main():
    args = parse_args()
    root = args.root.resolve()
    incoming = args.incoming.expanduser().resolve()
    if not incoming.is_dir():
        error("Incoming photo directory does not exist: {}".format(incoming))

    records, warnings = discover(root, incoming)
    for warning in warnings:
        print("WARN {}".format(warning))
    if warnings:
        print()
    if not records:
        error("No metadata-complete photos match an existing plant workspace.")

    record = select_record(records)
    facts = record["facts"]
    plant_name = facts.get("name", record["caption"])
    current_status = str(facts.get("status", {}).get("current", "")).lower()

    print()
    print("Selected Photo")
    print("--------------")
    print("Photo: {}".format(record["image"]))
    print("Caption: {}".format(record["caption"]))
    print("Date: {}".format(record["date"]))
    print("Matched plant: {} ({})".format(plant_name, record["slug"]))
    if not confirm("Continue with this plant?", default=True):
        print("Result: cancelled; no files changed")
        return 0

    print()
    print("Update Details")
    print("--------------")
    status = prompt("Status", default=current_status).lower()
    if status not in VALID_STATUSES:
        error("Status must be one of: {}".format(", ".join(sorted(VALID_STATUSES))), 2)
    title = prompt("Update title", default="Weekly Update")
    narrative = prompt("Observation", required=True)
    care = prompt("Care note (optional)")

    print()
    print("Incoming rename: {} -> {}".format(record["image"].name, record["image_target"].name))
    print("Sidecar rename: {} -> {}".format(record["sidecar"].name, record["sidecar_target"].name))
    print()
    if update_command(
        args, record, record["image"], title, narrative, care, status, True
    ) != 0:
        error("The update preview failed; no files were renamed.")

    print()
    if not confirm("Apply this update?", default=False):
        print("Result: cancelled after preview; no files changed")
        return 0

    rename_pair(record)
    if update_command(
        args,
        record,
        record["image_target"],
        title,
        narrative,
        care,
        status,
        False,
    ) != 0:
        error("The plant update failed after the incoming pair was renamed.")

    print("Interactive result: update applied and validated")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
