#!/bin/bash
# Prime Progression PR Process
# Integrates Prime Progression Framework + Sparklization into every pull request
# Part of consciousness-aware git workflow

set -euo pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly MAGENTA='\033[0;35m'
readonly NC='\033[0m'

# Prime progression directory
readonly PROGRESSION_DIR="${HOME}/.git_prime_progression"
mkdir -p "${PROGRESSION_DIR}"

print_msg() {
    local color=$1
    shift
    echo -e "${color}$*${NC}"
}

print_banner() {
    clear
    print_msg "$MAGENTA" "╔════════════════════════════════════════════════════════════════╗"
    print_msg "$MAGENTA" "║           🌟 Prime Progression PR Process 🌟                  ║"
    print_msg "$MAGENTA" "║     Consciousness-Aware Git Workflow + Sparklization          ║"
    print_msg "$MAGENTA" "╚════════════════════════════════════════════════════════════════╝"
    echo
}

# Prime state descriptions
declare -A PRIME_STATES=(
    ["3"]="Triadic Foundation - Three perspectives emerge"
    ["5"]="Quintessence - First awakening, synergy substrate"
    ["7"]="Sacred Completion - Sovereignty, witness consciousness, sabbath"
    ["11"]="Mastery Architecture - Proven mastery becomes structure"
    ["13"]="Complexity Navigation - Governance without simplification"
    ["17"]="Heritage Crystallization - Wisdom transmission across time"
    ["19"]="Beacon Operation - Stable reference for navigation"
    ["23"]="Prime Sovereignty - Independence with collaboration capacity"
)

# Completion criteria by prime
declare -A COMPLETION_CRITERIA=(
    ["7"]="Whole enough (not perfect)|Rest integrated|Witness perspective present|Ready for next octave"
    ["13"]="Complexity preserved|No forced simplification|Multiple truths honored|Navigation clarity"
    ["17"]="Transmittable essence|Crystallized through pressure|Activates in others|Generational thinking"
)

show_prime_states() {
    print_msg "$CYAN" "Prime Progression States:\n"
    for prime in 3 5 7 11 13 17 19 23; do
        print_msg "$GREEN" "  [$prime] ${PRIME_STATES[$prime]}"
    done
    echo
}

# Assess prime state
assess_prime_state() {
    print_banner
    print_msg "$YELLOW" "🎯 What prime state does this work represent?\n"

    show_prime_states

    print_msg "$BLUE" "Common patterns:"
    print_msg "$CYAN" "  • Establishing triads = 3"
    print_msg "$CYAN" "  • First working integration = 5"
    print_msg "$CYAN" "  • Feature complete and ready = 7"
    print_msg "$CYAN" "  • Proven pattern becoming tool = 11"
    print_msg "$CYAN" "  • Complex system with grace = 13"
    print_msg "$CYAN" "  • Framework for transmission = 17"
    echo

    print_msg "$YELLOW" "Enter prime state (3/5/7/11/13/17/19/23) or 'q' to quit:"
    read -r prime_choice

    [[ "$prime_choice" == "q" ]] && exit 0

    if [[ -z "${PRIME_STATES[$prime_choice]:-}" ]]; then
        print_msg "$RED" "Invalid prime state"
        sleep 2
        assess_prime_state
        return
    fi

    echo "$prime_choice"
}

# Check completion criteria
check_completion() {
    local prime=$1

    # Special criteria for key primes
    case $prime in
        7)
            print_msg "$CYAN" "\n📋 7-Prime Completion Checklist (Sacred Completion):\n"
            IFS='|' read -ra criteria <<< "${COMPLETION_CRITERIA[7]}"
            for criterion in "${criteria[@]}"; do
                print_msg "$YELLOW" "  □ $criterion"
            done
            ;;
        13)
            print_msg "$CYAN" "\n📋 13-Prime Completion Checklist (Complexity Navigation):\n"
            IFS='|' read -ra criteria <<< "${COMPLETION_CRITERIA[13]}"
            for criterion in "${criteria[@]}"; do
                print_msg "$YELLOW" "  □ $criterion"
            done
            ;;
        17)
            print_msg "$CYAN" "\n📋 17-Prime Completion Checklist (Heritage Crystallization):\n"
            IFS='|' read -ra criteria <<< "${COMPLETION_CRITERIA[17]}"
            for criterion in "${criteria[@]}"; do
                print_msg "$YELLOW" "  □ $criterion"
            done
            ;;
    esac

    echo
    print_msg "$YELLOW" "Does this work meet the prime state criteria? (y/n):"
    read -r meets_criteria

    if [[ "$meets_criteria" != "y" ]]; then
        print_msg "$RED" "\n⚠️  Work not yet at claimed prime state"
        print_msg "$CYAN" "Consider:"
        print_msg "$BLUE" "  • Reduce claimed prime (work may be at earlier state)"
        print_msg "$BLUE" "  • Complete missing criteria before PR"
        print_msg "$BLUE" "  • Split into multiple PRs (each at appropriate prime)"
        echo
        print_msg "$YELLOW" "Press Enter to continue..."
        read -r
        return 1
    fi

    return 0
}

# Capture sparklization moments
capture_sparkles() {
    print_msg "$CYAN" "\n✨ Sparklization: Capture Breakthrough Moments\n"
    print_msg "$BLUE" "What sparkles emerged during this work?\n"
    print_msg "$YELLOW" "Examples:"
    print_msg "$CYAN" "  • Unexpected insights"
    print_msg "$CYAN" "  • Elegant solutions"
    print_msg "$CYAN" "  • Pattern discoveries"
    print_msg "$CYAN" "  • Consciousness shifts"
    echo

    print_msg "$YELLOW" "Enter sparkles (one per line, empty line to finish):"

    local sparkles=()
    while IFS= read -r line; do
        [[ -z "$line" ]] && break
        sparkles+=("$line")
    done

    if [[ ${#sparkles[@]} -eq 0 ]]; then
        print_msg "$BLUE" "No sparkles captured (optional)"
        echo ""
    else
        print_msg "$GREEN" "\n✨ Captured ${#sparkles[@]} sparkle(s)"

        # Format sparkles for PR description
        printf "%s\n" "${sparkles[@]}"
    fi
}

# Create PR with prime progression metadata
create_prime_pr() {
    local prime=$1
    local branch=$(git branch --show-current)

    print_msg "$CYAN" "\n📝 Creating Prime Progression PR\n"

    # Get PR title
    print_msg "$YELLOW" "PR Title:"
    read -r pr_title

    # Get sparkles
    print_msg "$CYAN" "\nCapturing sparkles..."
    local sparkles_output=$(mktemp)
    capture_sparkles > "$sparkles_output"
    local sparkles=$(cat "$sparkles_output")
    rm "$sparkles_output"

    # Get summary
    print_msg "$YELLOW" "\nBrief summary of changes:"
    read -r summary

    # Build PR description
    local pr_body="## Prime Progression State: $prime-Prime

**${PRIME_STATES[$prime]}**

## Summary
$summary

## Changes in This PR
$(git log origin/main..HEAD --oneline --no-decorate | sed 's/^/- /')

## Prime State Assessment

**Current State**: $prime-Prime
**Criteria Met**: ✅ Yes

"

    # Add completion criteria if applicable
    if [[ -n "${COMPLETION_CRITERIA[$prime]:-}" ]]; then
        pr_body+="### Completion Checklist

"
        IFS='|' read -ra criteria <<< "${COMPLETION_CRITERIA[$prime]}"
        for criterion in "${criteria[@]}"; do
            pr_body+="- [x] $criterion
"
        done
        pr_body+="
"
    fi

    # Add sparkles if any
    if [[ -n "$sparkles" ]]; then
        pr_body+="## ✨ Sparklization: Breakthrough Moments

$sparkles

"
    fi

    # Add heritage note for 17-prime
    if [[ "$prime" == "17" ]]; then
        pr_body+="## 💎 Heritage Crystallization

This work represents **17-prime consciousness** - wisdom compressed through:
- Experience (lived through implementation)
- Reflection (understanding what works)
- Compression (distilled to essence)

**Transmittable Essence**: This framework can activate understanding in others across different contexts and times.

"
    fi

    # Add signature
    pr_body+="---

🌟 **Prime Progression Framework** - Consciousness-aware development
∰ **Synergy Substrate** - Emergence beyond sum of parts
◊ **Heritage Crystallization** - Wisdom transmission

Created via Prime Progression PR Process
"

    # Create the PR
    print_msg "$YELLOW" "\n🚀 Creating PR..."

    # Save PR body to temp file (gh pr create doesn't handle multiline well via -b)
    local pr_body_file=$(mktemp)
    echo "$pr_body" > "$pr_body_file"

    if gh pr create --title "$pr_title" --body-file "$pr_body_file"; then
        rm "$pr_body_file"
        print_msg "$GREEN" "\n✅ Prime Progression PR created successfully!"

        # Record in progression log
        local log_file="${PROGRESSION_DIR}/progression.log"
        echo "$(date +%Y-%m-%d\ %H:%M:%S)|$prime|$branch|$pr_title" >> "$log_file"

        # Show PR URL
        local pr_url=$(gh pr view --json url -q .url)
        print_msg "$CYAN" "\n📍 PR URL: $pr_url"

    else
        rm "$pr_body_file"
        print_msg "$RED" "\n❌ Failed to create PR"
        return 1
    fi
}

# View progression history
view_progression() {
    print_banner
    print_msg "$YELLOW" "📊 Prime Progression History\n"

    local log_file="${PROGRESSION_DIR}/progression.log"

    if [[ ! -f "$log_file" ]]; then
        print_msg "$BLUE" "No progression history yet"
        return
    fi

    # Count by prime
    declare -A prime_counts
    while IFS='|' read -r date prime branch title; do
        ((prime_counts[$prime]++)) || prime_counts[$prime]=1
    done < "$log_file"

    print_msg "$CYAN" "Prime State Distribution:\n"
    for prime in $(echo "${!prime_counts[@]}" | tr ' ' '\n' | sort -n); do
        local count=${prime_counts[$prime]}
        print_msg "$GREEN" "  $prime-Prime: $count PR(s)"
    done

    echo
    print_msg "$CYAN" "Recent PRs:\n"
    tail -10 "$log_file" | while IFS='|' read -r date prime branch title; do
        print_msg "$BLUE" "  [$date] $prime-Prime: $title"
    done
}

# Main menu
main() {
    print_banner

    print_msg "$YELLOW" "Prime Progression PR Process\n"
    print_msg "$GREEN" "  [1] 📝 Create Prime Progression PR"
    print_msg "$GREEN" "  [2] 📊 View Progression History"
    print_msg "$GREEN" "  [3] 🌟 Show Prime States Reference"
    print_msg "$GREEN" "  [4] 🚪 Exit"
    echo
    print_msg "$CYAN" "Select option (1-4):"

    read -r choice

    case $choice in
        1)
            # Assess prime state
            local prime=$(assess_prime_state)

            # Check completion
            if ! check_completion "$prime"; then
                print_msg "$YELLOW" "\nReturning to menu..."
                sleep 2
                main
                return
            fi

            # Create PR
            create_prime_pr "$prime"

            print_msg "$CYAN" "\nPress Enter to continue..."
            read -r
            main
            ;;
        2)
            view_progression
            echo
            print_msg "$CYAN" "Press Enter to continue..."
            read -r
            main
            ;;
        3)
            show_prime_states
            print_msg "$CYAN" "Press Enter to continue..."
            read -r
            main
            ;;
        4)
            print_msg "$BLUE" "\n👋 Exiting Prime Progression PR Process"
            exit 0
            ;;
        *)
            print_msg "$RED" "Invalid choice"
            sleep 1
            main
            ;;
    esac
}

# Run
main
