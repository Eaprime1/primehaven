#!/usr/bin/env bash
# Perplexity Conduit Launcher
# Provides easy access to Perplexity CLI with PrimeHaven context

CONDUIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PERPLEXITY_CLI="$CONDUIT_DIR/perplexityai"
CONTEXT_DIR="/home/sauron/primehaven/.perplexity"
WORKSPACE="$CONDUIT_DIR/workspace"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function show_help() {
    cat << EOF
${GREEN}Perplexity Conduit Launcher${NC}

${BLUE}Usage:${NC}
    $0 [OPTIONS] "query"
    $0 --context          # Show PrimeHaven context files
    $0 --workspace        # Open workspace directory
    $0 --examples         # List example queries

${BLUE}Options:${NC}
    -u            Show token usage
    -c            Show citations
    -m <model>    Select model (sonar, sonar-pro, sonar-reasoning)
    -g            Colorful output with Glow
    --save <name> Save output to workspace/research/<name>.md

${BLUE}Examples:${NC}
    # Simple query
    $0 "Explain quantum superposition"

    # With citations and usage
    $0 -uc "Latest research on consciousness and prime numbers"

    # Save to workspace
    $0 --save quantum_consciousness "How do quantum effects relate to consciousness?"

    # Use sonar-pro model
    $0 -m sonar-pro "Deep analysis of antigravity concepts"

${BLUE}PrimeHaven Context:${NC}
    Framework docs: $CONTEXT_DIR/framework/
    Project docs:   $CONTEXT_DIR/project/
    Workspace:      $WORKSPACE/

EOF
}

function show_context() {
    echo -e "${GREEN}PrimeHaven Context Files for Perplexity${NC}\n"
    echo -e "${BLUE}Framework:${NC}"
    ls -lh "$CONTEXT_DIR/framework/" | tail -n +2
    echo -e "\n${BLUE}Project:${NC}"
    ls -lh "$CONTEXT_DIR/project/" | tail -n +2
}

function show_examples() {
    echo -e "${GREEN}Example Queries${NC}\n"
    for script in "$CONDUIT_DIR/examples/queries"/*.sh; do
        if [ -f "$script" ]; then
            echo -e "${BLUE}$(basename "$script")${NC}"
            head -n 2 "$script" | tail -n 1 | sed 's/^# /  /'
            echo
        fi
    done
}

function open_workspace() {
    cd "$WORKSPACE" && pwd && ls -la
}

# Check for special commands
case "$1" in
    --help|-h)
        show_help
        exit 0
        ;;
    --context)
        show_context
        exit 0
        ;;
    --examples)
        show_examples
        exit 0
        ;;
    --workspace)
        open_workspace
        exit 0
        ;;
esac

# Check if API key is set
if [ -z "$PERPLEXITY_API_KEY" ]; then
    # Try to load from config/.env
    if [ -f "$CONDUIT_DIR/config/.env" ]; then
        source "$CONDUIT_DIR/config/.env"
    fi

    if [ -z "$PERPLEXITY_API_KEY" ]; then
        echo -e "${YELLOW}Warning: PERPLEXITY_API_KEY not set${NC}"
        echo "Set it in ~/.bashrc or create config/.env from config/.env.example"
        exit 1
    fi
fi

# Parse arguments
SAVE_NAME=""
PERPLEXITY_ARGS=()
QUERY=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --save)
            SAVE_NAME="$2"
            shift 2
            ;;
        -*)
            # Pass through to perplexity CLI
            if [[ "$1" == "-m" ]]; then
                PERPLEXITY_ARGS+=("$1" "$2")
                shift 2
            else
                PERPLEXITY_ARGS+=("$1")
                shift
            fi
            ;;
        *)
            QUERY="$1"
            shift
            ;;
    esac
done

# Check if query provided
if [ -z "$QUERY" ]; then
    echo -e "${YELLOW}No query provided. Use --help for usage information.${NC}"
    exit 1
fi

# Run perplexity query
echo -e "${GREEN}Querying Perplexity...${NC}\n"

cd "$PERPLEXITY_CLI" || exit 1

if [ -n "$SAVE_NAME" ]; then
    # Save output to workspace
    OUTPUT_FILE="$WORKSPACE/research/${SAVE_NAME}.md"
    mkdir -p "$WORKSPACE/research"

    python3 -m perplexity.perplexity "${PERPLEXITY_ARGS[@]}" "$QUERY" | tee "$OUTPUT_FILE"

    echo -e "\n${GREEN}Output saved to: ${OUTPUT_FILE}${NC}"
else
    # Just display
    python3 -m perplexity.perplexity "${PERPLEXITY_ARGS[@]}" "$QUERY"
fi
