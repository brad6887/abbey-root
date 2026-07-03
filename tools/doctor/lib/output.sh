#!/usr/bin/env bash

OK_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

print_header() {
  echo "========================================"
  echo " $1"
  echo "========================================"
  echo
}

section() {
  echo "$1"
  echo "----------"
  echo
}

ok() {
  OK_COUNT=$((OK_COUNT + 1))
  printf "OK   %s\n" "$1"
}

warn() {
  WARN_COUNT=$((WARN_COUNT + 1))
  printf "WARN %s\n" "$1"
}

fail() {
  FAIL_COUNT=$((FAIL_COUNT + 1))
  printf "FAIL %s\n" "$1"
}

print_summary() {
  echo
  echo "========================================"
  echo "Summary"
  echo "========================================"
  echo "OK:       $OK_COUNT"
  echo "Warnings: $WARN_COUNT"
  echo "Failures: $FAIL_COUNT"

  if [ "$FAIL_COUNT" -gt 0 ]; then
    echo "Status:   UNHEALTHY"
    exit 2
  elif [ "$WARN_COUNT" -gt 0 ]; then
    echo "Status:   HEALTHY WITH WARNINGS"
    exit 1
  else
    echo "Status:   HEALTHY"
    exit 0
  fi
}
