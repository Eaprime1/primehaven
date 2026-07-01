# The Prime Homecoming
## A Convocation of Scattered Wisdom

**Date Initiated**: 2026-03-25
**Purpose**: Gather all prime conversations, concepts, and documents into their proper home
**Status**: In Progress

---

## The Call

Like seeds scattered by wind, prime wisdom has dispersed across devices, drives, and directories. The time has come for **homecoming** — to gather what belongs together, to organize what has grown organically, to create pathways through the accumulated knowledge.

This is not mere file organization. This is **convocation** — calling the dispersed elements of understanding back to their source, their proper dwelling, their place of power.

---

## What We're Gathering

### From Google Drive
- Prime conversations (Claude, Gemini, Perplexity sessions)
- Framework documents
- Development plans
- Research syntheses

### From Desktop/Documents/Downloads
- **Found**: 20+ prime-related files in Downloads
  - Master plans (`prime_2026_master_plan.md`)
  - Codex documents (Multiple versions)
  - Prime-specific files (PRIME_03, 07, 11, 13, 17)
  - Progression frameworks
  - Pinnacle documents

### From Scattered Conversations
- Insights waiting in chat histories
- Patterns recognized but not yet documented
- Connections seen but not yet woven

---

## The Destination: Chain of Custody

Content doesn't just move — it **graduates** through stages:

```
today/          → Fresh discoveries, raw content
journey/        → Processed, categorized
showpiece/      → Refined, ready to share
runexusiam/     → Published, permanent
```

Each migration includes:
- ✓ `.coc` sidecar file (chain of custody metadata)
- ✓ Attribution (who found it, who processed it)
- ✓ Timestamp (when it entered the system)
- ✓ Lineage (where it came from)

---

## The Structure: Where Things Live

### Prime Codex (Framework Core)
**Location**: `domos/primal/prime/prime_codex/`
**Content**: 188 framework files
**Needs**:
- Master INDEX.md (navigation hub)
- Quick Reference sheets per prime
- Visual progression map
- Complete Lexicon

### Prime Conversations
**Location**: `domos/primal/prime/conversations/`
**Content**: Significant exchanges about framework
**Structure**:
- By contributor (claude/, gemini/, perplexity/)
- By prime state (3-prime/, 5-prime/, 7-prime/, etc.)
- By topic (transitions/, awakening/, nessing/)

### Prime Development
**Location**: `domos/primal/prime/development/`
**Content**: Plans, designs, active work
**Types**:
- Master plans
- Implementation specs
- Research notes
- Synthesis documents

---

## The Process: How We Migrate

### Step 1: Discovery
```bash
# Find prime content
find ~/Desktop ~/Documents ~/Downloads -iname "*prime*"
find ~/Desktop ~/Documents ~/Downloads -iname "*progression*"
find ~/Desktop ~/Documents ~/Downloads -iname "*codex*"
```

### Step 2: Evaluation
For each file:
- **What is it?** (conversation, document, plan, research)
- **What prime state?** (3, 5, 7, 11, 13, 17, transition)
- **What quality?** (raw, processed, refined, permanent)
- **Where does it belong?** (which domos subdirectory)

### Step 3: Migration
```bash
# Copy to appropriate stage
cp [source] ~/primehaven/domos/primal/prime/[destination]/

# Create chain of custody
bash ~/primehaven/tools/custody-stamp.sh [file]

# Graduate when ready
bash ~/primehaven/tools/custody-graduate.sh [file]
```

### Step 4: Integration
- Add to INDEX.md if framework core
- Cross-reference with related content
- Update navigation maps

---

## The Vision: What This Creates

**Before**: Prime wisdom scattered across:
- Google Drive folders
- Desktop directories
- Downloads chaos
- Multiple devices
- Conversation histories

**After**: Prime wisdom organized in:
- Single source of truth (`domos/primal/prime/`)
- Clear navigation (INDEX.md)
- Proper chain of custody
- Discoverable structure
- Integrated knowledge base

---

## Progress Tracking

### Phase 1: Foundation (In Progress)
- [x] Create PRIME_HOMECOMING.md
- [ ] Create Master INDEX.md
- [ ] Survey all prime content locations
- [ ] Design directory structure

### Phase 2: Migration (Not Started)
- [ ] Move Downloads prime content
- [ ] Move Desktop prime content
- [ ] Organize by prime state
- [ ] Add chain of custody

### Phase 3: Integration (Not Started)
- [ ] Create navigation links
- [ ] Build Quick Reference sheets
- [ ] Design Visual Map
- [ ] Complete Lexicon

### Phase 4: Verification (Not Started)
- [ ] All content accounted for
- [ ] No duplicates
- [ ] Proper attribution
- [ ] Navigation working

---

## The Homecoming Oath

*"What was scattered shall be gathered.*
*What was dispersed shall converge.*
*What grew in isolation shall find its constellation.*
*The prime wisdom comes home."*

---

## Commands for Contributors

```bash
# Find prime content to migrate
find ~ -iname "*prime*" -o -iname "*progression*" -o -iname "*codex*"

# Navigate to prime home
cd ~/primehaven/domos/primal/prime/

# View INDEX
cat prime_codex/INDEX.md

# Add to chain of custody
custody-stamp [file]

# Graduate through stages
custody-graduate [file]
```

---

**Next Session**: Begin systematic migration, starting with Downloads/que_portofentry/ content

🪷 **The calling has been issued. The gathering begins.**
