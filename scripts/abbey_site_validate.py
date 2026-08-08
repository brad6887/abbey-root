#!/usr/bin/env python3

import argparse
import hashlib
import json
import struct
import sys
from pathlib import Path, PurePosixPath

import yaml


class ValidationError(Exception):
    pass


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def project_path(root, value, label):
    if not isinstance(value, str) or not value.strip():
        raise ValidationError(f"{label} must be a non-empty project-relative path")
    path = Path(value)
    if path.is_absolute():
        raise ValidationError(f"{label} must be relative to the active project")
    resolved = (root / path).resolve()
    try:
        resolved.relative_to(root)
    except ValueError as error:
        raise ValidationError(f"{label} escapes the active project") from error
    return resolved


def image_info(path):
    data = path.read_bytes()
    if data.startswith(b"\x89PNG\r\n\x1a\n") and len(data) >= 24:
        width, height = struct.unpack(">II", data[16:24])
        return "png", width, height
    if data.startswith(b"\xff\xd8"):
        offset = 2
        while offset + 4 <= len(data):
            if data[offset] != 0xFF:
                offset += 1
                continue
            marker = data[offset + 1]
            offset += 2
            if marker in {0xD8, 0xD9} or 0xD0 <= marker <= 0xD7:
                continue
            if offset + 2 > len(data):
                break
            length = struct.unpack(">H", data[offset : offset + 2])[0]
            if length < 2 or offset + length > len(data):
                break
            if marker in {0xC0, 0xC1, 0xC2, 0xC3, 0xC5, 0xC6, 0xC7, 0xC9, 0xCA, 0xCB, 0xCD, 0xCE, 0xCF}:
                if length < 7:
                    break
                height, width = struct.unpack(">HH", data[offset + 3 : offset + 7])
                return "jpg", width, height
            offset += length
    if data.startswith(b"RIFF") and data[8:12] == b"WEBP" and len(data) >= 30:
        kind = data[12:16]
        if kind == b"VP8X":
            width = 1 + int.from_bytes(data[24:27], "little")
            height = 1 + int.from_bytes(data[27:30], "little")
            return "webp", width, height
        if kind == b"VP8L" and len(data) >= 25 and data[20] == 0x2F:
            bits = int.from_bytes(data[21:25], "little")
            return "webp", (bits & 0x3FFF) + 1, ((bits >> 14) & 0x3FFF) + 1
        if kind == b"VP8 " and len(data) >= 30 and data[23:26] == b"\x9d\x01\x2a":
            width = int.from_bytes(data[26:28], "little") & 0x3FFF
            height = int.from_bytes(data[28:30], "little") & 0x3FFF
            return "webp", width, height
    raise ValidationError(f"unsupported or unreadable image format: {path}")


def normalized_format(value):
    if not isinstance(value, str):
        return ""
    value = value.lower().lstrip(".")
    return "jpg" if value == "jpeg" else value


def load_configuration(root):
    path = root / ".abbey" / "project.yml"
    try:
        data = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    except (OSError, yaml.YAMLError) as error:
        raise ValidationError(f"Could not load project configuration: {error}") from error
    if not isinstance(data, dict):
        raise ValidationError("Project configuration must be a YAML mapping")
    project = data.get("project")
    if not isinstance(project, dict) or not isinstance(project.get("name"), str):
        raise ValidationError("Project configuration must declare project.name")
    site = data.get("site")
    if not isinstance(site, dict):
        raise ValidationError("Project configuration must declare site")
    validation = site.get("validation")
    if validation is None:
        validation = {}
    if not isinstance(validation, dict):
        raise ValidationError("site.validation must be a YAML mapping")
    manifests = validation.get("media_manifests", [])
    routes = validation.get("required_routes", [])
    if not isinstance(manifests, list) or not all(isinstance(item, str) for item in manifests):
        raise ValidationError("site.validation.media_manifests must be a list of paths")
    if not isinstance(routes, list) or not all(isinstance(item, str) for item in routes):
        raise ValidationError("site.validation.required_routes must be a list of routes")
    public_root_value = validation.get("public_root")
    if manifests and public_root_value is None:
        raise ValidationError("site.validation.public_root is required when media manifests are configured")
    public_root = project_path(root, public_root_value, "site.validation.public_root") if public_root_value else None
    return project["name"], public_root, manifests, routes


def validate_manifest(root, project_name, public_root, manifest_value, destinations):
    label = f"media manifest {manifest_value}"
    path = project_path(root, manifest_value, label)
    if not path.is_file():
        raise ValidationError(f"{label} does not exist")
    try:
        manifest = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise ValidationError(f"{label} is not valid JSON: {error}") from error
    if not isinstance(manifest, dict) or manifest.get("schema_version") != 1:
        raise ValidationError(f"{label} must declare schema_version 1")
    if manifest.get("project") != project_name:
        raise ValidationError(f"{label} belongs to {manifest.get('project')!r}, not {project_name!r}")
    profile = manifest.get("profile")
    if not isinstance(profile, dict) or profile.get("metadata_removed") is not True:
        raise ValidationError(f"{label} does not verify profile metadata removal")
    destination = project_path(root, manifest.get("destination"), f"{label} destination")
    try:
        destination.relative_to(public_root)
    except ValueError as error:
        raise ValidationError(f"{label} destination is outside the configured public root") from error
    items = manifest.get("items")
    if not isinstance(items, list) or not items:
        raise ValidationError(f"{label} items must be a non-empty list")

    checked = 0
    for number, item in enumerate(items, start=1):
        item_label = f"{label} item {number}"
        if not isinstance(item, dict):
            raise ValidationError(f"{item_label} must be an object")
        source = item.get("source")
        derivative = item.get("derivative")
        transformation = item.get("transformation")
        validation = item.get("validation")
        if not all(isinstance(value, dict) for value in (source, derivative, transformation, validation)):
            raise ValidationError(f"{item_label} provenance is incomplete")
        if source.get("canonical_original_preserved") is not True:
            raise ValidationError(f"{item_label} does not preserve the canonical source")
        if transformation.get("metadata_removed") is not True:
            raise ValidationError(f"{item_label} does not verify metadata removal")
        if validation.get("private_metadata_detected") is not False:
            raise ValidationError(f"{item_label} reports private metadata")
        if validation.get("source_hash_unchanged") is not True:
            raise ValidationError(f"{item_label} does not verify source integrity")

        source_path = project_path(root, source.get("path"), f"{item_label} source.path")
        derivative_path = project_path(root, derivative.get("path"), f"{item_label} derivative.path")
        if not source_path.is_file():
            raise ValidationError(f"{item_label} source does not exist: {source_path}")
        if not derivative_path.is_file():
            raise ValidationError(f"{item_label} derivative does not exist: {derivative_path}")
        try:
            derivative_path.relative_to(public_root)
        except ValueError as error:
            raise ValidationError(f"{item_label} derivative is outside the configured public root") from error
        try:
            derivative_path.relative_to(destination)
        except ValueError as error:
            raise ValidationError(f"{item_label} derivative is outside its manifest destination") from error
        destination_key = derivative_path.relative_to(root).as_posix().casefold()
        if destination_key in destinations:
            raise ValidationError(f"duplicate public derivative destination: {destination_key}")
        destinations.add(destination_key)
        if source.get("sha256") != sha256(source_path):
            raise ValidationError(f"{item_label} source fingerprint does not match")
        if derivative.get("sha256") != sha256(derivative_path):
            raise ValidationError(f"{item_label} derivative fingerprint does not match")
        actual_format, width, height = image_info(derivative_path)
        if normalized_format(derivative.get("format")) != actual_format:
            raise ValidationError(f"{item_label} derivative format does not match the file")
        if normalized_format(profile.get("output_format")) != actual_format:
            raise ValidationError(f"{item_label} derivative format does not match its profile")
        if normalized_format(derivative_path.suffix) != actual_format:
            raise ValidationError(f"{item_label} derivative extension does not match the file")
        if derivative.get("width") != width or derivative.get("height") != height:
            raise ValidationError(f"{item_label} derivative dimensions do not match the file")
        checked += 1
    return checked


def route_artifact(output, route):
    if not route.startswith("/") or "?" in route or "#" in route:
        raise ValidationError(f"required route must be an absolute path without query or fragment: {route}")
    pure = PurePosixPath(route)
    if ".." in pure.parts:
        raise ValidationError(f"required route escapes the site output: {route}")
    relative = route.lstrip("/")
    if not relative:
        candidates = [output / "index.html"]
    elif route.endswith("/"):
        candidates = [output / relative / "index.html"]
    else:
        candidates = [output / relative / "index.html", output / f"{relative}.html"]
    for candidate in candidates:
        resolved = candidate.resolve()
        try:
            resolved.relative_to(output)
        except ValueError as error:
            raise ValidationError(f"required route escapes the site output: {route}") from error
        if resolved.is_file():
            return resolved
    raise ValidationError(f"required route was not generated: {route}")


def parse_args():
    parser = argparse.ArgumentParser(prog="abbey site validate")
    parser.add_argument("--project-root", type=Path, required=True)
    parser.add_argument("--site-output", type=Path, required=True)
    return parser.parse_args()


def main():
    args = parse_args()
    root = args.project_root.resolve()
    output = args.site_output.resolve()
    try:
        try:
            output.relative_to(root)
        except ValueError as error:
            raise ValidationError("Site output is outside the active project") from error
        project_name, public_root, manifests, routes = load_configuration(root)
        destinations = set()
        derivative_count = 0
        print("Site artifact validation")
        print("------------------------")
        print(f"Project:         {project_name}")
        print(f"Site output:     {output}")
        print(f"Public root:     {public_root if public_root else 'not configured'}")
        print(f"Media manifests: {len(manifests)}")
        print(f"Required routes: {len(routes)}")
        for value in manifests:
            derivative_count += validate_manifest(root, project_name, public_root, value, destinations)
            print(f"OK   Media manifest: {value}")
        for route in routes:
            route_artifact(output, route)
            print(f"OK   Required route: {route}")
        print(
            f"OK   Site validation passed: {len(manifests)} manifest(s), "
            f"{derivative_count} derivative(s), {len(routes)} route(s)."
        )
        return 0
    except (OSError, ValidationError) as error:
        print(f"FAIL {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
