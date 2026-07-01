---
name: entity-feature-development-workflow
description: Workflow command scaffold for entity-feature-development-workflow in MANDELBROT.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /entity-feature-development-workflow

Use this workflow when working on **entity-feature-development-workflow** in `MANDELBROT`.

## Goal

Implements a new terminal entity (such as a browser or tool) following a three-phase pattern: design/spec → implementation plan → code modules → integration → docs/tests.

## Common Files

- `docs/superpowers/specs/*.md`
- `docs/superpowers/plans/*.md`
- `docs/plans/*.md`
- `terminals/<entity>/`
- `terminals/entities/<entity>-*/`
- `terminals/<entity>/config/*`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Create a design/spec file in docs/superpowers/specs/ or docs/plans/
- Write an implementation plan in docs/superpowers/plans/ or docs/plans/
- Create directory structure for the entity under terminals/entities/<entity-name>/ and/or terminals/<entity-name>/
- Add core code modules (e.g., browser_selector.sh, session_manager.sh, spirit.sh, entity_wrapper.sh) in the entity directory
- Add configuration files under terminals/<entity-name>/config/

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.