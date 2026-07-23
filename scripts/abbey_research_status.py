#!/usr/bin/env python3

from __future__ import annotations

import argparse
import sys
from collections import Counter
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import yaml


SUPPORTED_DIRECTORIES = {
    "corpus": "corpus",
    "experiments": "experiment",
    "observations": "observation",
    "evidence": "evidence",
    "hypotheses": "hypothesis",
    "validation": "validation",
}

REQUIRED_FIELDS = (
    "artifact_id",
    "artifact_type",
    "title",
    "version",
    "status",
)

TYPE_ORDER = (
    "corpus",
    "experiment",
    "observation",
    "evidence",
    "hypothesis",
    "validation",
)

TYPE_LABELS = {
    "corpus": "Corpus",
    "experiment": "Experiments",
    "observation": "Observations",
    "evidence": "Evidence",
    "hypothesis": "Hypotheses",
    "validation": "Validations",
}


@dataclass(frozen=True)
class Artifact:
    artifact_id: str
    artifact_type: str
    title: str
    version: Any
    status: str
    path: Path
    project: str
    corpus: str | None
    experiment: str | None
    parents: tuple[str, ...]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Discover formal Abbey research artifacts and report "
            "their relationships and chain status."
        )
    )
    parser.add_argument(
        "--repo",
        required=True,
        help="Path to the Abbey repository root.",
    )
    return parser.parse_args()


def read_frontmatter(path: Path) -> dict[str, Any] | None:
    try:
        content = path.read_text(encoding="utf-8")
    except OSError:
        return None

    lines = content.splitlines()

    if not lines or lines[0].strip() != "---":
        return None

    closing_index = None

    for index in range(1, len(lines)):
        if lines[index].strip() == "---":
            closing_index = index
            break

    if closing_index is None:
        return None

    frontmatter_text = "\n".join(lines[1:closing_index])

    try:
        data = yaml.safe_load(frontmatter_text)
    except yaml.YAMLError:
        return None

    if not isinstance(data, dict):
        return None

    return data


def normalize_parent_list(value: Any) -> tuple[str, ...]:
    if value is None:
        return ()

    if isinstance(value, str):
        return (value,)

    if isinstance(value, list):
        return tuple(
            str(item)
            for item in value
            if item is not None and str(item).strip()
        )

    return ()


def discover_artifacts(repo: Path) -> list[Artifact]:
    research_root = repo / "docs" / "research"
    artifacts: list[Artifact] = []

    if not research_root.is_dir():
        return artifacts

    for project_dir in sorted(research_root.iterdir()):
        if not project_dir.is_dir():
            continue

        project = project_dir.name

        for directory_name, expected_type in SUPPORTED_DIRECTORIES.items():
            artifact_dir = project_dir / directory_name

            if not artifact_dir.is_dir():
                continue

            for path in sorted(artifact_dir.glob("*.md")):
                metadata = read_frontmatter(path)

                if metadata is None:
                    continue

                if not all(field in metadata for field in REQUIRED_FIELDS):
                    continue

                artifact_type = str(metadata["artifact_type"]).strip()

                if artifact_type != expected_type:
                    continue

                source = metadata.get("source", {})

                if not isinstance(source, dict):
                    source = {}

                corpus = source.get("corpus")
                experiment = source.get("experiment")
                parents = normalize_parent_list(
                    source.get("parent_artifacts")
                )

                artifacts.append(
                    Artifact(
                        artifact_id=str(
                            metadata["artifact_id"]
                        ).strip(),
                        artifact_type=artifact_type,
                        title=str(metadata["title"]).strip(),
                        version=metadata["version"],
                        status=str(metadata["status"]).strip(),
                        path=path,
                        project=project,
                        corpus=(
                            str(corpus).strip()
                            if corpus is not None
                            else None
                        ),
                        experiment=(
                            str(experiment).strip()
                            if experiment is not None
                            else None
                        ),
                        parents=parents,
                    )
                )

    return artifacts


def build_index(
    artifacts: list[Artifact],
) -> dict[str, Artifact]:
    return {
        artifact.artifact_id: artifact
        for artifact in artifacts
    }


def provenance_parents(
    artifact: Artifact,
    index: dict[str, Artifact],
) -> list[str]:
    return [
        parent
        for parent in artifact.parents
        if parent not in index
    ]


def find_child(
    artifacts: list[Artifact],
    parent_id: str,
    artifact_type: str,
) -> Artifact | None:
    matches = [
        artifact
        for artifact in artifacts
        if artifact.artifact_type == artifact_type
        and parent_id in artifact.parents
    ]

    if not matches:
        return None

    return sorted(
        matches,
        key=lambda artifact: artifact.artifact_id,
    )[0]


def build_observation_chains(
    artifacts: list[Artifact],
) -> list[list[str]]:
    observations = sorted(
        (
            artifact
            for artifact in artifacts
            if artifact.artifact_type == "observation"
        ),
        key=lambda artifact: artifact.artifact_id,
    )

    chains: list[list[str]] = []

    for observation in observations:
        chain = [observation.artifact_id]

        evidence = find_child(
            artifacts,
            observation.artifact_id,
            "evidence",
        )

        if evidence is None:
            chains.append(chain)
            continue

        chain.append(evidence.artifact_id)

        hypothesis = find_child(
            artifacts,
            evidence.artifact_id,
            "hypothesis",
        )

        if hypothesis is None:
            chains.append(chain)
            continue

        chain.append(hypothesis.artifact_id)

        validation = find_child(
            artifacts,
            hypothesis.artifact_id,
            "validation",
        )

        if validation is not None:
            chain.append(validation.artifact_id)

        chains.append(chain)

    return chains


def print_header(repo: Path) -> None:
    print("========================================")
    print(" Abbey Research Status")
    print("========================================")
    print()
    print(f"Repo: {repo}")
    print()


def print_projects(artifacts: list[Artifact]) -> None:
    projects = sorted({artifact.project for artifact in artifacts})

    print("Research Projects")
    print("-----------------")

    if not projects:
        print("WARN No formal research projects discovered")
    else:
        for project in projects:
            print(f"OK   {project}")

    print()


def print_artifact_counts(artifacts: list[Artifact]) -> None:
    counts = Counter(
        artifact.artifact_type
        for artifact in artifacts
    )

    print("Artifacts")
    print("---------")

    for artifact_type in TYPE_ORDER:
        label = TYPE_LABELS[artifact_type]
        print(f"OK   {label + ':':13} {counts[artifact_type]}")

    print()


def print_chains(chains: list[list[str]]) -> tuple[int, int]:
    complete = 0
    incomplete = 0

    print("Artifact Chains")
    print("---------------")

    if not chains:
        print("WARN No observation chains discovered")
        print()
        return complete, incomplete

    for chain in chains:
        if len(chain) == 4:
            complete += 1
            print(f"OK   {' → '.join(chain)}")
        else:
            incomplete += 1
            print(f"WARN {' → '.join(chain)}")

    print()

    return complete, incomplete


def print_provenance(
    artifacts: list[Artifact],
    index: dict[str, Artifact],
) -> int:
    references: list[tuple[str, str]] = []

    for artifact in sorted(
        artifacts,
        key=lambda item: item.artifact_id,
    ):
        for parent in provenance_parents(artifact, index):
            references.append(
                (artifact.artifact_id, parent)
            )

    print("Provenance References")
    print("---------------------")

    if not references:
        print("OK   None")
    else:
        for artifact_id, parent in references:
            print(f"INFO {artifact_id} → {parent}")

    print()

    return len(references)


def main() -> int:
    args = parse_args()
    repo = Path(args.repo).resolve()

    artifacts = discover_artifacts(repo)
    index = build_index(artifacts)
    chains = build_observation_chains(artifacts)

    print_header(repo)
    print_projects(artifacts)
    print_artifact_counts(artifacts)
    complete, incomplete = print_chains(chains)
    provenance_count = print_provenance(
        artifacts,
        index,
    )

    print("Summary")
    print("-------")
    print(f"Complete chains:      {complete}")
    print(f"Incomplete chains:    {incomplete}")
    print(f"Provenance references:{provenance_count:>3}")
    print(f"Formal artifacts:     {len(artifacts)}")
    print()

    return 0


if __name__ == "__main__":
    sys.exit(main())
