# pool/QUEUE.md — Development Queue

**Head Pressure**: 1 (one ACTIVE at a time)
**Last Updated**: 2026-05-21
**Queue Discipline**: FIFO (see README for priority override rules)

---

## ACTIVE (Head Pressure Slot)

```
[ACTIVE] }mandelbrot{ — Full Character Development
  Source:      .mandelbrot/IDENTITY.md, .mandelbrot/NARRATIVE.md
  Added:       2026-04-08
  Promoted:    2026-05-21 (after Violation Framework graduation)
  Description: Expand from seed identity into complete character entity.
               Visual sigil, BBS coordinate naming, peer relationships,
               healing quest mechanics for the splinters.
               See GitHub Issue #16.
  Destination: .mandelbrot/ (expanded files)
  Priority:    Standard
```

---

## QUEUED

```
[2] }complexity{ — Theory Crystallization
  Source:      .complexity/SEED.md
  Added:       2026-04-08
  Description: Extract thesis from three conversation threads (one maxed).
               Compare with existing complexity theory. Identify novel angle.
               First real theory-class concept in the ecosystem.
               See GitHub Issue #17.
  Destination: .complexity/ → future complexity/ repo

[3] BBS/domos Integration Plan
  Source:      .bit/backbone/SEVEN_NODE_ARCHITECTURE.md
  Added:       2026-04-08
  Description: Develop the seven-node BBS backbone into a concrete
               integration plan for the domos/ structure.
               Connect backbone nodes to aspect terminals (t1-t6 mapping).
               FidoNet-inspired, prime-state-mapped.
  Destination: .bit/ (expanded), docs/ (integration guide)

[4] Primal Launch Preparation
  Source:      docs/PRIMORIS_VISION.md, docs/PRIMAL_LAUNCH_PLAN.md
  Added:       2026-04-08
  Description: Operationalize the primal launch. What needs to be true
               for the 35GB gravity mass to be launchable?
               Dependencies: violation framework ✓, entity lifecycle proven (surf ✓),
               BBS backbone active, naming convention stable.
  Destination: docs/PRIMAL_LAUNCH_PLAN.md (developed)
```

---

## PRESSURIZING (Not yet pool-ready — accumulating)

```
[P1] mandelbrot Narrative — World Before Primoris
  Source:      .mandelbrot/NARRATIVE.md (partial)
  Status:      More conversation needed before pool-ready
  Note:        Needs the Oaken / splinter relationships mapped first

[P2] Complexity Repo — Full Theory Document
  Source:      (conversation threads, not yet in repo)
  Status:      Needs thread extraction before pool-ready

[P3] Violation Framework — Neurodivergent Extension
  Source:      (follows VIOLATION_FRAMEWORK.md graduation)
  Status:      Base framework graduated 2026-05-21. Ready to queue when development session available.
```

---

## GRADUATED (Passed Through)

| Title | In | Out | Destination |
|-------|----|-----|-------------|
| Violation Framework | 2026-04-08 | 2026-05-21 | `.mandelbrot/VIOLATION_FRAMEWORK.md` |

*(Full entries in MANIFEST.md)*

---

## Queue Notes

- Head pressure enforced: only one ACTIVE at a time
- Priority overrides documented here with written reason
- Pressurizing items reviewed each session — promote when ready
