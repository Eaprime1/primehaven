# Paradise Wrapper Integration Plan

**Created**: 2026-02-08 21:35
**Purpose**: Integrate new CLI wrappers into existing Paradise Unified launcher
**Discovery**: Paradise already has 6 launcher variants and comprehensive infrastructure

---

## Key Discovery

**You already built the orchestration layer!**

```
primal/pryme/gravity/bash/
├── paradise_unified.sh    # 401 lines - main launcher
├── paradise.sh            # 24KB - original version
├── paradise_v2.sh         # 24KB - v2 iteration
├── tmux_paradise.sh       # TMUX integration
├── browser_launcher.sh    # Browser automation
├── sync_all_repos.sh      # Repository sync
├── sync_repo.sh           # Single repo sync
├── sync_gdrive.sh         # Google Drive sync
└── sync_today_gdrive.sh   # Daily sync
```

**Current Paradise Categories**:
1. 🌐 Browsers & Sites
2. 🤖 AI Platforms (ChatGPT, Claude, Perplexity, Gemini - web only)
3. 📂 Development Sites
4. 🔧 GitHub & Git
5. ⚙️ System Setup
6. 🛠 PRIME & Tools
7. 💾 Repository Sync
8. 🖥️ TMUX Sessions
9. 📊 Documentation

---

## Vision: Enhanced Paradise with CLI Integration

### Current State
```bash
# Paradise launches web interfaces:
AI_PLATFORMS -> Opens browser to claude.ai, gemini.google.com, etc.
```

### Enhanced State
```bash
# Paradise launches CLI tools + web interfaces:
AI_PLATFORMS -> Submenu:
  1. 🌐 Gemini Web
  2. 💻 Gemini CLI
  3. 🤝 Delegate to Gemini
  4. 📄 Check Gemini Tasks
```

---

## Integration Strategy

### Add New Paradise Category: "🤖 AI CLI & Delegation"

```bash
*"AI CLI & Delegation"*)
    declare -a AI_CLI=(
        "💬 Claude CLI (current session)"
        "🎨 Gemini CLI"
        "🔍 Perplexity CLI"
        "🤝 AI Delegation Menu"
        "📊 View Delegated Tasks"
        "📥 Retrieve Task Results"
        "🔄 Multi-AI Pipeline"
        "⬅️ Back"
    )

    AI_CLI_CHOICE=$(printf "%s\n" "${AI_CLI[@]}" | fzf \
        --prompt="AI CLI > " \
        --border=rounded \
        --reverse)

    case "$AI_CLI_CHOICE" in
        *"Claude CLI"*)
            # Launch Claude Code
            cd ~/primehaven && claude
            ;;
        *"Gemini CLI"*)
            # Interactive Gemini
            echo "Ask Gemini:"
            read -p "> " QUERY
            gemini ask "$QUERY"
            ;;
        *"Perplexity CLI"*)
            # Interactive Perplexity
            echo "Research with Perplexity:"
            read -p "> " QUERY
            llm -m sonar-pro "$QUERY"
            ;;
        *"Delegation Menu"*)
            # Show delegation submenu
            ~/primehaven/tools/ai_delegation_menu.sh
            ;;
        *"View Delegated"*)
            ~/primehaven/tools/ai_delegation_status.sh
            ;;
        *"Retrieve"*)
            ~/primehaven/tools/ai_delegation_retrieve_menu.sh
            ;;
        *"Multi-AI Pipeline"*)
            ~/primehaven/tools/ai_pipeline.sh
            ;;
    esac
    ;;
```

### Add Category: "🔗 Service Wrappers"

```bash
*"Service Wrappers"*)
    declare -a SERVICES=(
        "📝 Notion CLI"
        "🚀 Vercel CLI"
        "🔍 Sentry CLI"
        "📊 PostHog CLI"
        "📋 Atlassian (Jira/Confluence)"
        "📌 Pinecone CLI"
        "🤗 Hugging Face CLI"
        "💳 Stripe CLI"
        "🎨 Figma CLI"
        "⬅️ Back"
    )

    SERVICE_CHOICE=$(printf "%s\n" "${SERVICES[@]}" | fzf \
        --prompt="Service > " \
        --border=rounded \
        --reverse)

    case "$SERVICE_CHOICE" in
        *Notion*)
            ~/primehaven/wrappers/bin/notion_menu.sh
            ;;
        *Vercel*)
            ~/primehaven/wrappers/bin/vercel_menu.sh
            ;;
        *Sentry*)
            ~/primehaven/wrappers/bin/sentry_menu.sh
            ;;
        # ... etc
    esac
    ;;
```

### Add Category: "🗄️ Archive & Domos"

```bash
*"Archive & Domos"*)
    declare -a ARCHIVE_OPS=(
        "📸 Create Entity Snapshot"
        "🗂️ Create Project Archive"
        "📚 Create Domos-Level Archive"
        "🔍 Browse Archives"
        "♻️ Restore from Archive"
        "🏷️ Tag Current State"
        "🌳 Create Worktree (Entity)"
        "📊 Archive Statistics"
        "⬅️ Back"
    )

    ARCHIVE_CHOICE=$(printf "%s\n" "${ARCHIVE_OPS[@]}" | fzf \
        --prompt="Archive > " \
        --border=rounded \
        --reverse)

    case "$ARCHIVE_CHOICE" in
        *"Entity Snapshot"*)
            echo "Entity name (e.g., notion, sentry, perplexity):"
            read -p "> " ENTITY
            ~/primehaven/tools/archive_entity.sh "$ENTITY"
            ;;
        *"Project Archive"*)
            echo "Project name:"
            read -p "> " PROJECT
            ~/primehaven/tools/archive_project.sh "$PROJECT"
            ;;
        *"Domos-Level"*)
            # Full system snapshot at Domos consciousness level
            ~/primehaven/tools/archive_domos.sh
            ;;
        *"Browse"*)
            ls -lh ~/primehaven/archives/
            ;;
        *"Worktree"*)
            echo "Entity name for isolated worktree:"
            read -p "> " ENTITY
            ~/primehaven/tools/create_entity_worktree.sh "$ENTITY"
            ;;
    esac
    ;;
```

---

## New Tools to Create

### 1. AI Delegation Menu
```bash
# ~/primehaven/tools/ai_delegation_menu.sh

#!/bin/bash
echo "╔════════════════════════════════════════════╗"
echo "║  Delegate Task to AI                      ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Select AI
AI=$(printf "gemini\nperplexity\nauto" | fzf --prompt="AI > ")

echo ""
echo "Task description:"
read -p "> " TASK

echo ""
echo "Output filename (e.g., research_oauth.md):"
read -p "> " OUTPUT

# Delegate
~/primehaven/tools/ai_delegate.sh "$AI" "$TASK" "$OUTPUT"

echo ""
read -p "Press Enter to continue..."
```

### 2. Multi-AI Pipeline
```bash
# ~/primehaven/tools/ai_pipeline.sh

#!/bin/bash
# Multi-AI pipeline orchestration

echo "╔════════════════════════════════════════════╗"
echo "║  Multi-AI Pipeline Builder                ║"
echo "╚════════════════════════════════════════════╝"
echo ""

echo "Step 1: Research (Perplexity)"
echo "Research topic:"
read -p "> " RESEARCH_TOPIC

echo ""
echo "Step 2: Implementation (Gemini)"
echo "What to build based on research:"
read -p "> " IMPL_TASK

echo ""
echo "Step 3: Review (Claude - you)"
echo "Review focus areas:"
read -p "> " REVIEW_FOCUS

echo ""
echo "Pipeline Setup:"
echo "  1. Perplexity researches: $RESEARCH_TOPIC"
echo "  2. Gemini implements: $IMPL_TASK"
echo "  3. Claude reviews: $REVIEW_FOCUS"
echo ""

read -p "Execute pipeline? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Start pipeline
    TIMESTAMP=$(date +%s)

    echo "Starting Perplexity research..."
    ~/primehaven/tools/ai_delegate.sh perplexity \
        "$RESEARCH_TOPIC" \
        "pipeline_${TIMESTAMP}_research.md"

    # Wait for research (could be async, but for simplicity...)
    sleep 2

    echo "Starting Gemini implementation..."
    ~/primehaven/tools/ai_delegate.sh gemini \
        "$IMPL_TASK (reference: pipeline_${TIMESTAMP}_research.md)" \
        "pipeline_${TIMESTAMP}_implementation.md"

    echo ""
    echo "Pipeline initiated!"
    echo "Monitor: ai_delegation_status"
    echo "When complete, Claude can review both outputs."
fi
```

### 3. Archive Entity Script
```bash
# ~/primehaven/tools/archive_entity.sh

#!/bin/bash
ENTITY="$1"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE_DIR="$HOME/primehaven/archives/$ENTITY"

mkdir -p "$ARCHIVE_DIR"

echo "Creating $ENTITY snapshot..."

# Git archive of relevant files
if [ "$ENTITY" = "notion" ]; then
    # Archive Notion-related files
    git archive --format=tar.gz \
        --prefix="${ENTITY}-${TIMESTAMP}/" \
        HEAD \
        $(git ls-files | grep -i notion) \
        > "$ARCHIVE_DIR/${ENTITY}-${TIMESTAMP}.tar.gz"
elif [ "$ENTITY" = "sentry" ]; then
    # Archive Sentry-related files
    git archive --format=tar.gz \
        --prefix="${ENTITY}-${TIMESTAMP}/" \
        HEAD \
        $(git ls-files | grep -i sentry) \
        > "$ARCHIVE_DIR/${ENTITY}-${TIMESTAMP}.tar.gz"
else
    # Generic entity archive
    git archive --format=tar.gz \
        --prefix="${ENTITY}-${TIMESTAMP}/" \
        HEAD > "$ARCHIVE_DIR/${ENTITY}-${TIMESTAMP}.tar.gz"
fi

# Store metadata
cat > "$ARCHIVE_DIR/${ENTITY}-${TIMESTAMP}.meta" <<EOF
Entity: $ENTITY
Created: $(date)
Commit: $(git rev-parse HEAD)
Branch: $(git branch --show-current)
Message: $(git log -1 --format=%s)
Size: $(du -h "$ARCHIVE_DIR/${ENTITY}-${TIMESTAMP}.tar.gz" | cut -f1)
EOF

echo "✅ Snapshot created: $ARCHIVE_DIR/${ENTITY}-${TIMESTAMP}.tar.gz"
cat "$ARCHIVE_DIR/${ENTITY}-${TIMESTAMP}.meta"
```

### 4. Domos-Level Archive
```bash
# ~/primehaven/tools/archive_domos.sh

#!/bin/bash
# Full system snapshot at highest level

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DOMOS_DIR="$HOME/primehaven/archives/domos"
mkdir -p "$DOMOS_DIR"

echo "╔════════════════════════════════════════════╗"
echo "║  Creating Domos-Level Archive             ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Full repository state
git archive --format=tar.gz \
    --prefix="primehaven-domos-${TIMESTAMP}/" \
    HEAD > "$DOMOS_DIR/primehaven-${TIMESTAMP}.tar.gz"

# System metadata
cat > "$DOMOS_DIR/domos-${TIMESTAMP}.meta" <<EOF
═══════════════════════════════════════════
  DOMOS-LEVEL ARCHIVE
═══════════════════════════════════════════

Created: $(date)
Commit: $(git rev-parse HEAD)
Branch: $(git branch --show-current)
Message: $(git log -1 --format=%s)

Recent History:
$(git log -5 --oneline)

System State:
  Node.js: $(node --version)
  Python: $(python3 --version | head -1)
  Docker: $(docker --version)

Active AIs:
  - Claude: $(claude --version 2>/dev/null || echo "CLI session")
  - Gemini: $(gemini --version 2>/dev/null || echo "0.23.0")
  - Perplexity: llm tool (sonar models)

Delegated Tasks:
$(~/primehaven/tools/ai_delegation_status.sh)

Archive Size: $(du -h "$DOMOS_DIR/primehaven-${TIMESTAMP}.tar.gz" | cut -f1)
EOF

echo "✅ Domos-level archive complete"
echo ""
cat "$DOMOS_DIR/domos-${TIMESTAMP}.meta"
```

---

## Wrapper Service Menus

### Notion Menu
```bash
# ~/primehaven/wrappers/bin/notion_menu.sh

#!/bin/bash
declare -a NOTION_OPS=(
    "✏️ Create Task"
    "📄 Create Page"
    "🔍 Search"
    "📊 Query Database"
    "🏗️ Build Task from URL"
    "📋 Setup Task Board"
    "⬅️ Back"
)

CHOICE=$(printf "%s\n" "${NOTION_OPS[@]}" | fzf \
    --prompt="Notion > " \
    --border=rounded)

case "$CHOICE" in
    *"Create Task"*)
        echo "Task title:"
        read TITLE
        claude skill Notion:create-task "$TITLE"
        ;;
    *"Search"*)
        echo "Search query:"
        read QUERY
        claude skill Notion:search "$QUERY"
        ;;
    # ... etc
esac
```

---

## Multi-AI Pro Plan Utilization

### Gemini Pro Capabilities in Paradise
```bash
*"Gemini Pro Features"*)
    declare -a GEMINI_FEATURES=(
        "🧪 Generate Test Suite"
        "🔨 Implement Feature (from spec)"
        "🐛 Debug Code Issue"
        "📝 Generate Documentation"
        "🔄 Refactor Code"
        "💡 Code Suggestions"
        "⬅️ Back"
    )

    GEMINI_CHOICE=$(printf "%s\n" "${GEMINI_FEATURES[@]}" | fzf)

    case "$GEMINI_CHOICE" in
        *"Test Suite"*)
            echo "File to test:"
            read FILE
            ai_delegate gemini "Generate comprehensive test suite for $FILE" \
                "tests_$(basename $FILE).md"
            ;;
        *"Implement"*)
            echo "Specification file:"
            read SPEC
            ai_delegate gemini "Implement feature based on $SPEC" \
                "implementation_$(date +%s).ts"
            ;;
    esac
    ;;
```

### Perplexity Pro Research in Paradise
```bash
*"Perplexity Pro Research"*)
    declare -a RESEARCH_TYPES=(
        "📚 Latest Best Practices"
        "🔬 Academic Research"
        "🛠️ Tool Comparison"
        "📊 Technology Trends"
        "🔒 Security Analysis"
        "💡 Architecture Patterns"
        "⬅️ Back"
    )

    RESEARCH_CHOICE=$(printf "%s\n" "${RESEARCH_TYPES[@]}" | fzf)

    case "$RESEARCH_CHOICE" in
        *"Best Practices"*)
            echo "Technology/topic:"
            read TOPIC
            ai_delegate perplexity \
                "Latest $TOPIC best practices 2026 with citations" \
                "research_${TOPIC// /_}.md"
            ;;
        *"Tool Comparison"*)
            echo "Tools to compare (comma-separated):"
            read TOOLS
            ai_delegate perplexity \
                "Compare $TOOLS - pros, cons, use cases, 2026 data" \
                "comparison_$(date +%s).md"
            ;;
    esac
    ;;
```

---

## Directory Structure Integration

```
primehaven/
├── primal/pryme/gravity/bash/
│   ├── paradise_unified.sh        # ← Enhance this
│   ├── paradise_v2.sh              # Your iterations
│   ├── tmux_paradise.sh            # TMUX integration
│   └── sync_*.sh                   # Existing sync tools
│
├── tools/                          # Existing tools
│   ├── ai_delegate.sh              # ✅ Created
│   ├── ai_delegation_status.sh     # ✅ Created
│   ├── ai_delegation_retrieve.sh   # ✅ Created
│   ├── ai_delegation_menu.sh       # 🔄 To create
│   ├── ai_pipeline.sh              # 🔄 To create
│   ├── archive_entity.sh           # 🔄 To create
│   ├── archive_project.sh          # 🔄 To create
│   ├── archive_domos.sh            # 🔄 To create
│   └── create_entity_worktree.sh   # 🔄 To create
│
├── wrappers/                       # 🔄 New directory
│   ├── bin/                        # CLI executables
│   │   ├── notion                  # Notion wrapper
│   │   ├── notion_menu.sh          # Notion menu
│   │   ├── vercel_menu.sh          # Vercel menu
│   │   ├── sentry_menu.sh          # Sentry menu
│   │   └── posthog_menu.sh         # PostHog menu
│   ├── lib/                        # Shared libraries
│   └── config/                     # Configurations
│
├── conduit/
│   ├── perplexity/                 # ✅ Complete
│   ├── gemini/                     # 🔄 To create (mirror perplexity)
│   └── unified/                    # 🔄 Shared AI resources
│
└── archives/                       # 🔄 New directory
    ├── notion/                     # Entity snapshots
    ├── sentry/
    ├── projects/                   # Project archives
    └── domos/                      # Full system snapshots
```

---

## Implementation Sequence

### Phase 1: Core Infrastructure (Now)
```bash
1. Create directory structure
   mkdir -p ~/primehaven/{wrappers/{bin,lib,config},archives/{domos,projects}}

2. Create menu scripts
   - ai_delegation_menu.sh
   - ai_pipeline.sh

3. Test delegation system
   ai_delegate gemini "Create test for auth.ts" gemini_test.md
   ai_delegation_status
```

### Phase 2: Service Wrappers (Next)
```bash
1. Create Notion wrapper + menu
2. Create Vercel wrapper + menu
3. Test integration with Paradise
```

### Phase 3: Archive System (Then)
```bash
1. Create archive scripts
   - archive_entity.sh
   - archive_project.sh
   - archive_domos.sh

2. Create worktree management
   - create_entity_worktree.sh

3. Test full archive workflow
```

### Phase 4: Paradise Integration (Finally)
```bash
1. Enhance paradise_unified.sh with new categories
2. Add AI CLI & Delegation menu
3. Add Service Wrappers menu
4. Add Archive & Domos menu
5. Test complete workflow
```

---

## Visionary Perspective: The Complete Picture

**What You've Already Built**:
- Paradise launcher (6 variants showing iteration)
- Repository sync (3 different sync tools)
- Browser automation
- TMUX integration
- Organization scripts

**What We're Adding**:
- Multi-AI orchestration
- Service wrapper layer
- Archive/domos system
- Entity isolation (worktrees)

**The Synergy**:
```
Paradise (Coordination Hub)
    ↓
AI Delegation (Multi-AI)
    ↓
Service Wrappers (Integrations)
    ↓
Archive System (State Management)
    ↓
Git Automation (Persistence)
```

**Result**: Single interface (Paradise) orchestrates everything:
- Launch any AI (web or CLI)
- Delegate tasks across AIs
- Interact with any service
- Create snapshots at any level
- Manage entity isolation

This is **infrastructure that multiplies capability** - each tool enhances all others.

---

## Next Actions

1. Create directory structure
2. Build ai_delegation_menu.sh
3. Build ai_pipeline.sh
4. Create first service wrapper (Notion)
5. Test multi-AI pipeline
6. Integrate into Paradise

Ready to proceed?
