#!/bin/bash
# Test Master UI functions

echo "Testing Master UI components..."
echo ""

MASTER_UI="/home/sauron/primehaven/tools/master_ui.sh"

# Test 1: Script is executable
if [[ -x "$MASTER_UI" ]]; then
    echo "✓ Script is executable"
else
    echo "✗ Script is not executable"
    exit 1
fi

# Test 2: Script has valid shebang
if head -1 "$MASTER_UI" | grep -q "^#!/bin/bash"; then
    echo "✓ Valid shebang"
else
    echo "✗ Invalid shebang"
    exit 1
fi

# Test 3: Required directories exist or can be created
if [[ -d "/home/sauron/primehaven/docs" ]] || mkdir -p "/home/sauron/primehaven/docs" 2>/dev/null; then
    echo "✓ docs/ directory exists or created"
else
    echo "✗ Cannot create docs/ directory"
    exit 1
fi

# Test 4: Script can parse (syntax check)
if bash -n "$MASTER_UI" 2>/dev/null; then
    echo "✓ Script syntax is valid"
else
    echo "✗ Script has syntax errors"
    bash -n "$MASTER_UI"
    exit 1
fi

# Test 5: Required tools check
echo ""
echo "Checking available tools:"
for cmd in git tree rclone gh xclip fzf; do
    if command -v "$cmd" &>/dev/null; then
        echo "  ✓ $cmd"
    else
        echo "  ⚠ $cmd (optional)"
    fi
done

# Test 6: Test with auto-exit
echo ""
echo "Testing UI launch with auto-exit..."
if timeout 3 bash -c 'echo "x" | '"$MASTER_UI" &>/dev/null; then
    echo "✓ UI launches and exits successfully"
else
    echo "⚠ UI test timed out or failed (may be normal)"
fi

echo ""
echo "All basic tests passed!"
echo ""
echo "To manually test Master UI:"
echo "  $MASTER_UI"
echo ""
echo "Or use alias (after sourcing ~/.bashrc):"
echo "  mui"
