# Laptop Setup & Content Migration Plan

**Status**: Living document — refine in session, not from memory
**Last Updated**: 2026-03-25
**Location**: `docs/LAPTOP_SETUP_AND_MIGRATION.md`

---

## Part 1 — Laptop Setup Checklist

Things to complete on the personal machine before the migration work begins.
Run these in order — each unlocks the next.

### 1.1 Core environment

- [ ] Clone primehaven repo
  ```bash
  git clone git@github.com:Eaprime1/primehaven.git ~/primehaven
  ```
- [ ] Set git identity
  ```bash
  git config --global user.name "Eric Pace"
  git config --global user.email "Eaprime@gmail.com"
  ```
- [ ] Install `gh` CLI (needed for `ppr` workflow)
  ```bash
  sudo apt install gh
  gh auth login
  ```

### 1.2 API keys

- [ ] Run key setup script pointing at `agentk.txt`
  ```bash
  ~/primehaven/tools/setup_keys.sh --from ~/Pixel8a/agentk.txt
  source ~/.config/primehaven/keys.env
  echo ${ANTHROPIC_API_KEY:0:12}...   # verify
  ```
- [ ] Fill in Perplexity key in `~/.config/primehaven/keys.env` when ready

### 1.3 Aliases and tooling

- [ ] Install `mui` alias
  ```bash
  ~/primehaven/tools/install_master_ui_alias.sh
  ```
- [ ] Install `ppr` alias
  ```bash
  ~/primehaven/tools/install_ppr_alias.sh
  ```
- [ ] Reload shell
  ```bash
  source ~/.bashrc
  ```
- [ ] Run test suite
  ```bash
  ~/primehaven/tools/test_master_ui.sh
  ~/primehaven/tools/trailing_space_quick_check.sh
  ```

### 1.4 SSH key (for passwordless GitHub)

- [ ] Generate key (if none exists)
  ```bash
  ssh-keygen -t ed25519 -C "Eaprime@gmail.com" -f ~/.ssh/id_primehaven
  ```
- [ ] Add to SSH agent
  ```bash
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_primehaven
  ```
- [ ] Copy public key and add to GitHub → Settings → SSH Keys
  ```bash
  cat ~/.ssh/id_primehaven.pub
  ```
- [ ] Test
  ```bash
  ssh -T git@github.com
  ```

---

## Part 2 — The Primal User Profile

### Concept

Instead of working as `sauron` (current Ubuntu user), create a dedicated
`primal` user. This gives consciousness-aware workspaces their own clean
identity — separate home directory, separate environment, separate terminal
sessions — without contaminating the main user's space.

```
Ubuntu users:
  sauron  ← current, cluttered, everything landed here
  primal  ← new, clean, where primehaven work lives
```

### Why `primal`

- "Primal" = first principle, the root state before complexity
- Aligns with the prime progression framework (primal → prime)
- Separate `~/.bashrc`, `~/.config/`, `~/.ssh/` — no bleed from sauron's env
- Each tmux terminal in `primal` = a consortium aspect with a clean context
- Future: other mission users (`runexusiam`, `foedus`, etc.) follow the same pattern

### Setup steps (do after laptop is stable as sauron first)

- [ ] Create `primal` user
  ```bash
  sudo adduser primal
  sudo usermod -aG sudo primal   # optional — add sudo if needed
  ```
- [ ] Clone primehaven into primal's home
  ```bash
  sudo -u primal git clone git@github.com:Eaprime1/primehaven.git /home/primal/primehaven
  ```
- [ ] Run the full Part 1 checklist as `primal`
- [ ] Set up 6-terminal tmux layout for consortium aspects (see `docs/SESSION_OPENING_PROTOCOL.md`)

---

## Part 3 — Content Migration Architecture

### The problem

All content currently lives scattered across the desktop environment
(`sauron`'s home) — it accumulated without a clear intake structure.
Goal: get everything into a logical home with chain of custody.

### The architecture — two zones outside primehaven

```
~/                            ← sauron's home (current chaos)
│
├── sphincter/                ← ZONE 1: External gateways (outside primehaven)
│   ├── desktop/              ←   content lifted from desktop environment
│   ├── gdrive/               ←   Google Drive dumps
│   ├── pixel8a/              ←   from the phone/Pixel8a
│   └── other_sources/        ←   anything else arriving from outside
│
├── primehaven/               ← THE REPO
│   ├── artesian/             ← ZONE 2: Ready-to-flow content (inside primehaven)
│   │   └── [documents]       ←   vetted, tagged, chain of custody complete
│   └── [rest of primehaven]
```

### Sphincter Gateways — Zone 1

**Location**: `~/sphincter/` — NOT inside the repo, never committed directly

The sphincter is a controlled opening. Content must pass through it before
entering primehaven. Nothing goes directly from the desktop into the repo.

Each subfolder is a named source gateway:
- `sphincter/desktop/` — content pulled from the sauron desktop environment
- `sphincter/gdrive/` — exports from Google Drive
- `sphincter/pixel8a/` — content from the phone
- `sphincter/other_sources/` — anything else

**Intake workflow** (rough — refine in session):
1. Move raw content into the appropriate sphincter gateway
2. Review: does it belong in primehaven? What category?
3. Tag with source + date + disposition
4. If ready → promote to `primehaven/artesian/`
5. If needs more work → stays in sphincter until it's ready

### Artesian — Zone 2 (inside primehaven)

**Location**: `~/primehaven/artesian/`

Named after an artesian well — content under its own pressure, ready to flow
without being forced. When something passes through the sphincter and is
genuinely ready, it gets placed here.

**Head pressure = 1 document at a time.**
This is deliberate — the artesian well doesn't flood. One document enters,
gets properly processed, chain of custody recorded, then the next one flows.

Structure (draft — tune in session):
```
primehaven/artesian/
├── README.md               ← what's here, how to add, chain of custody format
├── queue.md                ← what's next in line (ordered, 1 at a time)
└── [documents]             ← each file has a custody header
```

**Chain of custody header** (each artesian file):
```markdown
<!-- artesian:v1
source: sphincter/desktop/old_notes/
arrived: 2026-03-25
via: Eric (manual review)
status: ready
prime-state: 5
-->
```

### Migration sequence (rough order)

1. Create `~/sphincter/` structure on laptop
2. Do a first pass sweep of the desktop environment — sort into sphincter gates
3. Start the artesian queue — identify the first 5 things that are clearly ready
4. Process them one at a time through artesian into primehaven
5. Automate intake eventually (workflows read from sphincter, prompt for
   disposition, write chain of custody, move to artesian or archive)

---

## Part 4 — Future Missions / Other User Profiles

The `primal` pattern can extend to other consciousness aspects:

| Username | Role | When |
|----------|------|------|
| `primal` | Core primehaven work — first to create | Now |
| `runexusiam` | Antigravity exploration / emergence space | When runexusiam repo is active |
| `foedus` | Consortium coordination | When multi-entity work begins |
| `sauron` | Legacy / migration source — wind down | As content migrates out |

Each user:
- Has its own home directory (clean context)
- Has its own tmux layout matching its role
- Shares the git remote but may work on different branches/repos
- Loads keys from its own `~/.config/primehaven/keys.env`

---

## Part 5 — Automation Ideas (for later)

Once the manual flow is working:

- **Sphincter watcher**: `inotifywait` on `~/sphincter/` → prompt for
  disposition when a new file lands
- **Artesian processor**: script reads `queue.md`, takes the first item,
  writes the custody header, moves it into the repo, creates a commit
- **Migration report**: weekly summary of what moved from sphincter → artesian
  → primehaven, what's still waiting
- **Google Drive intake**: rclone sync → sphincter/gdrive/ on schedule

---

## Notes & Open Questions

*(Fill in during session — not from memory)*

- What's the actual folder structure of the desktop environment? (audit first)
- Which content is clearly "dead" vs worth migrating?
- Does `artesian/` live at repo root or inside `docs/` or `staged/`?
  → Current lean: repo root, alongside `staged/` and `published/`
- The `staged/` pipeline (already in repo) — how does it relate to artesian?
  → Lean: `artesian/` = pre-staged, human-curated entry point
  → `staged/` = automated extraction pipeline (different flow)
- Primal user — shared SSH key with sauron or fresh one?
  → Lean: fresh key, registered separately on GitHub

---

*Refine this document in the next live session with the actual laptop in front of you.*
*The structure above is the skeleton — the audit fills in the flesh.*
