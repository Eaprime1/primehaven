#!/bin/bash

################################################################################
# Node.js Upgrade to v22
# Fixes: Gemini CLI + Zapier CLI + all Node-based tools
################################################################################

set -e

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Node.js Upgrade - v18 → v22                                ║"
echo "║  Unlocks: Gemini + Zapier + all Node tools                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Current Node version: $(node --version)"
echo "Target: v22.x"
echo ""
echo "This will:"
echo "  1. Download NodeSource setup script"
echo "  2. Install Node.js v22"
echo "  3. Verify installation"
echo ""
read -p "Continue? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 1
fi

echo ""
echo "Step 1: Downloading NodeSource setup script..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -

echo ""
echo "Step 2: Installing Node.js v22..."
sudo apt-get install -y nodejs

echo ""
echo "Step 3: Verifying installation..."
echo "Node version: $(node --version)"
echo "NPM version: $(npm --version)"

echo ""
echo "Step 4: Testing Gemini..."
if gemini --version 2>&1 | grep -q "version"; then
    echo "✅ Gemini CLI - Working!"
else
    echo "⚠️  Gemini CLI - Still has issues (check manually)"
fi

echo ""
echo "Step 5: Testing Zapier..."
if zapier --version 2>&1 | grep -q "zapier-platform-cli"; then
    echo "✅ Zapier CLI - Working!"
else
    echo "⚠️  Zapier CLI - Still has issues (check manually)"
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Node.js upgrade complete!                                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Next: Run ./tools/review_wrapper_requirements.sh"
