#!/usr/bin/env python3

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import secrets
import stat
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

import yaml


RUN_ID_PATTERN = re.compile(r"^RUN-[A-Za-z0-9][A-Za-z0-9-]*$")
PROJECT_PATTERN = re.compile(r"^[a-z0-9][a-z0-9-]*$")
CONTEXT_ID_PATTERN = re.compile(r"^[A-Z][A-Z0-9-]*$")
OBSERVATION_PATTERN = re.compile(r"^OBS-([0-9]{3,})\.md$")
CHECK_DECISIONS = {"undecided", "approved", "rejected"}
REVIEW_DECISIONS = {"undecided", "approved", "rejected"}
REVIEW_CHECKS = (
    "finding_wording_is_proportional",
    "citations_are_representative",
    "interpretation_is_distinguished",
)


class PromotionError(Exception):
    pass


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Review and promote an Abbey Research observation candidate."
        )
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    for command in ("review-init", "review-validate"):
        command_parser = subparsers.add_parser(command)
        command_parser.add_argument("run_id")

    promote_parser = subparsers.add_parser("promote")
    promote_parser.add_argument("run_id")
    promote_parser.add_argument(
        "--confirm",
        action="store_true",
        help="Write the previewed canonical observation.",
    )
    return parser.parse_args()


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def fingerprint(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def fingerprint_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def is_within(path: Path, parent: Path) -> bool:
    try:
        path.relative_to(parent)
    except ValueError:
        return False
    return True


def load_object(path: Path, label: str) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError as exc:
        raise PromotionError(f"{label} not found: {path}") from exc
    except (OSError, json.JSONDecodeError) as exc:
        raise PromotionError(f"Unable to read {label}: {path}: {exc}") from exc

    if not isinstance(value, dict):
        raise PromotionError(f"{label} must contain a JSON object: {path}")
    return value


def write_object_exclusive(path: Path, value: dict[str, Any]) -> None:
    try:
        with path.open("x", encoding="utf-8") as stream:
            json.dump(value, stream, indent=2, ensure_ascii=False)
            stream.write("\n")
    except FileExistsError as exc:
        raise PromotionError(f"Review record already exists: {path}") from exc


def write_manifest(path: Path, manifest: dict[str, Any]) -> None:
    temporary = path.with_suffix(".yaml.tmp")
    temporary.write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )
    temporary.replace(path)


def resolve_run(repo_root: Path, run_id: str) -> tuple[Path, Path]:
    if not RUN_ID_PATTERN.fullmatch(run_id):
        raise PromotionError(f"Invalid research run identifier: {run_id}")

    runs_root = Path(
        os.environ.get(
            "ABBEY_RESEARCH_RUNS_DIR",
            repo_root / "working/research/runs",
        )
    ).resolve()
    run_dir = (runs_root / run_id).resolve()

    if not is_within(run_dir, runs_root):
        raise PromotionError("Research run path escapes the configured root.")
    if not run_dir.is_dir():
        raise PromotionError(f"Research run not found: {run_dir}")
    return run_dir, run_dir / "manifest.yaml"


def require_string(value: Any, label: str) -> str:
    if not isinstance(value, str) or not value.strip():
        raise PromotionError(f"Missing or invalid {label}.")
    return value.strip()


def validate_snapshot(
    record: Any,
    run_dir: Path,
    label: str,
) -> dict[str, str]:
    if not isinstance(record, dict):
        raise PromotionError(f"Missing or invalid {label} record.")

    expected_hash = require_string(record.get("sha256"), f"{label} hash")
    snapshot_value = require_string(
        record.get("snapshot"),
        f"{label} snapshot",
    )
    snapshot = Path(os.path.abspath(snapshot_value))
    inputs_dir = Path(os.path.abspath(run_dir / "inputs"))

    if (
        not is_within(snapshot, inputs_dir)
        or snapshot.is_symlink()
        or not snapshot.is_file()
        or not is_within(snapshot.resolve(), inputs_dir.resolve())
    ):
        raise PromotionError(f"{label.capitalize()} snapshot is unavailable or unsafe.")
    if fingerprint(snapshot) != expected_hash:
        raise PromotionError(f"{label.capitalize()} snapshot fingerprint changed.")

    return {
        "snapshot": str(snapshot.relative_to(run_dir)),
        "sha256": expected_hash,
    }


def validate_manifest(
    run_dir: Path,
    manifest_path: Path,
    run_id: str,
    *,
    allow_promoted: bool = False,
) -> tuple[dict[str, Any], dict[str, Any]]:
    manifest = load_object(manifest_path, "Run manifest")

    if manifest.get("run_id") != run_id:
        raise PromotionError("Run manifest identifier does not match the selected run.")
    if manifest.get("artifact_type") != "observation":
        raise PromotionError("Only observation candidates can be reviewed or promoted.")

    allowed_states = {"review-ready"}
    if allow_promoted:
        allowed_states.add("promoted")
    if manifest.get("state") not in allowed_states:
        raise PromotionError(
            "Research run must be review-ready before review or promotion."
        )

    project = require_string(manifest.get("project"), "research project")
    if not PROJECT_PATTERN.fullmatch(project):
        raise PromotionError(f"Invalid research project name: {project}")

    source = manifest.get("source")
    if not isinstance(source, dict):
        raise PromotionError("Run manifest source context is missing.")
    corpus = require_string(source.get("corpus"), "source corpus")
    experiment = require_string(source.get("experiment"), "source experiment")
    if not CONTEXT_ID_PATTERN.fullmatch(corpus):
        raise PromotionError(f"Invalid corpus identifier: {corpus}")
    if not CONTEXT_ID_PATTERN.fullmatch(experiment):
        raise PromotionError(f"Invalid experiment identifier: {experiment}")
    if source.get("parent_artifacts") not in ([], None):
        raise PromotionError("Observation candidates cannot declare formal parents.")

    artifacts = manifest.get("artifacts")
    if not isinstance(artifacts, dict):
        raise PromotionError("Run manifest artifact paths are missing.")
    candidate_value = require_string(
        artifacts.get("candidate"),
        "candidate artifact path",
    )
    candidate = Path(os.path.abspath(candidate_value))
    expected_candidate = Path(os.path.abspath(run_dir / "candidate.md"))
    if (
        candidate != expected_candidate
        or candidate.is_symlink()
        or not candidate.is_file()
        or not is_within(candidate.resolve(), run_dir.resolve())
    ):
        raise PromotionError("Candidate path is unavailable or outside the run contract.")

    executions = manifest.get("executions")
    if not isinstance(executions, list) or not any(
        isinstance(item, dict)
        and item.get("stage") == "validation"
        and item.get("status") == "passed"
        and item.get("exit_code") == 0
        for item in executions
    ):
        raise PromotionError("Run manifest does not record passing validation.")

    generation = manifest.get("generation")
    if not isinstance(generation, dict):
        raise PromotionError("Run manifest generation provenance is missing.")
    model = require_string(generation.get("model"), "generation model")
    prompt = validate_snapshot(
        generation.get("prompt"),
        run_dir,
        "prompt",
    )

    input_values = manifest.get("inputs")
    if not isinstance(input_values, list):
        raise PromotionError("Run manifest inputs must be a list.")
    inputs = [
        validate_snapshot(item, run_dir, f"input {index}")
        for index, item in enumerate(input_values, start=1)
    ]

    context: dict[str, Any] = {
        "project": project,
        "corpus": corpus,
        "experiment": experiment,
        "model": model,
        "prompt": prompt,
        "inputs": inputs,
        "candidate": candidate,
        "candidate_sha256": fingerprint(candidate),
    }
    return manifest, context


def review_record(run_id: str, candidate_sha256: str) -> dict[str, Any]:
    return {
        "schema_version": 1,
        "run_id": run_id,
        "artifact_type": "observation",
        "candidate_sha256": candidate_sha256,
        "created_at": utc_now(),
        "decision": "undecided",
        "reviewer": "",
        "reviewed_at": "",
        "canonical_title": "",
        "checks": {name: "undecided" for name in REVIEW_CHECKS},
        "notes": "",
    }


def validate_review_timestamp(value: str) -> None:
    try:
        parsed = datetime.fromisoformat(value.replace("Z", "+00:00"))
    except ValueError as exc:
        raise PromotionError("Review timestamp must use ISO 8601 format.") from exc
    if parsed.tzinfo is None:
        raise PromotionError("Review timestamp must include a timezone.")


def validate_review(
    review: dict[str, Any],
    run_id: str,
    candidate_sha256: str,
    *,
    require_complete: bool,
    require_approval: bool,
) -> str:
    expected_fields = {
        "schema_version",
        "run_id",
        "artifact_type",
        "candidate_sha256",
        "created_at",
        "decision",
        "reviewer",
        "reviewed_at",
        "canonical_title",
        "checks",
        "notes",
    }
    if set(review) != expected_fields:
        raise PromotionError("Review record fields do not match schema version 1.")
    if review.get("schema_version") != 1:
        raise PromotionError("Unsupported review record schema version.")
    created_at = require_string(review.get("created_at"), "review creation timestamp")
    validate_review_timestamp(created_at)
    if review.get("run_id") != run_id:
        raise PromotionError("Review record run identifier does not match.")
    if review.get("artifact_type") != "observation":
        raise PromotionError("Review record artifact type must be observation.")
    if review.get("candidate_sha256") != candidate_sha256:
        raise PromotionError("Candidate changed after the review record was created.")

    decision = review.get("decision")
    if decision not in REVIEW_DECISIONS:
        raise PromotionError("Review decision must be undecided, approved, or rejected.")

    checks = review.get("checks")
    if not isinstance(checks, dict) or set(checks) != set(REVIEW_CHECKS):
        raise PromotionError("Review record contains an invalid human checklist.")
    if any(value not in CHECK_DECISIONS for value in checks.values()):
        raise PromotionError("Review checklist decisions are invalid.")

    if not require_complete:
        return str(decision)
    if decision == "undecided" or "undecided" in checks.values():
        raise PromotionError("Review record still contains undecided human decisions.")

    reviewer = require_string(review.get("reviewer"), "reviewer")
    reviewed_at = require_string(review.get("reviewed_at"), "review timestamp")
    validate_review_timestamp(reviewed_at)

    if decision == "approved":
        require_string(review.get("canonical_title"), "canonical title")
        if any(value != "approved" for value in checks.values()):
            raise PromotionError("Approved reviews require every checklist item to pass.")
    else:
        require_string(review.get("notes"), "rejection notes")

    if require_approval and decision != "approved":
        raise PromotionError("Review decision does not approve canonical promotion.")

    return str(decision)


def validate_review_anchor(
    manifest: dict[str, Any],
    run_dir: Path,
    candidate_sha256: str,
) -> tuple[Path, str]:
    anchor = manifest.get("review")
    if not isinstance(anchor, dict):
        raise PromotionError("Run manifest does not contain a review anchor.")
    review_path = run_dir / "review.json"
    if anchor.get("record") != str(review_path):
        raise PromotionError("Run manifest review path does not match the run contract.")
    if anchor.get("candidate_sha256") != candidate_sha256:
        raise PromotionError("Candidate changed after the review record was created.")
    created_at = require_string(
        anchor.get("created_at"), "review anchor timestamp"
    )
    validate_review_timestamp(created_at)
    if review_path.is_symlink() or not review_path.is_file():
        raise PromotionError("Review record is unavailable or unsafe.")
    return review_path, created_at


def load_frontmatter(path: Path, label: str) -> dict[str, Any]:
    try:
        content = path.read_text(encoding="utf-8")
        lines = content.splitlines()
        if not lines or lines[0] != "---":
            raise ValueError("missing frontmatter")
        closing = lines[1:].index("---") + 1
        metadata = yaml.safe_load("\n".join(lines[1:closing]))
    except (OSError, UnicodeDecodeError, ValueError, yaml.YAMLError) as exc:
        raise PromotionError(f"Invalid canonical {label} metadata: {path.name}") from exc
    if not isinstance(metadata, dict):
        raise PromotionError(f"Invalid canonical {label} metadata: {path.name}")
    return metadata


def validate_canonical_artifact(
    path: Path,
    project_root: Path,
    artifact_id: str,
    artifact_type: str,
) -> dict[str, Any]:
    if (
        path.is_symlink()
        or not path.is_file()
        or not is_within(path.resolve(), project_root)
    ):
        raise PromotionError(
            f"Canonical {artifact_type} does not resolve safely: {artifact_id}"
        )
    metadata = load_frontmatter(path, artifact_type)
    if (
        metadata.get("artifact_id") != artifact_id
        or metadata.get("artifact_type") != artifact_type
    ):
        raise PromotionError(
            f"Canonical {artifact_type} metadata does not match: {path.name}"
        )
    return metadata


def validate_canonical_context(
    repo_root: Path,
    context: dict[str, Any],
) -> Path:
    project_root = (
        repo_root / "docs/research" / str(context["project"])
    ).resolve()
    research_root = (repo_root / "docs/research").resolve()
    if not is_within(project_root, research_root) or not project_root.is_dir():
        raise PromotionError("Canonical research project does not exist.")

    corpus_path = project_root / "corpus" / f"{context['corpus']}.md"
    experiment_path = (
        project_root / "experiments" / f"{context['experiment']}.md"
    )
    validate_canonical_artifact(
        corpus_path,
        project_root,
        str(context["corpus"]),
        "corpus",
    )
    experiment = validate_canonical_artifact(
        experiment_path,
        project_root,
        str(context["experiment"]),
        "experiment",
    )
    experiment_source = experiment.get("source")
    if (
        not isinstance(experiment_source, dict)
        or experiment_source.get("corpus") != context["corpus"]
    ):
        raise PromotionError(
            "Canonical experiment source does not match the candidate corpus."
        )
    observations_dir = project_root / "observations"
    if observations_dir.exists() and (
        observations_dir.is_symlink()
        or not observations_dir.is_dir()
        or not is_within(observations_dir.resolve(), project_root)
    ):
        raise PromotionError("Canonical observations directory is unsafe.")
    return observations_dir


def allocate_observation(observations_dir: Path) -> tuple[str, Path]:
    numbers: list[int] = []
    if observations_dir.is_dir():
        for path in observations_dir.glob("OBS-*.md"):
            match = OBSERVATION_PATTERN.fullmatch(path.name)
            if match is None:
                raise PromotionError(
                    f"Invalid canonical observation identifier: {path.name}"
                )
            metadata = load_frontmatter(path, "observation")
            expected_id = path.stem
            if (
                metadata.get("artifact_id") != expected_id
                or metadata.get("artifact_type") != "observation"
            ):
                raise PromotionError(
                    f"Canonical observation metadata does not match: {path.name}"
                )
            numbers.append(int(match.group(1)))

    next_number = max(numbers, default=0) + 1
    artifact_id = f"OBS-{next_number:03d}"
    target = observations_dir / f"{artifact_id}.md"
    if target.exists():
        raise PromotionError(f"Canonical promotion target already exists: {target}")
    return artifact_id, target


def yaml_string(value: Any) -> str:
    return json.dumps(str(value), ensure_ascii=False)


def render_artifact(
    artifact_id: str,
    context: dict[str, Any],
    review: dict[str, Any],
    review_sha256: str,
    candidate_content: str,
) -> str:
    reviewed_at = str(review["reviewed_at"]).replace("Z", "+00:00")
    created_date = datetime.fromisoformat(reviewed_at).date().isoformat()
    lines = [
        "---",
        f"artifact_id: {artifact_id}",
        "artifact_type: observation",
        f"title: {yaml_string(review['canonical_title'])}",
        "version: 1",
        "status: draft",
        "",
        "source:",
        f"  corpus: {context['corpus']}",
        f"  experiment: {context['experiment']}",
        "  parent_artifacts: []",
        "",
        "created:",
        f"  date: {created_date}",
        f"  author: {yaml_string(review['reviewer'])}",
        "  method: AI-assisted research with explicit human review",
        "",
        "ai:",
        f"  model: {yaml_string(context['model'])}",
        "  tool: abbey research",
        f"  prompt_sha256: {context['prompt']['sha256']}",
    ]
    if context["inputs"]:
        lines.append("  input_sha256:")
        lines.extend(
            f"    - {item['sha256']}" for item in context["inputs"]
        )
    else:
        lines.append("  input_sha256: []")
    lines.extend(
        [
            "",
            "provenance:",
            f"  run_id: {yaml_string(review['run_id'])}",
            f"  candidate_sha256: {context['candidate_sha256']}",
            f"  review_sha256: {review_sha256}",
            "---",
            "",
            candidate_content.rstrip(),
            "",
        ]
    )
    return "\n".join(lines)


def install_exclusive(target: Path, content: str) -> None:
    target.parent.mkdir(parents=True, exist_ok=True)
    temporary = target.parent / f".{target.name}.{secrets.token_hex(4)}.tmp"
    try:
        with temporary.open("x", encoding="utf-8") as stream:
            stream.write(content)
            stream.flush()
            os.fsync(stream.fileno())
        try:
            os.link(temporary, target)
        except FileExistsError as exc:
            raise PromotionError(
                f"Canonical promotion target already exists: {target}"
            ) from exc
    finally:
        if temporary.exists():
            temporary.unlink()
    target.chmod(stat.S_IRUSR | stat.S_IRGRP | stat.S_IROTH)


def run_candidate_validation(repo_root: Path, candidate: Path) -> None:
    tool = Path(
        os.environ.get(
            "ABBEY_RESEARCH_STAGE_TOOL",
            repo_root / "tools/bin/abbey-research",
        )
    )
    result = subprocess.run(
        [
            str(tool),
            "validate",
            "--type",
            "observation",
            "--input",
            str(candidate),
        ],
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    if result.returncode:
        if result.stdout:
            print(result.stdout, file=sys.stderr, end="")
        raise PromotionError("Candidate failed structural validation.")


def review_init(repo_root: Path, run_id: str) -> int:
    run_dir, manifest_path = resolve_run(repo_root, run_id)
    manifest, context = validate_manifest(run_dir, manifest_path, run_id)
    review_path = run_dir / "review.json"
    if "review" in manifest:
        raise PromotionError(f"Review record already exists: {review_path}")
    record = review_record(run_id, str(context["candidate_sha256"]))
    write_object_exclusive(review_path, record)
    manifest["review"] = {
        "record": str(review_path),
        "candidate_sha256": context["candidate_sha256"],
        "created_at": record["created_at"],
    }
    try:
        write_manifest(manifest_path, manifest)
    except OSError:
        review_path.unlink()
        raise

    print("Abbey Research Review Record")
    print()
    print(f"Run:      {run_id}")
    print("Decision: undecided")
    print(f"Review:   {review_path}")
    print()
    print("Complete every human decision before validation or promotion.")
    return 0


def review_validate(repo_root: Path, run_id: str) -> int:
    run_dir, manifest_path = resolve_run(repo_root, run_id)
    manifest, context = validate_manifest(
        run_dir,
        manifest_path,
        run_id,
        allow_promoted=True,
    )
    review_path, anchored_created_at = validate_review_anchor(
        manifest,
        run_dir,
        str(context["candidate_sha256"]),
    )
    review = load_object(review_path, "Review record")
    if review.get("created_at") != anchored_created_at:
        raise PromotionError(
            "Review creation timestamp does not match the run manifest anchor."
        )
    decision = validate_review(
        review,
        run_id,
        str(context["candidate_sha256"]),
        require_complete=True,
        require_approval=False,
    )

    print("Abbey Research Review Validation")
    print()
    print(f"Run:      {run_id}")
    print(f"Decision: {decision}")
    print("Result:   PASS")
    return 0


def promote(repo_root: Path, run_id: str, confirm: bool) -> int:
    run_dir, manifest_path = resolve_run(repo_root, run_id)
    manifest, context = validate_manifest(run_dir, manifest_path, run_id)
    review_path, anchored_created_at = validate_review_anchor(
        manifest,
        run_dir,
        str(context["candidate_sha256"]),
    )
    try:
        review_bytes = review_path.read_bytes()
        review = json.loads(review_bytes.decode("utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise PromotionError(
            f"Unable to read review record: {review_path}: {exc}"
        ) from exc
    if not isinstance(review, dict):
        raise PromotionError("Review record must contain a JSON object.")
    if review.get("created_at") != anchored_created_at:
        raise PromotionError(
            "Review creation timestamp does not match the run manifest anchor."
        )
    validate_review(
        review,
        run_id,
        str(context["candidate_sha256"]),
        require_complete=True,
        require_approval=True,
    )
    run_candidate_validation(repo_root, Path(context["candidate"]))
    observations_dir = validate_canonical_context(repo_root, context)
    artifact_id, target = allocate_observation(observations_dir)
    review_sha256 = fingerprint_bytes(review_bytes)

    print("Abbey Research Promotion")
    print()
    print(f"Run:        {run_id}")
    print(f"Artifact:   {artifact_id}")
    print(f"Target:     {target}")
    print(f"Project:    {context['project']}")
    print(f"Corpus:     {context['corpus']}")
    print(f"Experiment: {context['experiment']}")
    print(f"Model:      {context['model']}")
    print(f"Prompt:     {context['prompt']['sha256']}")
    print("Inputs:")
    if context["inputs"]:
        for item in context["inputs"]:
            print(f"  - {item['sha256']}")
    else:
        print("  - None")

    if not confirm:
        print()
        print("Preview only. No canonical artifact was written.")
        print("Re-run with --confirm after reviewing this promotion plan.")
        return 0

    candidate_path = Path(context["candidate"])
    candidate_bytes = candidate_path.read_bytes()
    if fingerprint_bytes(candidate_bytes) != context["candidate_sha256"]:
        raise PromotionError("Candidate changed during promotion validation.")
    if fingerprint(review_path) != review_sha256:
        raise PromotionError("Review record changed during promotion validation.")
    try:
        candidate_content = candidate_bytes.decode("utf-8")
    except UnicodeDecodeError as exc:
        raise PromotionError("Candidate is not valid UTF-8 text.") from exc
    content = render_artifact(
        artifact_id,
        context,
        review,
        review_sha256,
        candidate_content,
    )
    install_exclusive(target, content)

    manifest["state"] = "promoted"
    manifest["promotion"] = {
        "artifact_id": artifact_id,
        "target": str(target),
        "candidate_sha256": context["candidate_sha256"],
        "review_sha256": review_sha256,
        "promoted_at": utc_now(),
    }
    try:
        write_manifest(manifest_path, manifest)
    except OSError:
        target.unlink()
        raise
    review_path.chmod(stat.S_IRUSR | stat.S_IRGRP | stat.S_IROTH)

    print()
    print("Promotion complete.")
    print(f"Canonical artifact: {target}")
    return 0


def main() -> int:
    args = parse_arguments()
    repo_root = Path(os.environ["ABBEY_ROOT"]).resolve()

    try:
        if args.command == "review-init":
            return review_init(repo_root, args.run_id)
        if args.command == "review-validate":
            return review_validate(repo_root, args.run_id)
        if args.command == "promote":
            return promote(repo_root, args.run_id, args.confirm)
    except (OSError, PromotionError) as exc:
        print(f"ERROR {exc}", file=sys.stderr)
        return 1

    raise AssertionError(f"Unhandled command: {args.command}")


if __name__ == "__main__":
    sys.exit(main())
