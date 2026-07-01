# Surf Browser Navigator Entity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a terminal browser navigator entity with smart browser selection (lynx/w3m/browsh), session persistence, comments, and GitHub integration

**Architecture:** Entity wrapper pattern with four modules: main wrapper (Physical helix), browser selector, session manager (Mental helix), and spirit module (exploration). All scripts in bash, session data in ~/.surf/ (git-ignored).

**Tech Stack:** Bash 4.0+, lynx, w3m, browsh, coreutils

---

## File Structure Map

**New Files to Create:**
```
terminals/surf/
├── entity_wrapper.sh          # Main entry (arg parsing, helix routing)
├── browser_selector.sh        # URL pattern matching → browser choice
├── session_manager.sh         # History, comments, persistence
├── spirit.sh                  # Bookmarks, discovery, exploration
└── config/
    ├── lynx.cfg              # Cookie persistence config
    ├── w3m_config            # Cookie + table rendering
    └── browsh_config.toml    # Headless Firefox settings

terminals/entities/
├── surf-simple/
│   └── entity_wrapper.sh     # Seed: lynx-only minimal browser
└── surf-unified/
    └── entity_wrapper.sh     # Seed: web + project navigator placeholder

~/.eric/context/contributors/
└── surf.md                   # Entity briefing
```

**Files to Modify:**
```
tools/master_ui.sh:~200       # Add "W) Web Navigator" menu option
.gitignore                    # Add ~/.surf/ ignore rule
~/.bashrc                     # Add surf alias (manual step, documented)
```

**Session Data (git-ignored, runtime-created):**
```
~/.surf/
├── sessions/
│   ├── github-session        # GitHub cookies
│   └── default-session       # General cookies
├── history.log               # timestamp|url|browser|status
├── comments.db               # timestamp|url|comment|tags
├── bookmarks.txt             # url|title|tags
└── github-token              # GitHub PAT (chmod 600)
```

---

## Task 1: Project Setup & Directory Structure

**Files:**
- Create: `terminals/surf/` (directory)
- Create: `terminals/surf/config/` (directory)
- Create: `terminals/entities/surf-simple/` (directory)
- Create: `terminals/entities/surf-unified/` (directory)
- Modify: `.gitignore`

- [ ] **Step 1: Create surf directory structure**

```bash
cd "$HOME/primehaven"
mkdir -p terminals/surf/config
mkdir -p terminals/entities/surf-simple
mkdir -p terminals/entities/surf-unified
```

- [ ] **Step 2: Add .surf/ to .gitignore**

Append to `.gitignore`:
```
# Surf browser session data
.surf/
```

- [ ] **Step 3: Verify directories created**

Run: `ls -la terminals/surf/ terminals/entities/`
Expected: Directories exist with correct structure

- [ ] **Step 4: Commit setup**

```bash
git add .gitignore terminals/
git commit -m "chore: create surf browser entity directory structure

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 2: Browser Selector Module

**Files:**
- Create: `terminals/surf/browser_selector.sh`

- [ ] **Step 1: Create browser selector with URL pattern matching**

Create `terminals/surf/browser_selector.sh`:
```bash
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
    case "$url" in
        *github.com*|*oauth*|*login*|*auth*)
            echo "browsh" ;;
        docs.*|*.readthedocs.io*)
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
    local browser

    if verify_browser "$preferred"; then
        echo "$preferred"
        return 0
    fi

    # Fallback chain
    for browser in w3m lynx browsh; do
        if verify_browser "$browser"; then
            echo "$browser" >&2
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
```

- [ ] **Step 2: Make executable and test**

```bash
chmod +x terminals/surf/browser_selector.sh
```

Run: `terminals/surf/browser_selector.sh "https://github.com/eaprime1"`
Expected: `browsh`

Run: `terminals/surf/browser_selector.sh "https://docs.python.org"`
Expected: `lynx`

Run: `terminals/surf/browser_selector.sh "https://stackoverflow.com/questions"`
Expected: `w3m`

Run: `terminals/surf/browser_selector.sh "https://example.com"`
Expected: `w3m` (default)

Run: `terminals/surf/browser_selector.sh "https://github.com" --lynx`
Expected: `lynx` (override)

- [ ] **Step 3: Commit browser selector**

```bash
git add terminals/surf/browser_selector.sh
git commit -m "feat: add smart browser selector for surf

URL pattern matching:
- github/auth/oauth → browsh
- docs/readthedocs → lynx
- stackoverflow → w3m
- default → w3m

Includes fallback and override flags.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 3: Session Manager Module

**Files:**
- Create: `terminals/surf/session_manager.sh`

- [ ] **Step 1: Create session manager with history and comments**

Create `terminals/surf/session_manager.sh`:
```bash
#!/bin/bash
# Session Manager - History, comments, bookmarks persistence
# Part of Surf Terminal Navigator Entity

set -euo pipefail

SURF_DIR="${HOME}/.surf"
SESSIONS_DIR="${SURF_DIR}/sessions"
HISTORY_FILE="${SURF_DIR}/history.log"
COMMENTS_FILE="${SURF_DIR}/comments.db"
BOOKMARKS_FILE="${SURF_DIR}/bookmarks.txt"

# Initialize session directories
init_session() {
    mkdir -p "$SURF_DIR" "$SESSIONS_DIR"
    touch "$HISTORY_FILE" "$COMMENTS_FILE" "$BOOKMARKS_FILE"
    chmod 700 "$SURF_DIR"
}

# log_visit <url> <browser> <status>
log_visit() {
    local url="$1"
    local browser="$2"
    local status="${3:-success}"
    local timestamp=$(date -Iseconds)

    echo "${timestamp}|${url}|${browser}|${status}" >> "$HISTORY_FILE"
}

# add_comment <url> <comment> [tags]
add_comment() {
    local url="$1"
    local comment="$2"
    local tags="${3:-}"
    local timestamp=$(date -Iseconds)

    echo "${timestamp}|${url}|${comment}|${tags}" >> "$COMMENTS_FILE"
    echo "✓ Comment added to $url"
}

# show_comments [search-term]
show_comments() {
    local search="${1:-}"

    if [[ ! -s "$COMMENTS_FILE" ]]; then
        echo "No comments yet. Press 'c' while browsing to add comments."
        return 0
    fi

    if [[ -n "$search" ]]; then
        grep -i "$search" "$COMMENTS_FILE" | format_comments
    else
        format_comments < "$COMMENTS_FILE"
    fi
}

# format_comments (reads from stdin)
format_comments() {
    while IFS='|' read -r timestamp url comment tags; do
        local time_ago=$(date -d "$timestamp" +'%Y-%m-%d %H:%M' 2>/dev/null || echo "$timestamp")
        echo ""
        echo "  $url"
        echo "    \"$comment\" - $time_ago"
        [[ -n "$tags" ]] && echo "    Tags: $tags"
    done
}

# get_recent [limit]
get_recent() {
    local limit="${1:-10}"

    if [[ ! -s "$HISTORY_FILE" ]]; then
        echo "No browsing history yet."
        return 0
    fi

    tail -n "$limit" "$HISTORY_FILE" | tac | while IFS='|' read -r timestamp url browser status; do
        local time_ago=$(date -d "$timestamp" +'%H:%M' 2>/dev/null || echo "recent")
        echo "  → $url [$time_ago]"
    done
}

# add_bookmark <url> <title> [tags]
add_bookmark() {
    local url="$1"
    local title="$2"
    local tags="${3:-}"

    # Check if already bookmarked
    if grep -q "^${url}|" "$BOOKMARKS_FILE" 2>/dev/null; then
        echo "Already bookmarked: $url"
        return 0
    fi

    echo "${url}|${title}|${tags}" >> "$BOOKMARKS_FILE"
    echo "✓ Bookmarked: $title"
}

# list_bookmarks [search]
list_bookmarks() {
    local search="${1:-}"

    if [[ ! -s "$BOOKMARKS_FILE" ]]; then
        echo "No bookmarks yet. Press 'b' while browsing to add bookmarks."
        return 0
    fi

    if [[ -n "$search" ]]; then
        grep -i "$search" "$BOOKMARKS_FILE" | format_bookmarks
    else
        format_bookmarks < "$BOOKMARKS_FILE"
    fi
}

# format_bookmarks (reads from stdin)
format_bookmarks() {
    while IFS='|' read -r url title tags; do
        echo "  ★ $title"
        echo "    $url"
        [[ -n "$tags" ]] && echo "    Tags: $tags"
        echo ""
    done
}

# Main (if run directly for testing)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    init_session

    case "${1:-help}" in
        log) log_visit "$2" "$3" "${4:-success}" ;;
        comment) add_comment "$2" "$3" "${4:-}" ;;
        comments) show_comments "${2:-}" ;;
        recent) get_recent "${2:-10}" ;;
        bookmark) add_bookmark "$2" "$3" "${4:-}" ;;
        bookmarks) list_bookmarks "${2:-}" ;;
        *)
            echo "Usage: $0 {log|comment|comments|recent|bookmark|bookmarks} [args]"
            echo "Examples:"
            echo "  $0 log 'https://example.com' w3m success"
            echo "  $0 comment 'https://example.com' 'Useful resource' 'reference'"
            echo "  $0 comments"
            echo "  $0 recent 5"
            echo "  $0 bookmark 'https://example.com' 'Example Site' 'demo'"
            echo "  $0 bookmarks"
            ;;
    esac
fi
```

- [ ] **Step 2: Make executable and test**

```bash
chmod +x terminals/surf/session_manager.sh
```

Run: `terminals/surf/session_manager.sh log "https://github.com/eaprime1" browsh success`
Expected: Entry added to ~/.surf/history.log

Run: `terminals/surf/session_manager.sh comment "https://github.com/eaprime1" "Check PR status" github,todo`
Expected: `✓ Comment added to https://github.com/eaprime1`

Run: `terminals/surf/session_manager.sh comments`
Expected: Shows formatted comment

Run: `terminals/surf/session_manager.sh bookmark "https://docs.python.org/3/" "Python Docs" python,reference`
Expected: `✓ Bookmarked: Python Docs`

Run: `terminals/surf/session_manager.sh recent 5`
Expected: Shows recent visit

- [ ] **Step 3: Verify file permissions**

Run: `ls -la ~/.surf/`
Expected: drwx------ (700 permissions)

- [ ] **Step 4: Commit session manager**

```bash
git add terminals/surf/session_manager.sh
git commit -m "feat: add session manager for surf

History tracking, comments, and bookmarks:
- log_visit: Records all URLs with timestamp
- add_comment: Annotate URLs with notes and tags
- show_comments: View/search comment history
- add_bookmark: Save frequently visited URLs
- get_recent: Show recent browsing history

Session data stored in ~/.surf/ (git-ignored).

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 4: Spirit Module (Exploration & Discovery)

**Files:**
- Create: `terminals/surf/spirit.sh`

- [ ] **Step 1: Create spirit module with bookmark management**

Create `terminals/surf/spirit.sh`:
```bash
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

    if tar -xzf "$archive_path" -C "$HOME" 2>/dev/null; then
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
```

- [ ] **Step 2: Make executable and test**

```bash
chmod +x terminals/surf/spirit.sh
```

Run: `terminals/surf/spirit.sh` (then press 'q' to quit)
Expected: Interactive spirit menu displays

- [ ] **Step 3: Commit spirit module**

```bash
git add terminals/surf/spirit.sh
git commit -m "feat: add spirit module for surf exploration

Spirit helix (Create/17):
- Interactive menu for bookmarks/comments/history
- Tag-based discovery (related content)
- Session export/import for sharing
- Formatted views for exploration

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 5: Main Entity Wrapper (Physical Helix)

**Files:**
- Create: `terminals/surf/entity_wrapper.sh`

- [ ] **Step 1: Create main entity wrapper with arg parsing**

Create `terminals/surf/entity_wrapper.sh`:
```bash
#!/bin/bash
# Surf - Terminal Browser Navigator Entity
# Commands stay pure. Entities add Nessing. ∰◊€π¿🌌∞
# Physical Helix (Work/15): Browse web with smart browser selection
# Mental Helix (Play/16): History, comments, documentation
# Spirit Helix (Create/17): Discovery, bookmarks, exploration

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/browser_selector.sh"
source "${SCRIPT_DIR}/session_manager.sh"

# Colors
if [[ -t 1 ]] && command -v tput &>/dev/null; then
    BOLD=$(tput bold 2>/dev/null || echo "")
    NORMAL=$(tput sgr0 2>/dev/null || echo "")
    CYAN=$(tput setaf 6 2>/dev/null || echo "")
    GREEN=$(tput setaf 2 2>/dev/null || echo "")
    YELLOW=$(tput setaf 3 2>/dev/null || echo "")
    RED=$(tput setaf 1 2>/dev/null || echo "")
else
    BOLD=""
    NORMAL=""
    CYAN=""
    GREEN=""
    YELLOW=""
    RED=""
fi

# Box drawing
BOX_TL="╭"
BOX_TR="╮"
BOX_BL="╰"
BOX_BR="╯"
BOX_H="─"

# Initialize
init_session

# show_help - usage information
show_help() {
    cat <<EOF
${BOLD}${CYAN}Surf - Terminal Browser Navigator Entity${NORMAL}

${BOLD}Usage:${NORMAL}
  surf                      Interactive mode (menu)
  surf <URL>                Browse URL with smart browser selection
  surf <shortcut>           Quick access (github, docs, stackoverflow)
  surf -c                   View comments/history (Mental helix)
  surf -s                   Spirit mode (exploration/bookmarks)
  surf -h, --help           Show this help

${BOLD}Browser Override:${NORMAL}
  surf --lynx <URL>         Force lynx browser
  surf --w3m <URL>          Force w3m browser
  surf --browsh <URL>       Force browsh browser

${BOLD}Quick Shortcuts:${NORMAL}
  surf github               https://github.com/eaprime1
  surf github primehaven    https://github.com/eaprime1/primehaven
  surf docs python          https://docs.python.org/3/
  surf so <query>           Search Stack Overflow

${BOLD}While Browsing:${NORMAL}
  c - Add comment to current URL (after exiting browser)
  b - Bookmark current URL (after exiting browser)
  q - Quit browser

${BOLD}Examples:${NORMAL}
  surf https://github.com/eaprime1
  surf github
  surf --lynx https://docs.python.org
  surf -c
  surf -s
EOF
}

# interactive_menu - main UI
interactive_menu() {
    clear
    echo "${BOLD}${CYAN}"
    echo "${BOX_TL}$(printf '%*s' 58 | tr ' ' "$BOX_H") SURF - Terminal Navigator $(printf '%*s' 58 | tr ' ' "$BOX_H")${BOX_TR}"
    echo "${NORMAL}"
    echo ""
    echo "  ${BOLD}Quick Access:${NORMAL}"
    echo "    g) GitHub (eaprime1)         d) Python Docs"
    echo "    p) This Repo (primehaven)    s) Stack Overflow"
    echo "    c) Comments/History          h) Help/Shortcuts"
    echo ""
    echo "  ${BOLD}Recent:${NORMAL}"
    get_recent 5
    echo ""
    echo "${CYAN}${BOX_BL}$(printf '%*s' 128 | tr ' ' "$BOX_H")${BOX_BR}${NORMAL}"
    echo ""
    read -p "Enter URL or selection: " input

    case "$input" in
        g) browse_url "https://github.com/eaprime1" ;;
        p) browse_url "https://github.com/eaprime1/primehaven" ;;
        d) browse_url "https://docs.python.org/3/" ;;
        s) browse_url "https://stackoverflow.com" ;;
        c) show_comments; read -n 1 -s -r -p "Press any key..."; interactive_menu ;;
        h) show_help; read -n 1 -s -r -p "Press any key..."; interactive_menu ;;
        q) exit 0 ;;
        "") interactive_menu ;;
        *) browse_url "$input" ;;
    esac

    # After browsing, offer comment/bookmark
    offer_annotation "$input"
    interactive_menu
}

# browse_url <url> [browser-override]
browse_url() {
    local url="$1"
    local override="${2:-}"

    # Expand shortcuts
    case "$url" in
        github) url="https://github.com/eaprime1" ;;
        github\ *)
            local repo="${url#github }"
            url="https://github.com/eaprime1/${repo}"
            ;;
        docs\ python) url="https://docs.python.org/3/" ;;
        so\ *)
            local query="${url#so }"
            url="https://stackoverflow.com/search?q=${query// /+}"
            ;;
    esac

    # Select browser
    local browser=$(select_browser "$url" "$override")
    browser=$(fallback_browser "$browser")

    echo ""
    echo "${GREEN}→${NORMAL} Opening: $url"
    echo "${GREEN}→${NORMAL} Browser: $browser"
    echo ""

    # Launch browser
    local exit_code=0
    case "$browser" in
        lynx) lynx -accept_all_cookies "$url" || exit_code=$? ;;
        w3m) w3m "$url" || exit_code=$? ;;
        browsh) browsh --startup-url "$url" || exit_code=$? ;;
    esac

    # Log visit
    if [[ $exit_code -eq 0 ]]; then
        log_visit "$url" "$browser" "success"
    else
        log_visit "$url" "$browser" "error:$exit_code"
        echo "${RED}✗${NORMAL} Browser exited with error: $exit_code"
    fi
}

# offer_annotation <url>
offer_annotation() {
    local url="$1"

    echo ""
    read -n 1 -s -r -p "${CYAN}Add comment/bookmark? (c=comment, b=bookmark, Enter=skip):${NORMAL} " choice
    echo ""

    case "$choice" in
        c)
            read -p "Comment: " comment
            read -p "Tags (comma-separated): " tags
            add_comment "$url" "$comment" "$tags"
            ;;
        b)
            read -p "Title: " title
            read -p "Tags (comma-separated): " tags
            add_bookmark "$url" "$title" "$tags"
            ;;
    esac
}

# Main
case "${1:-interactive}" in
    -h|--help|help)
        show_help
        ;;
    -c|c|comments)
        show_comments "${2:-}"
        ;;
    -s|s|spirit)
        "${SCRIPT_DIR}/spirit.sh"
        ;;
    --lynx|--w3m|--browsh)
        browse_url "${2:-}" "$1"
        offer_annotation "${2:-}"
        ;;
    interactive)
        interactive_menu
        ;;
    *)
        browse_url "$1"
        offer_annotation "$1"
        ;;
esac
```

- [ ] **Step 2: Make executable and test interactive mode**

```bash
chmod +x terminals/surf/entity_wrapper.sh
```

Run: `terminals/surf/entity_wrapper.sh` (then press 'q' to quit)
Expected: Interactive menu displays with quick access options

- [ ] **Step 3: Test direct URL browsing**

Run: `terminals/surf/entity_wrapper.sh https://example.com`
Expected: Opens w3m with example.com, prompts for comment/bookmark after

- [ ] **Step 4: Test shortcuts**

Run: `terminals/surf/entity_wrapper.sh github`
Expected: Opens browsh with github.com/eaprime1

- [ ] **Step 5: Test browser override**

Run: `terminals/surf/entity_wrapper.sh --lynx https://github.com`
Expected: Opens lynx (not browsh)

- [ ] **Step 6: Commit entity wrapper**

```bash
git add terminals/surf/entity_wrapper.sh
git commit -m "feat: add main entity wrapper for surf (Physical helix)

Physical helix (Work/15):
- Interactive menu with quick access shortcuts
- Direct URL browsing with smart browser selection
- Browser override flags (--lynx, --w3m, --browsh)
- Comment/bookmark prompts after browsing
- Shortcut expansion (github, docs, so)

Integration with browser_selector and session_manager.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 6: Browser Configuration Files

**Files:**
- Create: `terminals/surf/config/lynx.cfg`
- Create: `terminals/surf/config/w3m_config`
- Create: `terminals/surf/config/browsh_config.toml`

- [ ] **Step 1: Create lynx configuration**

Create `terminals/surf/config/lynx.cfg`:
```
# Lynx configuration for Surf browser entity
# Cookie persistence for auth flows

ACCEPT_ALL_COOKIES:TRUE
PERSISTENT_COOKIES:TRUE
COOKIE_FILE:~/.surf/sessions/cookies.txt
COOKIE_SAVE_FILE:~/.surf/sessions/cookies.txt

# VI-style navigation
VI_KEYS_ALWAYS_ON:TRUE

# Character set
CHARACTER_SET:utf-8
ASSUME_CHARSET:utf-8

# Display
COLOR:4
SHOW_CURSOR:TRUE
UNDERLINE_LINKS:FALSE
```

- [ ] **Step 2: Create w3m configuration**

Create `terminals/surf/config/w3m_config`:
```
# W3m configuration for Surf browser entity

# Cookies
accept_cookie 1
use_cookie 1
cookie_file ~/.surf/sessions/w3m-cookies
cookie_avoid_wrong_number_of_dots

# Display
tabstop 4
indent_incr 4
pixel_per_char 8
pixel_per_line 16
display_charset UTF-8
document_charset UTF-8

# Behavior
confirm_qq 0
auto_uncompress 1
decode_url 0
display_link_number 1
```

- [ ] **Step 3: Create browsh configuration**

Create `terminals/surf/config/browsh_config.toml`:
```toml
# Browsh configuration for Surf browser entity

[firefox]
path = "/usr/bin/firefox"
use-existing = false
with-gui = false

[http-server]
bind = "127.0.0.1"
port = 4333

[tty]
small-window-width = 40
```

- [ ] **Step 4: Document configuration usage**

Create `terminals/surf/config/README.md`:
```markdown
# Surf Browser Configuration

Browser-specific configurations for optimal terminal browsing.

## Setup (Manual)

These configs need to be symlinked or copied to browser config locations:

### Lynx
```bash
cat terminals/surf/config/lynx.cfg >> ~/.lynxrc
```

### W3m
```bash
cat terminals/surf/config/w3m_config >> ~/.w3m/config
```

### Browsh
```bash
mkdir -p ~/.config/browsh
cp terminals/surf/config/browsh_config.toml ~/.config/browsh/config.toml
```

## Cookie Files

All browsers store cookies in `~/.surf/sessions/` for persistence.

## Notes

- Lynx: VI keys enabled, all cookies accepted
- W3m: Link numbers displayed, UTF-8 charset
- Browsh: Headless Firefox on port 4333
```

- [ ] **Step 5: Commit configurations**

```bash
git add terminals/surf/config/
git commit -m "feat: add browser configurations for surf

Browser configs:
- lynx: Cookie persistence, VI keys, UTF-8
- w3m: Cookie support, link numbers, UTF-8
- browsh: Headless Firefox, localhost:4333

Includes setup README for manual installation.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 7: Seed Entities (Future Expansion)

**Files:**
- Create: `terminals/entities/surf-simple/entity_wrapper.sh`
- Create: `terminals/entities/surf-unified/entity_wrapper.sh`

- [ ] **Step 1: Create surf-simple seed (Approach 1)**

Create `terminals/entities/surf-simple/entity_wrapper.sh`:
```bash
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
```

- [ ] **Step 2: Create surf-unified seed (Approach 3)**

Create `terminals/entities/surf-unified/entity_wrapper.sh`:
```bash
#!/bin/bash
# Surf-Unified - Web + Project Navigator (Approach 3 seed)
# Placeholder for future development

set -euo pipefail

cat <<EOF
╭──────────── Surf-Unified Navigator ────────────╮
│                                                 │
│  This is a placeholder for Approach 3:         │
│  Unified navigation for web AND project files  │
│                                                 │
│  Planned features:                              │
│    - Web browsing (using surf's browser logic) │
│    - Project file navigation (file browser)    │
│    - Unified comments (web + files)            │
│    - Cross-search (history + local files)      │
│                                                 │
│  Status: Seed entity for future expansion      │
│                                                 │
╰─────────────────────────────────────────────────╯

To build this:
  1. Copy terminals/surf/ as foundation
  2. Add file browser module (ls, find, grep)
  3. Integrate with germ for project awareness
  4. Unified comment system across web + files

See design spec: docs/superpowers/specs/2026-03-26-surf-browser-entity-design.md
EOF
```

- [ ] **Step 3: Make seed entities executable**

```bash
chmod +x terminals/entities/surf-simple/entity_wrapper.sh
chmod +x terminals/entities/surf-unified/entity_wrapper.sh
```

- [ ] **Step 4: Test surf-simple**

Run: `terminals/entities/surf-simple/entity_wrapper.sh --help`
Expected: Shows help for minimal lynx browser

- [ ] **Step 5: Test surf-unified placeholder**

Run: `terminals/entities/surf-unified/entity_wrapper.sh`
Expected: Shows placeholder message with future roadmap

- [ ] **Step 6: Commit seed entities**

```bash
git add terminals/entities/
git commit -m "feat: add seed entities for surf expansion

Seed entities for future development:

surf-simple (Approach 1):
- Minimal lynx-only browser
- Basic history tracking
- No comments or smart selection
- For quick docs lookups

surf-unified (Approach 3):
- Placeholder for web + project navigation
- Roadmap documented in placeholder
- Foundation for unified navigator

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 8: Entity Briefing & Documentation

**Files:**
- Create: `~/.eric/context/contributors/surf.md`
- Create: `terminals/surf/README.md`

- [ ] **Step 1: Create entity briefing**

Create `~/.eric/context/contributors/surf.md`:
```markdown
# Surf - Terminal Browser Navigator Entity

**Entity Type**: Software Tool
**Created**: 2026-03-26
**Location**: `/home/sauron/primehaven/terminals/surf/`

## Role

Terminal web browser with intelligent browser selection, session persistence, and discovery features.

## Capabilities

- **Smart Browser Selection**: Automatically chooses lynx/w3m/browsh based on URL pattern
  - GitHub/auth → browsh (handles complex UI)
  - Docs/readthedocs → lynx (fast reading)
  - Stack Overflow → w3m (code formatting)
  - Default → w3m

- **Session Persistence**: All browsing tracked in `~/.surf/`
  - History log with timestamps
  - Comments on URLs with tags
  - Bookmarks for quick access
  - Session export/import

- **GitHub Integration**: Quick shortcuts for eaprime1 repos
  - `surf github` → github.com/eaprime1
  - `surf github primehaven` → this repo
  - Token-based auth (planned, not yet implemented)

- **Three Helix Structure** (PrimeHaven entity pattern):
  - Physical (Work/15): Browse web with smart selection
  - Mental (Play/16): View history, comments, help
  - Spirit (Create/17): Explore bookmarks, discover related content

## Personality

Efficient navigator. Remembers context. Suggests related content based on tags. Doesn't overwhelm with options—shows recent history and quick shortcuts.

## Communication Style

- Status bar updates while browsing
- Prompts for comments/bookmarks after visits
- Shortcut hints in menus
- Color-coded UI (cyan headers, green success, yellow warnings)

## Usage Patterns

```bash
surf                      # Interactive menu
surf https://example.com  # Direct browsing
surf github               # Quick shortcut
surf -c                   # View comments
surf -s                   # Spirit mode (exploration)
```

## Integration

- **master_ui.sh**: Menu option "W) Web Navigator"
- **~/.bashrc**: `alias surf='...'` (manual setup)
- **Session data**: `~/.surf/` (git-ignored)

## Related Entities

- **surf-simple**: Minimal lynx-only variant (seed entity)
- **surf-unified**: Future web + project navigator (seed entity)

## Notes for AI Contributors

When working with surf:
- Session data is in `~/.surf/`, never in git
- Browser selection logic in `browser_selector.sh`
- Comments use pipe-delimited format: `timestamp|url|comment|tags`
- Entity follows PrimeHaven pattern (see `terminals/hello.sh`)

GitHub token auth is designed but not yet implemented (Task 10 in plan).
```

- [ ] **Step 2: Create surf README**

Create `terminals/surf/README.md`:
```markdown
# Surf - Terminal Browser Navigator Entity

Terminal-based web browser with intelligent browser selection (lynx/w3m/browsh), session persistence, and discovery features.

## Quick Start

```bash
# Alias (add to ~/.bashrc)
alias surf='$HOME/primehaven/terminals/surf/entity_wrapper.sh'

# Interactive mode
surf

# Direct browsing
surf https://github.com/eaprime1

# Quick shortcuts
surf github
surf docs python

# View history/comments
surf -c

# Exploration mode
surf -s
```

## Components

| Module | Purpose |
|--------|---------|
| `entity_wrapper.sh` | Main entry point, interactive menu |
| `browser_selector.sh` | URL pattern → browser mapping |
| `session_manager.sh` | History, comments, bookmarks |
| `spirit.sh` | Discovery, exploration, export/import |
| `config/` | Browser-specific configurations |

## Entity Pattern (Three Helixes)

- **Physical (Work/15)**: Browse web with smart browser selection
- **Mental (Play/16)**: View history, comments, documentation
- **Spirit (Create/17)**: Explore bookmarks, discover related content

## Browser Selection Logic

| URL Pattern | Browser | Reason |
|-------------|---------|--------|
| `*.github.com/*` | browsh | Complex UI, auth flows |
| `*oauth*`, `*login*` | browsh | Interactive auth |
| `docs.*`, `*.readthedocs.io` | lynx | Fast text reading |
| `stackoverflow.com/*` | w3m | Code formatting |
| default | w3m | Good middle ground |

Override with: `surf --lynx URL`, `surf --w3m URL`, `surf --browsh URL`

## Session Data

Stored in `~/.surf/` (git-ignored):

```
~/.surf/
├── sessions/          # Browser cookies
├── history.log        # timestamp|url|browser|status
├── comments.db        # timestamp|url|comment|tags
├── bookmarks.txt      # url|title|tags
└── github-token       # GitHub PAT (planned)
```

## Configuration

See `config/README.md` for browser setup instructions.

## Seed Entities

- **surf-simple**: Minimal lynx-only browser (`terminals/entities/surf-simple/`)
- **surf-unified**: Web + project navigator placeholder (`terminals/entities/surf-unified/`)

## Development

Built using TDD, DRY, YAGNI principles.

See implementation plan: `docs/superpowers/plans/2026-03-26-surf-browser-entity.md`

---

*"Commands stay pure. Entities add Nessing." — PrimeHaven*
```

- [ ] **Step 3: Commit documentation**

```bash
git add ~/.eric/context/contributors/surf.md terminals/surf/README.md
git commit -m "docs: add entity briefing and README for surf

Entity briefing:
- Role, capabilities, personality
- Three helix structure documented
- Usage patterns and integration points
- Notes for AI contributors

Surf README:
- Quick start guide
- Component overview
- Browser selection logic
- Session data structure

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 9: master_ui.sh Integration

**Files:**
- Modify: `tools/master_ui.sh:~200`

- [ ] **Step 1: Find menu section in master_ui.sh**

Run: `grep -n "draw_main_menu\|main menu" tools/master_ui.sh | head -5`
Expected: Line numbers for menu function

- [ ] **Step 2: Add surf menu option to master_ui.sh**

Find the menu options section (around line 200-300) and add:

```bash
        W|w)
            clear_screen
            draw_box_header "WEB NAVIGATOR - SURF" 80
            echo ""
            status_indicator "info" "Launching Surf browser navigator..."
            echo ""

            # Check if surf exists
            if [[ -x "${PRIMEHAVEN_ROOT}/terminals/surf/entity_wrapper.sh" ]]; then
                "${PRIMEHAVEN_ROOT}/terminals/surf/entity_wrapper.sh"
            else
                status_indicator "error" "Surf not found at ${PRIMEHAVEN_ROOT}/terminals/surf/"
                echo ""
                echo "Install surf with: cd ~/primehaven && git pull"
            fi

            pause
            ;;
```

- [ ] **Step 3: Add to menu display**

In the menu display section, add:

```bash
    echo "  ${BOLD}${GREEN}W)${NORMAL} Web Navigator (Surf) - Terminal browser with smart selection"
```

- [ ] **Step 4: Test master_ui.sh menu**

Run: `tools/master_ui.sh`
Expected: Menu shows "W) Web Navigator (Surf)" option

Press 'W', expected: Launches surf interactive mode

- [ ] **Step 5: Commit master_ui.sh integration**

```bash
git add tools/master_ui.sh
git commit -m "feat: integrate surf into master_ui.sh menu

New menu option: W) Web Navigator (Surf)

Launches surf entity wrapper with error handling if not found.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 10: Shell Alias & Installation Instructions

**Files:**
- Create: `terminals/surf/INSTALL.md`

- [ ] **Step 1: Create installation guide**

Create `terminals/surf/INSTALL.md`:
```markdown
# Surf Installation Guide

## 1. Add Shell Alias

Add to `~/.bashrc`:

```bash
# Surf - Terminal Browser Navigator
alias surf='/home/sauron/primehaven/terminals/surf/entity_wrapper.sh'
```

Then reload:
```bash
source ~/.bashrc
```

## 2. Configure Browsers (Optional)

For optimal experience, merge browser configs:

### Lynx
```bash
cat ~/primehaven/terminals/surf/config/lynx.cfg >> ~/.lynxrc
```

### W3m
```bash
mkdir -p ~/.w3m
cat ~/primehaven/terminals/surf/config/w3m_config >> ~/.w3m/config
```

### Browsh
```bash
mkdir -p ~/.config/browsh
cp ~/primehaven/terminals/surf/config/browsh_config.toml ~/.config/browsh/config.toml
```

## 3. Verify Installation

```bash
surf --help
```

Expected: Shows surf help menu

```bash
surf
```

Expected: Interactive menu appears

## 4. First Use

1. **Browse a site**: `surf https://docs.python.org`
2. **After browsing**: Press 'c' to add a comment
3. **View history**: `surf -c`
4. **Explore**: `surf -s`

## 5. GitHub Setup (Future)

GitHub quick access shortcuts work now:
```bash
surf github
surf github primehaven
```

Token-based auth for committing from terminal is planned but not yet implemented.

## Session Data

All data stored in `~/.surf/` (git-ignored):
- History: `~/.surf/history.log`
- Comments: `~/.surf/comments.db`
- Bookmarks: `~/.surf/bookmarks.txt`

## Troubleshooting

**Surf command not found:**
```bash
# Check alias
alias surf

# If missing, add to ~/.bashrc and reload
source ~/.bashrc
```

**Browser not launching:**
```bash
# Verify browsers installed
which lynx w3m browsh

# Install if missing (Ubuntu/Debian)
sudo apt install lynx w3m browsh
```

**Session data not persisting:**
```bash
# Check permissions
ls -la ~/.surf/

# Should be drwx------ (700)
# If not:
chmod 700 ~/.surf/
```

---

For more details, see: `terminals/surf/README.md`
```

- [ ] **Step 2: Document manual alias setup step**

Create note for user:

```bash
echo "
═══════════════════════════════════════════════════════
 SURF INSTALLATION - MANUAL STEP REQUIRED
═══════════════════════════════════════════════════════

Add this alias to ~/.bashrc:

    alias surf='/home/sauron/primehaven/terminals/surf/entity_wrapper.sh'

Then run: source ~/.bashrc

See terminals/surf/INSTALL.md for full setup instructions.
═══════════════════════════════════════════════════════
" > terminals/surf/INSTALL_NOTE.txt
```

- [ ] **Step 3: Commit installation docs**

```bash
git add terminals/surf/INSTALL.md terminals/surf/INSTALL_NOTE.txt
git commit -m "docs: add installation guide for surf

Installation steps:
1. Add shell alias to ~/.bashrc
2. Configure browsers (optional)
3. Verify with surf --help
4. First use walkthrough

Includes troubleshooting section.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 11: Testing & Verification

**Files:**
- Create: `terminals/surf/test_surf.sh`

- [ ] **Step 1: Create test script**

Create `terminals/surf/test_surf.sh`:
```bash
#!/bin/bash
# Surf Test Suite - Verify all components work

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/browser_selector.sh"
source "${SCRIPT_DIR}/session_manager.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS=0
FAIL=0

# Test helper
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"

    if [[ "$actual" == "$expected" ]]; then
        echo -e "${GREEN}✓${NC} $test_name"
        ((PASS++))
    else
        echo -e "${RED}✗${NC} $test_name"
        echo "  Expected: $expected"
        echo "  Got: $actual"
        ((FAIL++))
    fi
}

echo "═══════════════════════════════════════"
echo "  Surf Test Suite"
echo "═══════════════════════════════════════"
echo ""

# Test 1: Browser Selection
echo "Testing Browser Selection..."
result=$(select_browser "https://github.com/eaprime1")
assert_equals "browsh" "$result" "GitHub → browsh"

result=$(select_browser "https://docs.python.org")
assert_equals "lynx" "$result" "Python docs → lynx"

result=$(select_browser "https://stackoverflow.com")
assert_equals "w3m" "$result" "Stack Overflow → w3m"

result=$(select_browser "https://example.com")
assert_equals "w3m" "$result" "Default → w3m"

result=$(select_browser "https://oauth.example.com/login")
assert_equals "browsh" "$result" "OAuth → browsh"

result=$(select_browser "test.md")
assert_equals "lynx" "$result" "Markdown → lynx"

echo ""

# Test 2: Browser Override
echo "Testing Browser Override..."
result=$(select_browser "https://github.com" --lynx)
assert_equals "lynx" "$result" "Override to lynx"

result=$(select_browser "https://github.com" --w3m)
assert_equals "w3m" "$result" "Override to w3m"

result=$(select_browser "https://github.com" --browsh)
assert_equals "browsh" "$result" "Override to browsh"

echo ""

# Test 3: Session Manager
echo "Testing Session Manager..."

# Clean test data
rm -rf /tmp/test-surf
export SURF_DIR="/tmp/test-surf"
export SESSIONS_DIR="${SURF_DIR}/sessions"
export HISTORY_FILE="${SURF_DIR}/history.log"
export COMMENTS_FILE="${SURF_DIR}/comments.db"
export BOOKMARKS_FILE="${SURF_DIR}/bookmarks.txt"

init_session

# Test logging
log_visit "https://example.com" "w3m" "success"
if grep -q "example.com" "$HISTORY_FILE"; then
    echo -e "${GREEN}✓${NC} History logging works"
    ((PASS++))
else
    echo -e "${RED}✗${NC} History logging failed"
    ((FAIL++))
fi

# Test comments
add_comment "https://example.com" "Test comment" "test,demo" &>/dev/null
if grep -q "Test comment" "$COMMENTS_FILE"; then
    echo -e "${GREEN}✓${NC} Comment storage works"
    ((PASS++))
else
    echo -e "${RED}✗${NC} Comment storage failed"
    ((FAIL++))
fi

# Test bookmarks
add_bookmark "https://example.com" "Example Site" "test" &>/dev/null
if grep -q "Example Site" "$BOOKMARKS_FILE"; then
    echo -e "${GREEN}✓${NC} Bookmark storage works"
    ((PASS++))
else
    echo -e "${RED}✗${NC} Bookmark storage failed"
    ((FAIL++))
fi

# Test permissions
perms=$(stat -c '%a' "$SURF_DIR")
assert_equals "700" "$perms" "Session directory permissions"

echo ""

# Test 4: File Structure
echo "Testing File Structure..."

files=(
    "${SCRIPT_DIR}/entity_wrapper.sh"
    "${SCRIPT_DIR}/browser_selector.sh"
    "${SCRIPT_DIR}/session_manager.sh"
    "${SCRIPT_DIR}/spirit.sh"
    "${SCRIPT_DIR}/config/lynx.cfg"
    "${SCRIPT_DIR}/config/w3m_config"
    "${SCRIPT_DIR}/config/browsh_config.toml"
)

for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        echo -e "${GREEN}✓${NC} $(basename "$file") exists"
        ((PASS++))
    else
        echo -e "${RED}✗${NC} $(basename "$file") missing"
        ((FAIL++))
    fi
done

echo ""

# Test 5: Entity Wrapper Help
echo "Testing Entity Wrapper..."

if "${SCRIPT_DIR}/entity_wrapper.sh" --help &>/dev/null; then
    echo -e "${GREEN}✓${NC} Entity wrapper help works"
    ((PASS++))
else
    echo -e "${RED}✗${NC} Entity wrapper help failed"
    ((FAIL++))
fi

echo ""

# Summary
echo "═══════════════════════════════════════"
echo "  Test Results"
echo "═══════════════════════════════════════"
echo -e "${GREEN}PASS: $PASS${NC}"
echo -e "${RED}FAIL: $FAIL${NC}"
echo ""

if [[ $FAIL -eq 0 ]]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    exit 1
fi
```

- [ ] **Step 2: Make executable and run tests**

```bash
chmod +x terminals/surf/test_surf.sh
```

Run: `terminals/surf/test_surf.sh`
Expected: All tests pass

- [ ] **Step 3: Commit test suite**

```bash
git add terminals/surf/test_surf.sh
git commit -m "test: add test suite for surf browser entity

Tests:
- Browser selection logic (6 patterns)
- Browser override flags
- Session manager (history, comments, bookmarks)
- File structure verification
- Entity wrapper help functionality

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Task 12: Final Documentation & Plan Completion

**Files:**
- Update: `docs/superpowers/specs/2026-03-26-surf-browser-entity-design.md`

- [ ] **Step 1: Mark success criteria complete in spec**

Update spec file, change these checkboxes:
```markdown
## Success Criteria

- [x] `surf` command launches interactive menu
- [x] Smart browser selection works for all URL patterns
- [x] GitHub quick access works: `surf github` opens eaprime1 profile
- [x] Comments persist across sessions
- [x] Session history tracks all visited URLs
- [ ] GitHub token setup works, credentials cached (planned, not implemented)
- [x] master_ui.sh integration menu option functional
- [x] Entity briefing created at `~/.eric/context/contributors/surf.md`
- [x] Seed entities created for future expansion
- [x] All session data git-ignored (`.surf/` directory)
```

- [ ] **Step 2: Create completion summary**

Create `terminals/surf/STATUS.md`:
```markdown
# Surf Browser Entity - Implementation Status

**Date**: 2026-03-26
**Status**: ✅ Core Implementation Complete
**Branch**: feature/surf-browser-entity

## Completed Components

### Core Modules ✅
- [x] Browser Selector - Smart lynx/w3m/browsh selection
- [x] Session Manager - History, comments, bookmarks
- [x] Spirit Module - Exploration, discovery, export/import
- [x] Entity Wrapper - Main entry point, interactive menu

### Configuration ✅
- [x] Lynx config - Cookie persistence, VI keys
- [x] W3m config - Cookie support, UTF-8
- [x] Browsh config - Headless Firefox setup

### Integration ✅
- [x] master_ui.sh menu option
- [x] Entity briefing (`~/.eric/context/contributors/surf.md`)
- [x] Shell alias documentation
- [x] Session data git-ignore

### Seed Entities ✅
- [x] surf-simple - Minimal lynx-only browser
- [x] surf-unified - Placeholder for web+project navigator

### Documentation ✅
- [x] README.md - Quick start and component overview
- [x] INSTALL.md - Setup instructions
- [x] Test suite - Automated verification

## Not Implemented (Future)

- [ ] GitHub token authentication setup
- [ ] Keyboard shortcut injection (c/b while browsing)
- [ ] Smart suggestions based on history
- [ ] Integration with `germ` prime tracking

## Usage

```bash
# Add alias to ~/.bashrc
alias surf='/home/sauron/primehaven/terminals/surf/entity_wrapper.sh'

# Use surf
surf                      # Interactive mode
surf https://example.com  # Direct browsing
surf github               # Quick shortcut
surf -c                   # View comments
surf -s                   # Spirit mode
```

## Testing

Run test suite:
```bash
terminals/surf/test_surf.sh
```

All tests passing.

## Next Steps

1. **User Testing**: Eric tests browsing workflow
2. **GitHub Auth**: Implement token setup (Task 10 in original plan, deferred)
3. **Shortcuts**: Real-time comment/bookmark during browsing (requires wrapper intercept)
4. **PR Creation**: Merge to main once verified

## Files Changed

**New files:** 15
**Modified files:** 2 (master_ui.sh, .gitignore)

See full implementation plan: `docs/superpowers/plans/2026-03-26-surf-browser-entity.md`
```

- [ ] **Step 3: Commit final documentation**

```bash
git add docs/superpowers/specs/2026-03-26-surf-browser-entity-design.md terminals/surf/STATUS.md
git commit -m "docs: mark surf implementation complete, add status summary

Success criteria updated:
- Core implementation complete (9/10 criteria)
- GitHub token auth deferred to future
- All tests passing

Next: User testing, then merge to main.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Execution Notes

**Estimated time:** 60-90 minutes total (12 tasks × 5-7 minutes each)

**Order:** Tasks must be executed sequentially (dependencies between modules)

**Verification at each step:** Run commands shown in "Expected" sections

**Commit strategy:** One commit per task (12 commits total)

**Session data:** All runtime data in `~/.surf/` (git-ignored)

**Manual steps:**
1. Shell alias (user adds to ~/.bashrc)
2. Browser configs (optional, documented in INSTALL.md)

---

## Plan Review Checklist

Before execution, verify:

- [ ] All file paths are absolute or clearly relative
- [ ] Each step includes exact commands
- [ ] Expected output documented for verification
- [ ] Commits follow conventional commits format
- [ ] No placeholders or "TODO" comments in code
- [ ] Tests included for core functionality
- [ ] Documentation complete (README, INSTALL, entity briefing)

---

**End of Implementation Plan**

*Generated: 2026-03-26 using superpowers:writing-plans skill*
