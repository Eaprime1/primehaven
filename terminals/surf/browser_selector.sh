#!/bin/bash
# Browser Selector - Smart browser choice based on URL pattern
# Part of Surf Terminal Navigator Entity

set -euo pipefail

# select_browser <url> [--force-browser]
# Returns: browser name (lynx|w3m|browsh)
select_browser() {
    local url="$1"
    local force_browser="${2:-}"

    # Override: force specific browser
    case "$force_browser" in
        --lynx) echo "lynx"; return 0 ;;
        --w3m) echo "w3m"; return 0 ;;
        --browsh) echo "browsh"; return 0 ;;
    esac

    # Smart selection based on URL pattern
    # Note: browsh requires Firefox headless - use --browsh flag when needed
    case "$url" in
        *oauth*|*login*|*auth*)
            # JS-heavy auth flows - browsh if available, but may fail in TTY
            echo "browsh" ;;
        *github.com*)
            # GitHub works well in w3m for reading code/repos
            echo "w3m" ;;
        */docs/*|*docs.*|*.readthedocs.io*|*readthedocs*)
            echo "lynx" ;;
        *stackoverflow.com*)
            echo "w3m" ;;
        *.md|*.txt|file://*)
            echo "lynx" ;;
        *)
            echo "w3m" ;;
    esac
}

# verify_browser <browser-name>
# Returns: 0 if available, 1 if not
verify_browser() {
    local browser="$1"
    command -v "$browser" &>/dev/null
}

# fallback_browser <preferred>
# Returns: available browser, preferring w3m > lynx > browsh
fallback_browser() {
    local preferred="$1"

    if verify_browser "$preferred"; then
        echo "$preferred"
        return 0
    fi

    # Fallback chain
    for browser in w3m lynx browsh; do
        if verify_browser "$browser"; then
            echo "⚠ $preferred not available, using $browser" >&2
            echo "$browser"
            return 0
        fi
    done

    echo "ERROR: No browsers available (lynx, w3m, browsh)" >&2
    return 1
}

# Main execution (if run directly for testing)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0 <url> [--lynx|--w3m|--browsh]"
        exit 1
    fi

    browser=$(select_browser "$@")
    final_browser=$(fallback_browser "$browser")
    echo "$final_browser"
fi
