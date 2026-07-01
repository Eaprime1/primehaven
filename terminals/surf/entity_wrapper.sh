#!/bin/bash
# Entity Wrapper - Main Entry Point (Physical Helix)
# Part of Surf Terminal Navigator Entity
# The wrapper that brings it all together

set -euo pipefail

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source dependencies
source "${SCRIPT_DIR}/browser_selector.sh"
source "${SCRIPT_DIR}/session_manager.sh"

# Colors via tput
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
CYAN=$(tput setaf 6)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)

# Box drawing characters
BOX_TL="┌"
BOX_TR="┐"
BOX_BL="└"
BOX_BR="┘"
BOX_H="─"
BOX_V="│"
BOX_VR="├"
BOX_VL="┤"

# Initialize session at startup
init_session

# show_help() - usage info with all commands, shortcuts, examples
show_help() {
    cat <<EOF
${BOLD}${CYAN}╔══════════════════════════════════════════════════════════════╗
║                    SURF - Terminal Browser                   ║
║                      Entity Wrapper v1.0                     ║
╚══════════════════════════════════════════════════════════════╝${NORMAL}

${BOLD}USAGE:${NORMAL}
  $(basename "$0") [OPTIONS] [URL|SHORTCUT]
  $(basename "$0") interactive              ${CYAN}# Interactive menu${NORMAL}

${BOLD}OPTIONS:${NORMAL}
  -h, --help, help        Show this help
  -c, c, comments         Show all comments
  -s, s, spirit           Launch spirit mode (semantic view)
  --lynx                  Force lynx browser
  --w3m                   Force w3m browser
  --browsh                Force browsh browser
  interactive             Launch interactive menu

${BOLD}SHORTCUTS:${NORMAL}
  github                  → https://github.com/eaprime1
  github <repo>           → https://github.com/eaprime1/<repo>
  docs python             → https://docs.python.org/3/
  docs <lang>             → https://docs.<lang>.org/
  so <query>              → https://stackoverflow.com/search?q=<query>

${BOLD}EXAMPLES:${NORMAL}
  ${GREEN}# Browse GitHub profile${NORMAL}
  $(basename "$0") github

  ${GREEN}# Browse specific repo${NORMAL}
  $(basename "$0") github primehaven

  ${GREEN}# Python documentation${NORMAL}
  $(basename "$0") docs python

  ${GREEN}# Search Stack Overflow${NORMAL}
  $(basename "$0") so bash arrays

  ${GREEN}# Direct URL${NORMAL}
  $(basename "$0") https://github.com/eaprime1/primehaven

  ${GREEN}# Force specific browser${NORMAL}
  $(basename "$0") --lynx https://docs.python.org

  ${GREEN}# Interactive mode${NORMAL}
  $(basename "$0") interactive

${BOLD}INTERACTIVE MENU SHORTCUTS:${NORMAL}
  ${CYAN}g${NORMAL} - GitHub profile
  ${CYAN}p${NORMAL} - PrimeHaven repo
  ${CYAN}d${NORMAL} - Documentation search
  ${CYAN}s${NORMAL} - Stack Overflow search
  ${CYAN}c${NORMAL} - View comments
  ${CYAN}h${NORMAL} - Help
  ${CYAN}q${NORMAL} - Quit

${BOLD}FILES:${NORMAL}
  ${CYAN}~/.surf/history.log${NORMAL}     - Browsing history
  ${CYAN}~/.surf/comments.db${NORMAL}     - URL comments
  ${CYAN}~/.surf/bookmarks.txt${NORMAL}   - Saved bookmarks

${YELLOW}Navigation: "Speed up slow, find balance, slow down slow"${NORMAL}
EOF
}

# interactive_menu() - main UI with quick access and recent history
interactive_menu() {
    while true; do
        clear
        echo "${BOLD}${CYAN}${BOX_TL}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_TR}"
        echo "${BOX_V}              ${BOLD}SURF - Terminal Browser${NORMAL}${CYAN}              ${BOX_V}"
        echo "${BOX_VR}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_VL}${NORMAL}"
        echo ""
        echo "${GREEN}Quick Access:${NORMAL}"
        echo "  ${CYAN}g${NORMAL} - GitHub profile (eaprime1)"
        echo "  ${CYAN}p${NORMAL} - PrimeHaven repository"
        echo "  ${CYAN}d${NORMAL} - Documentation search"
        echo "  ${CYAN}s${NORMAL} - Stack Overflow search"
        echo "  ${CYAN}c${NORMAL} - View comments"
        echo "  ${CYAN}h${NORMAL} - Help"
        echo "  ${CYAN}q${NORMAL} - Quit"
        echo ""

        # Show recent 5 history entries
        if [[ -f "${HISTORY_FILE}" ]] && [[ -s "${HISTORY_FILE}" ]]; then
            echo "${YELLOW}Recent History (last 5):${NORMAL}"
            echo "${CYAN}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${NORMAL}"
            tail -n 5 "${HISTORY_FILE}" | while IFS='|' read -r timestamp url browser status; do
                local short_url="${url:0:50}"
                [[ "${#url}" -gt 50 ]] && short_url="${short_url}..."
                echo "  ${browser:0:6} | ${short_url}"
            done
            echo ""
        fi

        echo -n "${BOLD}Enter choice or URL: ${NORMAL}"
        read -r choice

        case "${choice}" in
            g|G)
                browse_url "github"
                ;;
            p|P)
                browse_url "github primehaven"
                ;;
            d|D)
                echo -n "Documentation topic (e.g., python, bash): "
                read -r topic
                browse_url "docs ${topic}"
                ;;
            s|S)
                echo -n "Stack Overflow query: "
                read -r query
                browse_url "so ${query}"
                ;;
            c|C)
                show_comments
                echo ""
                echo -n "Press Enter to continue..."
                read -r
                ;;
            h|H)
                show_help
                echo ""
                echo -n "Press Enter to continue..."
                read -r
                ;;
            q|Q)
                echo "${GREEN}Speed up slow, find balance, slow down slow.${NORMAL}"
                exit 0
                ;;
            "")
                continue
                ;;
            *)
                browse_url "${choice}"
                ;;
        esac
    done
}

# expand_shortcut <input...> - expand shortcuts to full URLs
expand_shortcut() {
    local input="$*"

    # GitHub shortcuts
    if [[ "${input}" == "github" ]]; then
        echo "https://github.com/eaprime1"
        return 0
    elif [[ "${input}" =~ ^github[[:space:]](.+)$ ]]; then
        echo "https://github.com/eaprime1/${BASH_REMATCH[1]}"
        return 0
    fi

    # Documentation shortcuts
    if [[ "${input}" =~ ^docs[[:space:]](.+)$ ]]; then
        local lang="${BASH_REMATCH[1]}"
        case "${lang}" in
            python|py)
                echo "https://docs.python.org/3/"
                ;;
            bash)
                echo "https://www.gnu.org/software/bash/manual/"
                ;;
            *)
                echo "https://docs.${lang}.org/"
                ;;
        esac
        return 0
    fi

    # Stack Overflow shortcuts
    if [[ "${input}" =~ ^so[[:space:]](.+)$ ]]; then
        local query="${BASH_REMATCH[1]}"
        local encoded_query=$(echo "${query}" | sed 's/ /+/g')
        echo "https://stackoverflow.com/search?q=${encoded_query}"
        return 0
    fi

    # Return as-is if not a shortcut
    echo "${input}"
}

# browse_url <url-or-shortcut> [--lynx|--w3m|--browsh] - main browsing function
browse_url() {
    local input="$*"
    local force_browser=""

    # Extract force browser option if present
    if [[ "${input}" == *"--lynx"* ]]; then
        force_browser="--lynx"
        input="${input//--lynx/}"
    elif [[ "${input}" == *"--w3m"* ]]; then
        force_browser="--w3m"
        input="${input//--w3m/}"
    elif [[ "${input}" == *"--browsh"* ]]; then
        force_browser="--browsh"
        input="${input//--browsh/}"
    fi

    # Trim whitespace
    input=$(echo "${input}" | xargs)

    if [[ -z "${input}" ]]; then
        echo "${RED}Error: No URL provided${NORMAL}"
        return 1
    fi

    # Expand shortcuts
    local url
    url=$(expand_shortcut "${input}")

    echo "${CYAN}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${NORMAL}"
    echo "${GREEN}Browsing:${NORMAL} ${url}"

    # Select browser
    local selected_browser
    selected_browser=$(select_browser "${url}" "${force_browser}")

    local final_browser
    final_browser=$(fallback_browser "${selected_browser}")

    if [[ $? -ne 0 ]]; then
        log_visit "${url}" "none" "error_no_browser"
        echo "${RED}Cannot browse: no browser available${NORMAL}"
        return 1
    fi

    echo "${YELLOW}Using:${NORMAL} ${BOLD}${final_browser}${NORMAL}"
    echo "${CYAN}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${BOX_H}${NORMAL}"
    echo ""

    # Launch browser
    "${final_browser}" "${url}"
    local exit_code=$?

    # Log the visit
    local status="success"
    [[ ${exit_code} -ne 0 ]] && status="error_exit_${exit_code}"
    log_visit "${url}" "${final_browser}" "${status}"

    # Offer annotation after browsing
    offer_annotation "${url}"
}

# offer_annotation <url> - prompt for comment or bookmark after browsing
offer_annotation() {
    local url="$1"

    echo ""
    echo "${YELLOW}Add annotation?${NORMAL}"
    echo "  ${CYAN}c${NORMAL} - Add comment"
    echo "  ${CYAN}b${NORMAL} - Add bookmark"
    echo "  ${CYAN}Enter${NORMAL} - Skip"
    echo -n "${BOLD}Choice: ${NORMAL}"
    read -r choice

    case "${choice}" in
        c|C)
            echo -n "Comment: "
            read -r comment
            if [[ -n "${comment}" ]]; then
                echo -n "Tags (optional, comma-separated): "
                read -r tags
                add_comment "${url}" "${comment}" "${tags}"
            fi
            ;;
        b|B)
            echo -n "Bookmark title: "
            read -r title
            if [[ -n "${title}" ]]; then
                echo -n "Tags (optional, comma-separated): "
                read -r tags
                add_bookmark "${url}" "${title}" "${tags}"
            fi
            ;;
        *)
            ;;
    esac
}

# Main execution
main() {
    # No arguments → interactive mode
    if [[ $# -eq 0 ]]; then
        interactive_menu
        exit 0
    fi

    # Parse arguments
    case "$1" in
        -h|--help|help)
            show_help
            exit 0
            ;;
        -c|c|comments)
            shift
            show_comments "$@"
            exit 0
            ;;
        -s|s|spirit)
            # Launch spirit mode (placeholder for now)
            if [[ -x "${SCRIPT_DIR}/spirit.sh" ]]; then
                exec "${SCRIPT_DIR}/spirit.sh" "$@"
            else
                echo "${YELLOW}Spirit mode not yet implemented${NORMAL}"
                echo "Will provide semantic/spiritual view of web content"
                exit 1
            fi
            ;;
        interactive)
            interactive_menu
            exit 0
            ;;
        *)
            # Direct browse
            browse_url "$@"
            exit 0
            ;;
    esac
}

# Execute main
main "$@"
