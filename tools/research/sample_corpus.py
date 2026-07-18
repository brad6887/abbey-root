#!/usr/bin/env python3

"""Display reproducible samples from a normalized writing corpus."""

from __future__ import annotations

import argparse

import csv

import random

import sys

from datetime import datetime

from pathlib import Path

from typing import Any

DEFAULT_CORPUS = Path("output/clean_corpus.csv")

def parse_arguments() -> argparse.Namespace:

    parser = argparse.ArgumentParser(

        description=(

            "Display clean posts from a normalized corpus in chronological, "

            "reverse-chronological, random, or year-filtered order."

        ),

    )

    parser.add_argument(

        "--corpus",

        type=Path,

        default=DEFAULT_CORPUS,

        help=f"Corpus CSV path. Default: {DEFAULT_CORPUS}",

    )

    selection = parser.add_mutually_exclusive_group(required=True)

    selection.add_argument(

        "--first",

        type=positive_integer,

        metavar="N",

        help="Show the earliest N clean posts.",

    )

    selection.add_argument(

        "--last",

        type=positive_integer,

        metavar="N",

        help="Show the latest N clean posts.",

    )

    selection.add_argument(

        "--random",

        type=positive_integer,

        metavar="N",

        help="Show N reproducibly selected random clean posts.",

    )

    selection.add_argument(

        "--year",

        type=int,

        metavar="YYYY",

        help="Show clean posts from a specific year.",

    )

    parser.add_argument(

        "--limit",

        type=positive_integer,

        metavar="N",

        help="Limit results used with --year.",

    )

    parser.add_argument(

        "--offset",

        type=nonnegative_integer,

        default=0,

        metavar="N",

        help="Skip the first N posts selected with --first. Default: 0",

    )

    parser.add_argument(

        "--seed",

        type=int,

        default=1,

        help="Random seed used with --random. Default: 1",

    )

    parser.add_argument(

        "--reverse",

        action="store_true",

        help="Reverse the final display order.",

    )

    parser.add_argument(

        "--metadata",

        action="store_true",

        help="Include source ID, status, and reason.",

    )

    args = parser.parse_args()

    if args.limit is not None and args.year is None:

        parser.error("--limit may only be used with --year")

    if args.offset and args.first is None:

        parser.error("--offset may only be used with --first")

    return args

def nonnegative_integer(value: str) -> int:

    try:

        number = int(value)

    except ValueError as exc:

        raise argparse.ArgumentTypeError(

            f"expected an integer, received {value!r}"

        ) from exc

    if number < 0:

        raise argparse.ArgumentTypeError("value must be zero or greater")

    return number

def positive_integer(value: str) -> int:

    try:

        number = int(value)

    except ValueError as exc:

        raise argparse.ArgumentTypeError(

            f"expected an integer, received {value!r}"

        ) from exc

    if number < 1:

        raise argparse.ArgumentTypeError("value must be at least 1")

    return number

def parse_datetime(value: str, source_id: str) -> datetime:

    normalized = value.strip().replace("Z", "+00:00")

    try:

        return datetime.fromisoformat(normalized)

    except ValueError as exc:

        raise ValueError(

            f"source_id {source_id!r} has invalid datetime {value!r}"

        ) from exc

def load_clean_posts(path: Path) -> list[dict[str, Any]]:

    if not path.is_file():

        raise FileNotFoundError(f"corpus not found: {path}")

    posts: list[dict[str, Any]] = []

    with path.open(encoding="utf-8", newline="") as handle:

        reader = csv.DictReader(handle)

        if reader.fieldnames is None:

            raise ValueError(f"corpus has no CSV header: {path}")

        required_fields = {"source_id", "datetime", "text", "status"}

        missing_fields = required_fields.difference(reader.fieldnames)

        if missing_fields:

            missing = ", ".join(sorted(missing_fields))

            raise ValueError(f"corpus is missing required fields: {missing}")

        for row_number, row in enumerate(reader, start=2):

            if row["status"].strip().lower() != "clean":

                continue

            text = row["text"].strip()

            if not text:

                continue

            source_id = row["source_id"].strip()

            try:

                parsed_datetime = parse_datetime(

                    row["datetime"],

                    source_id,

                )

            except ValueError as exc:

                raise ValueError(

                    f"{path}:{row_number}: {exc}"

                ) from exc

            posts.append(

                {

                    **row,

                    "_parsed_datetime": parsed_datetime,

                }

            )

    posts.sort(

        key=lambda row: (

            row["_parsed_datetime"],

            row["source_id"],

        )

    )

    return posts

def select_posts(

    posts: list[dict[str, Any]],

    args: argparse.Namespace,

) -> tuple[list[dict[str, Any]], str]:

    if args.first is not None:

        start = args.offset

        stop = start + args.first

        selected = posts[start:stop]

        description = f"posts {start + 1}-{stop}"

        if len(selected) < args.first:

            description += f" ({len(selected)} available)"

    elif args.last is not None:

        selected = posts[-args.last :]

        description = f"latest {args.last}"

    elif args.random is not None:

        sample_size = min(args.random, len(posts))

        generator = random.Random(args.seed)

        selected = generator.sample(posts, sample_size)

        selected.sort(

            key=lambda row: (

                row["_parsed_datetime"],

                row["source_id"],

            )

        )

        description = (

            f"random {sample_size} "

            f"(seed {args.seed})"

        )

    else:

        selected = [

            row

            for row in posts

            if row["_parsed_datetime"].year == args.year

        ]

        if args.limit is not None:

            selected = selected[: args.limit]

        description = f"year {args.year}"

        if args.limit is not None:

            description += f", first {args.limit}"

    if args.reverse:

        selected.reverse()

        description += ", reversed"

    return selected, description

def display_posts(

    posts: list[dict[str, Any]],

    corpus: Path,

    description: str,

    include_metadata: bool,

) -> None:

    print("Corpus Sample")

    print("=" * 80)

    print(f"Corpus:    {corpus}")

    print(f"Selection: {description}")

    print(f"Posts:     {len(posts)}")

    print()

    for index, row in enumerate(posts, start=1):

        print("=" * 80)

        source_id = row["source_id"].strip()

        try:

            display_id = f"FB-{int(source_id):06d}"

        except ValueError:

            display_id = f"FB-{source_id}"

        print(

            f"{index:3d}. "

            f"[{display_id}] "

            f"{row['_parsed_datetime'].isoformat()}"

        )

        if include_metadata:

            print(f"Raw ID:    {source_id}")

            print(f"Status:    {row['status']}")

            reason = row.get("reason", "").strip()

            if reason:

                print(f"Reason:    {reason}")

        print()

        print(row["text"].strip())

        print()

def main() -> int:

    args = parse_arguments()

    try:

        posts = load_clean_posts(args.corpus)

        selected, description = select_posts(posts, args)

    except (FileNotFoundError, OSError, ValueError) as exc:

        print(f"error: {exc}", file=sys.stderr)

        return 1

    display_posts(

        posts=selected,

        corpus=args.corpus,

        description=description,

        include_metadata=args.metadata,

    )

    return 0

if __name__ == "__main__":

    raise SystemExit(main())
