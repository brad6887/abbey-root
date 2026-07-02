#!/bin/bash
#
# Abbey Root Tool: <tool-name>
#
# Purpose:
#   TODO: Describe this tool.
#
# Usage:
#   <tool-name>
#
# Exit Codes:
#   0 = success
#   non-zero = failure
#

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
cat <<EOF
<tool-name>

TODO: Describe this tool.

Usage:
    <tool-name>

Exit Codes:
    0 = success
    non-zero = failure

EOF
exit 0
fi

# Tool logic starts here
