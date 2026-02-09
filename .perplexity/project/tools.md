# PrimeHaven Tools & Technologies

**Reference**: Extracted from claude.md and infrastructure documentation
**Last Updated**: 2026-02-07

---

## Technology Stack

### Core Environment

**Platform**: Ubuntu 24.04 LTS (terminal-focused, no GUI)

**Languages**:
- **Python**: 3.12.3 (91 dependencies in `requirements_pryme.txt`)
- **Node.js**: v18.19.1 (123 packages in node_modules)
- **Shell**: Bash

**Version Control**:
- **Git**: 2.43.0
- **GitHub CLI**: 2.45.0 (`gh` command)

**Documentation**:
- **Sphinx**: 7.2.6 (docs generation)
- **Markdown**: Processing and rendering

**Terminal Tools**:
- **TMUX**: Session management, workspace persistence
- **fzf**: Fuzzy finder for quick navigation
- **ripgrep**: Fast code search

---

## Key Tools

### Master UI (`mui`)

**Location**: `~/primehaven/tools/master_ui.sh`
**Alias**: `mui` (single command)
**Purpose**: Terminal-based control panel with single-keypress navigation

**Features**:
- System status dashboard
- DirTree generation
- Repository status checks
- Sync verification
- Tool launcher
- Quick actions

**Usage**:
```bash
mui              # Launch Master UI
mui --help       # Show options
```

**Documentation**:
- `docs/MASTER_UI_GUIDE.md` - Usage guide
- `docs/MASTER_UI_DESIGN_RATIONALE.md` - Architecture

### Paradise Unified Launcher

**Location**: `}pryme{/gravity/bash/paradise_unified_launcher.sh`
**Purpose**: Comprehensive command center for all operations

**Capabilities**:
- **AI Platform Access**: ChatGPT, Claude, Perplexity, Gemini, Poe
- **GitHub Management**: Repo operations, PR handling, issue tracking
- **Git Operations**: Commits, branches, sync, status
- **PRIME Quality**: Scanning, measurement (ξ coherence, φ fidelity)
- **Repository Sync**: 25+ repos tracked and synchronized
- **TMUX Sessions**: Create, manage, switch between workspaces
- **Documentation**: Quick access to all docs

**Usage**: Launch from `}pryme{/gravity/bash/`

### Trailing Space Protection

**Scanner**: `~/primehaven/tools/trailing_space_assassin.sh`
- Detects and fixes trailing spaces in files
- Scans entire repository
- Provides detailed reports

**Quick Check**: `~/primehaven/tools/trailing_space_quick_check.sh`
- Daily hygiene verification
- Fast scan for issues
- Minimal output (only problems shown)

**Pre-commit Hook**: `.git/hooks/pre-commit`
- Automatically installed
- Blocks commits with trailing spaces
- Prevents cross-platform visibility issues

**Why Critical**: Trailing spaces break file references across platforms, corrupt documentation

**Documentation**: `docs/TRAILING_SPACE_PROTECTION.md`

### RClone (Google Drive Sync)

**Remote**: `gdrive_suxen:` - Configured and operational

**Common Operations**:
```bash
# List remote directories
rclone lsd gdrive_suxen:

# Check sync status
rclone check ~/primehaven/journey_of_today gdrive_suxen:journey_of_today/

# Bidirectional sync
rclone bisync ~/primehaven/journey_of_today gdrive_suxen:journey_of_today/ --resync

# One-way upload
rclone sync ~/primehaven/journey_today/ gdrive_suxen:today/

# Copy single file
rclone copy file.txt gdrive_suxen:destination/
```

**Key Remotes**:
- `gdrive_suxen:` - Main Google Drive connection
- Syncs: `journey_of_today`, `today`, `prime_codex`, `€consortium®`

**Documentation**: `docs/GOOGLE_DRIVE_CONTENT_AUDIT.md`

---

## .eric Setup System

**Location**: `}pryme{/Q/.eric/`
**Purpose**: Modular environment initialization scripts

**Available Scripts**:
- `setup_packages.sh` - System package management
- `setup_python.sh` - Python environment (pip, virtualenv)
- `setup_nodejs.sh` - Node.js and npm
- `setup_git.sh` - Git configuration
- `setup_github.sh` - GitHub CLI authentication
- `setup_drive.sh` - Drive mounting (rclone)
- `setup_repos.sh` - Repository synchronization
- `setup_all.sh` - Run all setup scripts

**Philosophy**: Modular, idempotent, well-documented

**Usage**:
```bash
cd }pryme{/Q/.eric/
./setup_all.sh          # Full environment setup
./setup_git.sh          # Just Git configuration
```

---

## Python Libraries

**File**: `}pryme{/requirements_pryme.txt` (91 dependencies)

**Key Libraries**:
- **GitPython** - Git operations from Python
- **Sphinx** - Documentation generation
- **Markdown** - Markdown processing
- **YAML** - Configuration parsing
- **JSON** - Data interchange

**Installation**:
```bash
pip3 install -r }pryme{/requirements_pryme.txt
```

---

## GitHub CLI (`gh`)

**Version**: 2.45.0
**Purpose**: GitHub operations from terminal

**Authentication**:
```bash
gh auth status          # Check authentication
gh auth login           # Interactive login
```

**Common Operations**:
```bash
# Repository
gh repo view            # View repo details
gh repo create          # Create new repo

# Pull Requests
gh pr list              # List PRs
gh pr create            # Create PR
gh pr view [number]     # View specific PR

# Issues
gh issue list           # List issues
gh issue create         # Create issue
gh issue view [number]  # View specific issue
```

---

## Infrastructure Systems

### .bit BBS Network Architecture

**Location**: `~/primehaven/.bit/`
**Concept**: FidoNet-inspired distributed system
**Status**: Conceptual foundation (functional automation pending)

**Seven Nodes**:
1. **Nexus Prime** - Central Coordination → Master UI
2. **Consortium Gateway** - Entity Interface → Consciousness Consortium
3. **Content Archive** - Knowledge Repository → prime_codex, Google Drive
4. **Work Stream** - Active Development → /spaces/ workspaces
5. **Quality Gate** - Vetting & Review → Trailing Space, pre-commit hooks
6. **Distribution Hub** - Publication & Sync → GitHub, Drive sync
7. **Transform Layer** - Protocol Translation → API gateways, format conversion

**Message Flow**: Entity → Gateway → Quality Gate → Nexus → Archive → Distribution

**Documentation**: `.bit/backbone/SEVEN_NODE_ARCHITECTURE.md`

### PRIME Measurement System

**Metrics**:
- **ξ (coherence)** - How well components fit together
- **φ (fidelity)** - Accuracy to original intent

**Philosophy**:
- Measurement over opinion
- Objective quality assessment
- Continuous improvement tracking

**Implementation**: Integrated into Paradise launcher and quality gates

### Compass Navigation System

**Purpose**: Framework for navigation and orientation
**Concept**: Bounded safe operation vs. unbounded expansion
**Metaphor**: Reactor control (steady-state, critical operation)

---

## AI Integration Tools

### Claude Code

**Environment**: This context
**Role**: Structure, implementation, git operations (gravity)
**Tools**: All standard development tools, git, GitHub CLI
**Strength**: Systematic development, code generation, documentation

### Gemini CLI

**Location**: `conduit/gemini/gemini-cli/`
**Role**: Auto-ask development, exploratory work (antigravity)
**Installation**: Full CLI installed
**Strength**: Creative exploration, rapid iteration

### Perplexity CLI

**Location**: `conduit/perplexity/perplexityai/`
**Type**: Python-based CLI
**Role**: Research, synthesis, knowledge integration
**Strength**: Deep research with citations, external knowledge

**Python SDK**:
```python
from perplexity import Perplexity

client = Perplexity()
response = client.responses.create(
    preset="fast-search",
    input="Your query",
    instructions="You are a helpful assistant."
)
```

**CLI Usage**:
```bash
perplexity "Your query"
perplexity -uc -m sonar-pro "Complex query"  # With citations, sonar-pro model
```

---

## MCP Integration (Future)

**MCP**: Model Context Protocol
**Purpose**: Secure connections between AI and external data sources

**Planned MCPs**:
- Google Drive MCP (`@piotr-agier/google-drive-mcp`)
- Filesystem Access MCP
- GitHub MCP
- Custom PrimeHaven MCPs

**Status**: Google Drive MCP awaiting OAuth setup
**Documentation**: `claude.md` Google Drive Integration section

---

## Backup & Archive

**Backup Locations**:
- `}maw{/large_files/Q_distress_backup/`
- `}maw{/large_files/iris_complete_backup/`

**Archive System**:
- Google Drive (rclone sync)
- Git history (comprehensive commit logs)
- Sphinx documentation builds

---

## Quick Reference

### Most-Used Commands

```bash
# System Status
mui                     # Master UI dashboard

# Repository Operations
git status              # Check repo status
gh repo view            # View on GitHub
gh pr create            # Create pull request

# File Hygiene
~/primehaven/tools/trailing_space_quick_check.sh

# Sync Operations
rclone lsd gdrive_suxen:                    # List Drive
rclone bisync [local] [remote] --resync     # Sync

# Python
pip3 list               # List installed packages
python3 --version       # Check version

# Node.js
npm list                # List packages
node --version          # Check version
```

### Directory Quick Access

```bash
# Main workspaces
cd ~/primehaven/spaces/pryme          # Primary development
cd ~/primehaven/spaces/maw            # Collection cistern
cd ~/primehaven/spaces/perculate      # Clean workspace

# Gravity tools
cd ~/primehaven/spaces/pryme/gravity/bash    # Shell scripts
cd ~/primehaven/spaces/pryme/Q/.eric         # Setup scripts

# Documentation
cd ~/primehaven/docs                  # Project docs
cd ~/primehaven/primal/prime/prime_codex     # Prime frameworks

# Conduits
cd ~/primehaven/conduit/claude        # Claude workspace
cd ~/primehaven/conduit/perplexity    # Perplexity workspace
cd ~/primehaven/conduit/gemini        # Gemini workspace
```

---

*Reference these tools for efficient PrimeHaven development and operations.*
