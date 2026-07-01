#!/bin/bash
set -euo pipefail
# Quick script to push the restructure branch
# Run this from a terminal where GitHub authentication works

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

echo "Current branch:"
git branch --show-current

echo ""
echo "Recent commits:"
git log --oneline -5

echo ""
echo "Remote:"
git remote -v

echo ""
echo "Pushing restructure branch to origin..."

# Try SSH first
if git push -u origin restructure 2>/dev/null; then
    echo "✓ Pushed via SSH successfully!"
    exit 0
fi

echo "SSH push failed, trying HTTPS..."

# If SSH fails, push directly to HTTPS URL without rewriting origin.
git push https://github.com/Eaprime1/MANDELBROT.git restructure

echo "✓ Branch pushed!"
echo ""
echo "Next: Create PR at https://github.com/Eaprime1/MANDELBROT/compare/main...restructure"
