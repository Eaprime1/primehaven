#!/bin/bash

################################################################################
# AI Delegation System - Phase 1
# Allows Claude to delegate tasks to other AIs while continuing to work
################################################################################

set -euo pipefail

AI="$1"
TASK="$2"
OUTPUT_NAME="${3:-task_$(date +%s)}"

DELEGATE_DIR="$HOME/primehaven/.ai_delegation"
mkdir -p "$DELEGATE_DIR"

OUTPUT_FILE="$DELEGATE_DIR/$OUTPUT_NAME"
PID_FILE="${OUTPUT_FILE}.pid"
STATUS_FILE="${OUTPUT_FILE}.status"
META_FILE="${OUTPUT_FILE}.meta"

echo "📋 Delegating task to $AI..."
echo ""

# Write metadata
cat > "$META_FILE" << EOF
AI: $AI
Task: $TASK
Started: $(date)
Output: $OUTPUT_FILE
EOF

# Mark as in progress
echo "IN_PROGRESS" > "$STATUS_FILE"

# Delegate based on AI
case "$AI" in
  gemini)
    echo "🤖 Gemini working on: $TASK"
    (
      gemini ask "$TASK" > "$OUTPUT_FILE" 2>&1
      echo "COMPLETE" > "$STATUS_FILE"
      echo "Completed: $(date)" >> "$META_FILE"
    ) &
    echo $! > "$PID_FILE"
    ;;

  perplexity|pplx)
    echo "🔍 Perplexity researching: $TASK"
    (
      llm -m sonar-pro "$TASK" > "$OUTPUT_FILE" 2>&1
      echo "COMPLETE" > "$STATUS_FILE"
      echo "Completed: $(date)" >> "$META_FILE"
    ) &
    echo $! > "$PID_FILE"
    ;;

  chatgpt|gpt)
    echo "💬 ChatGPT working on: $TASK"
    (
      # Placeholder - implement when ChatGPT CLI found
      echo "ChatGPT CLI not yet configured" > "$OUTPUT_FILE"
      echo "ERROR" > "$STATUS_FILE"
    ) &
    echo $! > "$PID_FILE"
    ;;

  *)
    echo "❌ Unknown AI: $AI"
    echo "Available: gemini, perplexity, chatgpt"
    exit 1
    ;;
esac

PID=$(cat "$PID_FILE")

echo ""
echo "✅ Task delegated!"
echo "   AI: $AI"
echo "   PID: $PID"
echo "   Output: $OUTPUT_FILE"
echo ""
echo "Check status: ai_delegation_status"
echo "Retrieve: ai_delegation_retrieve $OUTPUT_NAME"
