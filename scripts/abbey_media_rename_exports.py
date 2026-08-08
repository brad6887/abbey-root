#!/usr/bin/env python3

import argparse
import datetime
import json
import os
import re
import subprocess
import sys
import tempfile
import uuid
from collections import defaultdict
from pathlib import Path

import yaml


class MediaError(Exception):
    pass


def configured_string(mapping, key, label):
    value = mapping.get(key)
    if not isinstance(value, str) or not value.strip():
        raise MediaError(f"{label}.{key} must be a non-empty string")
    return value.strip()


def load_config(path):
    try:
        config = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    except (OSError, yaml.YAMLError) as error:
        raise MediaError(f"Could not load media configuration: {error}") from error
    if not isinstance(config, dict) or config.get("schema_version") != 1:
        raise MediaError("Media configuration must declare schema_version: 1")
    workflow = config.get("rename_exports")
    if not isinstance(workflow, dict):
        raise MediaError("rename_exports must be a YAML mapping")

    caption_tag = configured_string(workflow, "caption_tag", "rename_exports")
    date_tag = configured_string(workflow, "date_tag", "rename_exports")
    template = configured_string(workflow, "filename_template", "rename_exports")
    manifest_name = configured_string(workflow, "manifest", "rename_exports")
    if template != "{caption_slug}-{capture_date}{sequence}":
        raise MediaError("unsupported rename_exports.filename_template")

    extensions = workflow.get("extensions")
    if not isinstance(extensions, list) or not extensions:
        raise MediaError("rename_exports.extensions must be a non-empty list")
    normalized = set()
    for extension in extensions:
        if not isinstance(extension, str) or not extension.strip():
            raise MediaError("rename_exports.extensions contains an invalid value")
        extension = extension.strip().lower()
        normalized.add(extension if extension.startswith(".") else f".{extension}")

    manifest_path = Path(manifest_name)
    if manifest_path.is_absolute() or len(manifest_path.parts) != 1:
        raise MediaError("rename_exports.manifest must be a filename")
    return caption_tag, date_tag, template, manifest_name, normalized


def metadata(tag, path):
    result = subprocess.run(
        ["exiftool", "-s3", f"-{tag}", str(path)],
        check=False,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        detail = result.stderr.strip() or f"ExifTool exited with status {result.returncode}"
        raise MediaError(f"Could not read metadata from {path.name}: {detail}")
    return result.stdout.strip()


def build_records(directory, caption_tag, date_tag, extensions):
    images = sorted(
        (
            path
            for path in directory.iterdir()
            if path.is_file()
            and not path.name.startswith("._")
            and path.suffix.lower() in extensions
        ),
        key=lambda path: (path.name.casefold(), path.name),
    )
    if not images:
        raise MediaError(f"No supported media found in: {directory}")

    xmp_by_stem = defaultdict(list)
    for path in directory.iterdir():
        if path.is_file() and not path.name.startswith("._") and path.suffix.lower() == ".xmp":
            xmp_by_stem[path.stem.casefold()].append(path)

    records = []
    problems = []
    for image in images:
        sidecars = xmp_by_stem[image.stem.casefold()]
        if not sidecars:
            problems.append(f"{image.name}: adjacent XMP sidecar is missing")
            continue
        if len(sidecars) > 1:
            names = ", ".join(sorted(path.name for path in sidecars))
            problems.append(f"{image.name}: multiple matching XMP sidecars found ({names})")
            continue
        sidecar = sidecars[0]
        caption = metadata(caption_tag, sidecar)
        if not caption:
            problems.append(f"{sidecar.name}: {caption_tag} caption is missing")
            continue
        slug = re.sub(r"[^a-z0-9]+", "-", caption.lower()).strip("-")
        if not slug:
            problems.append(f"{sidecar.name}: caption does not contain filename-safe letters or numbers")
            continue
        date_text = metadata(date_tag, image)
        match = re.match(r"^(\d{4}):(\d{2}):(\d{2})(?:[ T].*)?$", date_text)
        if not match:
            problems.append(f"{image.name}: {date_tag} is missing or invalid")
            continue
        try:
            capture_date = datetime.date(*(int(value) for value in match.groups()))
        except ValueError:
            problems.append(f"{image.name}: {date_tag} is missing or invalid")
            continue
        records.append(
            {
                "image": image,
                "sidecar": sidecar,
                "caption": caption,
                "slug": slug,
                "date": capture_date.isoformat(),
                "date_time": date_text,
            }
        )
    if problems:
        for problem in problems:
            print(f"FAIL {problem}")
        raise MediaError(f"validation failed; {len(problems)} problem(s); no files renamed")
    return records


def assign_targets(directory, records, template):
    groups = defaultdict(list)
    for record in records:
        groups[(record["slug"], record["date"])].append(record)
    for group in groups.values():
        group.sort(key=lambda record: (record["date_time"], record["image"].name.casefold(), record["image"].name))
        for index, record in enumerate(group, start=1):
            sequence = f"-{index:02d}" if len(group) > 1 else ""
            stem = template.format(
                caption_slug=record["slug"],
                capture_date=record["date"],
                sequence=sequence,
            )
            record["image_target"] = directory / f"{stem}{record['image'].suffix.lower()}"
            record["sidecar_target"] = directory / f"{stem}.xmp"

    sources = {record[key] for record in records for key in ("image", "sidecar")}
    targets = [record[key] for record in records for key in ("image_target", "sidecar_target")]
    duplicates = sorted({target for target in targets if targets.count(target) > 1}, key=lambda path: path.name)
    collisions = sorted({target for target in targets if target.exists() and target not in sources}, key=lambda path: path.name)
    if duplicates or collisions:
        for target in duplicates:
            print(f"FAIL Multiple files would be renamed to: {target.name}")
        for target in collisions:
            print(f"FAIL Destination already exists: {target.name}")
        raise MediaError("validation failed; no files renamed")


def rename_records(directory, records):
    staged = []
    try:
        for record in records:
            for source_key, target_key in (("image", "image_target"), ("sidecar", "sidecar_target")):
                source = record[source_key]
                target = record[target_key]
                if source == target:
                    continue
                temporary = directory / f".abbey-rename-{uuid.uuid4().hex}"
                source.rename(temporary)
                staged.append((source, temporary, target))
        for source, temporary, target in staged:
            if target.exists():
                raise MediaError(f"Destination appeared during rename: {target.name}")
            temporary.rename(target)
    except BaseException:
        for source, temporary, target in reversed(staged):
            current = temporary if temporary.exists() else target
            if current.exists() and not source.exists():
                current.rename(source)
        raise


def restore_original_names(records):
    for record in reversed(records):
        for source_key, target_key in (("sidecar", "sidecar_target"), ("image", "image_target")):
            source = record[source_key]
            target = record[target_key]
            if source != target and target.exists() and not source.exists():
                target.rename(source)


def write_manifest(path, project_name, project_root, config_path, config_source, records):
    manifest = {
        "schema_version": 1,
        "project": project_name,
        "project_root": str(project_root),
        "configuration": str(config_path),
        "configuration_source": config_source,
        "directory": str(path.parent),
        "items": [
            {
                "caption": record["caption"],
                "capture_date": record["date"],
                "capture_time": record["date_time"],
                "original_image": record["image"].name,
                "original_sidecar": record["sidecar"].name,
                "published_image": record["image_target"].name,
                "published_sidecar": record["sidecar_target"].name,
            }
            for record in records
        ],
    }
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=str(path.parent), prefix=f".{path.name}.", delete=False) as handle:
            temporary = Path(handle.name)
            json.dump(manifest, handle, indent=2, ensure_ascii=False)
            handle.write("\n")
            handle.flush()
            os.fsync(handle.fileno())
        os.replace(temporary, path)
    except BaseException:
        if temporary is not None and temporary.exists():
            temporary.unlink()
        raise


def parse_args():
    parser = argparse.ArgumentParser(prog="abbey media rename-exports")
    parser.add_argument("--project-root", type=Path, required=True)
    parser.add_argument("--config", type=Path, required=True)
    parser.add_argument("--config-source", required=True)
    parser.add_argument("--directory", type=Path, required=True)
    parser.add_argument("--dry-run", action="store_true")
    return parser.parse_args()


def main():
    args = parse_args()
    project_root = args.project_root.resolve()
    directory = args.directory.expanduser().resolve()
    config_path = args.config.resolve()
    try:
        if not directory.is_dir():
            raise MediaError(f"Export directory does not exist: {directory}")
        metadata_config = yaml.safe_load((project_root / ".abbey/project.yml").read_text(encoding="utf-8")) or {}
        project_name = metadata_config.get("project", {}).get("name", "Abbey Project")
        caption_tag, date_tag, template, manifest_name, extensions = load_config(config_path)
        records = build_records(directory, caption_tag, date_tag, extensions)
        assign_targets(directory, records, template)
        manifest_path = directory / manifest_name

        print("Abbey Media Export Rename")
        print("=========================")
        print(f"Active project:       {project_name}")
        print(f"Project root:         {project_root}")
        print(f"Configuration:        {config_path}")
        print(f"Configuration source: {args.config_source}")
        print(f"Directory:            {directory}")
        print(f"Manifest:             {manifest_path}")
        for record in records:
            print(f"{record['image'].name} -> {record['image_target'].name}")
            print(f"{record['sidecar'].name} -> {record['sidecar_target'].name}")

        if args.dry_run:
            print(f"Result: DRY RUN; {len(records)} media pair(s) validated; no files renamed")
            return 0
        rename_records(directory, records)
        try:
            write_manifest(manifest_path, project_name, project_root, config_path, args.config_source, records)
        except BaseException:
            restore_original_names(records)
            raise
        print(f"Manifest written: {manifest_path}")
        print(f"Result: renamed {len(records)} media pair(s)")
        return 0
    except (OSError, yaml.YAMLError, MediaError) as error:
        print(f"ERROR: {error}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
