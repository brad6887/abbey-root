#!/usr/bin/env python3
"""Prepare and apply reviewable multi-plant photo update worksheets."""

import argparse
import datetime
import os
import re
import shutil
import sys
import tempfile
from pathlib import Path

import yaml

IMAGE_SUFFIXES = {".jpg", ".jpeg", ".heic", ".png", ".tif", ".tiff"}
VALID_STATUSES = {"recovering", "thriving", "blooming", "dormant", "deceased"}


def error(message, status=1):
    print(f"ERROR: {message}")
    raise SystemExit(status)


def parse_date(value):
    try:
        return datetime.date.fromisoformat(value).isoformat()
    except (TypeError, ValueError):
        error(f"Date must use YYYY-MM-DD: {value}", 2)


def photo_match(name, date):
    escaped_date = re.escape(date)
    return re.fullmatch(
        rf"(?P<slug>[a-z0-9]+(?:-[a-z0-9]+)*)-{escaped_date}"
        rf"(?:-(?P<sequence>\d{{2}}))?(?P<extension>\.[^.]+)",
        name,
    )


def plant_slugs(root):
    plants_dir = root / "working" / "plants"
    if not plants_dir.is_dir():
        error(f"Plant workspace directory does not exist: {plants_dir}")
    return sorted(
        path.name
        for path in plants_dir.iterdir()
        if path.is_dir() and not path.name.startswith("_")
    )


def prepare(args):
    root = args.root.resolve()
    source = args.directory.expanduser().resolve()
    date = parse_date(args.date)
    if not source.is_dir():
        error(f"Photo directory does not exist: {source}")

    known_slugs = plant_slugs(root)
    known = set(known_slugs)
    groups = {slug: [] for slug in known_slugs}
    problems = []
    ignored_other_dates = 0

    for photo in sorted(source.iterdir(), key=lambda path: (path.name.casefold(), path.name)):
        if (
            not photo.is_file()
            or photo.name.startswith("._")
            or photo.suffix.lower() not in IMAGE_SUFFIXES
        ):
            continue
        match = photo_match(photo.name, date)
        if not match:
            if re.search(r"-\d{4}-\d{2}-\d{2}(?:-\d{2})?\.[^.]+$", photo.name):
                ignored_other_dates += 1
                continue
            problems.append(f"Unrecognized renamed photo for {date}: {photo.name}")
            continue
        slug = match.group("slug")
        if slug not in known:
            problems.append(f"Photo does not match a plant workspace: {photo.name}")
            continue
        sidecar = photo.with_suffix(".xmp")
        if not sidecar.is_file():
            problems.append(f"Photo is missing its paired XMP sidecar: {photo.name}")
            continue
        groups[slug].append(photo.name)

    if problems:
        print("Plant Batch Update Preparation")
        print("==============================")
        for problem in problems:
            print(f"FAIL {problem}")
        print(f"Result: preparation failed; {len(problems)} problem(s); no worksheet created")
        raise SystemExit(1)

    updates = []
    print("Plant Batch Update Preparation")
    print("==============================")
    print(f"Date: {date}")
    print(f"Source: {source}")
    for slug in known_slugs:
        photos = sorted(groups[slug])
        if not photos:
            print(f"WARN {slug}: no photos for {date}; skipped")
            continue
        history_path = root / "working" / "plants" / slug / "history.md"
        if not history_path.is_file():
            error(f"Plant history does not exist: {history_path}")
        history = history_path.read_text(encoding="utf-8")
        if re.search(rf"^## {re.escape(date)} —", history, re.MULTILINE):
            print(f"WARN {slug}: history already has an update for {date}; skipped")
            continue
        print(f"OK   {slug}: {len(photos)} photo(s)")
        updates.append({
            "plant": slug,
            "photos": photos,
            "current": photos[0] if len(photos) == 1 else None,
            "narrative": "",
            "care": "",
            "status": None,
        })

    if not updates:
        error(f"No plant photos found for {date}; no worksheet created")

    output = (
        args.output.expanduser().resolve()
        if args.output
        else root / "working" / "plant-updates" / f"{date}.yml"
    )
    if output.exists():
        error(f"Worksheet already exists: {output}")
    output.parent.mkdir(parents=True, exist_ok=True)
    worksheet = {
        "date": date,
        "source": str(source),
        "updates": updates,
    }
    output.write_text(
        yaml.safe_dump(worksheet, sort_keys=False, allow_unicode=True),
        encoding="utf-8",
    )
    if ignored_other_dates:
        print(f"INFO Ignored {ignored_other_dates} photo(s) from other dates")
    print(f"Worksheet: {output}")
    print(f"Result: prepared {len(updates)} plant update(s); review the worksheet before apply")


def replace_nested_scalar(text, section, key, value):
    lines = text.splitlines(keepends=True)
    section_index = None
    for index, line in enumerate(lines):
        if line.rstrip("\r\n") == f"{section}:":
            section_index = index
            break
    if section_index is None:
        raise ValueError(f"facts.yaml is missing section: {section}")
    for index in range(section_index + 1, len(lines)):
        line = lines[index]
        if line and not line[0].isspace():
            break
        if re.match(rf"^  {re.escape(key)}:\s*", line):
            ending = "\n" if line.endswith("\n") else ""
            lines[index] = f"  {key}: {value}{ending}"
            return "".join(lines)
    raise ValueError(f"facts.yaml is missing field: {section}.{key}")


def replace_status_tag(text, old_status, new_status):
    if old_status == new_status:
        return text
    lines = text.splitlines(keepends=True)
    in_tags = False
    for index, line in enumerate(lines):
        stripped = line.rstrip("\r\n")
        if stripped == "tags:":
            in_tags = True
            continue
        if in_tags and line and not line[0].isspace():
            break
        if in_tags and stripped.strip() == f"- {old_status}":
            ending = "\n" if line.endswith("\n") else ""
            indent = line[: len(line) - len(line.lstrip())]
            lines[index] = f"{indent}- {new_status}{ending}"
            break
    return "".join(lines)


def apply(args):
    root = args.root.resolve()
    worksheet_path = args.worksheet.expanduser().resolve()
    if not worksheet_path.is_file():
        error(f"Worksheet does not exist: {worksheet_path}")
    try:
        worksheet = yaml.safe_load(worksheet_path.read_text(encoding="utf-8"))
    except yaml.YAMLError as exc:
        error(f"Worksheet contains invalid YAML: {exc}")
    if not isinstance(worksheet, dict):
        error("Worksheet must contain a YAML mapping")

    date = parse_date(worksheet.get("date"))
    source_value = worksheet.get("source")
    source = Path(str(source_value)).expanduser().resolve() if source_value else None
    if source is None or not source.is_dir():
        error(f"Worksheet source directory does not exist: {source}")
    updates = worksheet.get("updates")
    if not isinstance(updates, list) or not updates:
        error("Worksheet must contain at least one update")

    plans = []
    problems = []
    seen_slugs = set()
    for number, update in enumerate(updates, start=1):
        label = f"update {number}"
        if not isinstance(update, dict):
            problems.append(f"{label}: must be a YAML mapping")
            continue
        slug = str(update.get("plant") or "").strip()
        label = slug or label
        if not slug or slug in seen_slugs:
            problems.append(f"{label}: plant is missing or duplicated")
            continue
        seen_slugs.add(slug)
        plant_dir = root / "working" / "plants" / slug
        facts_path = plant_dir / "facts.yaml"
        history_path = plant_dir / "history.md"
        photos_dir = plant_dir / "photos"
        if not all((plant_dir.is_dir(), facts_path.is_file(), history_path.is_file(), photos_dir.is_dir())):
            problems.append(f"{label}: plant workspace is incomplete")
            continue

        photo_names = update.get("photos")
        if not isinstance(photo_names, list) or not photo_names:
            problems.append(f"{label}: photos must contain at least one filename")
            continue
        if len(photo_names) != len(set(photo_names)):
            problems.append(f"{label}: photos contains duplicate filenames")
            continue
        valid_photos = []
        for name_value in photo_names:
            name = str(name_value)
            match = photo_match(name, date)
            if Path(name).name != name or not match or match.group("slug") != slug:
                problems.append(f"{label}: invalid photo filename for plant/date: {name}")
                continue
            photo = source / name
            if not photo.is_file():
                problems.append(f"{label}: source photo does not exist: {name}")
                continue
            if not photo.with_suffix(".xmp").is_file():
                problems.append(f"{label}: source XMP sidecar does not exist: {photo.with_suffix('.xmp').name}")
                continue
            destination = photos_dir / name
            if destination.exists():
                problems.append(f"{label}: destination photo already exists: {name}")
                continue
            valid_photos.append((photo, destination))

        current = update.get("current")
        if len(photo_names) == 1 and not current:
            current = photo_names[0]
        if not current:
            problems.append(f"{label}: current is required when multiple photos are listed")
        elif current not in photo_names:
            problems.append(f"{label}: current must name one of the listed photos")

        narrative = str(update.get("narrative") or "").strip()
        if not narrative:
            problems.append(f"{label}: narrative is required")
        care = str(update.get("care") or "").strip()
        requested_status = str(update.get("status") or "").strip().lower()
        if requested_status and requested_status not in VALID_STATUSES:
            problems.append(f"{label}: invalid status: {requested_status}")

        facts_text = facts_path.read_text(encoding="utf-8")
        history = history_path.read_text(encoding="utf-8")
        if re.search(rf"^## {re.escape(date)} —", history, re.MULTILINE):
            problems.append(f"{label}: a dated history entry already exists for {date}")
        try:
            facts = yaml.safe_load(facts_text)
            if not isinstance(facts, dict):
                raise ValueError("facts.yaml must contain a YAML mapping")
            current_status = str(facts.get("status", {}).get("current", "")).lower()
            new_status = requested_status or current_status
            updated_facts = replace_nested_scalar(
                facts_text, "photos", "current", f"photos/{current}"
            )
            updated_facts = replace_nested_scalar(
                updated_facts, "status", "current", new_status
            )
            updated_facts = replace_nested_scalar(
                updated_facts, "status", "updated", date
            )
            updated_facts = replace_status_tag(
                updated_facts, current_status, new_status
            )
        except (ValueError, yaml.YAMLError) as exc:
            problems.append(f"{label}: {exc}")
            continue

        entry = [
            f"## {date} — Weekly Update",
            "",
            "### Photos",
            "",
            *(f"- {name}" for name in photo_names),
            "",
            "### Observations",
            "",
            narrative,
        ]
        if care:
            entry.extend(["", "### Care", "", care])
        entry_text = "\n".join(entry) + "\n"
        separator = "" if history.endswith("\n\n") else "\n"
        updated_history = history + separator + "---\n\n" + entry_text
        plans.append({
            "slug": slug,
            "photos": valid_photos,
            "current": current,
            "facts_path": facts_path,
            "history_path": history_path,
            "facts_text": updated_facts,
            "history_text": updated_history,
            "photo_names": photo_names,
        })

    if problems:
        print("Plant Batch Update Validation")
        print("=============================")
        for problem in problems:
            print(f"FAIL {problem}")
        print(f"Result: validation failed; {len(problems)} problem(s); no files changed")
        raise SystemExit(1)

    print("Plant Batch Update")
    print("==================")
    print(f"Date: {date}")
    print(f"Worksheet: {worksheet_path}")
    for plan in plans:
        print(
            f'OK   {plan["slug"]}: {len(plan["photos"])} photo(s); '
            f'current={plan["current"]}'
        )
    if args.dry_run:
        print(f"Result: DRY RUN; {len(plans)} plant update(s) validated; no files changed")
        return

    created = []
    backups = []
    with tempfile.TemporaryDirectory(prefix=".abbey-plant-batch-", dir=root / "working") as temporary:
        stage = Path(temporary)
        try:
            for plan in plans:
                plant_stage = stage / plan["slug"]
                plant_stage.mkdir()
                for source_photo, destination in plan["photos"]:
                    staged_photo = plant_stage / destination.name
                    shutil.copy2(source_photo, staged_photo)
                    os.link(staged_photo, destination)
                    created.append(destination)
                for key in ("facts", "history"):
                    path = plan[f"{key}_path"]
                    backup = plant_stage / f"{key}.backup"
                    shutil.copy2(path, backup)
                    backups.append((path, backup))
                    replacement = plant_stage / f"{key}.new"
                    replacement.write_text(plan[f"{key}_text"], encoding="utf-8")
                    os.replace(replacement, path)
        except BaseException:
            for path, backup in reversed(backups):
                shutil.copy2(backup, path)
            for destination in reversed(created):
                destination.unlink(missing_ok=True)
            raise

    print(f"Result: applied {len(plans)} plant update(s)")


def build_parser():
    parser = argparse.ArgumentParser(prog="abbey plant update-batch")
    parser.add_argument("--root", type=Path, required=True, help=argparse.SUPPRESS)
    subparsers = parser.add_subparsers(dest="command", required=True)
    prepare_parser = subparsers.add_parser("prepare", help="create an update worksheet")
    prepare_parser.add_argument("directory", type=Path)
    prepare_parser.add_argument("--date", required=True)
    prepare_parser.add_argument("--output", type=Path)
    prepare_parser.set_defaults(handler=prepare)
    apply_parser = subparsers.add_parser("apply", help="apply a completed worksheet")
    apply_parser.add_argument("worksheet", type=Path)
    apply_parser.add_argument("--dry-run", action="store_true")
    apply_parser.set_defaults(handler=apply)
    return parser


def main():
    args = build_parser().parse_args()
    args.handler(args)


if __name__ == "__main__":
    main()
