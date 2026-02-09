#!/bin/bash

################################################################################
# AI Delegation Result Retriever
# Retrieves and displays results from delegated AI tasks
################################################################################

OUTPUT_NAME="$1"

if [ -z "$OUTPUT_NAME" ]; then
    echo "Usage: ai_delegation_retrieve <output_name>"
    echo ""
    echo "Available outputs:"
    ai_delegation_status | grep -E "COMPLETE|ERROR" | awk '{print "  -", $3}'
    exit 1
fi

DELEGATE_DIR="$HOME/primehaven/.ai_delegation"
OUTPUT_FILE="$DELEGATE_DIR/$OUTPUT_NAME"
STATUS_FILE="${OUTPUT_FILE}.status"
META_FILE="${OUTPUT_FILE}.meta"

if [ ! -f "$OUTPUT_FILE" ]; then
    echo "❌ Output not found: $OUTPUT_NAME"
    echo ""
    echo "Available:"
    ls -1 "$DELEGATE_DIR"/*.status 2>/dev/null | while read f; do
        base="${f%.status}"
        name="${base##*/}"
        status=$(cat "$f")
        echo "  - $name [$status]"
    done
    exit 1
fi

# Check status
if [ -f "$STATUS_FILE" ]; then
    STATUS=$(cat "$STATUS_FILE")
else
    STATUS="UNKNOWN"
fi

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Delegated Task Result                                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Show metadata
if [ -f "$META_FILE" ]; then
    cat "$META_FILE"
    echo ""
fi

echo "Status: $STATUS"
echo "══════════════════════════════════════════════════════════════"
echo ""

# Show output
if [ "$STATUS" == "IN_PROGRESS" ]; then
    echo "⚠️  Task still in progress. Showing partial output:"
    echo ""
fi

cat "$OUTPUT_FILE"
