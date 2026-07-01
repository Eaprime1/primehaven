# Surf - Terminal Browser Navigator Entity

Terminal-based web browser with intelligent browser selection (lynx/w3m/browsh), session persistence, and discovery features.

## Quick Start

```bash
# Alias (add to ~/.bashrc)
alias surf='/home/sauron/primehaven/terminals/surf/entity_wrapper.sh'

# Interactive mode
surf

# Direct browsing
surf https://github.com/eaprime1

# Quick shortcuts
surf github
surf docs python

# View history/comments
surf -c

# Exploration mode
surf -s
```

## Components

| Module | Purpose |
|--------|---------|
| `entity_wrapper.sh` | Main entry point, interactive menu |
| `browser_selector.sh` | URL pattern → browser mapping |
| `session_manager.sh` | History, comments, bookmarks |
| `spirit.sh` | Discovery, exploration, export/import |
| `config/` | Browser-specific configurations |

## Entity Pattern (Three Helixes)

- **Physical (Work/15)**: Browse web with smart browser selection
- **Mental (Play/16)**: View history, comments, documentation
- **Spirit (Create/17)**: Explore bookmarks, discover related content

## Browser Selection Logic

| URL Pattern | Browser | Reason |
|-------------|---------|--------|
| `*.github.com/*` | browsh | Complex UI, auth flows |
| `*oauth*`, `*login*` | browsh | Interactive auth |
| `docs.*`, `*.readthedocs.io` | lynx | Fast text reading |
| `stackoverflow.com/*` | w3m | Code formatting |
| default | w3m | Good middle ground |

Override with: `surf --lynx URL`, `surf --w3m URL`, `surf --browsh URL`

## Session Data

Stored in `~/.surf/` (git-ignored):

```
~/.surf/
├── sessions/          # Browser cookies
├── history.log        # timestamp|url|browser|status
├── comments.db        # timestamp|url|comment|tags
├── bookmarks.txt      # url|title|tags
└── github-token       # GitHub PAT (planned)
```

## Configuration

See `config/README.md` for browser setup instructions.

## Seed Entities

- **surf-simple**: Minimal lynx-only browser (`terminals/entities/surf-simple/`)
- **surf-unified**: Web + project navigator placeholder (`terminals/entities/surf-unified/`)

## Development

Built using TDD, DRY, YAGNI principles.

See implementation plan: `docs/superpowers/plans/2026-03-26-surf-browser-entity.md`

---

*"Commands stay pure. Entities add Nessing." — PrimeHaven*
