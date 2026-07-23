#!/usr/bin/env python3

import argparse
import csv
import json
import re
from collections import Counter, defaultdict
from pathlib import Path


CHECKIN_PATTERNS = [
    re.compile(r"https?://4sq\.", re.I),
    re.compile(r"@foursquare", re.I),
    re.compile(r"^I(?:'|’)?m at .+https?://t\.co/", re.I),
    re.compile(r"\(@ .+\)\s+https?://t\.co/", re.I),
]

EXCLUDE_PATTERNS = [
    (
        re.compile(r"^(?:https?://\S+|www\.\S+)$", re.I),
        "link_only",
    ),
    (
        re.compile(r"^(?:Place|Address):", re.I),
        "location_metadata",
    ),
]

REVIEW_PATTERNS = [
    (
        re.compile(r"@\[\d+:\d+:[^\]]+\]"),
        "facebook_mention_token",
    ),
    (
        re.compile(r'^Took the ".+" quiz\. Result is:', re.I),
        "application_quiz_template",
    ),
    (
        re.compile(r"^\d+ Years? Ago\b", re.I),
        "memory_metadata",
    ),
]

CONTEXT_PATTERNS = [
    (
        re.compile(
            r"^(?:is|has|was|wants|needs|hopes|thinks|wishes|"
            r"likes|loves|hates|feels|says|wonders|just)\b",
            re.I,
        ),
        "facebook_status_prompt_completion",
    ),
]


def classify(text: str) -> tuple[str, str, list[str]]:
    for pattern in CHECKIN_PATTERNS:
        if pattern.search(text):
            return "excluded", "automated_checkin", []

    for pattern, reason in EXCLUDE_PATTERNS:
        if pattern.search(text):
            return "excluded", reason, []

    for pattern, reason in REVIEW_PATTERNS:
        if pattern.search(text):
            return "review", reason, []

    flags = [
        reason
        for pattern, reason in CONTEXT_PATTERNS
        if pattern.search(text)
    ]
    return "eligible", "authored_voice_candidate", flags


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--corpus", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()

    with args.corpus.open(encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames is None:
            raise SystemExit("Corpus has no CSV header.")
        rows = list(reader)
        source_fields = reader.fieldnames

    output_rows = []
    counts = Counter()
    reasons = Counter()
    context_flags = Counter()
    examples = defaultdict(list)

    for row in rows:
        if row["status"].strip().lower() != "clean":
            research_status = "excluded"
            research_reason = "not_clean_corpus_row"
            flags = []
        else:
            research_status, research_reason, flags = classify(
                row["text"].strip()
            )

        counts[research_status] += 1
        reasons[research_reason] += 1
        for flag in flags:
            context_flags[flag] += 1

        key = f"{research_status}:{research_reason}"
        if len(examples[key]) < 8:
            examples[key].append(
                {
                    "source_id": f"FB-{int(row['source_id']):06d}",
                    "date": row["datetime"][:10],
                    "text": row["text"],
                }
            )

        output_rows.append(
            {
                **row,
                "research_status": research_status,
                "research_reason": research_reason,
                "platform_context": "|".join(flags),
            }
        )

    args.output.parent.mkdir(parents=True, exist_ok=True)
    fields = source_fields + [
        "research_status",
        "research_reason",
        "platform_context",
    ]
    with args.output.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields)
        writer.writeheader()
        writer.writerows(output_rows)

    report = {
        "source_corpus": str(args.corpus),
        "total_rows": len(output_rows),
        "research_status_counts": dict(sorted(counts.items())),
        "reason_counts": dict(sorted(reasons.items())),
        "platform_context_counts": dict(sorted(context_flags.items())),
        "examples": dict(sorted(examples.items())),
    }
    args.report.write_text(
        json.dumps(report, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )

    print("Voice Eligibility View")
    print("======================")
    for name in ("eligible", "review", "excluded"):
        print(f"{name.capitalize():<10} {counts[name]:>5}")
    print()
    for reason, count in sorted(reasons.items()):
        print(f"{reason:<32} {count:>5}")
    print()
    for flag, count in sorted(context_flags.items()):
        print(f"{flag:<32} {count:>5}")


if __name__ == "__main__":
    main()
