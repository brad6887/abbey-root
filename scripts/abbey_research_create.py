#!/usr/bin/env python3

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import secrets
import shlex
import shutil
import stat
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


STATES = {
    "generation": ("generated", "generation-failed"),
    "normalization": ("normalized", "normalization-failed"),
    "sanitization": ("sanitized", "sanitization-failed"),
    "validation": ("review-ready", "validation-failed"),
}

RUN_ID_PATTERN = re.compile(r"^RUN-[A-Za-z0-9][A-Za-z0-9-]*$")


def is_within(path: Path, parent: Path) -> bool:
    try:
        path.relative_to(parent)
    except ValueError:
        return False
    return True


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Create a controlled Abbey Research candidate.",
    )
    parser.add_argument("--type", dest="artifact_type", required=True)
    parser.add_argument("--project", required=True)
    parser.add_argument("--corpus", required=True)
    parser.add_argument("--experiment", required=True)
    parser.add_argument("--model", required=True)
    parser.add_argument("--prompt", required=True, type=Path)
    parser.add_argument("--input", action="append", default=[], type=Path)
    parser.add_argument("--max-tokens", type=int, default=6144)
    return parser.parse_args()


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def fingerprint(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def write_manifest(path: Path, manifest: dict[str, Any]) -> None:
    temporary = path.with_suffix(".yaml.tmp")
    temporary.write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )
    temporary.replace(path)


def snapshot(
    source: Path,
    destination: Path,
) -> dict[str, str]:
    resolved = source.resolve()
    if not resolved.is_file():
        raise ValueError(f"Input file not found: {source}")

    shutil.copyfile(resolved, destination)
    destination.chmod(stat.S_IRUSR | stat.S_IRGRP | stat.S_IROTH)
    return {
        "path": str(resolved),
        "sha256": fingerprint(resolved),
        "snapshot": str(destination),
    }


def run_stage(
    *,
    stage: str,
    command: list[str],
    manifest: dict[str, Any],
    manifest_path: Path,
    log_path: Path,
) -> None:
    record = {
        "stage": stage,
        "command": " ".join(shlex.quote(value) for value in command),
        "started_at": utc_now(),
        "status": "running",
    }
    manifest["executions"].append(record)
    write_manifest(manifest_path, manifest)

    result = subprocess.run(
        command,
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    log_path.write_text(result.stdout, encoding="utf-8")
    record["finished_at"] = utc_now()
    record["exit_code"] = result.returncode

    if result.returncode:
        record["status"] = "failed"
        manifest["state"] = STATES[stage][1]
        manifest["failure"] = {
            "stage": stage,
            "log": str(log_path),
        }
        write_manifest(manifest_path, manifest)
        if result.stdout:
            print(result.stdout, file=sys.stderr, end="")
        raise RuntimeError(f"{stage} failed")

    record["status"] = "passed"
    manifest["state"] = STATES[stage][0]
    write_manifest(manifest_path, manifest)


def main() -> int:
    args = parse_arguments()

    if args.artifact_type != "observation":
        print(
            f"Unsupported artifact type: {args.artifact_type}",
            file=sys.stderr,
        )
        print("Supported types: observation", file=sys.stderr)
        return 1
    if args.max_tokens < 1:
        print("--max-tokens must be a positive integer.", file=sys.stderr)
        return 1

    repo_root = Path(os.environ["ABBEY_ROOT"]).resolve()
    runs_root = Path(
        os.environ.get(
            "ABBEY_RESEARCH_RUNS_DIR",
            repo_root / "working/research/runs",
        )
    ).resolve()
    run_id = os.environ.get("ABBEY_RESEARCH_RUN_ID") or (
        datetime.now().strftime("RUN-%Y%m%d-%H%M%S-")
        + secrets.token_hex(2)
    )
    if not RUN_ID_PATTERN.fullmatch(run_id):
        print(f"Invalid research run identifier: {run_id}", file=sys.stderr)
        return 1

    canonical_root = (repo_root / "docs/research").resolve()
    if is_within(runs_root, canonical_root):
        print(
            "Research candidate runs cannot use canonical research paths.",
            file=sys.stderr,
        )
        return 1
    run_dir = runs_root / run_id

    try:
        run_dir.mkdir(parents=True, exist_ok=False)
    except FileExistsError:
        print(f"Research run already exists: {run_dir}", file=sys.stderr)
        print("Existing run outputs will not be overwritten.", file=sys.stderr)
        return 1

    inputs_dir = run_dir / "inputs"
    logs_dir = run_dir / "logs"
    inputs_dir.mkdir()
    logs_dir.mkdir()
    manifest_path = run_dir / "manifest.yaml"

    try:
        prompt_record = snapshot(args.prompt, inputs_dir / "prompt.md")
        input_records = [
            snapshot(path, inputs_dir / f"input-{index:03d}{path.suffix}")
            for index, path in enumerate(args.input, start=1)
        ]
    except (OSError, ValueError) as exc:
        print(str(exc), file=sys.stderr)
        shutil.rmtree(run_dir)
        return 1

    manifest: dict[str, Any] = {
        "run_id": run_id,
        "project": args.project,
        "artifact_type": args.artifact_type,
        "state": "initialized",
        "source": {
            "corpus": args.corpus,
            "experiment": args.experiment,
            "parent_artifacts": [],
        },
        "inputs": input_records,
        "generation": {
            "model": args.model,
            "prompt": prompt_record,
            "max_tokens": args.max_tokens,
            "tool_version": 1,
        },
        "created": {
            "timestamp": utc_now(),
            "method": "AI-assisted research",
        },
        "artifacts": {
            "raw": str(run_dir / "raw.md"),
            "normalized": str(run_dir / "normalized.md"),
            "candidate": str(run_dir / "candidate.md"),
            "validation": str(run_dir / "validation.txt"),
        },
        "executions": [],
    }
    write_manifest(manifest_path, manifest)

    tool = Path(
        os.environ.get(
            "ABBEY_RESEARCH_STAGE_TOOL",
            repo_root / "tools/bin/abbey-research",
        )
    )
    raw_path = run_dir / "raw.md"
    normalized_path = run_dir / "normalized.md"
    candidate_path = run_dir / "candidate.md"
    validation_path = run_dir / "validation.txt"

    commands = [
        (
            "generation",
            [
                str(tool),
                "run",
                "--type",
                "observation",
                "--model",
                args.model,
                "--prompt",
                str(inputs_dir / "prompt.md"),
                *[
                    item
                    for record in input_records
                    for item in ("--input", record["snapshot"])
                ],
                "--output",
                str(raw_path),
                "--max-tokens",
                str(args.max_tokens),
            ],
            logs_dir / "generation.txt",
        ),
        (
            "normalization",
            [
                str(tool),
                "normalize",
                "--type",
                "observation",
                "--model",
                args.model,
                "--input",
                str(raw_path),
                "--output",
                str(normalized_path),
            ],
            logs_dir / "normalization.txt",
        ),
        (
            "sanitization",
            [
                str(tool),
                "sanitize",
                "--input",
                str(normalized_path),
                "--output",
                str(candidate_path),
            ],
            logs_dir / "sanitization.txt",
        ),
        (
            "validation",
            [
                str(tool),
                "validate",
                "--type",
                "observation",
                "--input",
                str(candidate_path),
            ],
            validation_path,
        ),
    ]

    try:
        for stage, command, log_path in commands:
            run_stage(
                stage=stage,
                command=command,
                manifest=manifest,
                manifest_path=manifest_path,
                log_path=log_path,
            )
            if stage == "generation":
                raw_path.chmod(
                    stat.S_IRUSR | stat.S_IRGRP | stat.S_IROTH
                )
    except RuntimeError as exc:
        print(f"Research run: {run_id}", file=sys.stderr)
        print(f"Manifest: {manifest_path}", file=sys.stderr)
        print(str(exc), file=sys.stderr)
        return 1

    print("Abbey Research Candidate")
    print()
    print(f"Run:       {run_id}")
    print("State:     review-ready")
    print(f"Manifest:  {manifest_path}")
    print(f"Raw:       {raw_path}")
    print(f"Candidate: {candidate_path}")
    print()
    print("The candidate has not been reviewed or promoted.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
