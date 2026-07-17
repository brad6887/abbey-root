#!/usr/bin/env python3

from __future__ import annotations

import argparse
import re
import subprocess
from dataclasses import dataclass, field
from pathlib import Path


STOP_WORDS = {
    "a",
    "add",
    "additional",
    "and",
    "as",
    "abbey",
    "build",
    "complete",
    "continue",
    "create",
    "current",
    "design",
    "develop",
    "expand",
    "for",
    "from",
    "generate",
    "improve",
    "in",
    "into",
    "of",
    "on",
    "project",
    "review",
    "session",
    "the",
    "to",
    "using",
    "with",
    "workflow",
}

RECOMMENDATION_ENGINE_PATHS = {
    "tools/bin/abbey-next",
    "scripts/abbey_next_candidates.py",
    "tests/test-abbey-next.sh",
    "docs/architecture/ABBEY_NEXT_OUTPUT.md",
    "docs/architecture/RECOMMENDATION_ALGORITHM.md",
    "docs/architecture/RECOMMENDATION_ENGINE.md",
}


@dataclass
class BacklogItem:
    title: str
    section: str
    order: int
    tokens: set[str]


@dataclass
class Candidate:
    item: BacklogItem
    score: int = 20
    next_matches: list[str] = field(default_factory=list)
    status_matches: list[str] = field(default_factory=list)
    active_matches: list[str] = field(default_factory=list)


def clean_markdown(value: str) -> str:
    value = value.strip()
    value = re.sub(r"^- \[ \] ", "", value)
    value = re.sub(r"^- ", "", value)
    value = value.replace("`", "")
    return value.rstrip(".")


def tokenize(value: str) -> set[str]:
    words = re.findall(r"[a-z0-9]+", value.lower())

    return {
        word
        for word in words
        if len(word) > 3 and word not in STOP_WORDS
    }


def extract_section_bullets(
    path: Path,
    heading: str,
    stop_heading_level: int,
) -> list[str]:
    lines = path.read_text(encoding="utf-8").splitlines()
    items: list[str] = []
    found = False
    stop_prefix = "#" * stop_heading_level + " "

    for line in lines:
        if line == heading:
            found = True
            continue

        if not found:
            continue

        if line.startswith(stop_prefix):
            break

        if line.startswith("- ") and not line.startswith("- ["):
            items.append(clean_markdown(line))

    return items


def extract_incomplete_backlog(path: Path) -> list[BacklogItem]:
    items: list[BacklogItem] = []
    current_section = ""
    order = 0

    for line in path.read_text(encoding="utf-8").splitlines():
        if line.startswith("### "):
            current_section = line.removeprefix("### ").strip()
            continue

        if line.startswith("## "):
            current_section = line.removeprefix("## ").strip()
            continue

        if not line.startswith("- [ ] "):
            continue

        title = clean_markdown(line)

        items.append(
            BacklogItem(
                title=title,
                section=current_section,
                order=order,
                tokens=tokenize(title),
            )
        )
        order += 1

    return items


def git_changed_paths(repo: Path) -> list[str]:
    result = subprocess.run(
        [
            "git",
            "-C",
            str(repo),
            "status",
            "--porcelain",
            "--untracked-files=all",
        ],
        check=False,
        capture_output=True,
        text=True,
    )

    if result.returncode != 0:
        return []

    paths: list[str] = []

    for line in result.stdout.splitlines():
        if len(line) < 4:
            continue

        path = line[3:]

        if " -> " in path:
            path = path.split(" -> ", 1)[1]

        if path.endswith("/"):
            continue

        paths.append(path)

    return paths


def related(candidate_tokens: set[str], evidence: str) -> bool:
    evidence_tokens = tokenize(evidence)
    overlap = candidate_tokens & evidence_tokens

    if not candidate_tokens or not evidence_tokens:
        return False

    if len(overlap) >= 2:
        return True

    return len(candidate_tokens) == 1 and overlap == candidate_tokens


def recommendation_engine_active(changed_paths: list[str]) -> bool:
    return any(path in RECOMMENDATION_ENGINE_PATHS for path in changed_paths)


def rank_candidates(
    backlog_items: list[BacklogItem],
    next_priorities: list[str],
    status_priorities: list[str],
    changed_paths: list[str],
) -> list[Candidate]:
    engine_active = recommendation_engine_active(changed_paths)

    if engine_active:
        backlog_items = [
            item
            for item in backlog_items
            if item.section == "Project-Aware Recommendations"
        ]

    candidates: list[Candidate] = []

    for item in backlog_items:
        candidate = Candidate(item=item)

        for priority in next_priorities:
            if related(item.tokens, priority):
                candidate.next_matches.append(priority)

        if candidate.next_matches:
            candidate.score += 50

        for priority in status_priorities:
            if related(item.tokens, priority):
                candidate.status_matches.append(priority)

        if candidate.status_matches:
            candidate.score += 40

        if engine_active:
            candidate.active_matches = [
                path
                for path in changed_paths
                if path in RECOMMENDATION_ENGINE_PATHS
            ]
            candidate.score += 100

        candidates.append(candidate)

    return sorted(
        candidates,
        key=lambda candidate: (
            -candidate.score,
            -bool(candidate.active_matches),
            -bool(candidate.next_matches),
            -bool(candidate.status_matches),
            candidate.item.order,
            candidate.item.title.lower(),
        ),
    )


def sanitize_field(value: str) -> str:
    return value.replace("\t", " ").replace("\n", " ").replace("|", "/")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Rank deterministic Abbey work candidates."
    )
    parser.add_argument("--repo", required=True)
    parser.add_argument("--next", required=True, dest="next_path")
    parser.add_argument("--project-status", required=True)
    parser.add_argument("--backlog", required=True)
    args = parser.parse_args()

    repo = Path(args.repo)
    next_path = Path(args.next_path)
    project_status = Path(args.project_status)
    backlog = Path(args.backlog)

    next_priorities = extract_section_bullets(
        next_path,
        "# Current Priorities",
        1,
    )

    status_priorities = extract_section_bullets(
        project_status,
        "# Immediate Priorities",
        1,
    )

    backlog_items = extract_incomplete_backlog(backlog)
    changed_paths = git_changed_paths(repo)

    candidates = rank_candidates(
        backlog_items,
        next_priorities,
        status_priorities,
        changed_paths,
    )

    for candidate in candidates:
        fields = [
            str(candidate.score),
            candidate.item.title,
            " | ".join(candidate.next_matches),
            " | ".join(candidate.status_matches),
            " | ".join(candidate.active_matches),
        ]

        print("|".join(sanitize_field(field) for field in fields))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
