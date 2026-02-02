#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# MASTER UI - PrimeHaven Command Center
# ═══════════════════════════════════════════════════════════════════════════
# Terminal-based control panel for all PrimeHaven systems
# Designed for resilience during degraded states (tooth pain scenario)
# Single keypress navigation • Clear visual separation • Error resilience
# ═══════════════════════════════════════════════════════════════════════════

set -euo pipefail

PRIMEHAVEN_ROOT="${PRIMEHAVEN_ROOT:-$HOME/primehaven}"
TOOLS_DIR="${PRIMEHAVEN_ROOT}/tools"
DOCS_DIR="${PRIMEHAVEN_ROOT}/docs"
SPACES_DIR="${PRIMEHAVEN_ROOT}/spaces"

# Colors
if [[ -t 1 ]] && command -v tput &>/dev/null; then
    BOLD=$(tput bold 2>/dev/null || echo "")
    NORMAL=$(tput sgr0 2>/dev/null || echo "")
    RED=$(tput setaf 1 2>/dev/null || echo "")
    GREEN=$(tput setaf 2 2>/dev/null || echo "")
    YELLOW=$(tput setaf 3 2>/dev/null || echo "")
    BLUE=$(tput setaf 4 2>/dev/null || echo "")
    MAGENTA=$(tput setaf 5 2>/dev/null || echo "")
    CYAN=$(tput setaf 6 2>/dev/null || echo "")
else
    BOLD=""
    NORMAL=""
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    MAGENTA=""
    CYAN=""
fi

# Box drawing
BOX_H="─"
BOX_TL="╭"
BOX_TR="╮"
BOX_BL="╰"
BOX_BR="╯"

# Utility functions
draw_box_header() {
    local title="$1"
    local width="${2:-80}"
    local padding=$(( (width - ${#title} - 2) / 2 ))
    printf "${BOX_TL}"
    printf "%${padding}s" | tr ' ' "${BOX_H}"
    printf " ${BOLD}${CYAN}%s${NORMAL} " "$title"
    printf "%${padding}s" | tr ' ' "${BOX_H}"
    printf "${BOX_TR}\n"
}

draw_box_footer() {
    local width="${1:-80}"
    printf "${BOX_BL}"
    printf "%$((width - 2))s" | tr ' ' "${BOX_H}"
    printf "${BOX_BR}\n"
}

status_indicator() {
    local status="$1"
    local message="$2"
    case "$status" in
        ok|success) echo "${GREEN}✓${NORMAL} ${message}" ;;
        warn|warning) echo "${YELLOW}⚠${NORMAL} ${message}" ;;
        error|fail) echo "${RED}✗${NORMAL} ${message}" ;;
        info) echo "${BLUE}→${NORMAL} ${message}" ;;
        *) echo "  ${message}" ;;
    esac
}

has_command() {
    command -v "$1" &>/dev/null
}

pause() {
    local message="${1:-Press any key to continue...}"
    echo ""
    read -n 1 -s -r -p "${CYAN}${message}${NORMAL}"
    echo ""
}

clear_screen() {
    clear 2>/dev/null || printf "\033[2J\033[H"
}

# Core function: Generate dirtree
generate_dirtree() {
    clear_screen
    draw_box_header "DIRECTORY TREE GENERATOR" 80
    echo ""
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local output_file="${DOCS_DIR}/dirtree_${timestamp}.txt"
    
    echo "${BOLD}Generating directory tree...${NORMAL}"
    echo ""
    
    local depth=3
    if [[ -d "$PRIMEHAVEN_ROOT" ]]; then
        local dir_count=$(find "$PRIMEHAVEN_ROOT" -type d 2>/dev/null | wc -l)
        if (( dir_count > 1000 )); then
            depth=2
            status_indicator "warn" "Large directory detected, using depth=$depth"
        fi
    fi
    
    if has_command tree; then
        status_indicator "info" "Using 'tree' command (depth: $depth)"
        tree -L "$depth" -a -I '.git|__pycache__|.cache|node_modules' "$PRIMEHAVEN_ROOT" > "$output_file" 2>/dev/null || {
            status_indicator "error" "Tree command failed, using fallback"
            find "$PRIMEHAVEN_ROOT" -maxdepth "$depth" -type d 2>/dev/null | sort > "$output_file"
        }
    else
        status_indicator "warn" "'tree' not found, using find fallback"
        find "$PRIMEHAVEN_ROOT" -maxdepth "$depth" -type d 2>/dev/null | sort > "$output_file"
    fi
    
    echo ""
    status_indicator "ok" "Tree generated: $output_file"
    
    {
        echo ""
        echo "═══════════════════════════════════════════════════════════════════════════"
        echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Root: $PRIMEHAVEN_ROOT"
        echo "Depth: $depth"
        echo "═══════════════════════════════════════════════════════════════════════════"
    } >> "$output_file"
    
    echo ""
    echo "${BOLD}Route this tree to:${NORMAL}"
    echo "  ${CYAN}1${NORMAL}. Keep in docs/ only"
    echo "  ${CYAN}2${NORMAL}. Copy to journey_today/"
    echo "  ${CYAN}3${NORMAL}. Copy to clipboard (xclip)"
    echo "  ${CYAN}4${NORMAL}. View now"
    echo "  ${CYAN}5${NORMAL}. All of the above"
    echo ""
    
    read -n 1 -r -p "Select routing [1-5, or Enter to skip]: " choice
    echo ""
    echo ""
    
    case "$choice" in
        1) status_indicator "ok" "Saved to docs/" ;;
        2)
            if [[ -d "${PRIMEHAVEN_ROOT}/journey_today" ]]; then
                cp "$output_file" "${PRIMEHAVEN_ROOT}/journey_today/"
                status_indicator "ok" "Copied to journey_today/"
            else
                status_indicator "warn" "journey_today/ not found"
            fi
            ;;
        3)
            if has_command xclip; then
                cat "$output_file" | xclip -selection clipboard
                status_indicator "ok" "Copied to clipboard"
            else
                status_indicator "warn" "xclip not available"
            fi
            ;;
        4) less "$output_file" ;;
        5)
            [[ -d "${PRIMEHAVEN_ROOT}/journey_today" ]] && cp "$output_file" "${PRIMEHAVEN_ROOT}/journey_today/"
            has_command xclip && cat "$output_file" | xclip -selection clipboard
            status_indicator "ok" "Routed to all destinations"
            less "$output_file"
            ;;
        *) status_indicator "info" "Skipped routing" ;;
    esac
    
    echo ""
    draw_box_footer 80
    pause
}

# Core function: Show repo status
show_repo_status() {
    clear_screen
    draw_box_header "REPOSITORY STATUS DASHBOARD" 80
    echo ""
    
    echo "${BOLD}${MAGENTA}Main Repository:${NORMAL} primehaven"
    echo "════════════════════════════════════════"
    
    if [[ -d "${PRIMEHAVEN_ROOT}/.git" ]]; then
        cd "$PRIMEHAVEN_ROOT" || exit 1
        
        local branch=$(git branch --show-current 2>/dev/null || echo "unknown")
        status_indicator "info" "Branch: ${BOLD}${branch}${NORMAL}"
        
        if git diff-index --quiet HEAD -- 2>/dev/null; then
            status_indicator "ok" "Working tree clean"
        else
            local changes=$(git status --short | wc -l)
            status_indicator "warn" "Working tree has ${BOLD}${changes}${NORMAL} changes"
        fi
        
        local last_commit=$(git log -1 --pretty=format:"%h - %s (%cr)" 2>/dev/null || echo "No commits")
        status_indicator "info" "Last: ${last_commit}"
        
        if git remote &>/dev/null; then
            local remote_status=$(git status -sb 2>/dev/null | head -1)
            if [[ "$remote_status" =~ "ahead" ]]; then
                status_indicator "warn" "Ahead of remote (unpushed commits)"
            elif [[ "$remote_status" =~ "behind" ]]; then
                status_indicator "warn" "Behind remote (need to pull)"
            else
                status_indicator "ok" "Synced with remote"
            fi
        else
            status_indicator "info" "No remote configured"
        fi
    else
        status_indicator "error" "Not a git repository"
    fi
    
    echo ""
    
    if [[ -d "${SPACES_DIR}" ]]; then
        echo "${BOLD}${MAGENTA}Spaces Repositories:${NORMAL}"
        echo "════════════════════════════════════════"
        
        local repo_count=0
        for repo_dir in "${SPACES_DIR}"/*; do
            if [[ -d "${repo_dir}/.git" ]]; then
                repo_count=$((repo_count + 1))
                local repo_name=$(basename "$repo_dir")
                cd "$repo_dir" || continue
                local branch=$(git branch --show-current 2>/dev/null || echo "?")
                local status_icon
                
                if git diff-index --quiet HEAD -- 2>/dev/null; then
                    status_icon="${GREEN}✓${NORMAL}"
                else
                    status_icon="${YELLOW}●${NORMAL}"
                fi
                
                printf "  ${status_icon} %-20s ${CYAN}(%s)${NORMAL}\n" "$repo_name" "$branch"
            fi
        done
        
        if (( repo_count == 0 )); then
            status_indicator "info" "No git repositories found in spaces/"
        else
            echo ""
            status_indicator "ok" "Found ${BOLD}${repo_count}${NORMAL} repositories"
        fi
    fi
    
    echo ""
    draw_box_footer 80
    pause
}

# Core function: Quick sync check
quick_sync_check() {
    clear_screen
    draw_box_header "QUICK SYNC CHECK" 80
    echo ""
    
    echo "${BOLD}${CYAN}Checking system synchronization status...${NORMAL}"
    echo ""
    
    echo "${BOLD}Google Drive:${NORMAL}"
    if has_command rclone; then
        if rclone listremotes 2>/dev/null | grep -q "googledrive"; then
            status_indicator "ok" "rclone configured with Google Drive"
            if timeout 3 rclone lsd googledrive: --max-depth 1 &>/dev/null; then
                status_indicator "ok" "Google Drive accessible"
            else
                status_indicator "warn" "Google Drive configured but not accessible (offline?)"
            fi
        else
            status_indicator "warn" "rclone installed but Google Drive not configured"
        fi
    else
        status_indicator "error" "rclone not installed"
    fi
    
    echo ""
    
    echo "${BOLD}GitHub:${NORMAL}"
    if has_command gh; then
        if gh auth status &>/dev/null; then
            status_indicator "ok" "GitHub authenticated"
            cd "$PRIMEHAVEN_ROOT" || exit 1
            if git remote get-url origin &>/dev/null; then
                local repo_url=$(git remote get-url origin 2>/dev/null)
                status_indicator "ok" "Remote: ${repo_url}"
            else
                status_indicator "info" "No remote origin configured"
            fi
        else
            status_indicator "warn" "GitHub CLI installed but not authenticated"
            echo "         ${CYAN}Run: gh auth login${NORMAL}"
        fi
    else
        status_indicator "warn" "GitHub CLI (gh) not installed"
    fi
    
    echo ""
    
    echo "${BOLD}Git Configuration:${NORMAL}"
    if has_command git; then
        local git_user=$(git config --global user.name 2>/dev/null || echo "not set")
        local git_email=$(git config --global user.email 2>/dev/null || echo "not set")
        if [[ "$git_user" != "not set" ]]; then
            status_indicator "ok" "User: ${git_user} <${git_email}>"
        else
            status_indicator "warn" "Git user not configured"
        fi
    fi
    
    echo ""
    
    echo "${BOLD}Network:${NORMAL}"
    if timeout 2 ping -c 1 8.8.8.8 &>/dev/null; then
        status_indicator "ok" "Internet connection active"
    else
        status_indicator "error" "No internet connection detected"
    fi
    
    echo ""
    
    echo "${BOLD}Disk Space:${NORMAL}"
    if has_command df; then
        local disk_usage=$(df -h "$PRIMEHAVEN_ROOT" 2>/dev/null | awk 'NR==2 {print $5}' | sed 's/%//')
        if [[ -n "$disk_usage" ]]; then
            if (( disk_usage < 80 )); then
                status_indicator "ok" "Disk usage: ${disk_usage}% (healthy)"
            elif (( disk_usage < 90 )); then
                status_indicator "warn" "Disk usage: ${disk_usage}% (monitor)"
            else
                status_indicator "error" "Disk usage: ${disk_usage}% (critical)"
            fi
        fi
    fi
    
    echo ""
    draw_box_footer 80
    pause
}

# Launch tools menu
launch_tools() {
    clear_screen
    draw_box_header "LAUNCH TOOLS" 80
    echo ""
    
    echo "${BOLD}Available Launch Options:${NORMAL}"
    echo ""
    echo "  ${CYAN}1${NORMAL}. Open browser (default)"
    echo "  ${CYAN}2${NORMAL}. Open file manager (nautilus)"
    echo "  ${CYAN}3${NORMAL}. Open terminal (gnome-terminal)"
    echo "  ${CYAN}4${NORMAL}. Open text editor (gedit)"
    echo "  ${CYAN}5${NORMAL}. Open VS Code (if installed)"
    echo "  ${CYAN}6${NORMAL}. GitHub PrimeHaven repository"
    echo "  ${CYAN}7${NORMAL}. Google Drive in browser"
    echo ""
    
    read -n 1 -r -p "Select tool to launch [1-7, or Enter to cancel]: " choice
    echo ""
    echo ""
    
    case "$choice" in
        1)
            if has_command xdg-open; then
                xdg-open "https://www.google.com" &>/dev/null &
                status_indicator "ok" "Browser launched"
            else
                status_indicator "error" "xdg-open not available"
            fi
            ;;
        2)
            if has_command nautilus; then
                nautilus "$PRIMEHAVEN_ROOT" &>/dev/null &
                status_indicator "ok" "File manager opened"
            else
                status_indicator "error" "Nautilus not available"
            fi
            ;;
        3)
            if has_command gnome-terminal; then
                gnome-terminal --working-directory="$PRIMEHAVEN_ROOT" &>/dev/null &
                status_indicator "ok" "Terminal launched"
            else
                status_indicator "error" "gnome-terminal not available"
            fi
            ;;
        4)
            if has_command gedit; then
                gedit &>/dev/null &
                status_indicator "ok" "Text editor launched"
            else
                status_indicator "error" "gedit not available"
            fi
            ;;
        5)
            if has_command code; then
                code "$PRIMEHAVEN_ROOT" &>/dev/null &
                status_indicator "ok" "VS Code launched"
            else
                status_indicator "error" "VS Code not installed"
            fi
            ;;
        6)
            if has_command xdg-open; then
                xdg-open "https://github.com/Eaprime1/primehaven" &>/dev/null &
                status_indicator "ok" "GitHub repository opened"
            else
                status_indicator "error" "xdg-open not available"
            fi
            ;;
        7)
            if has_command xdg-open; then
                xdg-open "https://drive.google.com" &>/dev/null &
                status_indicator "ok" "Google Drive opened"
            else
                status_indicator "error" "xdg-open not available"
            fi
            ;;
        *) status_indicator "info" "Cancelled" ;;
    esac
    
    echo ""
    pause "Press any key to return to menu..."
}

# Show dashboard
show_dashboard() {
    clear_screen
    draw_box_header "PRIMEHAVEN COMMAND CENTER - STATUS DASHBOARD" 80
    echo ""
    
    echo "${BOLD}${MAGENTA}System Information${NORMAL}"
    echo "════════════════════════════════════════"
    status_indicator "info" "Date: $(date '+%Y-%m-%d %H:%M:%S')"
    status_indicator "info" "User: ${BOLD}${USER}${NORMAL}"
    status_indicator "info" "Home: ${PRIMEHAVEN_ROOT}"
    
    echo ""
    
    echo "${BOLD}${MAGENTA}Quick Status${NORMAL}"
    echo "════════════════════════════════════════"
    
    if [[ -d "${PRIMEHAVEN_ROOT}/.git" ]]; then
        cd "$PRIMEHAVEN_ROOT" || exit 1
        local branch=$(git branch --show-current 2>/dev/null || echo "unknown")
        if git diff-index --quiet HEAD -- 2>/dev/null; then
            status_indicator "ok" "Git: Clean (${branch})"
        else
            status_indicator "warn" "Git: Changes pending (${branch})"
        fi
    else
        status_indicator "error" "Git: Not initialized"
    fi
    
    if timeout 1 ping -c 1 8.8.8.8 &>/dev/null; then
        status_indicator "ok" "Network: Connected"
    else
        status_indicator "error" "Network: Offline"
    fi
    
    local tools_ok=0
    local tools_total=5
    has_command git && tools_ok=$((tools_ok + 1))
    has_command rclone && tools_ok=$((tools_ok + 1))
    has_command gh && tools_ok=$((tools_ok + 1))
    has_command tree && tools_ok=$((tools_ok + 1))
    has_command fzf && tools_ok=$((tools_ok + 1))
    
    if (( tools_ok == tools_total )); then
        status_indicator "ok" "Tools: All ${tools_total} installed"
    else
        status_indicator "warn" "Tools: ${tools_ok}/${tools_total} available"
    fi
    
    echo ""
    
    if [[ -d "${SPACES_DIR}" ]]; then
        local repo_count=$(find "${SPACES_DIR}" -maxdepth 2 -name ".git" -type d 2>/dev/null | wc -l)
        status_indicator "info" "Repositories: ${BOLD}${repo_count}${NORMAL} in spaces/"
    fi
    
    echo ""
    draw_box_footer 80
    echo ""
}

# Quick actions menu
show_quick_actions() {
    clear_screen
    draw_box_header "QUICK ACTIONS" 80
    echo ""
    
    echo "${BOLD}Available Quick Actions:${NORMAL}"
    echo ""
    echo "  ${CYAN}1${NORMAL}. Git status all (main + spaces repos)"
    echo "  ${CYAN}2${NORMAL}. Git pull all repositories"
    echo "  ${CYAN}3${NORMAL}. Generate full system report"
    echo "  ${CYAN}4${NORMAL}. Clean cache files (.cache, __pycache__)"
    echo "  ${CYAN}5${NORMAL}. List recent files (last 24h)"
    echo "  ${CYAN}6${NORMAL}. Show disk usage by directory"
    echo ""
    
    read -n 1 -r -p "Select action [1-6, or Enter to cancel]: " choice
    echo ""
    echo ""
    
    case "$choice" in
        1)
            echo "${BOLD}Git status for all repositories:${NORMAL}"
            echo ""
            [[ -d "${PRIMEHAVEN_ROOT}/.git" ]] && {
                echo "${CYAN}primehaven:${NORMAL}"
                cd "$PRIMEHAVEN_ROOT" && git status --short
                echo ""
            }
            [[ -d "${SPACES_DIR}" ]] && {
                for repo_dir in "${SPACES_DIR}"/*; do
                    if [[ -d "${repo_dir}/.git" ]]; then
                        echo "${CYAN}$(basename "$repo_dir"):${NORMAL}"
                        cd "$repo_dir" && git status --short
                        echo ""
                    fi
                done
            }
            ;;
        2)
            echo "${BOLD}Pulling all repositories:${NORMAL}"
            echo ""
            [[ -d "${PRIMEHAVEN_ROOT}/.git" ]] && {
                echo "${CYAN}primehaven:${NORMAL}"
                cd "$PRIMEHAVEN_ROOT" && git pull
                echo ""
            }
            [[ -d "${SPACES_DIR}" ]] && {
                for repo_dir in "${SPACES_DIR}"/*; do
                    if [[ -d "${repo_dir}/.git" ]]; then
                        echo "${CYAN}$(basename "$repo_dir"):${NORMAL}"
                        cd "$repo_dir" && git pull
                        echo ""
                    fi
                done
            }
            ;;
        3)
            local report_file="${DOCS_DIR}/system_report_$(date +%Y%m%d_%H%M%S).md"
            {
                echo "# PrimeHaven System Report"
                echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
                echo ""
                echo "## Git Status"
                cd "$PRIMEHAVEN_ROOT" && git status
                echo ""
                echo "## Disk Usage"
                du -sh "${PRIMEHAVEN_ROOT}"/* 2>/dev/null | sort -h
            } > "$report_file"
            status_indicator "ok" "Report saved: $report_file"
            ;;
        4)
            echo "${BOLD}Cleaning cache files...${NORMAL}"
            echo ""
            find "$PRIMEHAVEN_ROOT" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
            find "$PRIMEHAVEN_ROOT" -type d -name ".cache" -exec rm -rf {} + 2>/dev/null || true
            status_indicator "ok" "Cache cleaned"
            ;;
        5)
            echo "${BOLD}Files modified in last 24 hours:${NORMAL}"
            echo ""
            find "$PRIMEHAVEN_ROOT" -type f -mtime -1 2>/dev/null | head -20
            ;;
        6)
            echo "${BOLD}Disk usage by directory:${NORMAL}"
            echo ""
            du -sh "${PRIMEHAVEN_ROOT}"/* 2>/dev/null | sort -h
            ;;
        *) status_indicator "info" "Cancelled" ;;
    esac
    
    echo ""
    pause
}

# Show help
show_help() {
    clear_screen
    draw_box_header "MASTER UI HELP" 80
    echo ""
    
    cat << 'HELP_EOF'
MASTER UI - PrimeHaven Command Center

DESCRIPTION:
    Terminal-based control panel for managing all PrimeHaven systems.
    Designed for minimal cognitive load and resilience during degraded states.

MAIN MENU OPTIONS:
    d - Dashboard       : System status overview
    t - DirTree         : Generate directory tree with routing
    r - Repo Status     : Git status for all repositories
    s - Sync Check      : Check Google Drive, GitHub, network status
    l - Launch          : Quick launch browser, apps, platforms
    q - Quick Actions   : Common tasks (git pull all, reports, etc.)
    h - Help            : Show this help
    x - Exit            : Quit Master UI

FEATURES:
    • Single keypress navigation
    • Visual box drawing for clarity
    • Error resilience (handles missing tools gracefully)
    • Smart defaults (auto-detect directory size, network status)
    • Report routing (docs/, journey_today/, clipboard)

DESIGNED FOR:
    • Quick status checks across all systems
    • One-command tool launches
    • Report generation and routing
    • Working effectively during degraded states (pain, fatigue, etc.)

EXTENSIBILITY:
    Add new functions in the CORE FUNCTIONS section.
    Update main_menu() to add new menu options.

REQUIREMENTS:
    Essential: bash, git
    Optional: tree, rclone, gh, xclip, fzf, xdg-open

LOCATION:
    Script: $PRIMEHAVEN_ROOT/tools/master_ui.sh
    Docs:   $PRIMEHAVEN_ROOT/docs/MASTER_UI_GUIDE.md

HELP_EOF
    
    echo ""
    draw_box_footer 80
    pause
}

# Main menu
main_menu() {
    while true; do
        show_dashboard
        
        echo "${BOLD}${CYAN}MAIN MENU${NORMAL}"
        echo ""
        echo "  ${CYAN}d${NORMAL}. Dashboard       - System status overview"
        echo "  ${CYAN}t${NORMAL}. DirTree         - Generate directory tree"
        echo "  ${CYAN}r${NORMAL}. Repo Status     - Git status all repositories"
        echo "  ${CYAN}s${NORMAL}. Sync Check      - Google Drive, GitHub, network"
        echo "  ${CYAN}l${NORMAL}. Launch          - Browser, apps, platforms"
        echo "  ${CYAN}q${NORMAL}. Quick Actions   - Git pull all, reports, cleanup"
        echo "  ${CYAN}h${NORMAL}. Help            - Show help and documentation"
        echo "  ${CYAN}x${NORMAL}. Exit            - Quit Master UI"
        echo ""
        
        read -n 1 -r -p "${BOLD}Select option: ${NORMAL}" choice
        echo ""
        echo ""
        
        case "${choice,,}" in
            d) pause ;;
            t) generate_dirtree ;;
            r) show_repo_status ;;
            s) quick_sync_check ;;
            l) launch_tools ;;
            q) show_quick_actions ;;
            h) show_help ;;
            x)
                clear_screen
                echo "${GREEN}${BOLD}∰◊€π¿🌌∞${NORMAL}"
                echo ""
                echo "Master UI closed. Triple helix spiraling..."
                echo ""
                exit 0
                ;;
            *) ;;
        esac
    done
}

# Entry point
cd "$PRIMEHAVEN_ROOT" || {
    echo "Error: Cannot access $PRIMEHAVEN_ROOT"
    exit 1
}

mkdir -p "$DOCS_DIR"

main_menu
