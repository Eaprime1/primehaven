#!/bin/bash
# Install Master UI alias for easy access

BASHRC="$HOME/.bashrc"
ALIAS_LINE='alias mui="$HOME/primehaven/tools/master_ui.sh"'

echo "Installing Master UI alias..."
echo ""

# Check if alias already exists
if grep -q "alias mui=" "$BASHRC" 2>/dev/null; then
    echo "✓ Alias 'mui' already exists in ~/.bashrc"
else
    echo "Adding alias to ~/.bashrc..."
    echo "" >> "$BASHRC"
    echo "# Master UI - PrimeHaven Command Center" >> "$BASHRC"
    echo "$ALIAS_LINE" >> "$BASHRC"
    echo "✓ Alias added to ~/.bashrc"
fi

echo ""
echo "To use immediately in this terminal:"
echo "  source ~/.bashrc"
echo ""
echo "Then launch Master UI with:"
echo "  mui"
echo ""
echo "Or use full path:"
echo "  ~/primehaven/tools/master_ui.sh"
