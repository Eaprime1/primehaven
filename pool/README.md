# pool/ — Entrance Pool

> *An artesian well flows under its own pressure. The pool holds what is ready,
> at head pressure, until the hopper is ready to receive it.*

∰◊€π¿🌌∞

---

## What This Is

The **entrance pool** is a holding zone between "reviewed and ready" and "active development."

It is not a dump folder. It is not a backlog. It is a **pressurized queue** —
documents that are already growing, already substantial, and ready to be
developed further — waiting for their turn.

### Difference from `artesian/`

| | `artesian/` | `pool/` |
|--|-------------|---------|
| **Source** | External content entering the repo | Content already in the repo |
| **Gate** | Human review at sphincter | "Ready to develop" judgment |
| **Destination** | Anywhere in the repo | Hopper → active development |
| **State** | Pre-repo | Pre-development |

---

## Head Pressure = 1

Only **one document** may be in `ACTIVE` status at a time.

This is the artesian principle: natural, sustainable pressure. Not a pump.
Not forced. One document flows through at the right pace, completely,
before the next begins.

This prevents scattered attention and half-developed work.

---

## Queue Discipline

**FIFO** — first in, first queued — unless a **Priority Override** is documented.

Priority overrides require a written reason in `QUEUE.md`:
- Dependency: another piece of work blocks on this
- Time-sensitive: a launch or deadline requires it
- Cascade: this document unlocks many downstream items

---

## Document Lifecycle

```
[Document is ready to develop]
        ↓
    Add to QUEUE.md (status: QUEUED)
        ↓
    Wait for ACTIVE slot to open
        ↓
    Promote to ACTIVE (only one at a time)
        ↓
    Develop to completion
        ↓
    Graduate: log in MANIFEST.md, move to permanent home
        ↓
    Promote next QUEUED → ACTIVE
```

---

## What "Ready to Develop" Means

A document is ready for the pool when:
- It has a clear purpose / question it answers
- It is already substantive (not just a title)
- It is "already growing" — content is accumulating, not static
- It has a known destination (even if approximate)
- It does NOT need to change form — it needs development, not reconception

If a document needs to be rethought or reconceived, it is not pool-ready.
It goes back to `artesian/` or stays in its draft location.

---

## How to Add a Document

1. Confirm it meets the "ready to develop" criteria above
2. Add an entry to `QUEUE.md` in the next available position
3. Set status to `QUEUED`
4. Include: title, source path, date added, brief description

Do NOT move the physical file. The pool is a **manifest layer** —
the document stays where it lives. The pool tracks the queue, not the file.

Exception: Documents with no permanent home yet may live in `pool/`
temporarily until they graduate to their destination.

---

## How to Graduate a Document

1. Development is complete (or reached a defined milestone)
2. Document has moved to its permanent home
3. Update `QUEUE.md` entry to `GRADUATED`
4. Add entry to `MANIFEST.md` with: in_date, out_date, destination, summary
5. Promote next `QUEUED` item to `ACTIVE`

---

## Connection to Hopper (Future)

The **hopper** is the automated development routing system — not yet built.
When it is ready, it will consume from this pool in head-pressure-1 order.

The pool is designed to be hopper-compatible:
- Structured queue format (`QUEUE.md`)
- Chain of custody log (`MANIFEST.md`)
- Clear status states (QUEUED, ACTIVE, GRADUATED)

When the hopper is built, it reads from `pool/QUEUE.md` and processes ACTIVE.

---

*"One way in. One way out. At the pace the pressure naturally provides."*

∰◊€π¿🌌∞
