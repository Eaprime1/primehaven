#!/usr/bin/env bash
# setup_keys.sh — Secure key setup for primehaven
#
# Stores API keys in ~/.config/primehaven/keys.env (outside the repo, never committed)
# Run once on each machine you use primehaven on.
#
# Usage:
#   ./tools/setup_keys.sh                        # Interactive setup
#   ./tools/setup_keys.sh --from /path/to/agentk.txt  # Seed from existing key file

set -euo pipefail

KEYS_DIR="$HOME/.config/primehaven"
KEYS_FILE="$KEYS_DIR/keys.env"
BASHRC="$HOME/.bashrc"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_msg() { echo -e "${1}${2}${NC}"; }

print_msg "$BLUE" "╔══════════════════════════════════════╗"
print_msg "$BLUE" "║   primehaven key setup               ║"
print_msg "$BLUE" "╚══════════════════════════════════════╝"
echo

# --- Create secure directory ---
mkdir -p "$KEYS_DIR"
chmod 700 "$KEYS_DIR"
print_msg "$GREEN" "✓ Secure key directory: $KEYS_DIR (700)"

# --- Seed from file if provided ---
FROM_FILE=""
if [[ "${1:-}" == "--from" && -n "${2:-}" ]]; then
    FROM_FILE="${2}"
    if [[ ! -f "$FROM_FILE" ]]; then
        print_msg "$RED" "✗ Source file not found: $FROM_FILE"
        exit 1
    fi
fi

# --- Build or update keys.env ---
if [[ -f "$KEYS_FILE" ]]; then
    print_msg "$YELLOW" "⚠  $KEYS_FILE already exists — updating only missing keys"
else
    print_msg "$GREEN" "✓ Creating $KEYS_FILE"
    cat > "$KEYS_FILE" <<'TEMPLATE'
# primehaven API keys
# This file lives outside the repo. Never commit it. Never share it.
# Permissions should be 600: chmod 600 ~/.config/primehaven/keys.env
#
# Load in a shell session:
#   source ~/.config/primehaven/keys.env
# Or add to ~/.bashrc:
#   [ -f ~/.config/primehaven/keys.env ] && source ~/.config/primehaven/keys.env

TEMPLATE
    chmod 600 "$KEYS_FILE"
fi

# --- Anthropic API key ---
if grep -q "^export ANTHROPIC_API_KEY=" "$KEYS_FILE" 2>/dev/null; then
    print_msg "$YELLOW" "  ANTHROPIC_API_KEY already set — skipping"
else
    ANTHROPIC_KEY=""

    # Try to read from --from file
    if [[ -n "$FROM_FILE" ]]; then
        # Accept bare key or 'export KEY=value' format
        ANTHROPIC_KEY=$(grep -o 'sk-ant-[A-Za-z0-9_-]*' "$FROM_FILE" 2>/dev/null | head -1 || true)
        if [[ -n "$ANTHROPIC_KEY" ]]; then
            print_msg "$GREEN" "  ✓ Anthropic key found in $FROM_FILE"
        else
            print_msg "$YELLOW" "  No sk-ant-... key found in $FROM_FILE — enter manually"
        fi
    fi

    # Fall back to interactive input
    if [[ -z "$ANTHROPIC_KEY" ]]; then
        echo
        print_msg "$YELLOW" "  Enter Anthropic API key (sk-ant-...) or leave blank to skip:"
        read -rs ANTHROPIC_KEY
        echo
    fi

    if [[ -n "$ANTHROPIC_KEY" ]]; then
        echo "export ANTHROPIC_API_KEY=\"$ANTHROPIC_KEY\"" >> "$KEYS_FILE"
        print_msg "$GREEN" "  ✓ ANTHROPIC_API_KEY written"
    else
        echo "# export ANTHROPIC_API_KEY=\"\"  # add your key here" >> "$KEYS_FILE"
        print_msg "$YELLOW" "  ANTHROPIC_API_KEY placeholder added — fill in manually"
    fi
fi

# --- Perplexity key placeholder (conduit uses this) ---
if ! grep -q "PERPLEXITY_API_KEY" "$KEYS_FILE" 2>/dev/null; then
    echo "# export PERPLEXITY_API_KEY=\"\"  # needed for conduit/perplexity" >> "$KEYS_FILE"
fi

# --- Wire auto-load into .bashrc ---
LOAD_LINE='[[ -f ~/.config/primehaven/keys.env ]] && source ~/.config/primehaven/keys.env'
if grep -qF "$LOAD_LINE" "$BASHRC" 2>/dev/null; then
    print_msg "$YELLOW" "⚠  Auto-load already in ~/.bashrc"
else
    {
        echo ""
        echo "# primehaven API keys (auto-loaded, never in repo)"
        echo "$LOAD_LINE"
    } >> "$BASHRC"
    print_msg "$GREEN" "✓ Auto-load added to ~/.bashrc"
fi

echo
print_msg "$GREEN" "═══════════════════════════════════════"
print_msg "$GREEN" "  Setup complete"
print_msg "$GREEN" "═══════════════════════════════════════"
echo
print_msg "$BLUE" "  Keys file:   $KEYS_FILE"
print_msg "$BLUE" "  Permissions: $(stat -c '%a' "$KEYS_FILE" 2>/dev/null || stat -f '%OLp' "$KEYS_FILE" 2>/dev/null)"
echo
print_msg "$YELLOW" "  To activate in this terminal:"
print_msg "$BLUE"   "    source ~/.config/primehaven/keys.env"
echo
print_msg "$YELLOW" "  To verify:"
print_msg "$BLUE"   "    echo \${ANTHROPIC_API_KEY:0:12}..."
echo
print_msg "$YELLOW" "  To add more keys later, edit:"
print_msg "$BLUE"   "    \$EDITOR $KEYS_FILE"
echo
