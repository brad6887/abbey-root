#!/usr/bin/env python3

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

import yaml


class PublishError(Exception):
    pass


def project_path(root, value, label):
    path = Path(value)
    if path.is_absolute():
        raise PublishError(f"{label} must be relative to the active project")
    resolved = (root / path).resolve()
    try:
        resolved.relative_to(root)
    except ValueError as error:
        raise PublishError(f"{label} escapes the active project") from error
    return resolved


def relative_path(root, path):
    return path.resolve().relative_to(root).as_posix()


def configured_path(root, path):
    try:
        return relative_path(root, path)
    except ValueError:
        return str(path.resolve())


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def load_workflow(config_path, name, root):
    try:
        config = yaml.safe_load(config_path.read_text(encoding="utf-8")) or {}
    except (OSError, yaml.YAMLError) as error:
        raise PublishError(f"Could not load media configuration: {error}") from error
    if not isinstance(config, dict) or config.get("schema_version") != 1:
        raise PublishError("Media configuration must declare schema_version: 1")
    workflows = config.get("publish")
    if not isinstance(workflows, dict):
        raise PublishError("publish must be a YAML mapping")
    workflow = workflows.get(name)
    if not isinstance(workflow, dict):
        raise PublishError(f"Unknown media publication workflow: {name}")

    required = ("source", "destination", "intake_manifest", "manifest", "output_format")
    for key in required:
        if not isinstance(workflow.get(key), str) or not workflow[key].strip():
            raise PublishError(f"publish.{name}.{key} must be a non-empty string")
    output_format = workflow["output_format"].lower().lstrip(".")
    if output_format not in {"jpg", "jpeg", "png", "webp"}:
        raise PublishError(f"publish.{name}.output_format is unsupported")
    max_edge = workflow.get("max_edge", 2000)
    quality = workflow.get("quality", 85)
    if not isinstance(max_edge, int) or max_edge < 1:
        raise PublishError(f"publish.{name}.max_edge must be a positive integer")
    if not isinstance(quality, int) or not 1 <= quality <= 100:
        raise PublishError(f"publish.{name}.quality must be between 1 and 100")
    return {
        "source": project_path(root, workflow["source"], f"publish.{name}.source"),
        "destination": project_path(root, workflow["destination"], f"publish.{name}.destination"),
        "intake_manifest": project_path(root, workflow["intake_manifest"], f"publish.{name}.intake_manifest"),
        "manifest": project_path(root, workflow["manifest"], f"publish.{name}.manifest"),
        "output_format": output_format,
        "max_edge": max_edge,
        "quality": quality,
    }


def load_intake(path, source, output_format):
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise PublishError(f"Could not load intake manifest: {error}") from error
    if not isinstance(data, dict) or data.get("schema_version") != 1:
        raise PublishError("Intake manifest must declare schema_version: 1")
    items = data.get("items")
    if not isinstance(items, list) or not items:
        raise PublishError("Intake manifest items must be a non-empty list")

    records = []
    targets = set()
    for index, item in enumerate(items, start=1):
        if not isinstance(item, dict):
            raise PublishError(f"Intake manifest item {index} must be an object")
        prepared_name = item.get("published_image")
        if not isinstance(prepared_name, str) or Path(prepared_name).name != prepared_name:
            raise PublishError(f"Intake manifest item {index} has an unsafe published_image")
        source_path = (source / prepared_name).resolve()
        try:
            source_path.relative_to(source)
        except ValueError as error:
            raise PublishError(f"Intake manifest item {index} escapes the source directory") from error
        if not source_path.is_file():
            raise PublishError(f"Prepared source image does not exist: {source_path}")
        if source_path.suffix.lower() not in {".jpg", ".jpeg", ".png", ".webp"}:
            raise PublishError(f"Prepared source image type is unsupported: {source_path.suffix}")
        target_name = f"{Path(prepared_name).stem}.{output_format}"
        target_key = target_name.casefold()
        if target_key in targets:
            raise PublishError(f"Multiple inputs resolve to public derivative: {target_name}")
        targets.add(target_key)
        records.append(
            {
                "caption": item.get("caption") if isinstance(item.get("caption"), str) else "",
                "capture_date": item.get("capture_date"),
                "original_image": item.get("original_image"),
                "prepared_name": prepared_name,
                "source": source_path,
                "target_name": target_name,
            }
        )
    return records


def run_derivative(helper, source, destination, max_edge, quality):
    result = subprocess.run(
        [
            sys.executable,
            str(helper),
            str(source),
            str(destination),
            "--max-edge",
            str(max_edge),
            "--quality",
            str(quality),
        ],
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if result.returncode != 0:
        detail = result.stderr.strip() or result.stdout.strip()
        raise PublishError(f"Unable to publish image {source.name}" + (f":\n{detail}" if detail else ""))
    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError as error:
        raise PublishError(f"Invalid derivative provenance for: {source.name}") from error


def validate_provenance(provenance, source, derivative):
    try:
        source_record = provenance["source"]
        derivative_record = provenance["derivative"]
        transformation = provenance["transformation"]
        validation = provenance["validation"]
        width = derivative_record["width"]
        height = derivative_record["height"]
    except (KeyError, TypeError) as error:
        raise PublishError(f"Derivative provenance is incomplete for: {source.name}") from error
    if source_record.get("sha256") != sha256(source):
        raise PublishError(f"Derivative provenance has the wrong source fingerprint: {source.name}")
    if derivative_record.get("sha256") != sha256(derivative):
        raise PublishError(f"Derivative provenance has the wrong output fingerprint: {source.name}")
    if not isinstance(width, int) or width < 1 or not isinstance(height, int) or height < 1:
        raise PublishError(f"Derivative provenance has invalid dimensions: {source.name}")
    if transformation.get("metadata_removed") is not True:
        raise PublishError(f"Derivative metadata removal was not verified: {source.name}")
    if validation.get("private_metadata_detected") is not False:
        raise PublishError(f"Private metadata was detected in derivative: {source.name}")
    if validation.get("source_hash_unchanged") is not True:
        raise PublishError(f"Canonical source integrity was not verified: {source.name}")


def manifest_text(root, project_name, workflow_name, config_path, config_source, settings, records):
    items = []
    for record in records:
        provenance = record["provenance"]
        try:
            provenance["source"]["path"] = relative_path(root, record["source"])
            provenance["derivative"]["path"] = relative_path(root, record["target"])
        except (KeyError, TypeError) as error:
            raise PublishError(
                f"Derivative provenance is incomplete for: {record['prepared_name']}"
            ) from error
        items.append(
            {
                "caption": record["caption"],
                "capture_date": record["capture_date"],
                "original_image": record["original_image"],
                "prepared_image": record["prepared_name"],
                **provenance,
            }
        )
    manifest = {
        "schema_version": 1,
        "project": project_name,
        "workflow": workflow_name,
        "configuration": configured_path(root, config_path),
        "configuration_source": config_source,
        "source": relative_path(root, settings["source"]),
        "destination": relative_path(root, settings["destination"]),
        "intake_manifest": relative_path(root, settings["intake_manifest"]),
        "profile": {
            "output_format": settings["output_format"],
            "maximum_edge": settings["max_edge"],
            "quality": settings["quality"],
            "metadata_removed": True,
        },
        "items": items,
    }
    return json.dumps(manifest, indent=2, sort_keys=True, ensure_ascii=False) + "\n"


def commit_transaction(destination, manifest_path, staged, manifest_content):
    destination.parent.mkdir(parents=True, exist_ok=True)
    manifest_path.parent.mkdir(parents=True, exist_ok=True)
    transaction = Path(tempfile.mkdtemp(prefix=".abbey-media-publish-", dir=str(destination.parent)))
    backups = []
    installed = []
    try:
        destination.mkdir(parents=True, exist_ok=True)
        manifest_stage = transaction / "publication-manifest.json"
        manifest_stage.write_text(manifest_content, encoding="utf-8")
        targets = [(record["staged"], record["target"]) for record in staged]
        targets.append((manifest_stage, manifest_path))
        for sequence, (source, target) in enumerate(targets):
            if target.exists():
                backup = transaction / f"backup-{sequence}"
                target.rename(backup)
                backups.append((backup, target))
            source.rename(target)
            installed.append(target)
    except BaseException:
        for target in reversed(installed):
            if target.exists():
                target.unlink()
        for backup, target in reversed(backups):
            if backup.exists():
                backup.rename(target)
        raise
    finally:
        shutil.rmtree(transaction, ignore_errors=True)


def parse_args():
    parser = argparse.ArgumentParser(prog="abbey media publish")
    parser.add_argument("--project-root", type=Path, required=True)
    parser.add_argument("--config", type=Path, required=True)
    parser.add_argument("--config-source", required=True)
    parser.add_argument("--workflow", required=True)
    parser.add_argument("--derivative-helper", type=Path, required=True)
    parser.add_argument("--dry-run", action="store_true")
    return parser.parse_args()


def main():
    args = parse_args()
    root = args.project_root.resolve()
    config_path = args.config.resolve()
    try:
        project_data = yaml.safe_load((root / ".abbey/project.yml").read_text(encoding="utf-8")) or {}
        project_name = project_data.get("project", {}).get("name", "Abbey Project")
        settings = load_workflow(config_path, args.workflow, root)
        if not settings["source"].is_dir():
            raise PublishError(f"Publication source directory does not exist: {settings['source']}")
        records = load_intake(settings["intake_manifest"], settings["source"], settings["output_format"])
        for record in records:
            record["target"] = settings["destination"] / record["target_name"]
            if record["target"].exists() and not record["target"].is_file():
                raise PublishError(f"Public derivative target is not a file: {record['target']}")
        if settings["manifest"] in {record["target"] for record in records}:
            raise PublishError("Publication manifest conflicts with a derivative target")
        if settings["manifest"].exists() and not settings["manifest"].is_file():
            raise PublishError(f"Publication manifest target is not a file: {settings['manifest']}")

        print("Abbey Media Publication")
        print("=======================")
        print(f"Active project:       {project_name}")
        print(f"Project root:         {root}")
        print(f"Configuration:        {config_path}")
        print(f"Configuration source: {args.config_source}")
        print(f"Workflow:             {args.workflow}")
        print(f"Source:               {settings['source']}")
        print(f"Destination:          {settings['destination']}")
        print(f"Intake manifest:      {settings['intake_manifest']}")
        print(f"Publication manifest: {settings['manifest']}")
        for record in records:
            print(f"{record['prepared_name']} -> {record['target_name']}")
        if args.dry_run:
            print(f"Result: DRY RUN; {len(records)} derivative(s) validated; no files written")
            return 0

        settings["destination"].parent.mkdir(parents=True, exist_ok=True)
        staging = Path(tempfile.mkdtemp(prefix=".abbey-media-derivatives-", dir=str(settings["destination"].parent)))
        try:
            for record in records:
                record["staged"] = staging / record["target_name"]
                record["provenance"] = run_derivative(
                    args.derivative_helper,
                    record["source"],
                    record["staged"],
                    settings["max_edge"],
                    settings["quality"],
                )
                if not record["staged"].is_file():
                    raise PublishError(f"Derivative helper did not create: {record['target_name']}")
                validate_provenance(record["provenance"], record["source"], record["staged"])
            content = manifest_text(root, project_name, args.workflow, config_path, args.config_source, settings, records)
            existing = settings["manifest"].read_text(encoding="utf-8") if settings["manifest"].is_file() else None
            unchanged = existing == content and all(
                record["target"].is_file() and sha256(record["target"]) == sha256(record["staged"])
                for record in records
            )
            if unchanged:
                print(f"Result: {len(records)} derivative(s) already current; no files changed")
                return 0
            commit_transaction(settings["destination"], settings["manifest"], records, content)
        finally:
            shutil.rmtree(staging, ignore_errors=True)
        print(f"Publication manifest written: {settings['manifest']}")
        print(f"Result: published {len(records)} derivative(s)")
        return 0
    except (OSError, yaml.YAMLError, PublishError, ValueError) as error:
        print(f"ERROR: {error}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
