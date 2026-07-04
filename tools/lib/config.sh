#!/usr/bin/env bash

load_abbey_config() {
  local root="${ABBEY_ROOT:-$HOME/git/abbey-root}"

  # Tracked defaults
  if [[ -f "$root/config/abbey.conf" ]]; then
    # shellcheck disable=SC1090
    source "$root/config/abbey.conf"
  fi

  # Local overrides, ignored by Git
  if [[ -f "$root/.abbey/config.conf" ]]; then
    # shellcheck disable=SC1090
    source "$root/.abbey/config.conf"
  fi

  OPEN_WEBUI_URL="${OPEN_WEBUI_URL:-http://localhost:3000}"
  ABBEY_KNOWLEDGE_FILE="${ABBEY_KNOWLEDGE_FILE:-.abbey/knowledge/snapshot.md}"
  ABBEY_AI_AUTO_BUILD_KNOWLEDGE="${ABBEY_AI_AUTO_BUILD_KNOWLEDGE:-true}"
  OPEN_WEBUI_MODEL="${OPEN_WEBUI_MODEL:-qwen3:8b}"
}
