# Naming Convention — The mandelbrot Ecosystem

*Established: 2026-04-08*

---

## The Problem with ALL CAPS

`MANDELBROT` is hard to type. It carries a visual weight that works for
repo names on GitHub (where the system auto-uppercased it) but is
cumbersome in everyday conversation, documentation, and command lines.

More importantly: when everything is ALL CAPS, nothing is elevated.
Designation requires contrast.

---

## The New Convention

### Repos — lowercase

Major concept repos use **lowercase** names.

```
mandelbrot     ← this repo
complexity     ← future repo
```

Why lowercase works:
- Repos are *already* identifiable as major concepts by their existence
- Lowercase is easier to type in any context
- The concept's weight comes from its content, not its typography
- ALL CAPS stays available for genuine emphasis in conversation

GitHub may display them with any capitalization — the *canonical* name is lowercase.

---

### Elevated Designation — `}name{`

When referring to an entity/concept as **THE concept** (not just an instance),
use the **curly-bracket wrapping**: `}mandelbrot{`

This is the established pattern already in use:
- `}primehaven{` in claude.md headers
- `}MANDELBROT{` in session context

Updated to lowercase with the new convention:
- `}mandelbrot{` — THE mandelbrot
- `}complexity{` — THE complexity concept
- `}primoris{` — THE Primoris

Why curly brackets:
- Already in use in this ecosystem (precedent established)
- Easy to type
- Visually distinct without being aggressive
- Evokes the mathematical set notation `{x | condition}` — "the set of"
- The `}name{` form (inverted) reads as "containing name" — the entity holds itself

---

### Hidden Config Directories — `.name/`

Concept-specific configuration and identity files live in dotfolders:

```
.mandelbrot/    ← mandelbrot entity config, identity, narrative
.complexity/    ← complexity concept seed
.claude/        ← Claude AI session config (existing)
.gemini/        ← Gemini AI config (existing)
.perplexity/    ← Perplexity config (existing)
.bit/           ← BBS architecture config (existing)
```

This follows the Unix convention (dotfiles = configuration) and keeps
the root directory clean. The `.` prefix signals "this is infrastructure
for this concept, not content."

---

### In Conversation and Text

| Situation | Form | Example |
|-----------|------|---------|
| Casual mention | lowercase | "the mandelbrot repo" |
| Elevated/THE | `}name{` | "`}mandelbrot{` is the hope seed" |
| Strong emphasis | ALL CAPS | "this is MANDELBROT territory" |
| As THE concept | "the mandelbrot" | "when we say the mandelbrot we mean..." |
| Config folder | `.name/` | "see `.mandelbrot/IDENTITY.md`" |

---

### Character Entities vs. Repos vs. Concepts

Not all major names become repos. The distinction:

| Type | Naming | Example |
|------|--------|---------|
| Character entity | Capitalized proper noun | Valthram, Rema, Oak, Oaken |
| Major concept (potential theory) | lowercase repo name | `mandelbrot`, `complexity` |
| Framework component | camelCase or snake_case | `primeProgression`, `triple_helix` |
| Living document | UPPERCASE file | `IDENTITY.md`, `NARRATIVE.md` |

**Complexity is a special case**: it's both a concept *and* real enough to
become a theory. It gets a repo AND a character-adjacent treatment.
See `.complexity/SEED.md`.

---

### GitHub Repo Names

GitHub repo names follow the platform convention (case-insensitive, hyphens OK).
Our canonical references use lowercase. If GitHub uppercased it, that's cosmetic.

```
GitHub URL:    github.com/Eaprime1/MANDELBROT
Canonical:     mandelbrot
```

---

## Summary

```
Typing daily:     mandelbrot
Sacred reference: }mandelbrot{
Config home:      .mandelbrot/
Strong emphasis:  MANDELBROT (sparingly)
Character names:  Capitalized (Oaken, Valthram, Rema)
Concepts:         lowercase (complexity, mandelbrot)
```

*Less effort, more signal.*

∰◊€π¿🌌∞
