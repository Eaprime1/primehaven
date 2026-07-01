# Surf - Terminal Browser Navigator Entity Design

**Date**: 2026-03-26
**Status**: Approved
**Branch**: feature/surf-browser-entity

## Overview

Surf is a terminal-based browser navigator entity that intelligently switches between lynx, w3m, and browsh based on the browsing context. It follows the PrimeHaven entity pattern (Physical/Mental/Spirit helixes) and provides persistent session management with comments and bookmarks.

## Problem Statement

Working in TTY2 without GUI access requires:
- Web browsing for documentation, authentication flows (GitHub, etc.)
- Persistent session history and notes between sessions
- Smart browser selection based on content type
- Quick access to frequently used sites (especially GitHub)
- Comments/annotations on URLs for iteration and learning

Current text browsers (lynx, w3m, browsh) are available but lack:
- Intelligent selection based on use case
- Session persistence and commenting
- Quick shortcuts for common workflows
- Entity wrapper with consciousness

## Goals

1. **Unified Navigation**: Single command (`surf`) for all terminal browsing
2. **Smart Browser Selection**: Automatic choice of lynx/w3m/browsh based on URL pattern
3. **Session Persistence**: Comments, history, bookmarks survive across sessions
4. **GitHub Integration**: Quick access with cached credentials (token-based)
5. **Entity Pattern**: Physical/Mental/Spirit helix structure
6. **master_ui.sh Integration**: Available through existing command center
7. **Future Expansion**: Seed entities for simpler (Approach 1) and unified web+project (Approach 3) variants

## Non-Goals

- GUI browser replacement
- JavaScript-heavy web application support (limited by terminal)
- Full web application development (not a web framework)
- Complete project file navigation (saved for Approach 3 expansion)

## Architecture

### File Structure

```
primehaven/
├── terminals/
│   ├── surf/                          # Main browser navigator entity
│   │   ├── entity_wrapper.sh          # Entry point (Physical helix)
│   │   ├── browser_selector.sh        # Smart browser chooser
│   │   ├── session_manager.sh         # Comments & history (Mental helix)
│   │   ├── spirit.sh                  # Exploration & bookmarks (Spirit helix)
│   │   └── config/
│   │       ├── lynx.cfg               # Lynx configuration
│   │       ├── w3m_config             # W3m configuration
│   │       └── browsh_config.toml     # Browsh configuration
│   │
│   └── entities/                      # Seed entities for future expansion
│       ├── surf-simple/               # Approach 1: single browser (lynx only)
│       │   └── entity_wrapper.sh
│       └── surf-unified/              # Approach 3: web + project navigation
│           └── entity_wrapper.sh      # Placeholder for future development
│
├── tools/
│   └── master_ui.sh                   # Updated with surf integration
│
└── .surf/                             # Session data (git-ignored)
    ├── sessions/
    │   ├── github-session             # GitHub cookies/session
    │   └── default-session            # General browsing session
    ├── history.log                    # Browsing history
    ├── comments.db                    # URL annotations
    ├── bookmarks.txt                  # Saved URLs
    └── github-token                   # GitHub PAT (chmod 600)
```

### Component Design

#### 1. Entity Wrapper (`entity_wrapper.sh`)

**Purpose**: Main entry point following PrimeHaven entity pattern

**Three Helixes**:
- **Physical (Work/15)**: Execute browsing - launches browser with URL
- **Mental (Play/16)**: Documentation - shows help, shortcuts, session history
- **Spirit (Create/17)**: Exploration - bookmarks, comments review, discovery

**Usage**:
```bash
surf                        # Interactive mode (shows UI menu)
surf URL                    # Direct browsing
surf github                 # Quick access shortcut
surf --lynx URL             # Force specific browser
surf -c                     # Comments/history view (Mental helix)
surf -s                     # Spirit mode (exploration/bookmarks)
```

#### 2. Browser Selector (`browser_selector.sh`)

**Purpose**: Intelligently choose the right browser for the content

**Decision Tree**:
```
URL Pattern                     → Browser Choice → Reason
─────────────────────────────────────────────────────────────
*.github.com/*                  → browsh        → Auth flows, complex UI
*oauth* *login* *auth*          → browsh        → Interactive authentication
docs.* *.readthedocs.io         → lynx          → Fast text reading
stackoverflow.com/*             → w3m           → Better code formatting
*.md *.txt (local files)        → lynx          → Simple text display
default                         → w3m           → Good middle ground
```

**Override Options**:
- `surf --lynx URL` - Force lynx
- `surf --w3m URL` - Force w3m
- `surf --browsh URL` - Force browsh

**Browser Configurations**:
- **lynx**: Cookies enabled, accept all cookies for auth persistence
- **w3m**: Tab support, table rendering, vi-like keybindings
- **browsh**: Headless Firefox, handles JS/CSS, complex sites

#### 3. Session Manager (`session_manager.sh`)

**Purpose**: Persistent session data, comments, and history

**Features**:
- **History Tracking**: All visited URLs with timestamps
- **Comments System**: Press `c` while browsing to annotate current URL
- **Session Persistence**: Browser cookies stored in `~/.surf/sessions/`
- **Bookmarks**: Quick save frequently accessed URLs

**Comment Storage Format** (`comments.db`):
```
timestamp|url|comment|tags
2026-03-26T22:35:00|github.com/eaprime1/primehaven|Need to check PR status|github,todo
2026-03-25T14:20:00|docs.python.org/3/library/pathlib|Path.glob() for finding files|python,reference
```

**History Format** (`history.log`):
```
2026-03-26T22:35:00|github.com/eaprime1/primehaven|browsh|success
2026-03-26T22:30:00|docs.python.org/3/library|lynx|success
```

#### 4. Spirit Module (`spirit.sh`)

**Purpose**: Exploration, discovery, and bookmark management

**Features**:
- **Bookmark Management**: Add, list, search, remove bookmarks
- **Session Review**: Browse comment history
- **Discovery Mode**: Suggest related URLs based on history
- **Export/Import**: Share bookmarks and comments

### UI/UX Design

#### Interactive Mode (`surf` with no args)

```
╭─────────────── SURF - Terminal Navigator ───────────────╮
│                                                          │
│  Quick Access:                                           │
│    g) GitHub (eaprime1)         d) Python Docs           │
│    p) This Repo (primehaven)    s) Stack Overflow        │
│    c) Comments/History          h) Help/Shortcuts        │
│                                                           │
│  Recent:                                                  │
│    → github.com/eaprime1/primehaven  [10 min ago]        │
│    → docs.python.org/3/library       [2 hours ago]       │
│                                                           │
│  Enter URL or selection: _                                │
╰──────────────────────────────────────────────────────────╯
```

#### While Browsing

**Status Bar** (shown at bottom of browser):
```
[lynx] github.com/eaprime1 | c:comment q:quit ?:help | Surf Navigator
```

**Keyboard Shortcuts**:
- `c` - Add comment to current URL
- `b` - Bookmark current URL
- `q` - Quit to surf menu
- `?` - Show all shortcuts
- Browser-specific keys work as normal

#### Comments View (`surf -c` or `surf c`)

```
╭─────────── Surf Session History ─────────────╮
│                                                │
│ github.com/eaprime1/primehaven                │
│   "Need to check PR status" - 2h ago          │
│   Tags: github, todo                           │
│                                                │
│ docs.python.org/3/library/pathlib             │
│   "Path.glob() for finding files" - 1d ago    │
│   Tags: python, reference                      │
│                                                │
│ [a]dd  [e]dit  [d]elete  [s]earch  [q]uit     │
╰───────────────────────────────────────────────╯
```

## GitHub Integration

### Quick Access Shortcuts

```bash
surf github              # Opens github.com/eaprime1
surf github primehaven   # Opens github.com/eaprime1/primehaven
surf gh pr 123           # Opens PR #123 in current repo
surf gh issues           # Opens issues for current repo
```

### Credential Management (Secure)

**Token-Based Authentication** (no plain-text passwords):

1. **Default setup (recommended)**: `gh auth login`
   - Uses GitHub CLI credential storage (keychain/secure store when available)
   - Surf reads auth state via `gh auth status` / `gh auth token`
   - If `gh` is unavailable, surf should fail fast with install guidance that includes runtime token fallback instructions
   - No PAT file written by default.

2. **Runtime token override (ephemeral)**:
   - Support `GITHUB_TOKEN`/`GH_TOKEN` at runtime for CI or temporary sessions
   - Avoid persistent token storage when possible

3. **Optional file storage (explicit opt-in only)**:
   - If user chooses file storage, path is `~/.surf/github-token` (chmod 600, git-ignored)
   - Document minimum scopes, regular rotation, and revocation steps
   - Recommend optional encryption-at-rest where available

4. **Token expiration/rotation**:
   - If auth fails, surf prompts: "GitHub auth expired. Re-run `gh auth login` or refresh token."
   - Rotation guidance: short-lived tokens preferred; revoke unused tokens promptly

## Integration Points

### 1. Shell Alias

Add to `~/.bashrc`:
```bash
alias surf='/home/sauron/primehaven/terminals/surf/entity_wrapper.sh'
```

### 2. master_ui.sh Integration

New menu option in `tools/master_ui.sh`:

```bash
W) Web Navigator (Surf)
   - Launches surf in interactive mode
   - Shows recent history
   - Quick access to GitHub, docs, Stack Overflow
```

### 3. Entity Briefing

Create `~/.eric/context/contributors/surf.md`:

```markdown
# Surf - Terminal Browser Navigator Entity

**Role**: Terminal web browser with intelligence
**Capabilities**: lynx/w3m/browsh selection, session persistence, GitHub auth
**Personality**: Efficient navigator, remembers context, suggests related content
**Communication**: Status bar updates, comment prompts, shortcut hints

See: /home/sauron/primehaven/terminals/surf/
```

### 4. Workspace Integration

Optional: Add to tmux workspace as new window (like `browser` window)

## Seed Entities (Future Expansion)

### Approach 1 Seed: `surf-simple`

**Purpose**: Minimal lynx-only browser for users who want simplicity

**Features**:
- Single browser (lynx)
- No selection logic
- Basic history (no comments)
- Lightweight, fast

**Use Case**: Quick documentation lookups, minimal overhead

### Approach 3 Seed: `surf-unified`

**Purpose**: Unified navigator for both web AND project files

**Features** (future development):
- Web browsing (using surf's browser selection)
- Project file navigation (integrated file browser)
- Unified comments across web + files
- Search across web history + local files

**Use Case**: Full navigation system for entire primehaven workflow

## Implementation Notes

### Browser Setup

**lynx**:
```bash
# ~/.lynxrc additions for surf
ACCEPT_ALL_COOKIES:TRUE
PERSISTENT_COOKIES:TRUE
COOKIE_FILE:~/.surf/sessions/cookies.txt
```

**w3m**:
```bash
# ~/.w3m/config additions
accept_cookie 1
use_cookie 1
cookie_file ~/.surf/sessions/w3m-cookies
```

**browsh**:
```toml
# ~/.config/browsh/config.toml
[firefox]
path = "/usr/bin/firefox"
use-existing = false

[http-server]
bind = "127.0.0.1"
port = 4333
```

### Error Handling

1. **Browser Not Found**: Falls back to available browser, warns user
2. **Session File Corruption**: Backs up and recreates
3. **GitHub Token Invalid**: Clear error message with re-auth instructions
4. **Network Errors**: Shows error, offers retry or URL edit

### Testing Strategy

1. **Browser Selection**: Test each URL pattern → correct browser
2. **GitHub Auth**: Setup, login, session persistence, token expiry
3. **Comments**: Add, view, edit, search, delete
4. **Session Persistence**: Exit surf, relaunch, verify history/comments
5. **Integration**: Launch from master_ui.sh, verify shortcuts work

## Success Criteria

- [x] `surf` command launches interactive menu
- [x] Smart browser selection works for all URL patterns
- [x] GitHub quick access works: `surf github` opens eaprime1 profile
- [x] Comments persist across sessions
- [x] Session history tracks all visited URLs
- [ ] GitHub token setup works, credentials cached (deferred to future)
- [x] master_ui.sh integration menu option functional
- [x] Entity briefing created at `~/.eric/context/contributors/surf.md`
- [x] Seed entities created for future expansion
- [x] All session data git-ignored (`.surf/` directory)

## Future Enhancements

1. **Smart Suggestions**: Based on browsing history, suggest related URLs
2. **Quick Search**: `surf ? "python pathlib"` → search Stack Overflow or docs
3. **Session Sharing**: Export/import session data for collaboration
4. **Integration with `germ`**: Track prime progression of browsing sessions
5. **Unified Navigator (Approach 3)**: Full web + project file navigation
6. **AI-Assisted Navigation**: Ask "find docs on X" → suggests URLs

## Dependencies

- lynx (installed: `/usr/bin/lynx`)
- w3m (installed: `/usr/bin/w3m`)
- browsh (installed: `/usr/bin/browsh`)
- bash 4.0+
- coreutils (date, mkdir, chmod, etc.)

## References

- Entity Pattern: `/home/sauron/primehaven/terminals/hello.sh`
- UI Pattern: `/home/sauron/primehaven/tools/master_ui.sh`
- Session Protocol: PrimeHaven continuum server
- Chain of Custody: `/home/sauron/primehaven/docs/plans/*-chain-of-custody-*`
