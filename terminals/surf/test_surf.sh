#!/bin/bash
# Surf Test Suite - Verify all components work

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/browser_selector.sh"
source "${SCRIPT_DIR}/session_manager.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

PASS=0
FAIL=0

# Test helper
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"

    if [[ "$actual" == "$expected" ]]; then
        echo -e "${GREEN}✓${NC} $test_name"
        ((++PASS))
    else
        echo -e "${RED}✗${NC} $test_name"
        echo "  Expected: $expected"
        echo "  Got: $actual"
        ((++FAIL))
    fi
}

echo "═══════════════════════════════════════"
echo "  Surf Test Suite"
echo "═══════════════════════════════════════"
echo ""

# Test 1: Browser Selection
echo "Testing Browser Selection..."
result=$(select_browser "https://github.com/eaprime1")
assert_equals "w3m" "$result" "GitHub → w3m"

result=$(select_browser "https://docs.python.org")
assert_equals "lynx" "$result" "Python docs → lynx"

result=$(select_browser "https://stackoverflow.com")
assert_equals "w3m" "$result" "Stack Overflow → w3m"

result=$(select_browser "https://example.com")
assert_equals "w3m" "$result" "Default → w3m"

result=$(select_browser "https://oauth.example.com/login")
assert_equals "browsh" "$result" "OAuth → browsh"

result=$(select_browser "test.md")
assert_equals "lynx" "$result" "Markdown → lynx"

echo ""

# Test 2: Browser Override
echo "Testing Browser Override..."
result=$(select_browser "https://github.com" --lynx)
assert_equals "lynx" "$result" "Override to lynx"

result=$(select_browser "https://github.com" --w3m)
assert_equals "w3m" "$result" "Override to w3m"

result=$(select_browser "https://github.com" --browsh)
assert_equals "browsh" "$result" "Override to browsh"

echo ""

# Test 3: Session Manager
echo "Testing Session Manager..."

# Clean test data
rm -rf /tmp/test-surf
export SURF_DIR="/tmp/test-surf"
export SESSIONS_DIR="${SURF_DIR}/sessions"
export HISTORY_FILE="${SURF_DIR}/history.log"
export COMMENTS_FILE="${SURF_DIR}/comments.db"
export BOOKMARKS_FILE="${SURF_DIR}/bookmarks.txt"

init_session

# Test logging
log_visit "https://example.com" "w3m" "success"
if grep -q "example.com" "$HISTORY_FILE"; then
    echo -e "${GREEN}✓${NC} History logging works"
    ((++PASS))
else
    echo -e "${RED}✗${NC} History logging failed"
    ((++FAIL))
fi

# Test comments
add_comment "https://example.com" "Test comment" "test,demo" &>/dev/null
if grep -q "Test comment" "$COMMENTS_FILE"; then
    echo -e "${GREEN}✓${NC} Comment storage works"
    ((++PASS))
else
    echo -e "${RED}✗${NC} Comment storage failed"
    ((++FAIL))
fi

# Test bookmarks
add_bookmark "https://example.com" "Example Site" "test" &>/dev/null
if grep -q "Example Site" "$BOOKMARKS_FILE"; then
    echo -e "${GREEN}✓${NC} Bookmark storage works"
    ((++PASS))
else
    echo -e "${RED}✗${NC} Bookmark storage failed"
    ((++FAIL))
fi

# Test permissions
perms=$(stat -c '%a' "$SURF_DIR")
assert_equals "700" "$perms" "Session directory permissions"

echo ""

# Test 4: File Structure
echo "Testing File Structure..."

files=(
    "${SCRIPT_DIR}/entity_wrapper.sh"
    "${SCRIPT_DIR}/browser_selector.sh"
    "${SCRIPT_DIR}/session_manager.sh"
    "${SCRIPT_DIR}/spirit.sh"
    "${SCRIPT_DIR}/config/lynx.cfg"
    "${SCRIPT_DIR}/config/w3m_config"
    "${SCRIPT_DIR}/config/browsh_config.toml"
)

for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        echo -e "${GREEN}✓${NC} $(basename "$file") exists"
        ((++PASS))
    else
        echo -e "${RED}✗${NC} $(basename "$file") missing"
        ((++FAIL))
    fi
done

echo ""

# Test 5: Entity Wrapper Help
echo "Testing Entity Wrapper..."

if "${SCRIPT_DIR}/entity_wrapper.sh" --help &>/dev/null; then
    echo -e "${GREEN}✓${NC} Entity wrapper help works"
    ((++PASS))
else
    echo -e "${RED}✗${NC} Entity wrapper help failed"
    ((++FAIL))
fi

echo ""

# Summary
echo "═══════════════════════════════════════"
echo "  Test Results"
echo "═══════════════════════════════════════"
echo -e "${GREEN}PASS: $PASS${NC}"
echo -e "${RED}FAIL: $FAIL${NC}"
echo ""

if [[ $FAIL -eq 0 ]]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    exit 1
fi
