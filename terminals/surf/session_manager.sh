#!/bin/bash
# Session Manager - History, comments, bookmarks persistence
# Part of Surf Terminal Navigator Entity

set -euo pipefail

SURF_DIR="${HOME}/.surf"
SESSIONS_DIR="${SURF_DIR}/sessions"
HISTORY_FILE="${SURF_DIR}/history.log"
COMMENTS_FILE="${SURF_DIR}/comments.db"
BOOKMARKS_FILE="${SURF_DIR}/bookmarks.txt"

# init_session - create directories, touch files, chmod 700 on SURF_DIR
init_session() {
    mkdir -p "${SESSIONS_DIR}"
    touch "${HISTORY_FILE}" "${COMMENTS_FILE}" "${BOOKMARKS_FILE}"
    chmod 700 "${SURF_DIR}"
}

# log_visit <url> <browser> <status> - append to history.log as: timestamp|url|browser|status
log_visit() {
    local url="${1:-}"
    local browser="${2:-}"
    local status="${3:-}"

    if [[ -z "${url}" || -z "${browser}" || -z "${status}" ]]; then
        echo "Error: Usage: log_visit <url> <browser> <status>" >&2
        return 1
    fi

    init_session

    local timestamp
    timestamp=$(date -Iseconds)
    echo "${timestamp}|${url}|${browser}|${status}" >> "${HISTORY_FILE}"
}

# add_comment <url> <comment> [tags] - append to comments.db as: timestamp|url|comment|tags
add_comment() {
    local url="${1:-}"
    local comment="${2:-}"
    local tags="${3:-}"

    if [[ -z "${url}" || -z "${comment}" ]]; then
        echo "Error: Usage: add_comment <url> <comment> [tags]" >&2
        return 1
    fi

    init_session

    local timestamp
    timestamp=$(date -Iseconds)
    echo "${timestamp}|${url}|${comment}|${tags}" >> "${COMMENTS_FILE}"
    echo "✓ Comment added to ${url}"
}

# format_comments - helper, reads stdin, formats nicely
format_comments() {
    local line
    while IFS='|' read -r timestamp url comment tags; do
        echo "─────────────────────────────────────────────"
        echo "URL:     ${url}"
        echo "Date:    ${timestamp}"
        echo "Comment: ${comment}"
        if [[ -n "${tags}" ]]; then
            echo "Tags:    ${tags}"
        fi
    done
}

# show_comments [search-term] - display formatted comments, optionally filtered
show_comments() {
    local search="${1:-}"

    if [[ ! -f "${COMMENTS_FILE}" ]]; then
        echo "No comments found."
        return 0
    fi

    if [[ -z "${search}" ]]; then
        cat "${COMMENTS_FILE}" | format_comments
    else
        grep -i "${search}" "${COMMENTS_FILE}" | format_comments
    fi
}

# get_recent [limit] - show last N history entries (default 10)
get_recent() {
    local limit="${1:-10}"

    if [[ ! -f "${HISTORY_FILE}" ]]; then
        echo "No history found."
        return 0
    fi

    echo "Recent browsing history (last ${limit}):"
    echo "─────────────────────────────────────────────"

    tail -n "${limit}" "${HISTORY_FILE}" | while IFS='|' read -r timestamp url browser status; do
        echo "$(date -d "${timestamp}" '+%Y-%m-%d %H:%M:%S') | ${browser:0:8} | ${status} | ${url}"
    done
}

# add_bookmark <url> <title> [tags] - append to bookmarks.txt as: url|title|tags (skip if exists)
add_bookmark() {
    local url="${1:-}"
    local title="${2:-}"
    local tags="${3:-}"

    if [[ -z "${url}" || -z "${title}" ]]; then
        echo "Error: Usage: add_bookmark <url> <title> [tags]" >&2
        return 1
    fi

    init_session

    # Check if bookmark already exists
    if grep -qF "${url}|" "${BOOKMARKS_FILE}" 2>/dev/null; then
        echo "⚠ Bookmark already exists for: ${url}"
        return 0
    fi

    echo "${url}|${title}|${tags}" >> "${BOOKMARKS_FILE}"
    echo "✓ Bookmarked: ${title}"
}

# format_bookmarks - helper, reads stdin, formats nicely
format_bookmarks() {
    local line
    while IFS='|' read -r url title tags; do
        echo "─────────────────────────────────────────────"
        echo "Title: ${title}"
        echo "URL:   ${url}"
        if [[ -n "${tags}" ]]; then
            echo "Tags:  ${tags}"
        fi
    done
}

# list_bookmarks [search] - display formatted bookmarks, optionally filtered
list_bookmarks() {
    local search="${1:-}"

    if [[ ! -f "${BOOKMARKS_FILE}" ]]; then
        echo "No bookmarks found."
        return 0
    fi

    if [[ -z "${search}" ]]; then
        cat "${BOOKMARKS_FILE}" | format_bookmarks
    else
        grep -i "${search}" "${BOOKMARKS_FILE}" | format_bookmarks
    fi
}

# Main block for direct testing with subcommands
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-}" in
        log)
            shift
            log_visit "$@"
            ;;
        comment)
            shift
            add_comment "$@"
            ;;
        comments)
            shift
            show_comments "$@"
            ;;
        recent)
            shift
            get_recent "$@"
            ;;
        bookmark)
            shift
            add_bookmark "$@"
            ;;
        bookmarks)
            shift
            list_bookmarks "$@"
            ;;
        *)
            echo "Usage: $0 {log|comment|comments|recent|bookmark|bookmarks} [args...]"
            echo ""
            echo "Commands:"
            echo "  log <url> <browser> <status>     - Log a visit"
            echo "  comment <url> <text> [tags]      - Add a comment"
            echo "  comments [search]                - Show comments"
            echo "  recent [limit]                   - Show recent history"
            echo "  bookmark <url> <title> [tags]    - Add bookmark"
            echo "  bookmarks [search]               - List bookmarks"
            exit 1
            ;;
    esac
fi
