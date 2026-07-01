#!/bin/bash
# Surf-Simple - Minimal lynx-only browser entity (Approach 1 seed)
# For quick docs lookups with minimal overhead

set -euo pipefail

SURF_SIMPLE_DIR="${HOME}/.surf-simple"
HISTORY_FILE="${SURF_SIMPLE_DIR}/history.log"

# Initialize
mkdir -p "$SURF_SIMPLE_DIR"
touch "$HISTORY_FILE"

# Simple logging
log_visit() {
    echo "$(date -Iseconds)|$1" >> "$HISTORY_FILE"
}

# Main
case "${1:-help}" in
    -h|--help|help)
        cat <<EOF
Surf-Simple - Minimal Lynx Browser

Usage:
  surf-simple <URL>         Browse with lynx
  surf-simple -r            Show recent history

Example:
  surf-simple https://docs.python.org
EOF
        ;;
    -r|recent)
        if [[ -s "$HISTORY_FILE" ]]; then
            echo "Recent:"
            tail -n 10 "$HISTORY_FILE" | tac | while IFS='|' read -r ts url; do
                echo "  → $url"
            done
        else
            echo "No history yet."
        fi
        ;;
    *)
        url="$1"
        echo "Opening with lynx: $url"
        lynx -accept_all_cookies "$url"
        log_visit "$url"
        ;;
esac
