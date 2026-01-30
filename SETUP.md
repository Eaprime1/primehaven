# }primehaven{ Setup Guide

**Created**: 2026-01-24
**Platform**: Ubuntu
**Purpose**: Setup from scratch guide for the primehaven environment

---

## Quick Start

If you're setting up a fresh environment or working in }perculate{, follow these steps.

---

## Prerequisites

### System Requirements
- Ubuntu/Debian Linux
- Python 3.12+
- Node.js 18+
- Git 2.43+
- GitHub CLI (gh)
- TMUX (optional but recommended)

### Check Current Environment

```bash
# Location check
pwd  # Should be /home/sauron/}primehaven{ or subdirectory

# Python version
python3 --version  # 3.12.3 or higher

# Node version
node --version  # v18.19.1 or higher

# Git version
git --version  # 2.43.0 or higher

# GitHub CLI
gh --version  # 2.45.0 or higher
```

---

## Environment Setup

### Option 1: Use Existing .eric Setup (Recommended)

The .eric setup system has modular scripts for complete environment configuration.

```bash
# Navigate to eric setup
cd }pryme{/Q/.eric/

# Review available setup scripts
ls -la

# Scripts available:
# - setup_packages.sh - System packages
# - setup_python.sh - Python environment
# - setup_nodejs.sh - Node.js environment
# - setup_git.sh - Git configuration
# - setup_github.sh - GitHub CLI auth
# - setup_drives.sh - Drive mounting
# - setup_sync.sh - Repository sync
# (and more...)

# Run complete setup guide
cat COMPLETE_SETUP_GUIDE.md

# Or run specific scripts as needed
./setup_packages.sh
./setup_python.sh
# etc.
```

### Option 2: Manual Setup (From Scratch)

If starting completely fresh:

#### 1. System Packages

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install essential packages
sudo apt install -y \
  git \
  python3 \
  python3-pip \
  python3-venv \
  nodejs \
  npm \
  tmux \
  fzf \
  ripgrep \
  curl \
  wget \
  build-essential

# Install GitHub CLI
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
```

#### 2. Python Environment

```bash
# Create virtual environment (if needed)
python3 -m venv ~/.venv/primehaven

# Activate virtual environment
source ~/.venv/primehaven/bin/activate

# Install from requirements
cd /home/sauron/}primehaven{/}pryme{
pip install -r requirements_pryme.txt

# Key packages (91 total):
# - sphinx (7.2.6)
# - gitpython
# - markdown
# - pyyaml
# - requests
# (and 86 more...)
```

#### 3. Node.js Environment

```bash
# Update npm
npm install -g npm@latest

# Install global tools
npm install -g \
  typescript \
  ts-node \
  nodemon \
  prettier \
  eslint

# Install project dependencies (if package.json exists)
cd /home/sauron/}primehaven{/}maw{/large_files/
npm install  # 123 packages currently
```

#### 4. Git Configuration

```bash
# Set global config
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch
git config --global init.defaultBranch main

# Set credential helper
git config --global credential.helper store

# Optional: Set editor
git config --global core.editor "nano"  # or vim, code, etc.
```

#### 5. GitHub CLI Authentication

```bash
# Login to GitHub
gh auth login

# Follow prompts:
# - Choose GitHub.com
# - Choose HTTPS or SSH
# - Authenticate via browser or token
# - Choose default git protocol

# Verify authentication
gh auth status
```

---

## Directory Initialization

### Setup }runexusiam{ Repository

```bash
cd /home/sauron/}primehaven{/}runexusiam{

# Initialize git repository
git init

# Create initial structure (example)
mkdir -p {src,docs,tests,config}

# Create README
cat > README.md << 'EOF'
# runexusiam

Run-Nexus-IAM: Identity and Access Management Nexus

## Purpose

[Describe purpose here]

## Setup

[Setup instructions]

## Usage

[Usage instructions]

EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
.venv/
venv/
ENV/

# Node
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Project specific
*.log
.env
.env.local

EOF

# Initial commit
git add .
git commit -m "Initial commit: runexusiam repository structure"

# Create GitHub repository (if desired)
# gh repo create runexusiam --private --source=. --remote=origin
# git push -u origin main
```

### Setup }perculate{ Working Environment

```bash
cd /home/sauron/}primehaven{/}perculate{

# Create working structure (example - keep it minimal)
mkdir -p }perk{/workspace
mkdir -p }perk{/temp
mkdir -p }perk{/output

# Create notes file
cat > }perk{/NOTES.md << 'EOF'
# }perculate{ Working Notes

**Purpose**: Clean environment for work-in-progress

## Active Work

[Track current work here]

## Completed

[Track completed items here]

EOF

# Note: Do NOT create a git repository here
# This is intentionally a clean, non-versioned workspace
```

---

## Tool Setup

### Paradise Unified Launcher

```bash
# Navigate to launcher
cd /home/sauron/}primehaven{/}pryme{/gravity/bash/

# Make launcher executable
chmod +x paradise_unified_launcher.sh

# Create alias for easy access (add to ~/.bashrc)
echo "alias paradise='/home/sauron/\}primehaven\{/\}pryme\{/gravity/bash/paradise_unified_launcher.sh'" >> ~/.bashrc

# Reload bashrc
source ~/.bashrc

# Test launcher
paradise
```

### Sync Scripts

```bash
# Make sync scripts executable
cd /home/sauron/}primehaven{/}pryme{/gravity/bash/
chmod +x today_sync.sh
chmod +x codex_migrate.sh
# (and others as needed)

# Create aliases (add to ~/.bashrc)
cat >> ~/.bashrc << 'EOF'
# primehaven sync scripts
alias psync='/home/sauron/}primehaven{/}pryme{/gravity/bash/today_sync.sh'
alias codex-migrate='/home/sauron/}primehaven{/}pryme{/gravity/bash/codex_migrate.sh'
EOF

source ~/.bashrc
```

### TMUX Configuration

```bash
# Create or edit ~/.tmux.conf
cat > ~/.tmux.conf << 'EOF'
# Enable mouse support
set -g mouse on

# Set default terminal
set -g default-terminal "screen-256color"

# Set prefix to Ctrl-a
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Reload config
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

EOF

# Start tmux session for primehaven
tmux new-session -s primehaven -d
tmux attach -t primehaven
```

---

## Sphinx Documentation Setup

```bash
# Navigate to sphinx source
cd /home/sauron/}primehaven{/}maw{/unexusi_sort/source/

# Build HTML documentation
make html

# View documentation
# Output is in _build/html/
# Open _build/html/index.html in browser

# Or use Python HTTP server
cd _build/html/
python3 -m http.server 8000
# Visit http://localhost:8000 in browser
```

---

## Verification

### Check Setup Completeness

```bash
# Navigate to primehaven root
cd /home/sauron/}primehaven{

# Check Python
python3 --version
python3 -c "import sphinx, gitpython, markdown; print('Python packages OK')"

# Check Node
node --version
npm --version

# Check Git
git --version
git config --list

# Check GitHub CLI
gh auth status

# Check directory structure
ls -la
# Should see: }maw{, }pryme{, }runexusiam{, }perculate{

# Check Paradise launcher
paradise --help 2>/dev/null || echo "Paradise launcher found at: }pryme{/gravity/bash/"

# Check for requirements
test -f }pryme{/requirements_pryme.txt && echo "Requirements file found"
```

---

## Common Tasks

### Starting a New Work Session

```bash
# 1. Navigate to primehaven
cd /home/sauron/}primehaven{

# 2. Check current focus
cat }pryme{/Q/runexusiam/_CURRENT.md

# 3. Start TMUX session
tmux new -s work || tmux attach -t work

# 4. Activate Python environment (if using venv)
source ~/.venv/primehaven/bin/activate

# 5. Launch Paradise (optional)
paradise

# 6. Work in appropriate directory
# - }perculate{ for work-in-progress
# - }pryme{ for active development
# - }runexusiam{ for repository work
# - }maw{ for document processing/archival
```

### Creating New Documentation

```bash
# Navigate to docs directory
cd /home/sauron/}primehaven{/}pryme{/gravity/docs/

# Create new markdown file
touch NEW_DOC.md

# Edit with your preferred editor
nano NEW_DOC.md
# or: code NEW_DOC.md
# or: vim NEW_DOC.md

# Follow existing patterns from other docs
# Use PRIME measurement principles
# Keep it living documentation (will evolve)
```

### Running Sync Operations

```bash
# Use today_sync script
cd /home/sauron/}primehaven{/}pryme{/gravity/bash/
./today_sync.sh

# Or use alias if configured
psync
```

---

## Troubleshooting

### Python Import Errors

```bash
# Reinstall requirements
cd /home/sauron/}primehaven{/}pryme{
pip install -r requirements_pryme.txt --force-reinstall
```

### Git Authentication Issues

```bash
# Re-authenticate GitHub CLI
gh auth logout
gh auth login

# Check git credentials
git config --global --list
```

### Permission Issues

```bash
# Make scripts executable
chmod +x /home/sauron/}primehaven{/}pryme{/gravity/bash/*.sh
chmod +x /home/sauron/}primehaven{/}pryme{/Q/.eric/*.sh
```

### Node Modules Issues

```bash
# Clean and reinstall
cd /home/sauron/}primehaven{/}maw{/large_files/
rm -rf node_modules
npm install
```

---

## Environment Variables

Consider adding to `~/.bashrc` or `~/.profile`:

```bash
# primehaven environment
export PRIMEHAVEN_ROOT="/home/sauron/}primehaven{"
export PRIMEHAVEN_MAW="$PRIMEHAVEN_ROOT/}maw{"
export PRIMEHAVEN_PRYME="$PRIMEHAVEN_ROOT/}pryme{"
export PRIMEHAVEN_RUNEXUSIAM="$PRIMEHAVEN_ROOT/}runexusiam{"
export PRIMEHAVEN_PERCULATE="$PRIMEHAVEN_ROOT/}perculate{"

# Add gravity scripts to PATH
export PATH="$PRIMEHAVEN_PRYME/gravity/bash:$PATH"
export PATH="$PRIMEHAVEN_PRYME/Q/.eric:$PATH"

# Python
export PYTHONPATH="$PRIMEHAVEN_PRYME/gravity/python:$PYTHONPATH"

# Aliases
alias ph='cd $PRIMEHAVEN_ROOT'
alias maw='cd $PRIMEHAVEN_MAW'
alias pryme='cd $PRIMEHAVEN_PRYME'
alias runexusiam='cd $PRIMEHAVEN_RUNEXUSIAM'
alias perculate='cd $PRIMEHAVEN_PERCULATE'
alias paradise='$PRIMEHAVEN_PRYME/gravity/bash/paradise_unified_launcher.sh'
```

Then reload:

```bash
source ~/.bashrc
```

---

## Next Steps

After setup is complete:

1. Review `claude.md` for project understanding
2. Check `}pryme{/Q/runexusiam/_CURRENT.md` for active focus
3. Explore existing documentation in `}pryme{/gravity/docs/`
4. Set up work session in `}perculate{` if needed
5. Initialize repositories in `}runexusiam{` if needed
6. Review NANI_LAUNCH_PLAN.md for upcoming work

---

## Resources

### Documentation Locations
- Setup guides: `}pryme{/gravity/docs/`
- Planning docs: `}pryme{/Q/runexusiam/`
- Sphinx docs: `}maw{/unexusi_sort/source/`
- Session logs: Various locations in `}pryme{/Q/`

### Tool Locations
- Paradise launcher: `}pryme{/gravity/bash/paradise_unified_launcher.sh`
- Sync scripts: `}pryme{/gravity/bash/`
- Setup scripts: `}pryme{/Q/.eric/`
- Python tools: `}pryme{/gravity/python/`

### Configuration Files
- Python requirements: `}pryme{/requirements_pryme.txt`
- Sphinx config: `}maw{/unexusi_sort/source/conf.py`
- Git credentials: Various `.gitconfig` files

---

*Setup guide created 2026-01-24. Update as environment evolves.*
