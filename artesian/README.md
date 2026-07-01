# artesian/

> An artesian well flows under its own pressure — no pump required.
> Content here has passed through a sphincter gateway, been reviewed,
> and is ready to enter primehaven. **Head pressure: 1 document at a time.**

---

## What this is

`artesian/` is the curated intake zone for primehaven. Content arrives
from outside (sphincter gateways at `~/sphincter/`) and flows here when
it is genuinely ready — vetted, tagged, chain of custody intact.

This is **not** a dump folder. The pressure is natural, not forced.

---

## The flow

```
Outside world
    ↓
~/sphincter/<source>/     ← raw intake (outside repo, never committed)
    ↓  (human review + tagging)
~/primehaven/artesian/    ← ready to flow (here)
    ↓  (tooling / automation)
~/primehaven/<destination> ← final home in the repo
```

---

## Chain of custody header

Every file entering artesian carries this header:

```markdown
<!-- artesian:v1
source: sphincter/desktop/folder-name/
arrived: YYYY-MM-DD
via: [who/how reviewed]
prime-state: [3/5/7/11/13/17]
status: ready
destination: docs/ | staged/ | published/ | other
-->
```

---

## queue.md

`artesian/queue.md` is the ordered list of what flows next.
One item at a time. When an item is processed and moved to its
destination, the next one becomes active.

---

## Part of a larger network

This artesian well is one node in the sovereign artesian network.
Each entity/project has its own well. Wells link to other wells.
The network topology mirrors the .bit BBS 7-node architecture.

See: `docs/PRIMORIS_VISION.md` for the full network concept.

---

*The pressure is real. Let it flow.*
