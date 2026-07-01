#!/bin/bash
# Spirit Module - Exploration, discovery, bookmarks
# Part of Surf Terminal Navigator Entity (Create/17 helix)

set -euo pipefail

SURF_DIR="${HOME}/.surf"
BOOKMARKS_FILE="${SURF_DIR}/bookmarks.txt"
COMMENTS_FILE="${SURF_DIR}/comments.db"
HISTORY_FILE="${SURF_DIR}/history.log"

# Source session manager for shared functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/session_manager.sh"

# Colors (same pattern as master_ui.sh)
if [[ -t 1 ]] && command -v tput &>/dev/null; then
    BOLD=$(tput bold 2>/dev/null || echo "")
    NORMAL=$(tput sgr0 2>/dev/null || echo "")
    CYAN=$(tput setaf 6 2>/dev/null || echo "")
    YELLOW=$(tput setaf 3 2>/dev/null || echo "")
else
    BOLD=""
    NORMAL=""
    CYAN=""
    YELLOW=""
fi

# Spirit mode interactive menu
spirit_menu() {
    clear
    echo "${BOLD}${CYAN}"
    echo "╭──────────── SURF - Spirit Mode (Exploration) ────────────╮"
    echo "${NORMAL}"
    echo ""
    echo "  ${BOLD}Bookmarks${NORMAL}"
    echo "    b) List all bookmarks"
    echo "    s) Search bookmarks"
    echo ""
    echo "  ${BOLD}Comments${NORMAL}"
    echo "    c) View all comments"
    echo "    f) Find comments by keyword"
    echo ""
    echo "  ${BOLD}Discovery${NORMAL}"
    echo "    h) Browse history"
    echo "    r) Related URLs (based on tags)"
    echo ""
    echo "  ${BOLD}Export/Import${NORMAL}"
    echo "    e) Export session data"
    echo "    i) Import session data"
    echo ""
    echo "  q) Quit to surf menu"
    echo ""
    echo "${CYAN}╰───────────────────────────────────────────────────────────╯${NORMAL}"
    echo ""
    read -n 1 -s -r -p "Select option: " choice
    echo ""
    echo ""

    case "$choice" in
        b) list_bookmarks; pause ;;
        s) read -p "Search bookmarks: " term; list_bookmarks "$term"; pause ;;
        c) show_comments; pause ;;
        f) read -p "Search comments: " term; show_comments "$term"; pause ;;
        h) show_history; pause ;;
        r) show_related; pause ;;
        e) export_session; pause ;;
        i) import_session; pause ;;
        q) return 0 ;;
        *) echo "${YELLOW}Invalid option${NORMAL}"; sleep 1; spirit_menu ;;
    esac

    spirit_menu
}

# show_history - formatted history view
show_history() {
    echo "${BOLD}Browsing History${NORMAL}"
    echo ""

    if [[ ! -s "$HISTORY_FILE" ]]; then
        echo "No history yet."
        return 0
    fi

    tail -n 20 "$HISTORY_FILE" | tac | while IFS='|' read -r timestamp url browser status; do
        local date=$(date -d "$timestamp" +'%Y-%m-%d %H:%M' 2>/dev/null || echo "$timestamp")
        echo "  [$date] $url"
        echo "    Browser: $browser | Status: $status"
        echo ""
    done
}

# show_related - suggest URLs based on common tags
show_related() {
    echo "${BOLD}Related Content (by tags)${NORMAL}"
    echo ""

    # Extract unique tags from comments and bookmarks
    local tags=$(cat "$COMMENTS_FILE" "$BOOKMARKS_FILE" 2>/dev/null | \
        cut -d'|' -f4 | tr ',' '\n' | sort -u | grep -v '^$')

    if [[ -z "$tags" ]]; then
        echo "No tags found. Add tags to comments/bookmarks for discovery."
        return 0
    fi

    echo "Tags in your collection:"
    echo "$tags" | sed 's/^/  - /'
    echo ""

    read -p "Enter tag to explore: " tag

    echo ""
    echo "${BOLD}URLs tagged with '$tag':${NORMAL}"
    echo ""

    # Search comments
    if grep -i "|.*|.*|.*${tag}" "$COMMENTS_FILE" &>/dev/null; then
        echo "  ${BOLD}From Comments:${NORMAL}"
        grep -i "|.*|.*|.*${tag}" "$COMMENTS_FILE" | cut -d'|' -f2 | sed 's/^/    → /'
        echo ""
    fi

    # Search bookmarks
    if grep -i "|.*|.*${tag}" "$BOOKMARKS_FILE" &>/dev/null; then
        echo "  ${BOLD}From Bookmarks:${NORMAL}"
        grep -i "|.*|.*${tag}" "$BOOKMARKS_FILE" | while IFS='|' read -r url title tags; do
            echo "    ★ $title"
            echo "      $url"
        done
    fi
}

# export_session - backup session data
export_session() {
    local export_file="surf-session-$(date +%Y%m%d-%H%M%S).tar.gz"

    echo "Exporting session data to: $export_file"
    tar -czf "$export_file" -C "$HOME" .surf/ 2>/dev/null

    if [[ -f "$export_file" ]]; then
        echo "✓ Session exported to: $(pwd)/$export_file"
        echo "  Size: $(du -h "$export_file" | cut -f1)"
    else
        echo "✗ Export failed"
    fi
}

# import_session - restore session data
import_session() {
    read -p "Enter path to session archive: " archive_path

    if [[ ! -f "$archive_path" ]]; then
        echo "✗ File not found: $archive_path"
        return 1
    fi

    echo "⚠ This will merge with existing session data."
    read -n 1 -s -r -p "Continue? (y/n): " confirm
    echo ""

    if [[ "$confirm" != "y" ]]; then
        echo "Import cancelled."
        return 0
    fi

    tar -xzf "$archive_path" -C "$HOME" 2>/dev/null

    if [[ $? -eq 0 ]]; then
        echo "✓ Session imported successfully"
    else
        echo "✗ Import failed"
    fi
}

# pause helper
pause() {
    echo ""
    read -n 1 -s -r -p "${CYAN}Press any key to continue...${NORMAL}"
    echo ""
}

# Main
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    init_session
    spirit_menu
fi
