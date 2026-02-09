#!/bin/bash

################################################################################
# AI Delegation Status Checker
# Shows status of all delegated AI tasks
################################################################################

DELEGATE_DIR="$HOME/primehaven/.ai_delegation"

if [ ! -d "$DELEGATE_DIR" ]; then
    echo "No delegated tasks yet."
    echo "Use: ai_delegate <ai> \"task\" output.md"
    exit 0
fi

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Delegated AI Tasks                                         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

FOUND=0

for status_file in "$DELEGATE_DIR"/*.status; do
    [ -f "$status_file" ] || continue

    FOUND=1
    base="${status_file%.status}"
    name="${base##*/}"
    meta_file="${base}.meta"
    pid_file="${base}.pid"

    status=$(cat "$status_file")

    if [ -f "$meta_file" ]; then
        ai=$(grep "^AI:" "$meta_file" | cut -d' ' -f2)
        task=$(grep "^Task:" "$meta_file" | cut -d' ' -f2-)
        started=$(grep "^Started:" "$meta_file" | cut -d' ' -f2-)
    fi

    case "$status" in
        IN_PROGRESS)
            if [ -f "$pid_file" ]; then
                pid=$(cat "$pid_file")
                if ps -p "$pid" > /dev/null 2>&1; then
                    echo "🔄 IN PROGRESS: $name"
                else
                    # Process died
                    echo "❌ FAILED: $name (process died)"
                    echo "ERROR" > "$status_file"
                fi
            else
                echo "❌ FAILED: $name (no PID)"
            fi
            ;;
        COMPLETE)
            echo "✅ COMPLETE: $name"
            ;;
        ERROR)
            echo "❌ ERROR: $name"
            ;;
    esac

    if [ -n "$ai" ]; then
        echo "   AI: $ai"
    fi
    if [ -n "$task" ]; then
        echo "   Task: $task"
    fi
    if [ -n "$started" ]; then
        echo "   Started: $started"
    fi

    echo ""
done

if [ $FOUND -eq 0 ]; then
    echo "No delegated tasks yet."
    echo ""
    echo "Usage:"
    echo "  ai_delegate gemini \"Create tests for auth.ts\" auth_tests.md"
    echo "  ai_delegate perplexity \"Research OAuth 2.1\" oauth_research.md"
fi
