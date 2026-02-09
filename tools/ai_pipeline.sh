#!/bin/bash
# AI Pipeline - Multi-AI orchestration for complex workflows
# Enables sequential or parallel AI task execution
# Part of Multi-AI Delegation System (Phase 2)

set -euo pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly MAGENTA='\033[0;35m'
readonly NC='\033[0m'

# Directories
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PIPELINE_DIR="${HOME}/.ai_delegation/pipelines"
readonly RESULTS_DIR="${HOME}/.ai_delegation/pipeline_results"

# Ensure directories exist
mkdir -p "${PIPELINE_DIR}" "${RESULTS_DIR}"

# Print colored message
print_msg() {
    local color=$1
    shift
    echo -e "${color}$*${NC}"
}

# Print banner
print_banner() {
    print_msg "$MAGENTA" "╔════════════════════════════════════════════════════════════════╗"
    print_msg "$MAGENTA" "║             🔄 Multi-AI Pipeline Orchestration 🔄              ║"
    print_msg "$MAGENTA" "║          Research → Implement → Review Workflow                ║"
    print_msg "$MAGENTA" "╚════════════════════════════════════════════════════════════════╝"
}

# Show usage
usage() {
    print_banner
    echo
    print_msg "$YELLOW" "Usage: $0 [COMMAND] [OPTIONS]"
    echo
    print_msg "$CYAN" "Commands:"
    print_msg "$GREEN" "  create <pipeline_name>     Create new pipeline configuration"
    print_msg "$GREEN" "  run <pipeline_name>        Execute a pipeline"
    print_msg "$GREEN" "  status <pipeline_name>     Check pipeline status"
    print_msg "$GREEN" "  list                       List all pipelines"
    print_msg "$GREEN" "  quick <topic>              Quick 3-stage pipeline for a topic"
    echo
    print_msg "$CYAN" "Quick Pipeline (Research → Implement → Review):"
    print_msg "$BLUE" "  $0 quick \"OAuth 2.1 implementation\""
    print_msg "$BLUE" "    Stage 1: Perplexity researches best practices"
    print_msg "$BLUE" "    Stage 2: Gemini implements the code"
    print_msg "$BLUE" "    Stage 3: Claude reviews and integrates"
    echo
    print_msg "$CYAN" "Examples:"
    print_msg "$BLUE" "  $0 create auth_pipeline"
    print_msg "$BLUE" "  $0 run auth_pipeline"
    print_msg "$BLUE" "  $0 status auth_pipeline"
    print_msg "$BLUE" "  $0 quick \"Add user authentication\""
    echo
}

# Create pipeline configuration
create_pipeline() {
    local pipeline_name=$1
    local pipeline_file="${PIPELINE_DIR}/${pipeline_name}.pipeline"

    if [[ -f "$pipeline_file" ]]; then
        print_msg "$YELLOW" "⚠️  Pipeline already exists: $pipeline_name"
        print_msg "$CYAN" "Edit file: $pipeline_file"
        return 1
    fi

    print_msg "$YELLOW" "📝 Creating pipeline: $pipeline_name"
    echo

    # Create template pipeline configuration
    cat > "$pipeline_file" <<'EOF'
# Multi-AI Pipeline Configuration
# Each stage delegates to a specific AI with dependencies

# Stage format:
# STAGE_<N>_AI=<ai_type>           # gemini, perplexity, or claude
# STAGE_<N>_TASK=<task_description>
# STAGE_<N>_OUTPUT=<output_file>
# STAGE_<N>_DEPENDS=<stage_numbers_comma_separated>  # optional

# Example: Research → Implement → Review
STAGE_1_AI=perplexity
STAGE_1_TASK=Research OAuth 2.1 best practices and security considerations
STAGE_1_OUTPUT=oauth_research.md
STAGE_1_DEPENDS=

STAGE_2_AI=gemini
STAGE_2_TASK=Implement OAuth 2.1 authentication based on research findings
STAGE_2_OUTPUT=oauth_implementation.md
STAGE_2_DEPENDS=1

STAGE_3_AI=claude
STAGE_3_TASK=Review OAuth implementation and integrate with existing codebase
STAGE_3_OUTPUT=oauth_review.md
STAGE_3_DEPENDS=2

# Parallel example (stages 4 and 5 run simultaneously):
# STAGE_4_AI=gemini
# STAGE_4_TASK=Generate unit tests
# STAGE_4_OUTPUT=unit_tests.md
# STAGE_4_DEPENDS=2
#
# STAGE_5_AI=perplexity
# STAGE_5_TASK=Research latest security vulnerabilities
# STAGE_5_OUTPUT=security_audit.md
# STAGE_5_DEPENDS=2
EOF

    print_msg "$GREEN" "✅ Pipeline configuration created: $pipeline_file"
    print_msg "$CYAN" "Edit the file to customize stages, then run with:"
    print_msg "$BLUE" "  $0 run $pipeline_name"
}

# Parse pipeline configuration
parse_pipeline() {
    local pipeline_file=$1
    declare -gA STAGES

    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue

        # Remove leading/trailing whitespace
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)

        STAGES["$key"]="$value"
    done < "$pipeline_file"
}

# Get number of stages
get_stage_count() {
    local count=0
    for key in "${!STAGES[@]}"; do
        if [[ "$key" =~ ^STAGE_([0-9]+)_AI$ ]]; then
            local stage_num="${BASH_REMATCH[1]}"
            ((stage_num > count)) && count=$stage_num
        fi
    done
    echo "$count"
}

# Check if stage dependencies are met
check_dependencies() {
    local stage=$1
    local depends_key="STAGE_${stage}_DEPENDS"
    local depends="${STAGES[$depends_key]:-}"

    [[ -z "$depends" ]] && return 0  # No dependencies

    # Check each dependency
    IFS=',' read -ra deps <<< "$depends"
    for dep in "${deps[@]}"; do
        dep=$(echo "$dep" | xargs)  # Trim whitespace
        local dep_output="${STAGES[STAGE_${dep}_OUTPUT]}"
        local dep_file="${RESULTS_DIR}/${dep_output}"

        if [[ ! -f "$dep_file" ]]; then
            return 1  # Dependency not met
        fi
    done

    return 0  # All dependencies met
}

# Execute a pipeline stage
execute_stage() {
    local stage=$1
    local ai="${STAGES[STAGE_${stage}_AI]}"
    local task="${STAGES[STAGE_${stage}_TASK]}"
    local output="${STAGES[STAGE_${stage}_OUTPUT]}"
    local output_file="${RESULTS_DIR}/${output}"

    print_msg "$YELLOW" "🚀 Stage $stage: Delegating to ${ai^}..."
    print_msg "$BLUE" "   Task: $task"
    print_msg "$CYAN" "   Output: $output"

    # Delegate to AI
    if "${SCRIPT_DIR}/ai_delegate.sh" "$ai" "$task" "$output_file"; then
        print_msg "$GREEN" "✅ Stage $stage delegated successfully"
        return 0
    else
        print_msg "$RED" "❌ Stage $stage failed"
        return 1
    fi
}

# Run pipeline
run_pipeline() {
    local pipeline_name=$1
    local pipeline_file="${PIPELINE_DIR}/${pipeline_name}.pipeline"

    if [[ ! -f "$pipeline_file" ]]; then
        print_msg "$RED" "❌ Pipeline not found: $pipeline_name"
        print_msg "$CYAN" "Create with: $0 create $pipeline_name"
        return 1
    fi

    print_banner
    print_msg "$YELLOW" "\n🔄 Executing pipeline: $pipeline_name\n"

    # Parse configuration
    parse_pipeline "$pipeline_file"

    local stage_count=$(get_stage_count)
    print_msg "$CYAN" "Pipeline has $stage_count stages\n"

    # Execute stages
    local completed=()
    local pending=($(seq 1 $stage_count))

    while [[ ${#pending[@]} -gt 0 ]]; do
        local progress=false

        for stage in "${pending[@]}"; do
            if check_dependencies "$stage"; then
                execute_stage "$stage"
                completed+=("$stage")
                pending=("${pending[@]/$stage}")
                progress=true
                echo
            fi
        done

        if [[ "$progress" == false && ${#pending[@]} -gt 0 ]]; then
            print_msg "$YELLOW" "⏳ Waiting for dependencies to complete..."
            print_msg "$CYAN" "   Remaining stages: ${pending[*]}"
            sleep 5
        fi
    done

    print_msg "$GREEN" "✅ Pipeline completed: $pipeline_name"
    print_msg "$CYAN" "Results in: $RESULTS_DIR"
}

# Check pipeline status
check_status() {
    local pipeline_name=$1
    local pipeline_file="${PIPELINE_DIR}/${pipeline_name}.pipeline"

    if [[ ! -f "$pipeline_file" ]]; then
        print_msg "$RED" "❌ Pipeline not found: $pipeline_name"
        return 1
    fi

    print_banner
    print_msg "$YELLOW" "\n📊 Pipeline Status: $pipeline_name\n"

    parse_pipeline "$pipeline_file"
    local stage_count=$(get_stage_count)

    for stage in $(seq 1 $stage_count); do
        local ai="${STAGES[STAGE_${stage}_AI]}"
        local task="${STAGES[STAGE_${stage}_TASK]}"
        local output="${STAGES[STAGE_${stage}_OUTPUT]}"
        local output_file="${RESULTS_DIR}/${output}"

        print_msg "$CYAN" "Stage $stage (${ai^}):"
        print_msg "$BLUE" "  Task: $task"

        if [[ -f "$output_file" ]]; then
            print_msg "$GREEN" "  ✅ Completed"
        else
            print_msg "$YELLOW" "  ⏳ Pending"
        fi
        echo
    done
}

# List all pipelines
list_pipelines() {
    print_banner
    print_msg "$YELLOW" "\n📋 Available Pipelines:\n"

    local pipelines=($(find "$PIPELINE_DIR" -maxdepth 1 -type f -name "*.pipeline" 2>/dev/null))

    if [[ ${#pipelines[@]} -eq 0 ]]; then
        print_msg "$BLUE" "No pipelines found"
        print_msg "$CYAN" "Create one with: $0 create <pipeline_name>"
        return
    fi

    for pipeline_file in "${pipelines[@]}"; do
        local name=$(basename "$pipeline_file" .pipeline)
        parse_pipeline "$pipeline_file"
        local stage_count=$(get_stage_count)

        print_msg "$GREEN" "📦 $name"
        print_msg "$BLUE" "   Stages: $stage_count"

        # Show stage summary
        for stage in $(seq 1 $stage_count); do
            local ai="${STAGES[STAGE_${stage}_AI]}"
            local output="${STAGES[STAGE_${stage}_OUTPUT]}"
            local output_file="${RESULTS_DIR}/${output}"

            local status="⏳ pending"
            [[ -f "$output_file" ]] && status="✅ done"

            print_msg "$CYAN" "   • Stage $stage: ${ai^} ($status)"
        done
        echo
    done
}

# Quick pipeline (Research → Implement → Review)
quick_pipeline() {
    local topic=$1
    local pipeline_name="quick_$(date +%Y%m%d_%H%M%S)"
    local pipeline_file="${PIPELINE_DIR}/${pipeline_name}.pipeline"

    print_banner
    print_msg "$YELLOW" "\n⚡ Creating quick pipeline for: $topic\n"

    # Create quick pipeline configuration
    cat > "$pipeline_file" <<EOF
# Quick Pipeline: $topic
# Auto-generated: $(date)

STAGE_1_AI=perplexity
STAGE_1_TASK=Research best practices and latest information about: $topic
STAGE_1_OUTPUT=${pipeline_name}_research.md
STAGE_1_DEPENDS=

STAGE_2_AI=gemini
STAGE_2_TASK=Implement solution for: $topic (use research from previous stage)
STAGE_2_OUTPUT=${pipeline_name}_implementation.md
STAGE_2_DEPENDS=1

STAGE_3_AI=claude
STAGE_3_TASK=Review and integrate implementation for: $topic
STAGE_3_OUTPUT=${pipeline_name}_review.md
STAGE_3_DEPENDS=2
EOF

    print_msg "$GREEN" "✅ Quick pipeline created: $pipeline_name"
    echo
    print_msg "$CYAN" "Pipeline stages:"
    print_msg "$BLUE" "  1. Perplexity: Research best practices"
    print_msg "$BLUE" "  2. Gemini: Implement solution"
    print_msg "$BLUE" "  3. Claude: Review and integrate"
    echo
    print_msg "$YELLOW" "🚀 Executing pipeline..."
    echo

    run_pipeline "$pipeline_name"
}

# Main
main() {
    if [[ $# -eq 0 ]]; then
        usage
        exit 1
    fi

    local command=$1
    shift

    case $command in
        create)
            [[ $# -eq 0 ]] && { print_msg "$RED" "❌ Pipeline name required"; exit 1; }
            create_pipeline "$1"
            ;;
        run)
            [[ $# -eq 0 ]] && { print_msg "$RED" "❌ Pipeline name required"; exit 1; }
            run_pipeline "$1"
            ;;
        status)
            [[ $# -eq 0 ]] && { print_msg "$RED" "❌ Pipeline name required"; exit 1; }
            check_status "$1"
            ;;
        list)
            list_pipelines
            ;;
        quick)
            [[ $# -eq 0 ]] && { print_msg "$RED" "❌ Topic required"; exit 1; }
            quick_pipeline "$*"
            ;;
        *)
            print_msg "$RED" "❌ Unknown command: $command"
            usage
            exit 1
            ;;
    esac
}

main "$@"
