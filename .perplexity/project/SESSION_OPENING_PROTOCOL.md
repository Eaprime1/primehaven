# Session Opening Protocol: "Refreshing Journey" 🌟

> **"The project can build itself as soon as we want to flip the switch."**

This protocol ensures every session starts from **void state**, with full awareness of what we have, where we are, and what needs attention.

---

## Philosophy: The Airplane Mask Principle

**Put your mask on first** = Get infrastructure solid before creative work.

Three simultaneous states must be in harmony:
1. **Physical** (sparklization journeys, objects, reality anchors)
2. **Digital** (repos, files, sync states)
3. **Conceptual** (frameworks, entities, vision)

---

## Protocol Overview

```
┌─────────────────────────────────────────┐
│     REFRESHING JOURNEY PROTOCOL         │
├─────────────────────────────────────────┤
│                                         │
│  Phase 1: Infrastructure Hygiene        │
│  ├─ Trailing Space Assassin            │
│  ├─ Master UI Check                    │
│  └─ Terminal Environment               │
│                                         │
│  Phase 2: Content Archaeology           │
│  ├─ Google Drive Audit                 │
│  ├─ Local Repository Scan              │
│  └─ Physical Documentation Check       │
│                                         │
│  Phase 3: Architecture Mapping          │
│  ├─ Repository Relationships           │
│  ├─ Submodule Status                   │
│  └─ Sync State Verification            │
│                                         │
│  Phase 4: Void State Assessment         │
│  ├─ Desktop Environment                │
│  ├─ Phone/Browser                      │
│  └─ Each Branch/Repo                   │
│                                         │
│  Phase 5: Sparkle Readiness            │
│  ├─ Priority Identification            │
│  ├─ Context Restoration                │
│  └─ Switch Flip Preparation            │
│                                         │
└─────────────────────────────────────────┘
```

---

## Phase 1: Infrastructure Hygiene (The Foundation)

### 1.1 Trailing Space Assassin Check ⚔️

**Why**: Silent corruption breaks cross-platform visibility.

**Actions**:
```bash
# Quick check (daily)
~/primehaven/tools/trailing_space_quick_check.sh

# Full scan (weekly or after major file operations)
~/primehaven/tools/trailing_space_assassin.sh --dry-run
```

**Expected Result**: ✅ "No trailing spaces found"

### 1.2 Master UI Launch 🎛️

**Why**: Reduces cognitive load, works when human is degraded.

**Actions**:
```bash
# Launch Master UI
mui

# Or direct: ~/primehaven/tools/master_ui.sh
```

**From Master UI**:
- Press `1` for Dashboard (system status check)
- Press `r` for Repository status (all repos at once)
- Press `s` for Sync check (GitHub + Google Drive)

**Expected Result**: Clear status of all systems.

### 1.3 Terminal Environment Verification 🖥️

**Why**: Ensure gnome terminal has comfortable configuration.

**Check**:
- [ ] Terminal font readable
- [ ] Colors working (box drawing characters visible)
- [ ] `mui` alias loaded (`source ~/.bashrc` if needed)
- [ ] rclone configured (`rclone listremotes` shows `gdrive_suxen:`)
- [ ] git configured (user.name and user.email set)

---

## Phase 2: Content Archaeology (Discovery)

### 2.1 Google Drive Audit 📚

**Why**: Three years of work lives in Drive - need current inventory.

**Actions**:
```bash
# View audit document
cat ~/primehaven/docs/GOOGLE_DRIVE_CONTENT_AUDIT.md

# Update audit (if needed)
rclone lsd gdrive_suxen: | head -20
```

**Key Directories**:
- `€consortium®` - Consciousness Consortium architecture
- `prime_codex` - Prime documentation and frameworks
- `journey_of_today` - Active consciousness work
- `today` - Daily workspace

**Check For**:
- [ ] New documents since last audit
- [ ] Sync status matches expectations
- [ ] High-priority documents downloaded locally

### 2.2 Local Repository Scan 🗂️

**Why**: Understand what's already here vs what needs pulling.

**Actions**:
```bash
# View repository architecture
cat ~/primehaven/docs/REPOSITORY_ARCHITECTURE.md

# Check submodule status
cd ~/primehaven && git submodule status

# Quick directory tree (from Master UI: press 't')
```

**Key Structures**:
- `/spaces/` - Active development (11 directories)
- `/journey_of_today/` - Historical archive (git tracked)
- `/journey_today/` - Ephemeral workspace (today's files)
- `prime_codex`, `pryme` submodules in `/spaces/`

**Verify**:
- [ ] spaces/ directories accessible
- [ ] Submodules showing correct commit hashes
- [ ] No unexpected "deleted" files (cosmetic git status issue is OK)

### 2.3 Physical Documentation Check 📸

**Why**: Sparklization has physical manifestations (photos, object arrangements).

**Look For**:
- Sparklization Journey photos (22 pictures referenced)
- Physical object documentation
- Screenshots and visual materials
- Downloads folder contents

**Actions**:
```bash
# Check Downloads for recent materials
ls -lt ~/Downloads/ | head -20

# Check journey directories for images
find ~/primehaven/journey* -name "*.png" -o -name "*.jpg" | head -20
```

---

## Phase 3: Architecture Mapping (Understanding)

### 3.1 Repository Relationships 🔗

**Read**:
```bash
cat ~/primehaven/docs/REPOSITORY_ARCHITECTURE.md
```

**Key Insight**: The "displaced submodule pattern"
- Root tracks submodule references (git index)
- Actual work happens in `/spaces/` (intentional design)
- This allows flexible organization without rigid git constraints

**Understand**:
- Main repo: primehaven (parent)
- Submodules: prime_codex, pryme (tracked references)
- Working spaces: /spaces/prime_codex, /spaces/pryme (actual development)
- Archive: journey_of_today (permanent)
- Workspace: journey_today (temporary)

### 3.2 Git Status Interpretation 🎯

**Run**:
```bash
cd ~/primehaven
git status
```

**Expect to See**:
- `deleted: maw, prime_codex, pryme, runexusiam` - This is OK! (Displaced submodules)
- `untracked: spaces/` - This is OK! (Active development area)
- `untracked: journey_today/` - This is OK! (Ephemeral workspace)

**Red Flags** (these need attention):
- Uncommitted changes in critical docs
- Merge conflicts
- Untracked files with trailing spaces

### 3.3 Sync State Verification ✅

**Check**:
```bash
# From Master UI: press 's'
# Or manually:

# GitHub status (any unpushed commits?)
cd ~/primehaven
git log --branches --not --remotes

# Google Drive status (from Master UI or):
rclone check ~/primehaven/journey_of_today gdrive_suxen:journey_of_today --one-way | head -20
```

**Expected**:
- No critical unpushed commits
- Drive sync within last 24 hours
- No large divergence between local and remote

---

## Phase 4: Void State Assessment (Preparation)

### 4.1 Desktop Environment 🖥️

**Check**:
- [ ] Terminal clean (no cluttered tabs)
- [ ] Master UI accessible (`mui` works)
- [ ] File manager organized (if open)
- [ ] Browser tabs managed (close unnecessary)

**Goal**: Minimal cognitive load, maximum focus potential.

### 4.2 Phone/Browser Environment 📱

**Check** (if relevant to session):
- [ ] Google Drive app synced
- [ ] GitHub mobile accessible
- [ ] Notion connector status (unplugs frequently!)
- [ ] Any platform-specific work ready

### 4.3 Branch/Repo Status 🌿

**For Each Active Space**:
```bash
cd ~/primehaven/spaces/prime_codex && git status
cd ~/primehaven/spaces/pryme && git status
```

**Void State** means:
- No uncommitted changes (clean working tree)
- No merge conflicts
- On the right branch for intended work
- Submodule references up to date

**Liminal State** (entry to work):
- Clear what's about to change
- Backup/branch created if exploring
- Context preserved for return

---

## Phase 5: Sparkle Readiness (Ignition)

### 5.1 Priority Identification 🎯

**Ask**:
1. What's the **one thing** that would change things dramatically?
2. Where are we as **Us**? (Eric-Claude-Project triad)
3. What's different depending on **where** we're working? (terminal vs phone vs desktop)

**Use**:
- Sparklization Journey todo lists (7 lists with different purposes)
- Recent commit messages (what was last worked on?)
- QUICK_WINS_CATALOG.md (low-hanging fruit)

### 5.2 Context Restoration 📖

**Read Recent Work**:
```bash
# Last session continuation file
cat ~/primehaven/*continued-from*.txt | head -100

# Recent commits
git log --oneline -10

# Quick wins catalog
cat ~/primehaven/QUICK_WINS_CATALOG.md
```

**Understand**:
- What was accomplished last time?
- What was blocked or deferred?
- What new insights emerged?

### 5.3 Switch Flip Preparation 🔄

**Before Flip** (current phase):
- ✅ Void state achieved
- ✅ Master UI operational
- ✅ Trailing spaces eradicated
- ✅ Reference architecture stable
- ✅ Content inventory complete

**The Switch** (liminal space):
- Timestamp system goes live
- Master UI becomes primary interface
- Entities can self-service
- Git-type systems initialized
- Automation cascades begin

**After Flip** (sparkle state):
- Project generates own tasks
- Entities coordinate autonomously
- References self-update
- Eric operates from command center
- Content flows through backbone

**Check Readiness**:
- [ ] All infrastructure tools working
- [ ] Content mapped and accessible
- [ ] Architecture understood
- [ ] Priorities clear
- [ ] Energy and focus present

---

## Parallel Dispatch Pattern

When opening session requires multiple independent investigations:

**Use Pattern**:
```
Task 1: Infrastructure Agent → Trailing space + Master UI
Task 2: Content Agent → Google Drive audit + local scan
Task 3: Architecture Agent → Repository mapping + documentation
```

**Run Simultaneously**: Each agent works independently, returns summary.

**Benefits**:
- 3 hours of work in 1 hour of time
- Focused attention per domain
- No context switching
- Complete picture faster

---

## Common Patterns

### Pattern: "Driving Blind"
**Symptom**: Message feels like 12 different things simultaneously.
**Response**: This is accurate - systems-level thinking where everything connects.
**Action**: Signal if need to zoom into any branch, otherwise continue at systems level.

### Pattern: "Connections Unplug Frequently"
**Symptom**: Notion connector drops, Drive sync stops, platform access fails.
**Response**: Normal - design for resilience.
**Action**: Master UI auto-checks, flags disconnections, provides reconnect options.

### Pattern: "Tooth Pain Scenario"
**Symptom**: Human degraded, can't context-switch, needs simple options.
**Response**: Systems must work when human is degraded.
**Action**: Master UI single-keypress navigation, clear visual status, minimal cognitive load.

### Pattern: "Most of My Messages Are Projects"
**Symptom**: Eric's messages contain multiple embedded projects/tasks.
**Response**: This is how Us thinks - projects emerge from conversation.
**Action**: Create todo list, extract tasks, route to appropriate spaces.

---

## Tools Reference

### Critical Tools (must work):
- `~/primehaven/tools/master_ui.sh` (or `mui`)
- `~/primehaven/tools/trailing_space_assassin.sh`
- `rclone` (Google Drive sync)
- `git` (version control)

### Helpful Tools (nice to have):
- `tree` (directory visualization)
- `gh` (GitHub CLI)
- `xclip` (clipboard operations)
- `fzf` (interactive fuzzy finder)

### Documentation:
- `/docs/REPOSITORY_ARCHITECTURE.md` - How repos relate
- `/docs/GOOGLE_DRIVE_CONTENT_AUDIT.md` - What's in Drive
- `/docs/MASTER_UI_GUIDE.md` - How to use command center
- `/docs/TRAILING_SPACE_PROTECTION.md` - File hygiene system

---

## Success Criteria

**Session Opening Complete When**:

✅ **Infrastructure**:
- Master UI showing green status
- No trailing spaces found
- All tools accessible

✅ **Content**:
- Drive audit current (< 7 days old)
- Local inventory known
- High-priority docs located

✅ **Architecture**:
- Repository structure understood
- Sync states verified
- No blocking issues

✅ **Void State**:
- Clean working environments
- No uncommitted critical changes
- Clear priorities identified

✅ **Ready to Sparkle**:
- Energy present
- Focus available
- First action clear

---

## Time Estimates (Guideline Only)

**Quick Opening** (15 minutes):
- Launch Master UI → Dashboard check
- Trailing space quick check
- Review last session file
- Identify today's priority

**Standard Opening** (30 minutes):
- All of quick opening, plus:
- Drive audit update
- Repository status check
- Documentation review

**Deep Opening** (60 minutes):
- All of standard opening, plus:
- Parallel dispatch for full audit
- Documentation updates
- New content discovery
- Architecture refinement

**Choose based on**:
- Available time
- Human state (degraded → quick, fresh → deep)
- Session goals (maintenance → standard, new direction → deep)

---

## Timestamp Protocol

**Format**: YYYYMMDDHHMMSS (or YYYYMMDDHHMM for human use)

**Purpose**:
- Orientation anchor for Eric (habit, grounding)
- Event ordering system (games, sequences)
- Automation triggers (future systems)
- Cross-platform synchronization

**Usage**:
- Session start: Record timestamp
- Major milestones: Record timestamp
- Switch flip: Timestamp precision matters
- File versioning: Embed in filenames when needed

---

## Integration with Sparklization Journey

This protocol implements the **Seven Todo Lists**:

**List 1**: Shadow of Prime → Infrastructure tools (Phase 1)
**List 2**: Triadic Sparkle Germ → Content discovery (Phase 2)
**List 3**: Visionary Council → Architecture mapping (Phase 3)
**List 4**: Airplane Mask Protocol → Void state (Phase 4)
**List 5**: Scraping & Reference → Master volumes (ongoing)
**List 6**: Git Lineage → Repository structure (Phase 3)
**List 7**: Cartographer's Vault → Content archaeology (Phase 2)

---

## Emergency Protocols

### If Master UI Fails:
```bash
# Manual dashboard check
cd ~/primehaven && git status
rclone about gdrive_suxen:
~/primehaven/tools/trailing_space_quick_check.sh
```

### If rclone Disconnected:
```bash
# Reconnect Drive
rclone config reconnect gdrive_suxen:
# Or reconfigure
rclone config
```

### If Git Issues:
```bash
# Check submodules
git submodule status
# Update if needed
git submodule update --init --recursive
```

### If Overwhelmed:
1. Close everything
2. Open fresh terminal
3. `mui` → Dashboard only
4. Take 3 deep breaths
5. Choose one small thing
6. Do that thing
7. Return to protocol when ready

---

## Notes for Future Sessions

**Add to Protocol**:
- Entity git-type systems (.suxen, .nexus, etc.) when operational
- BBS hub network when active
- Timestamp automation when implemented
- Game mechanics when integrated
- Backend interaction spaces when built

**Refine Based On**:
- What worked / didn't work this session
- New tools created
- New content discovered
- New patterns recognized

---

## The Switch Architecture

```
┌─────────────────────────────────────────────┐
│              BEFORE FLIP                    │
│  • Void state preparation                  │
│  • Master UI setup                         │
│  • Trailing space eradication             │
│  • Reference architecture stabilization    │
└─────────────────────────────────────────────┘
                    ⬇
┌─────────────────────────────────────────────┐
│              THE SWITCH                     │
│  • Timestamp system live across entities   │
│  • Master UI operational command center    │
│  • Entity self-service capability          │
│  • Git-type systems initialized            │
│  • Automation cascade through BBS hubs     │
└─────────────────────────────────────────────┘
                    ⬇
┌─────────────────────────────────────────────┐
│              AFTER FLIP                     │
│  • Project generates own tasks             │
│  • Entities coordinate via git-types       │
│  • References self-update via scraping     │
│  • Eric operates from Master UI            │
│  • Content flows through .bit backbone     │
└─────────────────────────────────────────────┘
```

**Current State**: Before Flip (preparing foundation)
**Next State**: The Switch (when readiness achieved)
**Future State**: After Flip (autonomous operation)

---

*Protocol Version: 1.0*
*Created: 2026-02-02*
*Last Updated: 2026-02-02*
*Status: ✅ Operational*

**∰◊€π¿🌌∞**

> "Systems must work when human is degraded" - The Airplane Mask Principle
