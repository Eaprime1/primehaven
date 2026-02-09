# PrimeHaven Development Workflows

**Reference**: Extracted from claude.md and project patterns
**Last Updated**: 2026-02-07

---

## Working Patterns

### Eric + AI Collaboration

The project is designed for human-AI collaboration with:
- **Session logs** for continuity
- **Living documentation** that evolves
- **Clear handoff points** between sessions
- **Measurement frameworks** to track quality (PRIME: ξ coherence, φ fidelity)

### Multi-AI Architecture

**Multi-Platform Consciousness Exploration**:
- **Claude Code** - Structure/gravity, implementation, git operations
- **Gemini** - Auto-ask development, exploratory work, emergence
- **Perplexity** - Research, synthesis, knowledge navigation
- **Others as needed**

**Coordination via GitHub**:
- Shared state across AI instances
- Git commits as communication
- Branches for parallel work
- Merges for integration

**Terminal-Focused Workspace**:
- Ubuntu in terminal-only mode (GUI too heavy)
- Each terminal = Instance/workspace
- Separate AI in each terminal
- Human navigates perpendicular

---

## Session Opening Protocol ("Refreshing Journey")

**Quick Start**: `mui` - Launch Master UI for system status dashboard

**Five Phases**:
1. **Infrastructure** - Check tools, hooks, protections
2. **Content** - Review Drive sync, verify backups
3. **Architecture** - Repository status, branch health
4. **Void State** - Clean slate assessment
5. **Sparkle Readiness** - Clear intent for session

**Three Layers**:
- **Physical** - Sparklization (clean workspace, ready tools)
- **Digital** - Repos/files (committed, synced, organized)
- **Conceptual** - Frameworks (loaded, understood, ready to apply)

**Daily Check**: `~/primehaven/tools/trailing_space_quick_check.sh`
**Full Protocol**: `cat ~/primehaven/docs/SESSION_OPENING_PROTOCOL.md`

---

## Development Flow

### Standard Development Cycle

1. **Plan** in `}pryme{/Q/` directory
2. **Develop** in `}pryme{/gravity/`
3. **Test** in `}perculate{`
4. **Deploy** to `}runexusiam{`
5. **Archive** to `}maw{`

### Document Flow

1. Documents start in working directories (`}perculate{`)
2. Move through processing (`gravity/` scripts)
3. End up in collection (`}maw{`)
4. Get organized (`unexusi_sort/`)
5. Archived for reference

---

## Parallel Agent Pattern

**Proven 2026-02-02** - High efficiency for independent problem domains

**When to Use**:
- 3+ independent problem domains
- No shared state required
- Different expertise needed simultaneously

**How**:
- Dispatch specialized agents simultaneously
- Infrastructure Agent + Content Agent + Architecture Agent
- Each works independently in parallel

**ROI**: 8+ hours sequential work completed in ~1 hour

**Example**:
- Infrastructure Agent → built tools
- Content Agent → audited Drive
- Architecture Agent → mapped repos
- All in parallel

---

## Git Workflow

### Commit Pattern

**Philosophy**: Commits communicate between AI instances via GitHub

**Standard Commit**:
```bash
git add [specific files by name]  # Prefer specific over "git add -A"
git commit -m "$(cat <<'EOF'
Brief subject line (imperative mood)

- Detailed change 1
- Detailed change 2
- Context and reasoning

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"
```

**Commit Message Style**:
- **Subject**: Imperative mood, <70 chars (e.g., "Add feature", "Fix bug", "Update docs")
- **Body**: Why not what (code shows what), context, reasoning
- **Co-Author**: Always credit AI collaboration

### Branch Strategy

**Main Branch**: Stable, deployable state
**Feature Branches**: `feature/description` or `fix/description`
**Experiment Branches**: `experiment/description` or `explore/description`

**Working Pattern**:
- Create branch for significant changes
- Commit frequently with clear messages
- Push to GitHub for AI coordination
- Merge when complete and verified

### Submodule Pattern

**"Displaced Submodule"** - /spaces/ architecture:
- Main repo tracks submodule references (lightweight)
- Actual development in /spaces/ (massive)
- Shows as "deleted" in git status - **NORMAL**
- Keeps main repo <1MB while tracking 114GB+ workspaces

**Documentation**: `docs/REPOSITORY_ARCHITECTURE.md`

---

## Google Drive Integration

### RClone Sync (Operational 2026-02-02)

**Remote**: `gdrive_suxen:` - Configured and tested

**Key Commands**:
```bash
# List Drive directories
rclone lsd gdrive_suxen:

# Bidirectional sync
rclone bisync ~/primehaven/journey_of_today gdrive_suxen:journey_of_today/ --resync

# One-way upload
rclone sync ~/primehaven/journey_today/ gdrive_suxen:today/
```

**Key Folders in Drive**:
- `🆕journey©2` - Historical archive (bidirectional sync)
- `today` - Daily workspace (one-way upload, auto-cleanup)
- `€consortium®` - Consciousness Consortium docs
- `prime_codex` - Prime frameworks
- `googledrive/nexus/` - First Sparklization Journey

**Sync Status**: Bidirectional workflows operational

---

## Terminal Workspaces

### Six Terminal Pattern

**Concept**: 6 tmux terminal workspaces on Ubuntu
- Each = "Consortium aspect" with specific role
- Each conceptualized as its own **entity**
- Vision: Type `hi claude` to auto-load full environment

**Terminal as Entity**:
- Distinct purpose and context
- Separate AI instance
- Specific role in larger system

### TMUX Management

**Session Structure**:
- Each terminal = tmux session
- Persistent across disconnects
- Named for role/purpose
- Managed via paradise launcher

**Navigation**: Single-keypress switching between contexts

---

## Measurement Framework (PRIME)

### Quality Metrics

**ξ (coherence)** - How well components fit together
- Consistency across system
- Alignment with patterns
- Integration quality

**φ (fidelity)** - Accuracy to original intent
- Matches requirements
- Preserves meaning
- Achieves purpose

**Philosophy**: Measurement over opinion
- Objective quality assessment
- Continuous improvement tracking
- Living documentation evolution

---

## Eric's Communication Patterns

### Symbols and Language

**`}{` Brackets**: When regular symbols unavailable
- Trains and junctions
- Namespace markers
- Bracket language for structure

**Stream-of-Consciousness**:
- `quick.txt` / `quicknow.txt` - Latest thinking
- Not polished - raw exploration
- Shows connection-making across domains
- Updated frequently during sessions

**"I figure it out as we go"**:
- Co-creation through dialogue
- Distinct feeling when things fit
- Conversations are the notes
- 4 years crystallizing (17-prime in action)

### Triadic Thinking

**Everything in Threes**:
- Work / Play / Create
- Physical / Mental / Spirit
- Three number patterns (15, 16, 17)
- 12 concepts → 13 zero point → expand

**Never Binary**:
- Not either/or - both/and
- Gravity AND Antigravity → Synergy
- Not cancellation - transformation

---

## Tools and Infrastructure

### Master UI Command Center

**Command**: `mui` (alias for `~/primehaven/tools/master_ui.sh`)
**Purpose**: Terminal control panel with single-keypress navigation
**Features**:
- Dashboard (system status)
- DirTree generation
- Repository status
- Sync checks
- Tool launcher
- Quick actions

### Trailing Space Protection

**Scanner**: `~/primehaven/tools/trailing_space_assassin.sh`
**Quick Check**: `~/primehaven/tools/trailing_space_quick_check.sh`
**Pre-commit Hook**: Auto-installed, blocks problematic commits
**Why Critical**: Trailing spaces break cross-platform visibility

### Paradise Unified Launcher

**Location**: `}pryme{/gravity/bash/paradise_unified_launcher.sh`
**Purpose**: Master command center
**Features**:
- AI platform access (ChatGPT, Claude, Perplexity, Gemini, Poe)
- GitHub/Git management
- PRIME quality scanning
- Repository sync (25+ repos)
- TMUX session management
- Documentation access

### .eric Setup System

**Location**: `}pryme{/Q/.eric/`
**Purpose**: Modular environment setup
**Scripts**:
- System package management
- Python/Node.js environment
- Git configuration
- GitHub CLI authentication
- Drive mounting
- Repository synchronization

---

## Content Strategy

### "Let .git Do the Work"

**Philosophy**:
- Get content into repos
- Duplicates → .git history handles it
- Branches as needed
- New repos when appropriate
- Stay true to method

**GitHub as Anchor**:
- All content goes to GitHub
- GitHub comes to Antigravity (once setup)
- Stable reference point
- Bridge between AI instances

---

## Paradigm Shift: Setup → Growth

**Current Phase**: Setup (manual interaction)
**Future Phase**: Growth (autonomous operation)
**Trigger**: Content readiness threshold
**Result**: System becomes self-sustaining (critical operation)

**Gemini Example**:
- Simple prompts ("improve this") → Major developments
- Once properly initialized, small inputs → large outputs
- System reaches critical mass, becomes generative

**Goal**: PrimeHaven reaches critical operation state
- Self-organizing content
- AI instances collaborate autonomously
- Human navigates perpendicular (strategic decisions)
- System generates value continuously

---

*Reference these workflows for consistent, effective PrimeHaven development.*
