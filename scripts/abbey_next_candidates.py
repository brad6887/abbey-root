#!/usr/bin/env python3

from __future__ import annotations

import argparse
import re
import subprocess
from dataclasses import dataclass, field
from pathlib import Path


STOP_WORDS = {
    "a", "add", "additional", "and", "as", "abbey", "build", "complete",
    "continue", "create", "current", "design", "develop", "expand", "for",
    "from", "generate", "improve", "in", "into", "of", "on", "project",
    "review", "session", "the", "to", "using", "with", "workflow",
}

COMPLETED_STATUSES = {"complete", "completed"}

RECOMMENDATION_ENGINE_PATHS = {
    "tools/bin/abbey-next",
    "scripts/abbey_next_candidates.py",
    "tests/test-abbey-next.sh",
    "docs/architecture/ABBEY_NEXT_OUTPUT.md",
    "docs/architecture/RECOMMENDATION_ALGORITHM.md",
    "docs/architecture/RECOMMENDATION_ENGINE.md",
}

SESSION_SECTION_NAMES = {
    "objective",
    "definition of done",
    "summary",
    "accomplishments",
    "changes",
    "validation",
    "outcome",
    "lessons learned",
    "next steps",
}


@dataclass
class BacklogItem:
    title: str
    section: str
    order: int
    tokens: set[str]


@dataclass
class SessionUpdate:
    path: Path
    title: str
    status: str
    reviewed: bool
    completed_evidence: list[str]
    next_steps: list[str]


@dataclass
class Candidate:
    item: BacklogItem
    score: int = 20
    next_matches: list[str] = field(default_factory=list)
    status_matches: list[str] = field(default_factory=list)
    active_matches: list[str] = field(default_factory=list)
    session_matches: list[str] = field(default_factory=list)
    session_paths: list[str] = field(default_factory=list)


@dataclass
class PlanningConflict:
    item: BacklogItem
    update_path: str
    evidence: str


def clean_markdown(value: str) -> str:
    value = value.strip()
    value = re.sub(r"^[-*] \[[ xX]\] ", "", value)
    value = re.sub(r"^[-*] ", "", value)
    value = value.replace("`", "")
    value = value.strip("\"'“”")
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


def metadata_value(lines: list[str], key: str) -> str:
    pattern = re.compile(rf"^{re.escape(key)}:\s*(.*?)\s*$", re.IGNORECASE)

    for line in lines[:80]:
        match = pattern.match(line.strip())
        if match:
            return clean_markdown(match.group(1))

    return ""


def normalized_heading(line: str) -> str:
    value = re.sub(r"^#{1,6}\s+", "", line.strip())
    return value.strip().lower()


def extract_named_section(lines: list[str], name: str) -> list[str]:
    target = name.lower()
    found = False
    values: list[str] = []

    for line in lines:
        heading = normalized_heading(line)

        if not found:
            if heading == target:
                found = True
            continue

        if heading in SESSION_SECTION_NAMES and heading != target:
            break

        cleaned = clean_markdown(line)

        if not cleaned or cleaned in {"---", "⸻"}:
            continue

        if line.lstrip().startswith(("- ", "* ")):
            values.append(cleaned)
        elif not line.lstrip().startswith("#"):
            values.append(cleaned)

    return values


def extract_session_updates(repo: Path) -> list[SessionUpdate]:
    update_dir = repo / "docs/session-updates"

    if not update_dir.is_dir():
        return []

    updates: list[SessionUpdate] = []

    for path in sorted(update_dir.glob("*.md")):
        lines = path.read_text(encoding="utf-8").splitlines()

        reviewed_value = metadata_value(lines, "reviewed").lower()
        if reviewed_value != "false":
            continue

        status = metadata_value(lines, "status").lower()
        title = metadata_value(lines, "title")

        if not title:
            for line in lines:
                if line.startswith("# "):
                    title = clean_markdown(line)
                    break

        # Completion suppression must use strong session-level evidence.
        # Detailed accomplishment bullets are useful context, but broad token
        # overlap there can incorrectly suppress unrelated backlog items.
        evidence: list[str] = []

        if title:
            evidence.append(title)

        evidence.extend(extract_named_section(lines, "objective"))

        updates.append(
            SessionUpdate(
                path=path,
                title=title or path.stem,
                status=status,
                reviewed=False,
                completed_evidence=evidence,
                next_steps=extract_named_section(lines, "next steps"),
            )
        )

    return updates


def session_related(candidate_tokens: set[str], evidence: str) -> bool:
    """Require strong coverage before session prose influences a candidate."""
    evidence_tokens = tokenize(evidence)

    if not candidate_tokens or not evidence_tokens:
        return False

    overlap = candidate_tokens & evidence_tokens
    coverage = len(overlap) / len(candidate_tokens)

    return len(overlap) >= 2 and coverage >= 0.75


def recommendation_engine_active(changed_paths: list[str]) -> bool:
    return any(path in RECOMMENDATION_ENGINE_PATHS for path in changed_paths)


def completed_conflict(
    item: BacklogItem,
    session_updates: list[SessionUpdate],
    repo: Path,
) -> PlanningConflict | None:
    for update in session_updates:
        if update.status not in COMPLETED_STATUSES:
            continue

        for evidence in update.completed_evidence:
            if related(item.tokens, evidence):
                return PlanningConflict(
                    item=item,
                    update_path=str(update.path.relative_to(repo)),
                    evidence=evidence,
                )

    return None


def rank_candidates(
    backlog_items: list[BacklogItem],
    next_priorities: list[str],
    status_priorities: list[str],
    changed_paths: list[str],
    session_updates: list[SessionUpdate],
    repo: Path,
) -> tuple[list[Candidate], list[PlanningConflict]]:
    engine_active = recommendation_engine_active(changed_paths)

    if engine_active:
        backlog_items = [
            item
            for item in backlog_items
            if item.section == "Project-Aware Recommendations"
        ]

    candidates: list[Candidate] = []
    conflicts: list[PlanningConflict] = []

    for item in backlog_items:
        conflict = completed_conflict(item, session_updates, repo)

        if conflict is not None:
            conflicts.append(conflict)
            continue

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

        for update in session_updates:
            matched_steps = [
                step
                for step in update.next_steps
                if session_related(item.tokens, step)
            ]

            if matched_steps:
                candidate.session_matches.extend(matched_steps)
                candidate.session_paths.append(
                    str(update.path.relative_to(repo))
                )

        if candidate.session_matches:
            candidate.score += 30

        if engine_active:
            candidate.active_matches = [
                path
                for path in changed_paths
                if path in RECOMMENDATION_ENGINE_PATHS
            ]
            candidate.score += 100

        candidates.append(candidate)

    return (
        sorted(
            candidates,
            key=lambda candidate: (
                -candidate.score,
                -bool(candidate.active_matches),
                -bool(candidate.next_matches),
                -bool(candidate.status_matches),
                -bool(candidate.session_matches),
                candidate.item.order,
                candidate.item.title.lower(),
            ),
        ),
        conflicts,
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
    parser.add_argument(
        "--mode",
        choices=("candidates", "conflicts"),
        default="candidates",
    )
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
    session_updates = extract_session_updates(repo)

    candidates, conflicts = rank_candidates(
        backlog_items,
        next_priorities,
        status_priorities,
        changed_paths,
        session_updates,
        repo,
    )

    if args.mode == "conflicts":
        for conflict in conflicts:
            fields = [
                conflict.item.title,
                conflict.update_path,
                conflict.evidence,
            ]
            print("|".join(sanitize_field(field) for field in fields))

        return 0

    for candidate in candidates:
        fields = [
            str(candidate.score),
            candidate.item.title,
            " | ".join(candidate.next_matches),
            " | ".join(candidate.status_matches),
            " | ".join(candidate.active_matches),
            " | ".join(candidate.session_matches),
            " | ".join(dict.fromkeys(candidate.session_paths)),
        ]

        print("|".join(sanitize_field(field) for field in fields))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
