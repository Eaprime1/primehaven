#!/bin/bash

################################################################################
# AI CONSORTIUM - Unified Terminal Access
# Integration Hub for Multiple AI Platforms
################################################################################

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# AI Tool Paths
CLAUDE_CLI="/usr/local/bin/claude"
GEMINI_CLI="/usr/local/bin/gemini"
PERPLEXITY_WRAPPER="$HOME/primehaven/conduit/perplexity/scripts/pplx_cli.sh"

# Check status of each AI
check_ai_status() {
    echo -e "${BOLD}${CYAN}AI Consortium Status Check${NC}"
    echo -e "${BOLD}═══════════════════════════════════════════════════════════${NC}"
    echo ""

    # Claude
    if command -v claude &> /dev/null; then
        echo -e "${GREEN}✓${NC} Claude Code       - ${CYAN}/usr/local/bin/claude${NC}"
    else
        echo -e "${RED}✗${NC} Claude Code       - Not found"
    fi

    # Gemini
    if command -v gemini &> /dev/null; then
        if gemini --version &> /dev/null; then
            echo -e "${GREEN}✓${NC} Gemini CLI        - ${CYAN}/usr/local/bin/gemini${NC}"
        else
            echo -e "${YELLOW}⚠${NC} Gemini CLI        - ${YELLOW}Installed but broken (Node.js version issue)${NC}"
        fi
    else
        echo -e "${RED}✗${NC} Gemini CLI        - Not found"
    fi

    # Perplexity
    if command -v perplexity &> /dev/null; then
        echo -e "${YELLOW}⚠${NC} Perplexity        - ${YELLOW}Snap version (GUI-only)${NC}"
    else
        echo -e "${RED}✗${NC} Perplexity        - Not found"
    fi
    if [[ -f "$PERPLEXITY_WRAPPER" ]]; then
        echo -e "${BLUE}ℹ${NC} Perplexity Wrapper - ${CYAN}$PERPLEXITY_WRAPPER${NC} ${YELLOW}(needs setup)${NC}"
    fi

    # ChatGPT
    if command -v chatgpt &> /dev/null; then
        echo -e "${GREEN}✓${NC} ChatGPT CLI       - $(which chatgpt)"
    else
        echo -e "${YELLOW}?${NC} ChatGPT CLI       - ${YELLOW}Not found (needs verification)${NC}"
    fi

    # Grok
    if command -v grok &> /dev/null; then
        echo -e "${GREEN}✓${NC} Grok CLI          - $(which grok)"
    elif command -v grok3 &> /dev/null; then
        echo -e "${GREEN}✓${NC} Grok3 CLI         - $(which grok3)"
    else
        echo -e "${YELLOW}?${NC} Grok3 CLI         - ${YELLOW}Not found (needs verification)${NC}"
    fi

    # Monica AI
    if command -v monica &> /dev/null; then
        echo -e "${GREEN}✓${NC} Monica AI         - $(which monica)"
    else
        echo -e "${YELLOW}?${NC} Monica AI         - ${YELLOW}Not yet integrated${NC}"
    fi

    # Merlin AI
    if command -v merlin &> /dev/null; then
        echo -e "${GREEN}✓${NC} Merlin AI         - $(which merlin)"
    else
        echo -e "${YELLOW}?${NC} Merlin AI         - ${YELLOW}Not yet integrated${NC}"
    fi

    echo ""
}

# Show consortium menu
show_menu() {
    clear
    echo -e "${BOLD}${MAGENTA}"
    cat << "EOF"
╔════════════════════════════════════════════════════════════════╗
║                  AI CONSORTIUM                                ║
║            Terminal Access Coordination Hub                   ║
╚════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    echo -e "${BOLD}${GREEN}GRAVITY${NC} (Structure & Implementation)"
    echo -e "  ${CYAN}1)${NC} Claude Code      - Git ops, systematic development"
    echo -e "  ${CYAN}2)${NC} ChatGPT         - Conversational development"
    echo ""

    echo -e "${BOLD}${BLUE}SYNERGY${NC} (Research & Navigation)"
    echo -e "  ${CYAN}3)${NC} Perplexity      - Research with citations"
    echo -e "  ${CYAN}4)${NC} Grok3           - Real-time information"
    echo ""

    echo -e "${BOLD}${YELLOW}ANTIGRAVITY${NC} (Exploration & Emergence)"
    echo -e "  ${CYAN}5)${NC} Gemini          - Auto-ask, rapid iteration"
    echo -e "  ${CYAN}6)${NC} Monica AI       - Multi-model access"
    echo -e "  ${CYAN}7)${NC} Merlin AI       - Research assistant"
    echo ""

    echo -e "${BOLD}${MAGENTA}TOOLS${NC}"
    echo -e "  ${CYAN}s)${NC} Status Check    - Verify AI availability"
    echo -e "  ${CYAN}h)${NC} Help            - Documentation"
    echo -e "  ${CYAN}0)${NC} Exit"
    echo ""
    echo -ne "${BOLD}Select AI or tool: ${NC}"
}

# Launch Claude
launch_claude() {
    echo -e "${GREEN}Launching Claude Code...${NC}"
    if command -v claude &> /dev/null; then
        claude "$@"
    else
        echo -e "${RED}Error: Claude CLI not found${NC}"
        return 1
    fi
}

# Launch Gemini
launch_gemini() {
    echo -e "${YELLOW}Launching Gemini CLI...${NC}"
    if command -v gemini &> /dev/null; then
        if gemini --version &> /dev/null; then
            gemini "$@"
        else
            echo -e "${RED}Error: Gemini requires Node.js v20+${NC}"
            echo -e "${YELLOW}Current Node version: $(node --version)${NC}"
            echo ""
            echo "To fix:"
            echo "  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -"
            echo "  sudo apt-get install -y nodejs"
            return 1
        fi
    else
        echo -e "${RED}Error: Gemini CLI not found${NC}"
        return 1
    fi
}

# Launch Perplexity
launch_perplexity() {
    echo -e "${BLUE}Launching Perplexity...${NC}"

    # Check for wrapper script
    if [[ -f "$PERPLEXITY_WRAPPER" ]]; then
        "$PERPLEXITY_WRAPPER" "$@"
    else
        echo -e "${YELLOW}Perplexity terminal wrapper not yet configured${NC}"
        echo -e "Setup required in: ${CYAN}$PERPLEXITY_WRAPPER${NC}"
        return 1
    fi
}

# Launch ChatGPT
launch_chatgpt() {
    echo -e "${GREEN}Launching ChatGPT...${NC}"
    if command -v chatgpt &> /dev/null; then
        chatgpt "$@"
    else
        echo -e "${YELLOW}ChatGPT CLI not found${NC}"
        echo "Need to verify if installed or install:"
        echo "  npm install -g chatgpt-cli"
        echo "  OR"
        echo "  pip install chatgpt-cli"
        return 1
    fi
}

# Launch Grok
launch_grok() {
    echo -e "${BLUE}Launching Grok3...${NC}"
    if command -v grok3 &> /dev/null; then
        grok3 "$@"
    elif command -v grok &> /dev/null; then
        grok "$@"
    else
        echo -e "${YELLOW}Grok CLI not found${NC}"
        echo "Need to verify installation location"
        return 1
    fi
}

# Show help
show_help() {
    cat << EOF

${BOLD}AI Consortium - Terminal Access Hub${NC}

${BOLD}USAGE:${NC}
  ai_consortium              Interactive menu
  ai_consortium status       Check AI availability
  ai_consortium claude       Launch Claude directly
  ai_consortium perplexity   Launch Perplexity directly
  ai_consortium help         Show this help

${BOLD}ARCHITECTURE:${NC}
  See: ~/primehaven/docs/AI_CONSORTIUM_ARCHITECTURE.md

${BOLD}TRIADIC PATTERN:${NC}
  GRAVITY      - Claude, ChatGPT (structure, implementation)
  SYNERGY      - Perplexity, Grok (research, navigation)
  ANTIGRAVITY  - Gemini, Monica, Merlin (exploration, emergence)

${BOLD}CONFIGURATION:${NC}
  API Keys: ~/.ai_consortium_env
  Wrappers: ~/primehaven/tools/ai_wrappers/

${BOLD}INTEGRATION:${NC}
  Paradise Launcher: spaces/pryme/gravity/bash/paradise_unified_launcher.sh
  6-Terminal TMUX: Each terminal = AI instance

EOF
}

# Main execution
main() {
    case "${1:-menu}" in
        status)
            check_ai_status
            ;;
        claude)
            shift
            launch_claude "$@"
            ;;
        gemini)
            shift
            launch_gemini "$@"
            ;;
        perplexity)
            shift
            launch_perplexity "$@"
            ;;
        chatgpt)
            shift
            launch_chatgpt "$@"
            ;;
        grok|grok3)
            shift
            launch_grok "$@"
            ;;
        help|-h|--help)
            show_help
            ;;
        menu|"")
            # Interactive menu mode
            while true; do
                show_menu
                read -r choice
                echo ""

                case "$choice" in
                    1) launch_claude ;;
                    2) launch_chatgpt ;;
                    3) launch_perplexity ;;
                    4) launch_grok ;;
                    5) launch_gemini ;;
                    6) echo "Monica AI - Not yet integrated" ;;
                    7) echo "Merlin AI - Not yet integrated" ;;
                    s) check_ai_status ;;
                    h) show_help ;;
                    0) echo "Exiting AI Consortium"; exit 0 ;;
                    *) echo -e "${RED}Invalid choice${NC}" ;;
                esac

                echo ""
                read -p "Press Enter to continue..."
            done
            ;;
        *)
            echo "Unknown command: $1"
            echo "Use 'ai_consortium help' for usage"
            exit 1
            ;;
    esac
}

main "$@"
