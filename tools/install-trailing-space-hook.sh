#!/bin/bash

################################################################################
# Install Trailing Space Pre-Commit Hook
################################################################################

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
HOOK_SOURCE="${REPO_ROOT}/tools/pre-commit-hook-trailing-spaces"
HOOK_TARGET="${REPO_ROOT}/.git/hooks/pre-commit"

echo "Installing trailing space pre-commit hook..."
echo ""

# Check if hook already exists
if [[ -f "$HOOK_TARGET" ]] || [[ -L "$HOOK_TARGET" ]]; then
    echo "WARNING: Pre-commit hook already exists at:"
    echo "  $HOOK_TARGET"
    echo ""
    
    # Check if it's our hook
    if [[ -L "$HOOK_TARGET" ]]; then
        current_target=$(readlink "$HOOK_TARGET")
        if [[ "$current_target" == *"pre-commit-hook-trailing-spaces"* ]]; then
            echo "This is already our trailing space hook. Nothing to do."
            exit 0
        fi
    fi
    
    # Offer to backup
    backup="${HOOK_TARGET}.backup.$(date +%Y%m%d_%H%M%S)"
    read -p "Backup existing hook to ${backup}? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        mv "$HOOK_TARGET" "$backup"
        echo "Backed up to: $backup"
    else
        echo "Installation cancelled."
        exit 1
    fi
fi

# Create symlink
ln -s "../../tools/pre-commit-hook-trailing-spaces" "$HOOK_TARGET"

echo "✓ Pre-commit hook installed successfully!"
echo ""
echo "The hook will now check for trailing spaces before each commit."
echo "To bypass the hook (not recommended): git commit --no-verify"
