# Trailing Space Tools - Quick Reference Card

## The Problem
Files/folders with trailing spaces → invisible on some systems → data loss

## Tools Available

### 1. Quick Check (Daily Use)
```bash
./tools/trailing_space_quick_check.sh
```
Fast. Checks tracked files only. Use this regularly.

### 2. Full Scanner
```bash
# Preview only (safe)
./tools/trailing_space_assassin.sh --dry-run

# Interactive (asks before fixing)
./tools/trailing_space_assassin.sh

# Auto-fix (careful!)
./tools/trailing_space_assassin.sh --auto-fix

# CI/CD mode
./tools/trailing_space_assassin.sh --check
```

### 3. Pre-Commit Hook
Already installed. Blocks commits with trailing spaces automatically.

## When Your Commit is Blocked

```bash
# 1. Fix the issues
./tools/trailing_space_assassin.sh

# 2. Check what changed
git status

# 3. Stage the fixes
git add <files>

# 4. Retry commit
git commit -m "Your message"
```

## Documentation

- `tools/README_TRAILING_SPACES.md` - Full technical docs
- `docs/TRAILING_SPACE_PROTECTION.md` - User guide
- `tools/TRAILING_SPACE_SUMMARY.md` - Implementation details

## Status
- Repository: Clean (no trailing spaces)
- Protection: Active (pre-commit hook installed)
- Last checked: 2026-02-01
