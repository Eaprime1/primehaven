#!/bin/bash

################################################################################
# TRAILING SPACE QUICK CHECK
# Fast check using git ls-files for tracked files only
################################################################################

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Quick Trailing Space Check (tracked files only)"
echo "================================================"
echo ""

ISSUES=0

# Check tracked files
while IFS= read -r file; do
    basename="${file##*/}"
    if [[ "$basename" =~ [[:space:]]$ ]]; then
        echo -e "${RED}✗ Tracked file with trailing space:${NC}"
        echo -e "  ${file}"
        ((ISSUES++))
    fi
done < <(git ls-files -z | tr '\0' '\n')

# Check staged files
while IFS= read -r file; do
    basename="${file##*/}"
    if [[ "$basename" =~ [[:space:]]$ ]]; then
        echo -e "${RED}✗ Staged file with trailing space:${NC}"
        echo -e "  ${file}"
        ((ISSUES++))
    fi
done < <(git diff --cached --name-only)

echo ""
if [[ $ISSUES -eq 0 ]]; then
    echo -e "${GREEN}✓ No trailing spaces found in tracked/staged files${NC}"
    exit 0
else
    echo -e "${RED}✗ Found $ISSUES file(s) with trailing spaces${NC}"
    echo "Run: ./tools/trailing_space_assassin.sh --dry-run for full scan"
    exit 1
fi
