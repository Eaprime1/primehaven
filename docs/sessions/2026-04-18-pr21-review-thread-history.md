# PR #21 Review Thread Historical Record (2026-04-18)

## Scope
- Applied remaining actionable feedback from review thread:  
  https://github.com/Eaprime1/MANDELBROT/pull/21#pullrequestreview-4118716861
- Focused on workflow hardening, least-privilege permissions, and safer script behavior.

## Changes Applied
- `.github/workflows/gemini-dispatch.yml`
  - Added empty-string fallback in `startsWith(...)` expression.
  - Added empty-string fallback for `REQUEST` env in command extraction.
  - Tightened `review` reusable-workflow call permissions by removing `issues: write`.
- `.github/workflows/gemini-invoke.yml`
  - Pinned `actions/checkout` to a full commit SHA.
  - Pinned `google-github-actions/run-gemini-cli` to a full commit SHA (`v0.1.21`).
- `.github/workflows/gemini-review.yml`
  - Reduced permissions by removing `issues: write`.
  - Reduced GitHub App token mint scope by removing `permission-issues: write`.
- `PUSH_RESTRUCTURE_BRANCH.sh`
  - Removed side effect that rewrote `origin` remote URL.
  - Uses explicit HTTPS push URL fallback instead.

## TODO (Follow-up Backlog)
- [ ] Align PR title/description with actual scope (automation + docs + archive content).
- [ ] Pin remaining mutable action tags in other Gemini workflows for consistency.
- [ ] Consider adding a small workflow test/lint gate specifically for expression safety in dispatch conditions.
- [ ] Decide whether to split archival imports from workflow automation in a future PR for easier review.

## Implementation Ideas
- Add a `docs/pr-history/` index that links each repair pass and commit hash for auditability.
- Add a lightweight “review-comment checklist” template for future `@copilot repair` requests.
- Add CI guardrails for workflow permissions drift (least-privilege regression checks).
