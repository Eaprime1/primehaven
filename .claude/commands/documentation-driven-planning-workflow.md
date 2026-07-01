---
name: documentation-driven-planning-workflow
description: Workflow command scaffold for documentation-driven-planning-workflow in MANDELBROT.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /documentation-driven-planning-workflow

Use this workflow when working on **documentation-driven-planning-workflow** in `MANDELBROT`.

## Goal

Adds or updates detailed design documents and implementation plans before code changes, ensuring all major features/entities are planned and documented.

## Common Files

- `docs/superpowers/specs/*.md`
- `docs/superpowers/plans/*.md`
- `docs/plans/*.md`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Create or update a design/spec document in docs/superpowers/specs/ or docs/plans/
- Create or update an implementation plan in docs/superpowers/plans/ or docs/plans/
- Reference these documents in subsequent commits for implementation

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.