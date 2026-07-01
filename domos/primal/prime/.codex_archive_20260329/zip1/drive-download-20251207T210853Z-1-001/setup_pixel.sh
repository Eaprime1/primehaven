#!/bin/bash

echo "📱 --- INITIALIZING PIXEL COMMAND NODE ---"

# 1. Update Termux Repositories and Upgrade Packages
echo "🔄 Updating package lists..."
pkg update -y && pkg upgrade -y

# 2. Install Core Binaries (Git, Python, OpenSSH)
echo "🛠️  Installing Git, Python, and SSH..."
pkg install git python openssh -y

# 3. Request Storage Access
# This is critical for accessing /storage/emulated/0/
echo "📂 Verifying storage permissions..."
if [ ! -d ~/storage ]; then
    echo "   Requesting access... (Check your screen for a pop-up!)"
    termux-setup-storage
    sleep 2
else
    echo "   ✅ Storage link already exists."
fi

# 4. Install Python Dependencies
echo "🐍 Installing Python libraries..."
pip install GitPython --upgrade

# 5. Create Directory Structure (if missing)
TARGET_DIR="/storage/emulated/0/pixel8a/unexusi"
if [ ! -d "$TARGET_DIR" ]; then
    echo "   ⚠️  Target directory not found: $TARGET_DIR"
    echo "   Creating it now..."
    mkdir -p "$TARGET_DIR"
    echo "   ✅ Created $TARGET_DIR"
else
    echo "   ✅ Target directory found."
fi

# 6. Setup Complete
echo ""
echo "✨ SYSTEM READY ✨"
echo "To launch your fleet commander, type:"
echo "python my.git.phone.py"
echo ""
