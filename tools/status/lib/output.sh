section() {
  echo
  echo "$1"
  printf '%*s\n' "${#1}" '' | tr ' ' '-'
}

ok() {
  echo "OK   $*"
}

warn() {
  echo "WARN $*"
}

info() {
  echo "INFO $*"
}
