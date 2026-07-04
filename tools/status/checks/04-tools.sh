section "Abbey Tools"

for tool in abbey abbey-doctor abbey-journal abbey-ai abbey-status abbey-knowledge; do
  if [[ -x "$ABBEY_ROOT/tools/bin/$tool" ]]; then
    ok "$tool exists"
  else
    warn "$tool missing or not executable"
  fi
done
