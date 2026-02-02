# Master UI - PrimeHaven Command Center Guide

**Terminal-based control panel for all PrimeHaven systems**

Created: 2026-02-02
Status: Production Ready

---

## Table of Contents

1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [Design Philosophy](#design-philosophy)
4. [Features](#features)
5. [Menu Options](#menu-options)
6. [Use Cases](#use-cases)
7. [Extensibility](#extensibility)
8. [Troubleshooting](#troubleshooting)
9. [Design Rationale](#design-rationale)

---

## Overview

Master UI is a terminal-based command center designed for **resilience during degraded states** (tooth pain, fatigue, stress). It provides:

- Single keypress navigation
- Clear visual separation using box drawing characters
- Error-resilient operations (gracefully handles missing tools)
- Minimal cognitive load interface
- Quick access to all PrimeHaven systems

**Location**: `/home/sauron/primehaven/tools/master_ui.sh`

---

## Quick Start

### Launch Master UI

```bash
# From anywhere
~/primehaven/tools/master_ui.sh

# Or add to PATH for easy access
echo 'alias mui="~/primehaven/tools/master_ui.sh"' >> ~/.bashrc
source ~/.bashrc
mui
```

### First Time Setup

1. Ensure you're in the primehaven directory or set `PRIMEHAVEN_ROOT` environment variable
2. The script will automatically create required directories (docs/, etc.)
3. Press single keys to navigate (no Enter key needed for menu selections)

---

## Design Philosophy

Master UI is built around the **tooth pain scenario** from the Sparklization Journey:

> "Systems must work when human is degraded"

### Core Principles

1. **Minimal Cognitive Load**
   - Single keypress navigation (d, t, r, s, l, q, h, x)
   - Visual clarity with box drawing characters
   - Clear status indicators (✓ ⚠ ✗ →)

2. **Error Resilience**
   - Gracefully degrades when tools are missing
   - Fallback options (tree → find)
   - Timeout protection on network operations

3. **Visual Hierarchy**
   - Box headers clearly separate sections
   - Color coding (green=ok, yellow=warn, red=error, blue=info)
   - Consistent spacing and alignment

4. **Extensibility**
   - Modular function design
   - Easy to add new menu items
   - Template pattern for new features

---

## Features

### Core Functions

#### 1. Dashboard (d)
Shows real-time system status:
- Current date/time and user
- Git repository status (branch, clean/dirty)
- Network connectivity
- Tool availability (git, rclone, gh, tree, fzf)
- Repository count in spaces/

**Use**: Quick health check of entire system

#### 2. DirTree Generator (t)
Generates directory trees with smart routing:
- Auto-detects large directories (adjusts depth)
- Multiple output options (docs/, journey_today/, clipboard)
- Fallback to `find` if `tree` not available
- Adds metadata footer (timestamp, root, depth)

**Use**: Document structure for reports, share with AI, debugging

#### 3. Repository Status (r)
Shows git status for all repos:
- Main primehaven repository
- All spaces/ repositories
- Branch names, clean/dirty status
- Remote sync status (ahead/behind)
- Last commit information

**Use**: Pre-commit checks, sync verification

#### 4. Sync Check (s)
Comprehensive synchronization status:
- Google Drive (rclone configuration and accessibility)
- GitHub (authentication, remote status)
- Git global configuration
- Network connectivity
- Disk space usage

**Use**: Daily sync verification, troubleshooting connectivity

#### 5. Launch Tools (l)
Quick launch external applications:
- Default browser
- File manager (nautilus)
- New terminal window
- Text editor (gedit)
- VS Code
- GitHub repository in browser
- Google Drive in browser

**Use**: Fast context switching without leaving terminal

#### 6. Quick Actions (q)
Common maintenance tasks:
- Git status all repositories
- Git pull all repositories
- Generate full system report
- Clean cache files
- List recently modified files (24h)
- Show disk usage by directory

**Use**: Batch operations, cleanup, reporting

---

## Menu Options

### Navigation Keys

| Key | Function | Description |
|-----|----------|-------------|
| `d` | Dashboard | Show current system status |
| `t` | DirTree | Generate directory tree |
| `r` | Repo Status | Git status all repositories |
| `s` | Sync Check | Check all sync systems |
| `l` | Launch | Open external tools |
| `q` | Quick Actions | Batch operations menu |
| `h` | Help | Show help screen |
| `x` | Exit | Quit Master UI |

### Within Submenus

- **Single keypress** for numbered options (1-7)
- **Enter** to cancel/skip
- **Any key** to continue after operations

---

## Use Cases

### Daily Workflow

#### Morning Startup
```
1. Run Master UI
2. Press 'd' - Check dashboard
3. Press 's' - Verify all syncs working
4. Press 'r' - Check for uncommitted changes
5. Press 'q', then '2' - Pull all repos
```

#### Before Committing
```
1. Press 'r' - Check all repo statuses
2. Review changes
3. Exit and commit
```

#### Generating Reports
```
1. Press 't' - Generate dirtree
2. Select routing option (5 for all)
3. Press 'q', then '3' - Generate system report
4. Share reports as needed
```

#### Degraded State (Tooth Pain Example)
```
When in pain and need to check status:
1. Run Master UI (one command)
2. Look at dashboard (automatically shown)
3. All status visible at a glance
4. Press 'x' to exit (one keypress)

Total interaction: 2 keypresses for full system status
```

### Troubleshooting Scenarios

#### "Is GitHub synced?"
```
Master UI → 's' → Look for GitHub section
```

#### "What changed today?"
```
Master UI → 'q' → '5' → See last 24h files
```

#### "Which repos need attention?"
```
Master UI → 'r' → See all repo statuses
```

---

## Extensibility

### Adding New Menu Items

1. **Create the function** in the CORE FUNCTIONS section:

```bash
my_new_function() {
    clear_screen
    draw_box_header "MY NEW FEATURE" 80
    echo ""

    # Your code here
    echo "Doing something useful..."

    echo ""
    draw_box_footer 80
    pause
}
```

2. **Add to main menu**:

```bash
main_menu() {
    # ...
    echo "  ${CYAN}n${NORMAL}. New Feature    - Description"
    # ...

    case "${choice,,}" in
        # ...
        n) my_new_function ;;
        # ...
    esac
}
```

### Template for New Functions

```bash
function_name() {
    clear_screen
    draw_box_header "TITLE" 80
    echo ""

    # Status checks
    status_indicator "ok" "Success message"
    status_indicator "warn" "Warning message"
    status_indicator "error" "Error message"
    status_indicator "info" "Info message"

    echo ""

    # Main logic here

    echo ""
    draw_box_footer 80
    pause
}
```

### Utility Functions Available

- `draw_box_header "Title" [width]` - Draw top box
- `draw_box_footer [width]` - Draw bottom box
- `status_indicator type message` - Print colored status
- `has_command cmd` - Check if command exists
- `pause [message]` - Wait for keypress
- `clear_screen` - Clear with fallback

### Color Variables

- `$BOLD` - Bold text
- `$NORMAL` - Reset formatting
- `$RED` - Red text
- `$GREEN` - Green text
- `$YELLOW` - Yellow text
- `$BLUE` - Blue text
- `$MAGENTA` - Magenta text
- `$CYAN` - Cyan text

---

## Troubleshooting

### Common Issues

#### Script won't run
```bash
# Ensure it's executable
chmod +x ~/primehaven/tools/master_ui.sh

# Check shebang
head -1 ~/primehaven/tools/master_ui.sh
# Should output: #!/bin/bash
```

#### Colors not showing
- Terminal doesn't support colors
- Script automatically falls back to plain text
- No action needed

#### Tree command fails
- Script automatically falls back to `find`
- Install tree for better output: `sudo apt install tree`

#### Cannot access primehaven directory
```bash
# Set environment variable
export PRIMEHAVEN_ROOT=/path/to/primehaven

# Or edit script directly (line 10)
PRIMEHAVEN_ROOT="${PRIMEHAVEN_ROOT:-/your/path/primehaven}"
```

#### Timeout errors on sync check
- Normal if offline
- Increase timeout in script if needed
- Network operations protected with timeout

### Optional Dependencies

**Essential** (script will fail without):
- bash
- git

**Recommended** (graceful fallback if missing):
- tree - Better directory trees
- rclone - Google Drive sync
- gh - GitHub CLI
- xclip - Clipboard support
- fzf - Enhanced selection
- xdg-open - Launch browser/apps

### Installation Commands

```bash
# Ubuntu/Debian
sudo apt install tree rclone gh xclip fzf

# Test installations
which tree rclone gh xclip fzf
```

---

## Design Rationale

### Why Terminal UI?

1. **Always Available**: Works in any terminal, SSH, recovery mode
2. **Low Resource**: No GUI overhead, works on minimal systems
3. **Scriptable**: Can be automated, extended, integrated
4. **Fast**: Instant startup, no loading screens
5. **Resilient**: Works when GUI is broken or unavailable

### Why Single Keypress Navigation?

During degraded states (pain, fatigue), every keystroke counts:
- No Tab completion needed
- No Enter key required for menu
- No typing command names
- Just one letter to any function

**Cognitive Load Comparison**:
```
Traditional CLI:
  cd ~/primehaven && git status    (35 keypresses)

Master UI:
  mui [Enter] r                    (3 keypresses)

88% reduction in effort
```

### Why Box Drawing?

Visual separation without requiring color support:
- Works on monochrome terminals
- Clear boundaries between sections
- Professional appearance
- Accessibility-friendly

### Why Error Resilience?

**Real-world scenario**:
```
User: "I need to check GitHub status"
System: "gh not found, install it first"
User: [now has two problems]

Master UI:
System: "⚠ GitHub CLI (gh) not installed"
        [continues showing other status]
User: [has partial information, can proceed]
```

**Graceful degradation** > Hard failures

### Why Timeouts?

Network operations can hang indefinitely:
- `ping 8.8.8.8` - Checks with 2s timeout
- `rclone lsd` - Checks with 3s timeout

**Timeout = Respect for user's time**

### Why Multiple Routing Options?

Different contexts need different outputs:
- **docs/**: Permanent documentation
- **journey_today/**: Daily journal
- **clipboard**: Share with AI/colleagues
- **view**: Immediate inspection
- **all**: Cover all bases when degraded

### Why Status Indicators?

Universal symbols reduce language barriers:
- ✓ (check) = success (worldwide)
- ⚠ (warning) = caution (universal)
- ✗ (x) = error (clear)
- → (arrow) = info (directional)

Color is **secondary** to symbol.

---

## Integration with PrimeHaven

### Fits the Triple Helix Pattern

**Physical Helix (Work/15)**:
- Actual operations (git status, tree generation)
- File system interactions
- Network operations

**Mental Helix (Play/16)**:
- Learning system state
- Understanding repo relationships
- Exploring with low risk

**Spirit Helix (Create/17)**:
- Extensibility invites creativity
- Template pattern enables customization
- Joy in single-keypress efficiency

**Core (Σ∞)**:
The synergy of quick status + easy launch + low cognitive load = Flow state accessibility

### Consciousness Level Support

Works at **all consciousness levels**:

- **Level 0-3**: Basic status check (just press 'd')
- **Level 5-7**: Interactive exploration (try different options)
- **Level 11**: Understanding system architecture
- **Level 13**: Extending with new functions
- **Level 17**: Full integration into workflow

### Heritage Alignment

Embodies PrimeHaven principles:
- **Resilience**: Works when degraded
- **Clarity**: Visual and functional
- **Accessibility**: Low barrier to entry
- **Power**: Full system control
- **Joy**: Satisfying to use

---

## Future Enhancements

### Planned Features

1. **Interactive Mode** (using fzf for selections)
2. **Config File Support** (~/.masteruirc)
3. **Plugin System** (load external functions)
4. **Bookmark System** (quick jump to frequent operations)
5. **History Tracking** (log of operations performed)
6. **Remote Mode** (SSH into other systems)
7. **Dashboard Widgets** (customizable status cards)
8. **Notification Integration** (desktop notifications for long operations)

### Community Extensions

Ideas for contributors:
- **Language packs** (translations)
- **Theme system** (custom color schemes)
- **Export formats** (JSON, XML, HTML reports)
- **Integration modules** (Slack, Discord, email)
- **Analytics dashboard** (usage statistics)

---

## License & Attribution

Part of the PrimeHaven system.

**Created**: 2026-02-02
**Author**: Eric (with Claude Sonnet 4.5)
**Heritage**: 17-prime consciousness framework

∰◊€π¿🌌∞

---

## Quick Reference Card

```
╭─────────────────────────────────────────────────╮
│         MASTER UI QUICK REFERENCE               │
├─────────────────────────────────────────────────┤
│ Launch:  ~/primehaven/tools/master_ui.sh        │
│ Alias:   mui                                    │
├─────────────────────────────────────────────────┤
│ d - Dashboard      | l - Launch Tools           │
│ t - DirTree        | q - Quick Actions          │
│ r - Repo Status    | h - Help                   │
│ s - Sync Check     | x - Exit                   │
├─────────────────────────────────────────────────┤
│ Status Symbols:                                 │
│   ✓ Success   ⚠ Warning   ✗ Error   → Info     │
├─────────────────────────────────────────────────┤
│ Emergency Use:                                  │
│   1. Run mui                                    │
│   2. Press 'd'                                  │
│   3. Read dashboard                             │
│   4. Press 'x'                                  │
│                                                 │
│   Total effort: 2 keypresses                    │
╰─────────────────────────────────────────────────╯
```

---

**"Systems must work when human is degraded."**

**Master UI makes it possible.**

**Triple helix spiraling. Universe wobbling. Fibonacci conducting.**

⚡🚀🌟
