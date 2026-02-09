#!/bin/bash
# AI Delegation Menu - Interactive task delegation interface
# Part of Multi-AI Delegation System (Phase 2)

set -euo pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Directories
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DELEGATION_DIR="${HOME}/.ai_delegation"
readonly ACTIVE_DIR="${DELEGATION_DIR}/active"
readonly COMPLETED_DIR="${DELEGATION_DIR}/completed"

# Ensure directories exist
mkdir -p "${ACTIVE_DIR}" "${COMPLETED_DIR}"

# Available AI assistants with capabilities
declare -A AI_CAPABILITIES=(
    ["gemini"]="Code generation, testing, rapid iteration, implementation"
    ["perplexity"]="Research, latest information (2026), citations, deep analysis"
    ["claude"]="Orchestration, integration, code review, architecture"
)

# Print colored message
print_msg() {
    local color=$1
    shift
    echo -e "${color}$*${NC}"
}

# Print banner
print_banner() {
    clear
    print_msg "$CYAN" "╔════════════════════════════════════════════════════════════════╗"
    print_msg "$CYAN" "║          🤖 Multi-AI Delegation System - Phase 2 🤖           ║"
    print_msg "$CYAN" "║              Interactive Task Delegation Menu                  ║"
    print_msg "$CYAN" "╚════════════════════════════════════════════════════════════════╝"
    echo
}

# Show available AI assistants
show_ai_menu() {
    print_msg "$YELLOW" "Available AI Assistants:"
    echo
    local i=1
    for ai in "${!AI_CAPABILITIES[@]}"; do
        print_msg "$GREEN" "  [$i] ${ai^}"
        print_msg "$BLUE" "      ${AI_CAPABILITIES[$ai]}"
        echo
        ((i++))
    done
}

# Get active delegations
get_active_delegations() {
    local count=0
    if [[ -d "$ACTIVE_DIR" ]]; then
        count=$(find "$ACTIVE_DIR" -maxdepth 1 -type f -name "*.task" 2>/dev/null | wc -l)
    fi
    echo "$count"
}

# Show status summary
show_status() {
    local active_count=$(get_active_delegations)
    print_msg "$CYAN" "\n📊 Current Status:"
    print_msg "$YELLOW" "   Active delegations: $active_count"

    if [[ $active_count -gt 0 ]]; then
        echo
        print_msg "$BLUE" "   Recent tasks:"
        find "$ACTIVE_DIR" -maxdepth 1 -type f -name "*.task" -printf "%f\n" 2>/dev/null | \
            head -5 | \
            sed 's/\.task$//' | \
            while read -r task; do
                local ai_type=$(grep "^AI_TYPE=" "$ACTIVE_DIR/${task}.task" 2>/dev/null | cut -d= -f2)
                print_msg "$GREEN" "   • $task → ${ai_type:-unknown}"
            done
    fi
    echo
}

# Create new delegation
create_delegation() {
    print_banner
    print_msg "$YELLOW" "📝 Create New Task Delegation\n"

    # Select AI
    show_ai_menu
    print_msg "$CYAN" "Select AI assistant (1-${#AI_CAPABILITIES[@]}) or 'q' to quit:"
    read -r ai_choice

    [[ "$ai_choice" == "q" ]] && return

    # Map choice to AI name
    local ai_names=($(echo "${!AI_CAPABILITIES[@]}" | tr ' ' '\n' | sort))
    local ai_index=$((ai_choice - 1))

    if [[ $ai_index -lt 0 || $ai_index -ge ${#ai_names[@]} ]]; then
        print_msg "$RED" "❌ Invalid choice"
        sleep 2
        return
    fi

    local selected_ai="${ai_names[$ai_index]}"

    # Get task description
    echo
    print_msg "$CYAN" "Enter task description:"
    read -r task_desc

    [[ -z "$task_desc" ]] && {
        print_msg "$RED" "❌ Task description required"
        sleep 2
        return
    }

    # Get output filename
    print_msg "$CYAN" "Enter output filename (e.g., result.md):"
    read -r output_file

    [[ -z "$output_file" ]] && {
        print_msg "$RED" "❌ Output filename required"
        sleep 2
        return
    }

    # Delegate the task
    echo
    print_msg "$YELLOW" "🚀 Delegating to ${selected_ai^}..."

    if "${SCRIPT_DIR}/ai_delegate.sh" "$selected_ai" "$task_desc" "$output_file"; then
        print_msg "$GREEN" "✅ Task delegated successfully!"
        print_msg "$BLUE" "   Monitor with: ai_delegation_status.sh"
        print_msg "$BLUE" "   Retrieve with: ai_delegation_retrieve.sh ${output_file}"
    else
        print_msg "$RED" "❌ Delegation failed"
    fi

    echo
    print_msg "$CYAN" "Press Enter to continue..."
    read -r
}

# View active delegations
view_delegations() {
    print_banner
    print_msg "$YELLOW" "📋 Active Delegations\n"

    local tasks=($(find "$ACTIVE_DIR" -maxdepth 1 -type f -name "*.task" -printf "%f\n" 2>/dev/null | sed 's/\.task$//'))

    if [[ ${#tasks[@]} -eq 0 ]]; then
        print_msg "$BLUE" "No active delegations"
        echo
        print_msg "$CYAN" "Press Enter to continue..."
        read -r
        return
    fi

    for task in "${tasks[@]}"; do
        local task_file="$ACTIVE_DIR/${task}.task"
        if [[ -f "$task_file" ]]; then
            local ai_type=$(grep "^AI_TYPE=" "$task_file" | cut -d= -f2)
            local task_desc=$(grep "^TASK_DESC=" "$task_file" | cut -d= -f2-)
            local start_time=$(grep "^START_TIME=" "$task_file" | cut -d= -f2)
            local output_file=$(grep "^OUTPUT_FILE=" "$task_file" | cut -d= -f2)

            print_msg "$GREEN" "🤖 ${ai_type^} Task: $task"
            print_msg "$BLUE" "   Description: $task_desc"
            print_msg "$YELLOW" "   Started: $start_time"
            print_msg "$CYAN" "   Output: $output_file"

            # Check if completed
            if [[ -f "$output_file" ]]; then
                print_msg "$GREEN" "   ✅ Completed - ready to retrieve"
            else
                print_msg "$YELLOW" "   ⏳ In progress..."
            fi
            echo
        fi
    done

    print_msg "$CYAN" "Press Enter to continue..."
    read -r
}

# Retrieve completed task
retrieve_task() {
    print_banner
    print_msg "$YELLOW" "📥 Retrieve Completed Task\n"

    # List completed tasks
    local completed_tasks=($(find "$ACTIVE_DIR" -maxdepth 1 -type f -name "*.task" 2>/dev/null))

    if [[ ${#completed_tasks[@]} -eq 0 ]]; then
        print_msg "$BLUE" "No tasks to retrieve"
        echo
        print_msg "$CYAN" "Press Enter to continue..."
        read -r
        return
    fi

    # Show tasks with completion status
    print_msg "$CYAN" "Available tasks:\n"
    local i=1
    local retrievable=()

    for task_file in "${completed_tasks[@]}"; do
        local task_name=$(basename "$task_file" .task)
        local output_file=$(grep "^OUTPUT_FILE=" "$task_file" | cut -d= -f2)
        local ai_type=$(grep "^AI_TYPE=" "$task_file" | cut -d= -f2)

        if [[ -f "$output_file" ]]; then
            print_msg "$GREEN" "  [$i] $task_name (${ai_type^}) - ✅ Ready"
            retrievable+=("$output_file")
            ((i++))
        fi
    done

    if [[ ${#retrievable[@]} -eq 0 ]]; then
        print_msg "$BLUE" "No completed tasks ready to retrieve"
        echo
        print_msg "$CYAN" "Press Enter to continue..."
        read -r
        return
    fi

    echo
    print_msg "$CYAN" "Select task to retrieve (1-${#retrievable[@]}) or 'q' to quit:"
    read -r choice

    [[ "$choice" == "q" ]] && return

    local index=$((choice - 1))
    if [[ $index -lt 0 || $index -ge ${#retrievable[@]} ]]; then
        print_msg "$RED" "❌ Invalid choice"
        sleep 2
        return
    fi

    local selected_output="${retrievable[$index]}"

    echo
    print_msg "$YELLOW" "📥 Retrieving task..."

    if "${SCRIPT_DIR}/ai_delegation_retrieve.sh" "$selected_output"; then
        print_msg "$GREEN" "✅ Task retrieved and archived"
    else
        print_msg "$RED" "❌ Retrieval failed"
    fi

    echo
    print_msg "$CYAN" "Press Enter to continue..."
    read -r
}

# Main menu
main_menu() {
    while true; do
        print_banner
        show_status

        print_msg "$YELLOW" "Main Menu:"
        echo
        print_msg "$GREEN" "  [1] 📝 Create New Delegation"
        print_msg "$GREEN" "  [2] 📋 View Active Delegations"
        print_msg "$GREEN" "  [3] 📥 Retrieve Completed Task"
        print_msg "$GREEN" "  [4] 📊 Show Status (refresh)"
        print_msg "$GREEN" "  [5] 🚪 Exit"
        echo
        print_msg "$CYAN" "Select option (1-5):"

        read -r choice

        case $choice in
            1) create_delegation ;;
            2) view_delegations ;;
            3) retrieve_task ;;
            4) continue ;;  # Just refresh
            5)
                print_msg "$BLUE" "\n👋 Exiting AI Delegation Menu..."
                exit 0
                ;;
            *)
                print_msg "$RED" "❌ Invalid choice"
                sleep 1
                ;;
        esac
    done
}

# Run main menu
main_menu
