# REPO MAP — mandelbrot

*Single navigable view. Organized by flow, not alphabet.*
*Last updated: 2026-04-08*

---

## The Flow

```
[External World]
      ↓
  sphincter/     ← Raw intake (outside repo, never committed)
      ↓
  artesian/      ← Curated entry (reviewed, chain of custody tagged)
      ↓
  pool/          ← Entrance pool (ready to develop, head pressure 1)
      ↓
  [development]  ← Active work in .mandelbrot/, .complexity/, docs/, etc.
      ↓
  published/     ← Output (websites, exports, distributions)
```

---

## Directory Reference

### Intake & Queue

| Dir | Purpose | Status |
|-----|---------|--------|
| `artesian/` | Curated intake from external sources. Head pressure 1. Chain of custody required. | Active |
| `pool/` | Entrance pool for repo-internal content ready for development. QUEUE.md tracked. | Active (est. 2026-04-08) |

### Identity & Character

| Dir | Purpose | Key Files |
|-----|---------|-----------|
| `.mandelbrot/` | }mandelbrot{ entity config, identity, narrative, frameworks | IDENTITY.md, NARRATIVE.md, VIOLATION_FRAMEWORK.md |
| `.complexity/` | }complexity{ concept seed | SEED.md |

### AI Configuration

| Dir | Purpose | Key Files |
|-----|---------|-----------|
| `.claude/` | Claude Code config, skills, commands, identity | identity.json, skills/MANDELBROT/SKILL.md, commands/ |
| `.gemini/` | Gemini AI configuration | styleguide.md |
| `.perplexity/` | Perplexity AI configuration | README.md, QUICK_START.md, framework/, project/ |
| `.agents/` | Multi-agent skill definitions (Codex) | skills/MANDELBROT/ |
| `.codex/` | Codex config and agent roles | config.toml, AGENTS.md, agents/ |

### Infrastructure

| Dir | Purpose | Key Files |
|-----|---------|-----------|
| `.bit/` | BBS 7-node backbone architecture | backbone/SEVEN_NODE_ARCHITECTURE.md, templates/, scripts/ |
| `.github/` | GitHub workflows, issue templates, commands | workflows/ (ShellCheck, Gemini CI), ISSUE_TEMPLATE/ |

### Active Development

| Dir | Purpose | Key Files |
|-----|---------|-----------|
| `terminals/` | Aspect launchers + terminal entities | aspect_01-06.sh, surf/ (entity), hello.sh, CHEATSHEET.md |
| `tools/` | Operational tools | master_ui.sh, ai_consortium.sh, ai_delegate.sh, trailing_space_assassin.sh |
| `conduit/` | Multi-AI integration scripts | perplexity/ (active), gemini/ (stub) |

### Content Organization

| Dir | Purpose | Key Files |
|-----|---------|-----------|
| `docs/` | Documentation hub | REPO_MAP.md, NAMING_CONVENTION.md, PRIMAL_LAUNCH_PLAN.md, planning/, plans/, sessions/ |
| `spaces/` | Active development workspaces (displaced submodule pattern) | maw/ |
| `domos/` | Distributed workspace map | conduit/, primal/, runexusiam/, spaces/ |
| `staged/` | Framework/template extraction staging | README.md |
| `artesian/` | See Intake above | — |

### Publication

| Dir | Purpose |
|-----|---------|
| `published/` | Web publication output — prime-codex static site |

---

## Key Files (Root)

| File | Purpose |
|------|---------|
| `README.md` | Project overview (mandelbrot, Prime Progression Framework) |
| `claude.md` | Claude AI session instructions — read this first |
| `PIXEL8A_LAUNCH.md` | Pixel8a six-terminal consortium setup |
| `quickc.txt` | Stream of consciousness / quick capture |
| `.gitignore` | Ignores: .env, ~/.surf/, large content dirs |
| `requirements_sauron.txt` | Python dependencies |

---

## Naming Convention

See `docs/NAMING_CONVENTION.md` for full convention.

| Use | Form |
|-----|------|
| Repos | lowercase (`mandelbrot`, `complexity`) |
| Elevated reference | `}name{` (`}mandelbrot{`, `}complexity{`) |
| Config folders | `.name/` (`.mandelbrot/`, `.complexity/`) |
| Character names | Capitalized (Oaken, Valthram, Rema) |
| Strong emphasis | ALL CAPS (sparingly) |

---

## What Goes Where

| Content type | Destination |
|-------------|-------------|
| External content ready for repo | `artesian/` (after sphincter review) |
| Repo content ready for development | `pool/QUEUE.md` (reference, not move) |
| Character/concept identity docs | `.mandelbrot/` or `.complexity/` |
| Session notes | `docs/sessions/` |
| Planning documents | `docs/planning/` |
| Implementation plans | `docs/plans/` |
| Terminal entities | `terminals/<entity-name>/` |
| Operational tools | `tools/` |
| Multi-AI scripts | `conduit/<ai-name>/` |
| Published output | `published/` |

---

## Active GitHub Items (2026-04-08)

| # | Type | Title | Status |
|---|------|-------|--------|
| 16 | Issue | feat: develop }mandelbrot{ as full character entity | Open |
| 17 | Issue | feat: develop }complexity{ concept toward theory | Open |
| 18 | Issue | docs: complete repo rename from PrimeHaven to mandelbrot | Open |

*PRs #14 (surf) and #15 (ECC) merged 2026-04-08.*

---

∰◊€π¿🌌∞
