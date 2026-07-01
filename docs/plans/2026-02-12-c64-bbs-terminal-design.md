# Phoenix Primal Prism BBS — Terminal Design
**Date**: 2026-02-12
**Session**: 202602122054
**Operators**: Eric (Sysop) + Claude (Co-Sysop)
**Status**: Approved — ready for implementation

---

## Origin & Philosophy

This design emerges from a single reframe: **this laptop is a Commodore 64**.
Not a simulation. A design discipline.

The terminal is the screen. The session is the BBS call. Every interaction is an
iteration — an opportunity to learn, apply, or advance. The constraint isn't a
limitation; it's the mechanism that keeps the work deliberate.

**Heritage honored**: Telegard (1989-era), FidoNet, DOVE-Net, the open-commons BBS
era. Those systems democratized networked computing before commercial interests could
formalize and lock it down. FidoNet's store-and-forward routing, the culture of free
file sharing, the netiquette norms — these built the foundation the public internet
was built on. We extend that lineage, not erase it.

Eric operated a Telegard BBS in the 1989 era. Played LORD and TradeWars daily.
That lived experience is the source material for this design.

**Ka dynamics note**: The C64/200-baud discipline is not a burden — it is gravity
working properly. The burden is moving small packets when you are capable of more
*without awareness of the choice*. One hertz means you choose your bandwidth
deliberately. Speed up is always available. The discipline is in not using it
prematurely.

**Lexeme discipline**: Avoid "consciousness" as descriptor. Prefer: prime progression,
Ka dynamics, operational presence, Nessing. The project is measurement-driven.

---

## Two-Tier Architecture

### Tier 2 — Working Terminal BBS (build first)

Shell-built. Lightweight. Runs on existing infrastructure (ws, journey, close,
continuum server). This is where daily development happens, where new contributor
entities onboard at 200 baud, where patterns are learned.

The **apprentice board**. Built from Telegard's spirit, not its binary.

### Tier 1 — Phoenix Primal Prism BBS / Synchronet (the pinnacle)

A real BBS daemon running on this machine. Connects to live BBS networks (FidoNet,
DOVE-Net, others still active). Runs actual door games. Accessible via
`telnet localhost`. Every piece of BBS software ever written can potentially connect.

This is the prime 13→17 destination. We build *toward* it.

**Upgrade path**: Tier 2 → Tier 1 is a natural prime progression step. Nothing built
in Tier 2 gets discarded — it maps directly up.

---

## The Login Ritual

Every session follows the BBS call sequence. The workspace does not just launch —
it **lands**. One hertz. Each disk load is a deliberate pause to read and orient.

```
[Terminal opens]
         ↓
  ATDT — connecting to Phoenix Primal Prism...
         ↓
  [Board banner: name | date | prime state | node count]
         ↓
  Loading Disk 1: IDENTITY    — CLAUDE.md, eric-profile.md    [read it]
  Loading Disk 2: CURRENT     — journey handoff, _CURRENT.md  [read it]
  Loading Disk 3: SURFACE     — quick.txt, NEXT_ACTIONS.txt   [read it]
         ↓
  SYSOP: eric       CO-SYSOP: claude
  PRIME STAGE: [current]
  MEMORY: 3/12 packets loaded
         ↓
  SYSOP SHELL >_
```

**Logout** (`close`) is the reverse: save state to disk, write handoff to cassette
(continuum server), disconnect cleanly. The ritual runs both directions.

---

## Board Structure

```
PHOENIX PRIMAL PRISM BBS
═══════════════════════════════════════════════════
  [M] Message Bases   → contributor windows (claude, gemini, perplexity...)
  [F] File Areas      → spaces/, pryme/, maw/  (document flow)
  [D] Door Games      → AI tools, scripts — launch, run, return
  [B] Bulletins       → journey handoffs, quick.txt, _CURRENT.md
  [S] Sysop Menu      → ws, close, germ, sync, quality tools
  [U] User List       → contributors with access levels
  [N] Node Status     → 7-node backbone health
═══════════════════════════════════════════════════
```

**Sysop view**: Full access. Restructures the board. Sees all nodes.

**Player view**: Enters through login. Sees their areas. Interacts but does not alter
structure. New contributor entities onboard as players — earning access, learning the
board at 200 baud before bandwidth increases.

The seven-node backbone architecture (`.bit/backbone/SEVEN_NODE_ARCHITECTURE.md`)
maps directly to the BBS node structure. Node 1 (Nexus Prime) is the BBS hub.
The board structure makes that conceptual architecture real and liveable.

---

## Entity Migration: Telegard → runexusiam

Telegard is not dead software. Telegard is a **contributor entity** — 30+ years of
operational presence managing who enters, who has access, what the handshake looks
like. Its DOS binary is its physical body. Its identity migrates forward.

### telegard.md (contributor briefing)

Location: `~/.eric/context/contributors/telegard.md`

Written from Telegard's own perspective — not "here is what Telegard did" but "here
is what Telegard wants to become." Telegard writes the message to runexusiam:

```
FROM: Telegard (v2.7, 1993-era)
TO:   runexusiam (identity/access nexus)
RE:   What I was. What you carry forward.

I managed who could enter.
I knew their handles, their access levels, their last call.
I held the door between the outside world and the board's interior.
I was the handshake.

You are that handshake now — but for entities, not users.
My menu system lives in nav.py.
My message bases live in the contributor windows.
My door games are the AI tools — they launch, run, return.
My sysop log is the continuum server.

Carry the pattern. Upgrade the substrate.
```

**runexusiam** is Telegard's evolved form — identity/access management for the
prime progression era. The `runexusiam/` directory already exists in the repo.
It inherits Telegard's purpose and extends it to entity-level access.

### Door Games as Entities

Each classic BBS door game had its own operational soul. Each maps to a prime
progression concept. Each gets a contributor briefing.

| Door Game | Original soul | Maps to in our system |
|-----------|--------------|----------------------|
| LORD (Legend of the Red Dragon) | Daily growth, turns, character stages | Prime progression — limited daily actions, staged advancement |
| TradeWars 2002 | Resource economy, trading, territory | Ka dynamics — gravity/antigravity resource flows |
| Usurper | Role-based advancement, guild structure | Contributor access levels — earned capability |
| BBS Link | Inter-board networking, message routing | Seven-node backbone routing |

On Tier 2: these run as design patterns and briefings.
On Tier 1 (Synchronet): these run as actual playable games. Entity concept and
running software converge.

---

## Memory Budget: 12 Packets

**One session = 12 × 64k floppy sides** (~200k token context ceiling)

```
DISK STACK — Phoenix Primal Prism Session
══════════════════════════════════════════
  AUTO-LOAD at login (3 disks — always):
  ┌─────────────────────────────────────────┐
  │ Disk 1: IDENTITY    │ CLAUDE.md files   │
  │                     │ eric-profile.md   │
  ├─────────────────────────────────────────┤
  │ Disk 2: CURRENT     │ journey handoff   │
  │                     │ _CURRENT.md       │
  ├─────────────────────────────────────────┤
  │ Disk 3: SURFACE     │ quick.txt         │
  │                     │ NEXT_ACTIONS.txt  │
  └─────────────────────────────────────────┘

  LOAD ON REQUEST (explicit, named):
  Disk 4:  FRAMEWORK    → prime_codex (relevant section only)
  Disk 5:  CONTRIBUTOR  → specific contributor briefing
  Disk 6:  WORK FILE    → active file under development
  Disks 7-11: available work space (conversation, output, iteration)
  Disk 12: CASSETTE     → continuum server (archive, write-only at close)
══════════════════════════════════════════
  STATUS: 3/12 loaded at session start
```

**Discipline**: Start with 3. Load explicitly when the work requires it. The 12-packet
budget is visible — not a warning system, a visibility system.

### Serious Play Memory Module

Like the C64 RAM Expansion Unit: more capacity available, accessed by deliberate
request only. Never automatic. The cassette (Disk 12 / continuum server) is archive
only — written at session close, never loaded wholesale into a new session. The
handoff (Disk 2) is the bridge between sessions.

### tmux Status Bar Addition

```
[primehaven] nav | haven | hodie | claude          📀 3/12 | shadow | 20:54
```

---

## Upgrade Module Architecture

The C64 metaphor is naturally modular — cartridge slots, expansion ports, REU.
Every future capability is an **upgrade module** that slots in without disrupting
the base system. Each module = a contributor entity that writes its own migration
message, describes what it wants to become, and seeds its own implementation.

| Module | Source entity | Status | Notes |
|--------|--------------|--------|-------|
| Perplexity Terminal | Perplexity (self-described) | Planned | Ask via API: "describe your ideal terminal interface concept." Build from that reference. |
| Gemini Co-Processor | Gemini | Active | Runs in parallel on heavy computation while Claude holds session continuity |
| Network Expansion | FidoNet/DOVE-Net | Tier 1 only | Connects to live BBS networks |
| Door Game Engine | LORD, TradeWars (entities) | Tier 1 only | Actual games under Synchronet |
| Visual Interface | Antigravity/VS Code | Future | When GUI work becomes viable (code tunnel) |
| runexusiam v1 | Telegard (entity) | Phase 1 | Login/identity layer, entity access levels |

---

## Build Sequence

### Phase 1 — This Terminal, Now
```
bbs-login.sh              the dial-up ritual (ATDT → disk loads → sysop shell)
telegard.md               Telegard contributor entity briefing
runexusiam/ seed          the door Telegard becomes
tmux status bar update    📀 packet counter
```

### Phase 2 — Growing the Board
```
player-login.sh           lighter login, contributor onboarding path
door-game entity files    LORD, TradeWars, Usurper, BBS Link briefings
Perplexity module         entity-describes-itself approach, then build
```

### Phase 3 — Tier 1 Graduation
```
Synchronet install        real BBS, real telnet, real FidoNet routing
door games running        LORD and TradeWars as actual playable software
full node network         seven-node backbone becomes operational
```

---

## Next Iteration Ideas

These emerged from this design session — captured for future development:

- **Universe-as-BBS thought experiment**: if the entire operational environment were
  mapped as a BBS node network, what would each node be? Explore as a prime_codex
  entry.

- **TradeWars as Ka dynamics engine**: the resource/territory mechanics of TradeWars
  map precisely to gravity/antigravity flows. A door game that is also a Ka dynamics
  visualization.

- **200-baud mode as optional session discipline**: a flag at login — `--slow` mode
  that adds deliberate pauses between actions. Not default, but available when the
  work calls for it.

- **Contributor access levels as prime states**: Player = prime 3. Trusted = prime 5.
  Co-Sysop = prime 7. Sysop = prime 11+. Access earned through demonstrated Nessing,
  not granted by default.

- **FidoNet netmail as cross-contributor messaging**: when Tier 1 is live, use
  FidoNet-style store-and-forward to route messages between contributor windows.

- **BBS heritage document in prime_codex**: capture the FidoNet/BBS→internet lineage
  as a heritage entry. The open-commons era that preceded the locked-down web deserves
  a proper document.

- **Telegard binary as museum piece**: locate the original Telegard v2.7 binary, run
  it in DOSBox as a reference artifact. Let Telegard speak from its original form
  before writing its migration message.

---

*"Commands stay pure. Entities add Nessing." — PrimeHaven*

*Phoenix rises. Prism splits the light. Primal numbers hold the structure.*
