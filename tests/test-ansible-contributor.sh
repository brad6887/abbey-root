#!/usr/bin/env bash
# Runs account mutations only in a disposable container; the checkout is read-only.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
command -v docker >/dev/null || { echo "FAIL Docker is required for isolated lifecycle validation."; exit 1; }
case "${1:-}" in
  "") dockerfile="Dockerfile"; image="abbey-contributor-test:local" ;;
  --rocky) dockerfile="Dockerfile.rocky"; image="abbey-contributor-test:rocky" ;;
  *) echo "Usage: tests/test-ansible-contributor.sh [--rocky]" >&2; exit 2 ;;
esac
[[ $# -le 1 ]] || { echo "FAIL Unexpected arguments." >&2; exit 2; }
docker build -q -f "$ROOT/tests/fixtures/contributor/$dockerfile" -t "$image" "$ROOT/tests/fixtures/contributor"
docker run --rm --network none --mount "type=bind,src=$ROOT,dst=/repo,readonly" "$image"
