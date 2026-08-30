#!/usr/bin/env python3
"""Generate a private, read-only plant photo review from canonical role metadata."""
import argparse
import hashlib
import html
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

import yaml

ROLES = (("original", "Original"), ("current", "Current"), ("hero", "Featured"))
EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp"}


def photograph(workspace, value):
    if not isinstance(value, str) or not value:
        raise ValueError(f"Invalid photograph reference: {value!r}")
    path = (workspace / value).resolve()
    if not path.is_relative_to(workspace.resolve()):
        raise ValueError(f"Photograph escapes workspace: {value}")
    if not path.is_file() or path.suffix.lower() not in EXTENSIONS:
        raise ValueError(f"Missing or unsupported photograph: {path}")
    return path


def collect(root, slugs, candidates=False):
    plants = root / "working/plants"
    if not slugs:
        slugs = sorted(p.parent.name for p in plants.glob("*/facts.yaml")
                       if not p.parent.name.startswith("_"))
    if not slugs:
        raise ValueError("No plant workspaces found")
    result = []
    for slug in dict.fromkeys(slugs):
        if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", slug):
            raise ValueError(f"Invalid plant slug: {slug}")
        workspace = (plants / slug).resolve()
        if not workspace.is_relative_to(plants.resolve()):
            raise ValueError(f"Workspace escapes plant root: {slug}")
        facts = yaml.safe_load((workspace / "facts.yaml").read_text())
        if not isinstance(facts, dict) or facts.get("slug") != slug:
            raise ValueError(f"Invalid facts or slug mismatch: {slug}")
        photos = facts.get("photos") or {}
        if not isinstance(photos, dict):
            raise ValueError(f"Invalid photos mapping: {slug}")
        selected = {}
        for role, _ in ROLES:
            value = photos.get(role)
            selected[role] = photograph(workspace, value) if value else None
        roles = []
        for role, label in ROLES:
            source = selected[role]
            fallback = None
            if role == "hero" and not source:
                fallback = next((key for key in ("current", "original") if selected[key]), None)
                source = selected.get(fallback)
            roles.append({"role": role, "label": label,
                          "selected": str(selected[role].relative_to(root)) if selected[role] else None,
                          "source": str(source.relative_to(root)) if source else None,
                          "fallback": fallback})
        gallery = []
        if candidates:
            for path in sorted((workspace / "photos").iterdir(), key=lambda p: p.name.casefold()):
                if path.suffix.lower() in EXTENSIONS and not path.name.startswith("._"):
                    path = photograph(workspace, str(path.relative_to(workspace)))
                    gallery.append(str(path.relative_to(root)))
        result.append({"slug": slug, "name": str(facts.get("name") or slug),
                       "facts": str((workspace / "facts.yaml").relative_to(root)),
                       "provenance": str((workspace / "photo-metadata.md").relative_to(root)),
                       "roles": roles, "candidates": gallery})
    return result


def thumbnail(source, directory):
    # A content key permits repeat reviews without rewriting original photographs.
    before = hashlib.sha256(source.read_bytes()).hexdigest()
    destination = directory / (before[:24] + ".jpg")
    if not destination.exists():
        executable = shutil.which("magick") or shutil.which("convert")
        if not executable:
            raise ValueError("ImageMagick is required for review thumbnails")
        subprocess.run([executable, str(source), "-auto-orient", "-thumbnail",
                        "640x480>", "-colorspace", "sRGB", "-strip", "-quality", "80",
                        str(destination)], check=True, capture_output=True)
    if hashlib.sha256(source.read_bytes()).hexdigest() != before:
        raise ValueError(f"Source changed during review: {source}")
    return "thumbs/" + destination.name


def render(root, rows, output):
    escape = html.escape
    thumbs = output / "thumbs"
    thumbs.mkdir(parents=True, exist_ok=True)
    cache = {}

    def picture(source, label):
        if not source:
            return '<div class="missing">Not designated</div>'
        if source not in cache:
            cache[source] = thumbnail(root / source, thumbs)
        return f'<a href="{cache[source]}"><img loading="lazy" src="{cache[source]}" alt="{escape(label)}"></a>'

    sections = []
    for row in rows:
        figures = []
        for role in row["roles"]:
            note = f'Fallback to {role["fallback"]}; no explicit selection' if role["fallback"] else ""
            figures.append(f'<figure><figcaption><strong>{role["label"]}</strong> '
                           f'<span>{escape(note)}</span></figcaption>'
                           f'{picture(role["source"], row["name"] + " — " + role["label"])}'
                           f'<code>{escape(role["source"] or "Not designated")}</code></figure>')
        gallery = ""
        if row["candidates"]:
            cards = "".join(f'<figure>{picture(p, row["name"] + " candidate")}'
                            f'<code>{escape(p)}</code></figure>' for p in row["candidates"])
            gallery = f'<details><summary>Existing source candidates ({len(row["candidates"])})</summary><div class="gallery">{cards}</div></details>'
        sections.append(f'<section id="{row["slug"]}"><h2>{escape(row["name"])}</h2>'
                        f'<p><code>{escape(row["facts"])}</code><br>Provenance: '
                        f'<code>{escape(row["provenance"])}</code></p>'
                        f'<div class="roles">{"".join(figures)}</div>{gallery}</section>')
    navigation = " · ".join(f'<a href="#{r["slug"]}">{escape(r["name"])}</a>' for r in rows)
    return f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width">
<title>Abbey Plant Image Review</title><style>
body{{font:16px system-ui,sans-serif;max-width:1200px;margin:auto;padding:24px;color:#233029;background:#f4f5f1}}
h1,h2{{line-height:1.2}}nav{{line-height:2}}section{{border-top:1px solid #bcc7be;margin-top:32px;padding-top:16px}}
.roles,.gallery{{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:16px}}
figure{{margin:0;background:white;border:1px solid #c8d0c9;border-radius:8px;overflow:hidden}}
figcaption,code{{display:block;padding:10px;overflow-wrap:anywhere}}figcaption span{{display:block;font-size:13px}}
figure a{{display:block;height:260px;background:#e9ede8}}img{{height:100%;width:100%;object-fit:contain}}
.missing{{height:260px;display:grid;place-items:center}}details{{margin:20px 0}}summary{{cursor:pointer;padding:12px}}
.gallery figure a{{height:220px}}p code{{display:inline;padding:0}}code{{font-size:12px}}
@media(max-width:700px){{.roles,.gallery{{grid-template-columns:1fr}}}}
</style></head><body><h1>Plant Image Review</h1>
<p>{len(rows)} plants · Original / Current / Featured (internal role: hero)</p>
<p>Private review only. Thumbnails are auto-oriented and stripped of embedded metadata.
Canonical files are never changed. Review provenance before assigning Original; filenames do not establish chronology.
These previews show source framing, not a public crop or proof of exported state.</p>
<nav>{navigation}</nav>{"".join(sections)}</body></html>
"""


def main():
    parser = argparse.ArgumentParser(prog="abbey plant image-review", description=__doc__)
    parser.add_argument("--root", required=True, type=Path, help=argparse.SUPPRESS)
    parser.add_argument("slugs", nargs="*")
    parser.add_argument("--candidates", action="store_true", help="Include existing source-photo galleries")
    parser.add_argument("--output", type=Path, help="Review directory within the canonical repository's .abbey/")
    args = parser.parse_args()
    root = args.root.resolve()
    output = (args.output if args.output and args.output.is_absolute()
              else root / (args.output or ".abbey/plant-image-review")).resolve()
    try:
        if not output.is_relative_to(root / ".abbey") or output == root / ".abbey":
            raise ValueError("Review output must be a subdirectory of the canonical repository's .abbey/")
        rows = collect(root, args.slugs, args.candidates)
        document = render(root, rows, output)
        (output / "index.html").write_text(document, encoding="utf-8")
        (output / "review.json").write_text(json.dumps(rows, indent=2) + "\n")
    except (OSError, ValueError, yaml.YAMLError, subprocess.CalledProcessError) as error:
        print(f"ERROR {error}", file=sys.stderr)
        return 1
    print(f"Review: {output / 'index.html'}")
    print(f"Plants: {len(rows)}; unset Original: {sum(not r['roles'][0]['selected'] for r in rows)}")
    print("No canonical metadata, source photographs, or website exports changed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
