# Trailing Space Protection System

## Overview

The primehaven repository includes comprehensive protection against trailing spaces in filenames and folder names - a critical issue that causes "massive silent corruption" across platforms.

## The Problem

Files or folders with trailing spaces in their names are:
- ❌ Invisible to some operating systems
- ❌ Break cross-platform compatibility
- ❌ Cause silent git reference failures
- ❌ Lead to data loss that goes unnoticed

Example:
```
my_file.txt       # Normal file
my_file.txt       # File with trailing space - different file, potentially invisible!
```

## Protection in Place

### 1. Pre-Commit Hook (Automatic)
Every commit is automatically checked for trailing spaces. If found, the commit is blocked with clear instructions on how to fix.

**Location**: `.git/hooks/pre-commit -> ../../tools/pre-commit-hook-trailing-spaces`

### 2. Detection & Fix Tools

#### Quick Check (Recommended for daily use)
```bash
./tools/trailing_space_quick_check.sh
```
Fast check of tracked files only. Use this regularly.

#### Full Scanner
```bash
# Preview mode (safe, no changes)
./tools/trailing_space_assassin.sh --dry-run

# Interactive mode (asks before fixing)
./tools/trailing_space_assassin.sh

# Auto-fix mode (use with caution)
./tools/trailing_space_assassin.sh --auto-fix
```

## What To Do When Blocked

If your commit is blocked by the pre-commit hook:

1. **Don't bypass** with `--no-verify` (you'll introduce corruption)

2. **Run the fix tool**:
   ```bash
   ./tools/trailing_space_assassin.sh
   ```

3. **Review the changes**:
   ```bash
   git status
   ```

4. **Stage the corrected files**:
   ```bash
   git add <corrected-files>
   ```

5. **Retry your commit**:
   ```bash
   git commit -m "Your message"
   ```

## For New Team Members

During onboarding:

1. Understand the trailing space issue (this document)
2. Verify the pre-commit hook is installed:
   ```bash
   ls -la .git/hooks/pre-commit
   ```
3. Run a quick check to see the tools in action:
   ```bash
   ./tools/trailing_space_quick_check.sh
   ```

## Technical Details

For detailed information, see:
- `tools/README_TRAILING_SPACES.md` - Comprehensive documentation
- `tools/TRAILING_SPACE_SUMMARY.md` - Implementation details

## Current Status

✅ Repository is clean (no trailing spaces in tracked files)  
✅ Pre-commit hook is active  
✅ Protection is working  

Last verified: 2026-02-01

## Quick Reference

| Task | Command |
|------|---------|
| Quick check | `./tools/trailing_space_quick_check.sh` |
| Full scan | `./tools/trailing_space_assassin.sh --dry-run` |
| Fix issues | `./tools/trailing_space_assassin.sh` |
| Install hook | `./tools/install-trailing-space-hook.sh` |

## Questions?

See the comprehensive documentation in `tools/README_TRAILING_SPACES.md`
