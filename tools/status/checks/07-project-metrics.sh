section "Project Metrics"

count_files() {
  local directory="$1"
  shift

  if [[ ! -d "$directory" ]]; then
    printf '%s\n' "Unavailable"
    return
  fi

  find "$directory" -type f "$@" -print 2>/dev/null | wc -l | tr -d ' '
}

TOOLKIT_COMMANDS="$(
  count_files "${ABBEY_TOOLKIT_ROOT:-$ABBEY_ROOT}/tools/bin" -maxdepth 1 -name 'abbey-*' -perm -111
)"
WEBSITE_PAGES="$(
  count_files "$ABBEY_ROOT/site/src/pages" -name '*.astro'
)"
JOURNAL_ENTRIES="$(
  count_files "$ABBEY_ROOT/content/journal" -name '*.md'
)"
DOCUMENTATION_FILES="$(
  count_files "$ABBEY_ROOT/docs" -name '*.md'
)"

info "Toolkit commands: $TOOLKIT_COMMANDS"
info "Website pages: $WEBSITE_PAGES"
info "Journal entries: $JOURNAL_ENTRIES"
info "Documentation files: $DOCUMENTATION_FILES"
