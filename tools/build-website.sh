#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="content"
OUT_DIR="website"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

find "$SRC_DIR" -type f -name "*.md" | sort | while read -r src; do
    rel="${src#$SRC_DIR/}"
   # Directory README files are for repository documentation, not public pages.
    if [[ "$rel" == "pages/README.md" ]]; then
        continue
    fi

    # Timeless pages live at the site root.
    # content/pages/about.md -> /about/
    if [[ "$rel" == pages/* ]]; then
        rel="${rel#pages/}"
    fi

rel_no_ext="${rel%.md}"
    if [[ "$(basename "$rel_no_ext")" == "README" ]]; then
        out_dir="$OUT_DIR/$(dirname "$rel_no_ext")"
    else
        out_dir="$OUT_DIR/$rel_no_ext"
    fi

    mkdir -p "$out_dir"

    title="$(grep -m1 '^# ' "$src" | sed 's/^# //')"
    [[ -z "$title" ]] && title="$rel_no_ext"

    {
        echo "<!doctype html>"
        echo "<html>"
        echo "<head>"
        echo "  <meta charset=\"utf-8\">"
        echo "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
        echo "  <title>$title</title>"
        echo "</head>"
        echo "<body>"
        echo "  <main>"
        echo "  <p><a href=\"/\">Home</a></p>"
        sed \
          -e 's/^# \(.*\)$/<h1>\1<\/h1>/' \
          -e 's/^## \(.*\)$/<h2>\1<\/h2>/' \
          -e 's/^### \(.*\)$/<h3>\1<\/h3>/' \
          -e 's/^$/<br>/' \
          "$src"
        echo "  </main>"
        echo "</body>"
        echo "</html>"
    } > "$out_dir/index.html"

    echo "Generated: $out_dir/index.html"
done

echo
echo "Website build complete: $OUT_DIR"
