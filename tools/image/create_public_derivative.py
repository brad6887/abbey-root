#!/usr/bin/env python3

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


SUPPORTED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp"}

PRIVATE_METADATA_PATTERN = re.compile(
    r"""
    \[GPS\]|
    \[Apple\]|
    \[ExifIFD\]|
    \[IFD0\]|
    \[IFD1\]|
    \[XMP|
    \[IPTC\]|
    \bGPS\w*\b|
    \bLatitude\b|
    \bLongitude\b|
    \bLocation\b|
    \bGeotag\b|
    \bMake\b|
    \bModel\b|
    \bHostComputer\b|
    \bSerial\w*\b|
    \bOwner\w*\b|
    \bPhotoIdentifier\b|
    \bDateTimeOriginal\b|
    \bCreateDate\b|
    \bSoftware\b
    """,
    re.IGNORECASE | re.VERBOSE,
)


class ImagePublishError(Exception):
    pass


def sha256(path):
    digest = hashlib.sha256()

    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)

    return digest.hexdigest()


def run(command):
    try:
        return subprocess.run(
            command,
            check=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
    except FileNotFoundError as error:
        raise ImagePublishError(
            f"required command is not installed: {command[0]}"
        ) from error
    except subprocess.CalledProcessError as error:
        detail = error.stderr.strip() or error.stdout.strip()
        raise ImagePublishError(
            f"command failed: {' '.join(command)}"
            + (f"\n{detail}" if detail else "")
        ) from error


def imagemagick_command():
    magick = shutil.which("magick")

    if magick:
        return [magick], magick

    convert = shutil.which("convert")

    if convert:
        return [convert], convert

    raise ImagePublishError(
        "ImageMagick is required; install the magick or convert command"
    )


def tool_version(command):
    result = run([command, "-version"])
    lines = result.stdout.splitlines()
    return lines[0] if lines else command


def image_dimensions(path):
    result = run(
        [
            "exiftool",
            "-s3",
            "-ImageWidth",
            "-ImageHeight",
            str(path),
        ]
    )

    values = [line.strip() for line in result.stdout.splitlines() if line.strip()]

    if len(values) != 2:
        raise ImagePublishError(
            f"unable to determine generated image dimensions: {path}"
        )

    return {
        "width": int(values[0]),
        "height": int(values[1]),
    }


def verify_metadata_removed(path):
    result = run(["exiftool", "-a", "-G1", "-s", str(path)])

    matches = [
        line
        for line in result.stdout.splitlines()
        if PRIVATE_METADATA_PATTERN.search(line)
    ]

    if matches:
        raise ImagePublishError(
            "potentially private metadata remains:\n"
            + "\n".join(matches)
        )


def create_derivative(source, destination, max_edge, quality):
    source = source.resolve()
    destination = destination.resolve()

    if not source.is_file():
        raise ImagePublishError(f"source image does not exist: {source}")

    if source.suffix.lower() not in SUPPORTED_EXTENSIONS:
        raise ImagePublishError(
            f"unsupported source image type: {source.suffix}"
        )

    if destination.suffix.lower() not in SUPPORTED_EXTENSIONS:
        raise ImagePublishError(
            f"unsupported destination image type: {destination.suffix}"
        )

    if max_edge < 1:
        raise ImagePublishError("maximum edge must be greater than zero")

    if quality < 1 or quality > 100:
        raise ImagePublishError("quality must be between 1 and 100")

    source_hash_before = sha256(source)
    destination.parent.mkdir(parents=True, exist_ok=True)

    image_command, image_executable = imagemagick_command()

    with tempfile.NamedTemporaryFile(
        prefix=f".{destination.stem}.",
        suffix=destination.suffix,
        dir=destination.parent,
        delete=False,
    ) as handle:
        temporary = Path(handle.name)

    try:
        command = image_command + [
            str(source),
            "-auto-orient",
            "-resize",
            f"{max_edge}x{max_edge}>",
            "-colorspace",
            "sRGB",
            "-strip",
        ]

        if destination.suffix.lower() in {".jpg", ".jpeg", ".webp"}:
            command.extend(["-quality", str(quality)])
        elif destination.suffix.lower() == ".png":
            command.extend(["-define", "png:compression-level=9"])

        command.append(str(temporary))

        run(command)
        verify_metadata_removed(temporary)

        dimensions = image_dimensions(temporary)

        if max(dimensions["width"], dimensions["height"]) > max_edge:
            raise ImagePublishError(
                "generated image exceeds configured maximum edge"
            )

        source_hash_after = sha256(source)

        if source_hash_before != source_hash_after:
            raise ImagePublishError(
                "canonical source changed during derivative generation"
            )

        public_hash = sha256(temporary)

        os.chmod(temporary, 0o644)
        os.replace(temporary, destination)

        return {
            "source": {
                "path": str(source),
                "sha256": source_hash_before,
                "canonical_original_preserved": True,
            },
            "derivative": {
                "path": str(destination),
                "sha256": public_hash,
                "format": destination.suffix.lower().lstrip("."),
                "width": dimensions["width"],
                "height": dimensions["height"],
            },
            "transformation": {
                "auto_orient": True,
                "maximum_edge": max_edge,
                "colorspace": "sRGB",
                "metadata_removed": True,
                "quality": (
                    quality
                    if destination.suffix.lower() in {".jpg", ".jpeg", ".webp"}
                    else None
                ),
            },
            "validation": {
                "private_metadata_detected": False,
                "source_hash_unchanged": True,
            },
            "tools": {
                "imagemagick": tool_version(image_executable),
                "exiftool": run(["exiftool", "-ver"]).stdout.strip(),
            },
        }

    finally:
        if temporary.exists():
            temporary.unlink()


def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Create a sanitized public image derivative."
    )

    parser.add_argument("source", type=Path)
    parser.add_argument("destination", type=Path)
    parser.add_argument("--max-edge", type=int, default=2400)
    parser.add_argument("--quality", type=int, default=85)

    return parser.parse_args()


def main():
    arguments = parse_arguments()

    try:
        provenance = create_derivative(
            arguments.source,
            arguments.destination,
            arguments.max_edge,
            arguments.quality,
        )
    except ImagePublishError as error:
        print(f"ERROR {error}", file=sys.stderr)
        return 1

    print(json.dumps(provenance, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
