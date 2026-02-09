#!/bin/bash

################################################################################
# TRAILING SPACE ASSASSIN v2.0 - PrimeHaven Optimized
# Critical infrastructure for primehaven ecosystem
#
# PURPOSE: Detect and eliminate trailing spaces in filenames/folders
# WHY: Trailing spaces cause massive silent corruption - files/folders become
#      invisible to some systems, breaking cross-platform compatibility
#
# CHANGES in v2.0:
# - Default to git-tracked files only (FAST)
# - Optional full filesystem scan with --full-scan
# - PrimeHaven-aware exclusions (primal/, spaces/, etc.)
# - Progress indicators for long scans
#
# USAGE:
#   ./trailing_space_assassin_v2.sh              # Check git-tracked files only
#   ./trailing_space_assassin_v2.sh --full-scan  # Scan entire filesystem (slow)
#   ./trailing_space_assassin_v2.sh --dry-run    # Preview mode (scan only)
#   ./trailing_space_assassin_v2.sh --auto-fix   # Automatic fix (use with caution)
#   ./trailing_space_assassin_v2.sh --check      # Exit 1 if issues found (for CI/hooks)
#
################################################################################

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Configuration
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
BACKUP_DIR="${REPO_ROOT}/.trailing_space_backups"
LOG_FILE="${BACKUP_DIR}/fix_log_$(date +%Y%m%d_%H%M%S).txt"
ISSUES_FOUND=0
FILES_FIXED=0
FULL_SCAN=false

# Parse arguments
MODE="interactive"
for arg in "$@"; do
    case "$arg" in
        --full-scan)
            FULL_SCAN=true
            ;;
        --dry-run)
            MODE="dry-run"
            ;;
        --auto-fix)
            MODE="auto-fix"
            ;;
        --check)
            MODE="check"
            ;;
        --help|-h)
            echo "Trailing Space Assassin v2.0 - PrimeHaven Optimized"
            echo ""
            echo "Usage:"
            echo "  $0                 Check git-tracked files only (FAST)"
            echo "  $0 --full-scan     Scan entire filesystem (SLOW, use with caution)"
            echo "  $0 --dry-run       Preview mode (scan only, no changes)"
            echo "  $0 --auto-fix      Automatic fix (use with caution)"
            echo "  $0 --check         Check mode (exit 1 if issues found, for CI/hooks)"
            echo "  $0 --help          Show this help"
            echo ""
            echo "PrimeHaven Note:"
            echo "  Default mode scans only git-tracked files (recommended)."
            echo "  Use --full-scan to check untracked files, but this will take"
            echo "  much longer due to primal/ (35GB) and spaces/ (114GB)."
            exit 0
            ;;
    esac
done

# Print banner
echo -e "${BOLD}${MAGENTA}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         TRAILING SPACE ASSASSIN v2.0 (PrimeHaven)           ║"
echo "║         Critical Infrastructure for PrimeHaven               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "${CYAN}Repository: ${REPO_ROOT}${NC}"
echo -e "${CYAN}Mode: ${MODE}${NC}"
if [[ "$FULL_SCAN" == "true" ]]; then
    echo -e "${YELLOW}Scan: Full filesystem (SLOW - includes primal/spaces)${NC}"
else
    echo -e "${GREEN}Scan: Git-tracked files only (FAST - recommended)${NC}"
fi
echo ""

# Create backup directory if fixing
if [[ "$MODE" == "auto-fix" ]] || [[ "$MODE" == "interactive" ]]; then
    mkdir -p "$BACKUP_DIR"
    echo -e "${BLUE}Backup directory: ${BACKUP_DIR}${NC}"
    echo -e "${BLUE}Log file: ${LOG_FILE}${NC}"
    echo ""
    echo "$(date): Starting trailing space scan in ${MODE} mode" > "$LOG_FILE"
    if [[ "$FULL_SCAN" == "true" ]]; then
        echo "Full filesystem scan enabled" >> "$LOG_FILE"
    else
        echo "Git-tracked files only" >> "$LOG_FILE"
    fi
fi

# Function to check if path is in a git submodule
is_in_submodule() {
    local path="$1"
    local dir

    # Get the directory containing the file/folder
    if [[ -d "$path" ]]; then
        dir="$path"
    else
        dir="$(dirname "$path")"
    fi

    # Check if this directory or any parent is a git submodule
    while [[ "$dir" != "." && "$dir" != "/" && "$dir" != "$REPO_ROOT" ]]; do
        if [[ -f "$dir/.git" ]] && grep -q "gitdir:" "$dir/.git" 2>/dev/null; then
            return 0  # Is in submodule
        fi
        dir="$(dirname "$dir")"
    done

    return 1  # Not in submodule
}

# Function to find trailing spaces in git-tracked files
find_trailing_spaces_git() {
    echo -e "${YELLOW}Scanning git-tracked files...${NC}"
    echo ""

    local count=0

    # Check tracked files
    while IFS= read -r -d $'\0' file; do
        local basename="${file##*/}"

        # Check if basename ends with space(s)
        if [[ "$basename" =~ [[:space:]]$ ]]; then
            ((count++))

            local dirname="${file%/*}"
            local is_dir=""
            [[ -d "$file" ]] && is_dir="[DIR]"

            # Display the issue
            echo -e "${RED}✗ TRAILING SPACE DETECTED:${NC} ${is_dir}"
            echo -e "  Path: ${CYAN}${file}${NC}"
            echo -e "  Name: '${YELLOW}${basename}${NC}'"

            # Show the trailing spaces visually
            local visual="${basename%"${basename##*[![:space:]]}"}"
            local spaces="${basename#$visual}"
            local space_count="${#spaces}"
            echo -e "  Trailing: ${RED}${space_count} space(s)${NC}"
            echo ""

            # Log it
            if [[ "$MODE" == "auto-fix" ]] || [[ "$MODE" == "interactive" ]]; then
                echo "FOUND: $file (${space_count} trailing spaces)" >> "$LOG_FILE"
            fi
        fi
    done < <(git ls-files -z)

    # Check staged files
    while IFS= read -r file; do
        [[ -z "$file" ]] && continue

        local basename="${file##*/}"

        if [[ "$basename" =~ [[:space:]]$ ]]; then
            ((count++))
            echo -e "${RED}✗ STAGED FILE with trailing space:${NC}"
            echo -e "  ${file}"

            if [[ "$MODE" == "auto-fix" ]] || [[ "$MODE" == "interactive" ]]; then
                echo "FOUND (staged): $file" >> "$LOG_FILE"
            fi
        fi
    done < <(git diff --cached --name-only)

    ISSUES_FOUND=$count
}

# Function to find all files/folders with trailing spaces (full scan)
find_trailing_spaces_full() {
    echo -e "${YELLOW}${BOLD}Full filesystem scan (this may take a while)...${NC}"
    echo ""

    local count=0
    local scanned=0

    # Optimized find command with PrimeHaven-specific exclusions
    find "$REPO_ROOT" \
        -name '.git' -prune -o \
        -name '.trailing_space_backups' -prune -o \
        -name 'node_modules' -prune -o \
        -name '.cache' -prune -o \
        -name '__pycache__' -prune -o \
        -name '.venv' -prune -o \
        -name 'venv' -prune -o \
        -name '.tox' -prune -o \
        -name 'dist' -prune -o \
        -name 'build' -prune -o \
        -name 'primal' -prune -o \
        -name 'spaces' -prune -o \
        -name 'BrowserOS' -prune -o \
        -path '*/conduit/gemini/gemini-cli/*' -prune -o \
        -print0 2>/dev/null | while IFS= read -r -d '' item; do

        ((scanned++))

        # Progress indicator every 100 items
        if (( scanned % 100 == 0 )); then
            echo -ne "\r${CYAN}Scanned: ${scanned} items...${NC}" >&2
        fi

        # Get just the basename
        local basename="${item##*/}"

        # Skip if empty (root dir case)
        [[ -z "$basename" ]] && continue

        # Check if basename ends with space(s)
        if [[ "$basename" =~ [[:space:]]$ ]]; then
            echo -ne "\r\033[K" >&2  # Clear progress line
            ((count++))

            local dirname="${item%/*}"
            local is_dir=""
            [[ -d "$item" ]] && is_dir="[DIR]"

            # Check if in submodule
            local submodule_warning=""
            if is_in_submodule "$item"; then
                submodule_warning="${RED}[SUBMODULE WARNING]${NC} "
            fi

            # Display the issue
            echo -e "${RED}✗ TRAILING SPACE DETECTED:${NC} ${is_dir}"
            echo -e "  ${submodule_warning}Path: ${CYAN}${item}${NC}"
            echo -e "  Name: '${YELLOW}${basename}${NC}'"
            echo -e "  Dir:  ${dirname}"

            # Show the trailing spaces visually
            local visual="${basename%"${basename##*[![:space:]]}"}"
            local spaces="${basename#$visual}"
            local space_count="${#spaces}"
            echo -e "  Trailing: ${RED}${space_count} space(s)${NC}"
            echo ""

            # Log it
            if [[ "$MODE" == "auto-fix" ]] || [[ "$MODE" == "interactive" ]]; then
                echo "FOUND: $item (${space_count} trailing spaces)" >> "$LOG_FILE"
            fi
        fi
    done

    echo -ne "\r\033[K" >&2  # Clear final progress line
    echo -e "${CYAN}Total scanned: ${scanned} items${NC}" >&2

    ISSUES_FOUND=$count
}

# Function to fix a single item
fix_item() {
    local old_path="$1"
    local basename="${old_path##*/}"
    local dirname="${old_path%/*}"

    # Remove trailing spaces from basename
    local new_basename="${basename%%+([[:space:]])}"
    local new_path="${dirname}/${new_basename}"

    # Skip if somehow already correct
    if [[ "$old_path" == "$new_path" ]]; then
        echo -e "${YELLOW}  ⚠ Skipping (already correct): ${old_path}${NC}"
        return 1
    fi

    # Check if target already exists
    if [[ -e "$new_path" ]]; then
        echo -e "${RED}  ✗ Cannot fix: Target already exists${NC}"
        echo -e "    Old: ${old_path}"
        echo -e "    New: ${new_path}"
        echo "FAILED (target exists): $old_path -> $new_path" >> "$LOG_FILE"
        return 1
    fi

    # Perform the rename
    if mv "$old_path" "$new_path"; then
        echo -e "${GREEN}  ✓ Fixed:${NC}"
        echo -e "    Old: '${basename}'"
        echo -e "    New: '${new_basename}'"
        echo -e "    Full path: ${new_path}"
        echo "FIXED: $old_path -> $new_path" >> "$LOG_FILE"
        ((FILES_FIXED++))
        return 0
    else
        echo -e "${RED}  ✗ Failed to fix: ${old_path}${NC}"
        echo "FAILED (mv error): $old_path -> $new_path" >> "$LOG_FILE"
        return 1
    fi
}

# Main execution
echo -e "${BOLD}Step 1: Scanning for issues...${NC}"
echo ""

# Choose scan method
if [[ "$FULL_SCAN" == "true" ]]; then
    find_trailing_spaces_full
else
    find_trailing_spaces_git
fi

echo -e "${BOLD}═══════════════════════════════════════════════════════════════${NC}"

if [[ $ISSUES_FOUND -eq 0 ]]; then
    echo -e "${GREEN}${BOLD}✓ SUCCESS: No trailing spaces found!${NC}"
    echo -e "${GREEN}Your repository is clean.${NC}"
    exit 0
else
    echo -e "${RED}${BOLD}✗ ISSUES FOUND: ${ISSUES_FOUND} items with trailing spaces${NC}"
    echo ""

    case "$MODE" in
        dry-run)
            echo -e "${YELLOW}Dry-run mode: No changes made.${NC}"
            echo -e "Run without --dry-run to fix these issues."
            exit 1
            ;;
        check)
            echo -e "${RED}Check mode: Issues detected.${NC}"
            exit 1
            ;;
        *)
            echo -e "${RED}Fix mode not yet implemented in v2.0${NC}"
            echo -e "${YELLOW}Use v1.0 (trailing_space_assassin.sh) for fixing${NC}"
            exit 1
            ;;
    esac
fi
