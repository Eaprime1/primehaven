#!/bin/bash

################################################################################
# TRAILING SPACE ASSASSIN
# Critical infrastructure for primehaven ecosystem
#
# PURPOSE: Detect and eliminate trailing spaces in filenames/folders
# WHY: Trailing spaces cause massive silent corruption - files/folders become
#      invisible to some systems, breaking cross-platform compatibility
#
# USAGE:
#   ./trailing_space_assassin.sh              # Interactive mode (scan + ask to fix)
#   ./trailing_space_assassin.sh --dry-run    # Preview mode (scan only)
#   ./trailing_space_assassin.sh --auto-fix   # Automatic fix (use with caution)
#   ./trailing_space_assassin.sh --check      # Exit 1 if issues found (for CI/hooks)
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

# Parse arguments
MODE="interactive"
case "${1:-}" in
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
        echo "Trailing Space Assassin - Eliminate filename trailing spaces"
        echo ""
        echo "Usage:"
        echo "  $0              Interactive mode (scan + ask to fix)"
        echo "  $0 --dry-run    Preview mode (scan only, no changes)"
        echo "  $0 --auto-fix   Automatic fix (use with caution)"
        echo "  $0 --check      Check mode (exit 1 if issues found, for CI/hooks)"
        echo "  $0 --help       Show this help"
        exit 0
        ;;
esac

# Print banner
echo -e "${BOLD}${MAGENTA}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         TRAILING SPACE ASSASSIN v1.0                         ║"
echo "║         Critical Infrastructure for PrimeHaven               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "${CYAN}Repository: ${REPO_ROOT}${NC}"
echo -e "${CYAN}Mode: ${MODE}${NC}"
echo ""

# Create backup directory if fixing
if [[ "$MODE" == "auto-fix" ]] || [[ "$MODE" == "interactive" ]]; then
    mkdir -p "$BACKUP_DIR"
    echo -e "${BLUE}Backup directory: ${BACKUP_DIR}${NC}"
    echo -e "${BLUE}Log file: ${LOG_FILE}${NC}"
    echo ""
    echo "$(date): Starting trailing space scan in ${MODE} mode" > "$LOG_FILE"
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

# Function to find all files/folders with trailing spaces
find_trailing_spaces() {
    echo -e "${YELLOW}Scanning for trailing spaces...${NC}"
    echo ""
    
    local count=0
    
    # Optimized find command - excludes common large directories
    # PrimeHaven-specific: Exclude massive gravity content (primal/spaces)
    # Use maxdepth for faster scanning if repository is huge
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
        
        # Get just the basename
        local basename="${item##*/}"
        
        # Skip if empty (root dir case)
        [[ -z "$basename" ]] && continue
        
        # Check if basename ends with space(s)
        if [[ "$basename" =~ [[:space:]]$ ]]; then
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
            echo -e "  Trailing: ${RED}${space_count} space(s)${NC} → '${visual}${RED}[${space_count}×SPACE]${NC}'"
            echo ""
            
            # Log it
            if [[ "$MODE" == "auto-fix" ]] || [[ "$MODE" == "interactive" ]]; then
                echo "FOUND: $item (${space_count} trailing spaces)" >> "$LOG_FILE"
            fi
        fi
    done
    
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

# Function to fix all issues
fix_all_issues() {
    echo -e "${YELLOW}${BOLD}Fixing trailing spaces...${NC}"
    echo ""
    
    local temp_file=$(mktemp)
    
    # Find all items with trailing spaces (deepest first to avoid parent/child conflicts)
    # PrimeHaven-specific: Exclude massive gravity content (primal/spaces)
    find "$REPO_ROOT" -depth \
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
        
        local basename="${item##*/}"
        [[ -z "$basename" ]] && continue
        
        if [[ "$basename" =~ [[:space:]]$ ]]; then
            echo "$item"
        fi
    done > "$temp_file"
    
    # Process each item
    local total=$(wc -l < "$temp_file")
    local current=0
    
    while IFS= read -r item; do
        ((current++))
        echo -e "${CYAN}[${current}/${total}]${NC} Processing: ${item}"
        
        # Warn about submodules
        if is_in_submodule "$item"; then
            echo -e "${RED}  ⚠ WARNING: This item is in a git submodule!${NC}"
            if [[ "$MODE" == "interactive" ]]; then
                read -p "  Continue fixing this item? [y/N] " -n 1 -r
                echo
                if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                    echo "  Skipped by user"
                    continue
                fi
            fi
        fi
        
        fix_item "$item"
        echo ""
    done < "$temp_file"
    
    rm -f "$temp_file"
}

# Main execution
echo -e "${BOLD}Step 1: Scanning for issues...${NC}"
echo ""

find_trailing_spaces

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
        auto-fix)
            echo -e "${YELLOW}Auto-fix mode: Proceeding with fixes...${NC}"
            echo ""
            fix_all_issues
            ;;
        interactive)
            echo -e "${YELLOW}Interactive mode${NC}"
            read -p "Do you want to fix these issues? [y/N] " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo ""
                fix_all_issues
            else
                echo -e "${YELLOW}No changes made.${NC}"
                exit 1
            fi
            ;;
    esac
    
    echo ""
    echo -e "${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    if [[ $FILES_FIXED -gt 0 ]]; then
        echo -e "${GREEN}${BOLD}✓ COMPLETE: Fixed ${FILES_FIXED} items${NC}"
        echo -e "${BLUE}Log saved to: ${LOG_FILE}${NC}"
        echo ""
        echo -e "${YELLOW}NEXT STEPS:${NC}"
        echo "1. Review the changes with: git status"
        echo "2. Test your repository to ensure everything works"
        echo "3. Commit the fixes with a descriptive message"
        echo "4. Consider installing the pre-commit hook to prevent future issues"
    else
        echo -e "${YELLOW}No items were fixed (possibly due to conflicts or errors)${NC}"
        echo -e "${BLUE}Check log: ${LOG_FILE}${NC}"
    fi
fi
