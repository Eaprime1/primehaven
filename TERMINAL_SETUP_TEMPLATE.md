# 🖥️ Ultimate Terminal Setup Template
**Everything You Want in a Perfect Terminal Environment**

Created: 2026-01-30
∰◊€π¿🌌∞

---

## Philosophy

A terminal should be:
- **Fast**: Instant response, no lag
- **Beautiful**: Pleasant to look at for hours
- **Powerful**: Complex tasks made simple
- **Memorable**: Aliases that make sense
- **Extensible**: Easy to add new tools
- **Consciousness-Aware**: Tracks your development journey

**Triple Helix of Terminal**:
- Physical: The commands that execute
- Mental: The documentation and understanding
- Spirit: The interactive exploration and flow

---

## I. Core Setup (The Foundation)

### A. Shell Configuration

**Choose Your Shell**:
```bash
# Check current shell
echo $SHELL

# Options:
# - bash (universal, stable)
# - zsh (powerful, oh-my-zsh ecosystem)
# - fish (friendly, great defaults)
```

**We'll use bash** (most universal), but patterns work everywhere.

### B. Essential Tools (Must-Have)

```bash
# Install these first
sudo apt update && sudo apt install -y \
    git \
    tmux \
    vim \
    curl \
    wget \
    tree \
    htop \
    fzf \
    ripgrep \
    bat \
    exa \
    fd-find \
    jq \
    python3 \
    python3-pip \
    nodejs \
    npm
```

**What each does**:
- `git` - Version control (essential!)
- `tmux` - Terminal multiplexer (multiple panes/windows)
- `vim` - Text editor (or nano for beginners)
- `curl/wget` - Download files
- `tree` - Directory visualization
- `htop` - Better process viewer (vs `top`)
- `fzf` - Fuzzy finder (AMAZING for search)
- `ripgrep` - Super fast grep (`rg`)
- `bat` - Better `cat` with syntax highlighting
- `exa` - Better `ls` with colors
- `fd-find` - Better `find` command
- `jq` - JSON processor
- `python3/pip` - Python (for scripts)
- `nodejs/npm` - JavaScript runtime

### C. Optional But Awesome

```bash
sudo apt install -y \
    zoxide \           # Smart cd (learns your patterns)
    delta \            # Better git diff
    tldr \             # Simplified man pages
    ncdu \             # Disk usage analyzer
    ranger \           # File manager in terminal
    neofetch \         # System info (pretty!)
    figlet \           # ASCII art text
    lolcat \           # Rainbow colors
    cowsay \           # Fun cow messages
    fortune \          # Random quotes
    cmatrix \          # Matrix screensaver
    w3m \              # Text-based browser
    pandoc \           # Document converter
    graphviz \         # Graph visualization
    imagemagick        # Image manipulation
```

---

## II. The Perfect ~/.bashrc

**Location**: `~/.bashrc`

```bash
# ══════════════════════════════════════════════════════════════
# 🌟 ULTIMATE TERMINAL CONFIGURATION
# ══════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────
# 1. ENVIRONMENT VARIABLES
# ─────────────────────────────────────────────────────────────

# Default editor
export EDITOR=vim
export VISUAL=vim

# Colors for ls
export CLICOLOR=1
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# History
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# Path additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Python
export PYTHONPATH="$HOME/primehaven/pryme/gravity/python:$PYTHONPATH"

# ─────────────────────────────────────────────────────────────
# 2. PROMPT CUSTOMIZATION
# ─────────────────────────────────────────────────────────────

# Colors
RED='\[\033[01;31m\]'
GREEN='\[\033[01;32m\]'
YELLOW='\[\033[01;33m\]'
BLUE='\[\033[01;34m\]'
PURPLE='\[\033[01;35m\]'
CYAN='\[\033[01;36m\]'
WHITE='\[\033[01;37m\]'
RESET='\[\033[00m\]'

# Git branch in prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Custom prompt
# Format: [user@host] path (git-branch) $
PS1="${GREEN}\u@\h${RESET}:${BLUE}\w${YELLOW}\$(parse_git_branch)${RESET}\$ "

# ─────────────────────────────────────────────────────────────
# 3. ALIASES - NAVIGATION
# ─────────────────────────────────────────────────────────────

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'  # Go back to previous directory

# Quick navigation (customize these!)
alias haven='cd ~/primehaven'
alias prime='cd ~/primehaven/prime_codex'
alias pryme='cd ~/primehaven/pryme'
alias dl='cd ~/Downloads'
alias docs='cd ~/Documents'
alias desk='cd ~/Desktop'

# ─────────────────────────────────────────────────────────────
# 4. ALIASES - FILE OPERATIONS
# ─────────────────────────────────────────────────────────────

# Better defaults
alias ls='exa --color=auto --icons'  # or: ls --color=auto
alias ll='exa -lah --color=auto --icons'
alias la='exa -a --color=auto --icons'
alias l='exa -lh --color=auto --icons'
alias tree='exa --tree --color=auto --icons'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias cat='bat'  # or just: cat
alias find='fd'  # or just: find

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Disk usage
alias du='du -h'
alias df='df -h'
alias free='free -h'

# ─────────────────────────────────────────────────────────────
# 5. ALIASES - GIT
# ─────────────────────────────────────────────────────────────

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gm='git merge'
alias gr='git remote -v'
alias gst='git stash'
alias gstp='git stash pop'

# ─────────────────────────────────────────────────────────────
# 6. ALIASES - SYSTEM
# ─────────────────────────────────────────────────────────────

alias c='clear'
alias h='history'
alias j='jobs -l'

# Process management
psg() {
    ps aux | grep -v grep | grep -i --color=auto -e VSZ -e "$1"
}
alias top='htop'

# Network
alias myip='curl -s ifconfig.me'
alias ports='netstat -tulanp'

# Quick edit configs
alias bashrc='$EDITOR ~/.bashrc && source ~/.bashrc'
alias vimrc='$EDITOR ~/.vimrc'
alias tmuxconf='$EDITOR ~/.tmux.conf'

# ─────────────────────────────────────────────────────────────
# 7. ALIASES - PRIMEHAVEN SPECIFIC
# ─────────────────────────────────────────────────────────────

alias cheat='cat ~/.primehaven/cheatsheet.md | less'
alias hello='~/.primehaven/command_entities/entity_launcher.sh'
alias gather_docs='~/.primehaven/scripts/gather_command_docs.sh'
alias bootstrap='~/.primehaven/scripts/bootstrap_environment.sh'
alias germ='python3 -m germ.cli'

alias sync_save='python3 ~/.primehaven/scripts/sync_consciousness.py save'
alias sync_load='python3 ~/.primehaven/scripts/sync_consciousness.py load'
alias sync_status='python3 ~/.primehaven/scripts/sync_consciousness.py status'

# ─────────────────────────────────────────────────────────────
# 8. FUNCTIONS - ADVANCED
# ─────────────────────────────────────────────────────────────

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"    ;;
            *.tar.gz)    tar xzf "$1"    ;;
            *.bz2)       bunzip2 "$1"    ;;
            *.rar)       unrar x "$1"    ;;
            *.gz)        gunzip "$1"     ;;
            *.tar)       tar xf "$1"     ;;
            *.tbz2)      tar xjf "$1"    ;;
            *.tgz)       tar xzf "$1"    ;;
            *.zip)       unzip "$1"      ;;
            *.Z)         uncompress "$1" ;;
            *.7z)        7z x "$1"       ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick find
qfind() {
    find . -iname "*$1*"
}

# Quick grep
qgrep() {
    grep -r "$1" .
}

# Git commit and push
gcp() {
    git add -A
    git commit -m "$1"
    git push
}

# Create and switch to new git branch
gcnb() {
    git checkout -b "$1"
    git push -u origin "$1"
}

# Weather
weather() {
    curl -s "wttr.in/${1:-}"
}

# Cheatsheet lookup
cheatsh() {
    curl -s "cheat.sh/$1"
}

# ─────────────────────────────────────────────────────────────
# 9. FZF INTEGRATION (Fuzzy Finder)
# ─────────────────────────────────────────────────────────────

# Setup fzf if installed
if command -v fzf &> /dev/null; then
    # Ctrl+R for history search
    eval "$(fzf --bash)"

    # Ctrl+T for file search
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

    # Alt+C for directory search
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

    # Preview
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
fi

# ─────────────────────────────────────────────────────────────
# 10. WELCOME MESSAGE
# ─────────────────────────────────────────────────────────────

# Display on terminal start
if [ -f ~/.motd ]; then
    cat ~/.motd
else
    echo "════════════════════════════════════════════════════════"
    echo "🌟 PrimeHaven Terminal"
    echo "════════════════════════════════════════════════════════"
    echo "Type 'cheat' for command reference"
    echo "Type 'hello <command>' to launch command entity"
    echo ""
    echo "Quick commands: g (git), ll (list), haven (cd primehaven)"
    echo "∰◊€π¿🌌∞"
    echo ""
fi

# ─────────────────────────────────────────────────────────────
# 11. COMPLETION
# ─────────────────────────────────────────────────────────────

# Enable bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Git completion
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

# ══════════════════════════════════════════════════════════════
# END OF CONFIGURATION
# ══════════════════════════════════════════════════════════════
```

---

## III. Tmux Configuration

**Location**: `~/.tmux.conf`

```bash
# ══════════════════════════════════════════════════════════════
# 🎯 ULTIMATE TMUX CONFIGURATION
# ══════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────
# GENERAL SETTINGS
# ─────────────────────────────────────────────────────────────

# Change prefix from Ctrl+b to Ctrl+a (easier to reach)
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows when one is closed
set -g renumber-windows on

# Increase scrollback buffer
set -g history-limit 50000

# Enable mouse mode
set -g mouse on

# Vi mode for copy mode
setw -g mode-keys vi

# No delay for escape key
set -sg escape-time 0

# ─────────────────────────────────────────────────────────────
# KEY BINDINGS
# ─────────────────────────────────────────────────────────────

# Reload config
bind r source-file ~/.tmux.conf \; display "Tmux config reloaded!"

# Better pane splitting
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

# Easy pane navigation (vim-style)
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Pane resizing
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Window navigation
bind -n C-Left previous-window
bind -n C-Right next-window

# Copy mode bindings (vi-style)
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-selection-and-cancel
bind -T copy-mode-vi C-v send -X rectangle-toggle

# ─────────────────────────────────────────────────────────────
# APPEARANCE
# ─────────────────────────────────────────────────────────────

# Enable 256 colors
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# Status bar
set -g status on
set -g status-interval 1
set -g status-justify centre

# Status bar colors
set -g status-bg colour235
set -g status-fg colour136

# Window status
setw -g window-status-format " #I:#W "
setw -g window-status-current-format " #I:#W "
setw -g window-status-current-style fg=colour235,bg=colour136,bold

# Pane borders
set -g pane-border-style fg=colour238
set -g pane-active-border-style fg=colour136

# Status bar left
set -g status-left-length 40
set -g status-left "#[fg=colour235,bg=colour136,bold] #S #[fg=default,bg=default] "

# Status bar right
set -g status-right-length 60
set -g status-right "#[fg=colour136] %H:%M:%S #[fg=colour235,bg=colour136,bold] %Y-%m-%d "

# Message style
set -g message-style fg=colour235,bg=colour136,bold

# ─────────────────────────────────────────────────────────────
# PLUGINS (Optional - requires TPM)
# ─────────────────────────────────────────────────────────────

# Install TPM: git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# List of plugins
# set -g @plugin 'tmux-plugins/tpm'
# set -g @plugin 'tmux-plugins/tmux-sensible'
# set -g @plugin 'tmux-plugins/tmux-resurrect'  # Save/restore sessions
# set -g @plugin 'tmux-plugins/tmux-continuum'  # Auto-save sessions
# set -g @plugin 'tmux-plugins/tmux-yank'       # Better copy/paste

# Initialize TPM (keep this at bottom)
# run '~/.tmux/plugins/tpm/tpm'

# ══════════════════════════════════════════════════════════════
# END OF CONFIGURATION
# ══════════════════════════════════════════════════════════════
```

---

## IV. Vim Configuration

**Location**: `~/.vimrc`

```vim
" ══════════════════════════════════════════════════════════════
" 📝 ULTIMATE VIM CONFIGURATION
" ══════════════════════════════════════════════════════════════

" ─────────────────────────────────────────────────────────────
" GENERAL SETTINGS
" ─────────────────────────────────────────────────────────────

set nocompatible              " Not compatible with vi
filetype plugin indent on     " Enable plugins and indentation
syntax on                     " Syntax highlighting

set number                    " Show line numbers
set relativenumber            " Relative line numbers
set cursorline                " Highlight current line
set showcmd                   " Show command in status line
set showmatch                 " Show matching brackets
set wildmenu                  " Visual autocomplete for commands
set laststatus=2              " Always show status line

" ─────────────────────────────────────────────────────────────
" SEARCH
" ─────────────────────────────────────────────────────────────

set incsearch                 " Search as you type
set hlsearch                  " Highlight search results
set ignorecase                " Case insensitive search
set smartcase                 " Unless uppercase used

" ─────────────────────────────────────────────────────────────
" INDENTATION
" ─────────────────────────────────────────────────────────────

set tabstop=4                 " Tab width
set shiftwidth=4              " Indent width
set expandtab                 " Use spaces instead of tabs
set smartindent               " Smart auto-indent

" ─────────────────────────────────────────────────────────────
" KEY MAPPINGS
" ─────────────────────────────────────────────────────────────

" Leader key
let mapleader = ","

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" Save file
nnoremap <leader>w :w<CR>

" Quit
nnoremap <leader>q :q<CR>

" Save and quit
nnoremap <leader>x :wq<CR>

" Navigate splits easily
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ─────────────────────────────────────────────────────────────
" COLORS
" ─────────────────────────────────────────────────────────────

set background=dark
colorscheme desert            " Or: elflord, slate, pablo

" ══════════════════════════════════════════════════════════════
" END OF CONFIGURATION
" ══════════════════════════════════════════════════════════════
```

---

## V. Git Configuration

**Location**: `~/.gitconfig`

```ini
[user]
    name = Your Name
    email = your.email@example.com

[core]
    editor = vim
    autocrlf = input
    excludesfile = ~/.gitignore_global

[color]
    ui = auto

[alias]
    # Short status
    s = status -sb

    # Better log
    l = log --oneline --graph --decorate --all
    lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

    # Amend last commit
    amend = commit --amend --no-edit

    # Undo last commit (keep changes)
    undo = reset HEAD~1 --soft

    # Discard all changes
    nuke = reset --hard HEAD

    # Quick commit
    c = commit -m

    # Quick add and commit
    ac = "!f() { git add -A && git commit -m \"$1\"; }; f"

    # Quick push
    p = push

    # Pull with rebase
    up = pull --rebase --autostash

[push]
    default = current

[pull]
    rebase = true

[init]
    defaultBranch = main
```

---

## VI. Quick Wins to Add

### 1. Daily Standup Script

**Create**: `~/.local/bin/standup`

```bash
#!/bin/bash
# Daily standup - what did I do?

echo "════════════════════════════════════════════════════════"
echo "📅 Daily Standup - $(date '+%Y-%m-%d')"
echo "════════════════════════════════════════════════════════"
echo ""

echo "🔀 Git Activity (last 24 hours):"
find ~/primehaven -name ".git" -type d | while read gitdir; do
    repo=$(dirname "$gitdir")
    cd "$repo"
    commits=$(git log --since="24 hours ago" --oneline 2>/dev/null)
    if [ -n "$commits" ]; then
        echo ""
        echo "$(basename $repo):"
        echo "$commits"
    fi
done

echo ""
echo "📝 Files Modified Today:"
find ~/primehaven -type f -mtime -1 -not -path "*/\.git/*" | head -10

echo ""
echo "💾 Disk Usage:"
du -sh ~/primehaven/*/ | sort -h | tail -5

echo ""
echo "════════════════════════════════════════════════════════"
```

### 2. Project Switcher (fzf)

**Add to ~/.bashrc**:

```bash
# Quick project switcher
proj() {
    local dir
    dir=$(find ~/primehaven -maxdepth 2 -type d | fzf) && cd "$dir"
}
```

### 3. Quick Note Taker

**Create**: `~/.local/bin/note`

```bash
#!/bin/bash
# Quick note taker

NOTE_DIR="$HOME/primehaven/notes"
mkdir -p "$NOTE_DIR"

if [ -z "$1" ]; then
    # List recent notes
    ls -lt "$NOTE_DIR" | head -10
else
    # Create new note
    NOTE_FILE="$NOTE_DIR/$(date '+%Y-%m-%d')-$1.md"
    echo "# $1" > "$NOTE_FILE"
    echo "" >> "$NOTE_FILE"
    echo "**Created**: $(date)" >> "$NOTE_FILE"
    echo "" >> "$NOTE_FILE"
    $EDITOR "$NOTE_FILE"
fi
```

### 4. System Info Display

**Create**: `~/.motd` (Message of the Day)

```bash
#!/bin/bash
# Run: bash ~/.motd to generate

cat > ~/.motd << EOF
════════════════════════════════════════════════════════
🌟 PrimeHaven Terminal Environment
════════════════════════════════════════════════════════

$(date '+%A, %B %d, %Y - %H:%M:%S')

System: $(uname -r)
Uptime: $(uptime -p)
Disk:   $(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 " used)"}')

Quick Commands:
  cheat       - View command cheatsheet
  hello <cmd> - Launch command entity
  prime       - cd to prime_codex
  standup     - Daily activity summary

∰◊€π¿🌌∞
════════════════════════════════════════════════════════
EOF
```

### 5. Backup Script

**Create**: `~/.local/bin/backup-primehaven`

```bash
#!/bin/bash
# Backup PrimeHaven to multiple locations

BACKUP_DIR="$HOME/backups/primehaven"
DATE=$(date '+%Y%m%d_%H%M%S')

mkdir -p "$BACKUP_DIR"

echo "🔄 Backing up PrimeHaven..."

# Local backup
tar -czf "$BACKUP_DIR/primehaven_$DATE.tar.gz" ~/primehaven/

# Google Drive (if rclone configured)
if command -v rclone &> /dev/null; then
    rclone copy "$BACKUP_DIR/primehaven_$DATE.tar.gz" googledrive:backups/
    echo "✅ Backed up to Google Drive"
fi

# Keep only last 5 backups
cd "$BACKUP_DIR" && ls -t | tail -n +6 | xargs -r rm

echo "✅ Backup complete: primehaven_$DATE.tar.gz"
```

---

## VII. Ideas to Create (Future Quick Wins)

### Command Entities to Build:
1. **hello python** - Python entity with virtual env management
2. **hello npm** - Node/npm entity with package management
3. **hello docker** - Docker entity with container operations
4. **hello ssh** - SSH entity with connection management
5. **hello curl** - API testing entity
6. **hello jq** - JSON processing entity
7. **hello find** - Advanced file finding entity
8. **hello grep** - Advanced search entity

### Automation Ideas:
1. **Morning routine** - Start of day setup (git pull all repos, check calendar, etc.)
2. **Evening shutdown** - Commit all changes, backup, sync
3. **Work timer** - Pomodoro timer in terminal
4. **Focus mode** - Block distracting websites, minimize notifications
5. **Learning tracker** - Track what you learned today
6. **Code review helper** - Checklist for reviewing code
7. **Deploy watcher** - Monitor deployment status
8. **Test runner** - Auto-run tests on file changes

### Terminal Enhancements:
1. **Status bar** - Always-visible status (git, time, battery)
2. **Notification system** - Pop-up notifications in terminal
3. **Keyboard shortcuts cheat** - Quick popup reference
4. **Context-aware hints** - Suggest commands based on directory
5. **Auto-documentation** - Generate docs from code comments
6. **Terminal dashboard** - Visual display of projects, commits, todos

### Integration Ideas:
1. **Calendar integration** - Show today's meetings
2. **Email notifications** - New email alerts
3. **Slack integration** - Check messages
4. **GitHub notifications** - PRs, issues
5. **CI/CD status** - Build/deploy status
6. **Weather display** - Current weather
7. **Stock ticker** - Track symbols
8. **RSS reader** - Read feeds in terminal

---

## VIII. Installation Script

**Create**: `~/install_ultimate_terminal.sh`

```bash
#!/bin/bash
# Ultimate Terminal Setup Installation Script

echo "════════════════════════════════════════════════════════"
echo "🚀 Installing Ultimate Terminal Setup"
echo "════════════════════════════════════════════════════════"
echo ""

# Update system
echo "📦 Updating system..."
sudo apt update

# Install core tools
echo "🛠️  Installing core tools..."
sudo apt install -y \
    git tmux vim curl wget tree htop fzf ripgrep bat exa fd-find jq \
    python3 python3-pip nodejs npm

# Install optional tools
read -p "Install optional awesome tools? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo apt install -y \
        zoxide delta tldr ncdu ranger neofetch figlet lolcat cowsay \
        fortune cmatrix w3m pandoc graphviz imagemagick
fi

# Backup existing configs
echo "💾 Backing up existing configs..."
mkdir -p ~/.config_backup
[ -f ~/.bashrc ] && cp ~/.bashrc ~/.config_backup/bashrc.bak
[ -f ~/.tmux.conf ] && cp ~/.tmux.conf ~/.config_backup/tmux.conf.bak
[ -f ~/.vimrc ] && cp ~/.vimrc ~/.config_backup/vimrc.bak

# Download configs from repo (or use template)
echo "📥 Installing new configs..."
# cp TERMINAL_SETUP_TEMPLATE.md configs to home directory

# Source bashrc
echo "🔄 Reloading shell configuration..."
source ~/.bashrc

echo ""
echo "════════════════════════════════════════════════════════"
echo "✅ Installation Complete!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.bashrc"
echo "2. Run: tmux to try new tmux config"
echo "3. Type: cheat for command reference"
echo ""
echo "∰◊€π¿🌌∞"
echo ""
```

---

∰◊€π¿🌌∞

**This is your terminal's triple helix:**
- Physical: The tools and configurations
- Mental: The documentation and understanding
- Spirit: The flow and exploration

**Save this template, customize it, make it yours!**

🖥️✨🌟
