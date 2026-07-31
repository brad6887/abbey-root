#!/usr/bin/env python3
"""Log Adafruit SHT41 Trinkey USB serial readings to bounded local storage."""

from __future__ import annotations

import argparse
import csv
import glob
import json
import os
import sys
import tempfile
import time
from datetime import datetime, timedelta, timezone
from pathlib import Path

import serial


def parse_reading(line: str) -> dict[str, object]:
    fields = [field.strip() for field in line.split(",")]
    if len(fields) != 4:
        raise ValueError(f"expected 4 CSV fields, received {len(fields)}")

    device_serial, temperature_c, humidity_percent, touch_value = fields
    temperature_c_value = float(temperature_c)

    return {
        "device_serial": device_serial,
        "temperature_c": temperature_c_value,
        "temperature_f": temperature_c_value * 9 / 5 + 32,
        "humidity_percent": float(humidity_percent),
        "touch_value": int(touch_value),
    }


def find_device(device_glob: str) -> str | None:
    devices = sorted(glob.glob(device_glob))
    return devices[0] if devices else None


def write_latest(data_directory: Path, reading: dict[str, object]) -> None:
    descriptor, temporary_name = tempfile.mkstemp(
        dir=data_directory,
        prefix=".latest-",
        suffix=".json",
        text=True,
    )
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8") as temporary_file:
            json.dump(reading, temporary_file, indent=2)
            temporary_file.write("\n")
        os.replace(temporary_name, data_directory / "latest.json")
    finally:
        if os.path.exists(temporary_name):
            os.unlink(temporary_name)


def append_csv(data_directory: Path, reading: dict[str, object]) -> None:
    date_stamp = str(reading["timestamp_utc"])[0:10]
    csv_path = data_directory / f"readings-{date_stamp}.csv"
    new_file = not csv_path.exists()

    with csv_path.open("a", encoding="utf-8", newline="") as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=reading.keys())
        if new_file:
            writer.writeheader()
        writer.writerow(reading)


def remove_expired_files(data_directory: Path, retention_days: int) -> None:
    cutoff = datetime.now(timezone.utc) - timedelta(days=retention_days)
    for csv_path in data_directory.glob("readings-*.csv"):
        modified = datetime.fromtimestamp(csv_path.stat().st_mtime, timezone.utc)
        if modified < cutoff:
            csv_path.unlink()


def log_message(message: str) -> None:
    print(message, file=sys.stderr, flush=True)


def run(args: argparse.Namespace) -> None:
    data_directory = Path(args.data_directory)
    data_directory.mkdir(parents=True, exist_ok=True)
    last_saved = 0.0
    last_status = None

    while True:
        device = find_device(args.device_glob)
        if device is None:
            status = f"waiting for a serial device matching {args.device_glob}"
            if status != last_status:
                log_message(status)
                last_status = status
            time.sleep(5)
            continue

        try:
            with serial.Serial(device, args.baud_rate, timeout=2) as port:
                status = f"reading SHT41 data from {device}"
                if status != last_status:
                    log_message(status)
                    last_status = status

                while True:
                    raw_line = port.readline().decode("utf-8", errors="replace").strip()
                    if not raw_line:
                        continue

                    try:
                        reading = parse_reading(raw_line)
                    except (TypeError, ValueError) as error:
                        log_message(f"ignoring invalid sensor line {raw_line!r}: {error}")
                        continue

                    now_monotonic = time.monotonic()
                    if now_monotonic - last_saved < args.interval:
                        continue

                    reading["timestamp_utc"] = datetime.now(timezone.utc).isoformat()
                    ordered_reading = {
                        "timestamp_utc": reading["timestamp_utc"],
                        "device_serial": reading["device_serial"],
                        "temperature_c": round(float(reading["temperature_c"]), 2),
                        "temperature_f": round(float(reading["temperature_f"]), 2),
                        "humidity_percent": round(float(reading["humidity_percent"]), 2),
                        "touch_value": reading["touch_value"],
                    }
                    append_csv(data_directory, ordered_reading)
                    write_latest(data_directory, ordered_reading)
                    remove_expired_files(data_directory, args.retention_days)
                    last_saved = now_monotonic
        except (OSError, serial.SerialException) as error:
            log_message(f"serial device unavailable: {error}")
            last_status = None
            time.sleep(5)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()
    parser.add_argument("--device-glob", required=True)
    parser.add_argument("--baud-rate", type=int, default=115200)
    parser.add_argument("--interval", type=int, default=60)
    parser.add_argument("--retention-days", type=int, default=30)
    parser.add_argument("--data-directory", required=True)
    return parser


if __name__ == "__main__":
    run(build_parser().parse_args())
