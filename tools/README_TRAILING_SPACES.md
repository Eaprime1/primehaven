# Trailing Space Assassin

## Critical Infrastructure for PrimeHaven Ecosystem

### The Problem

Trailing spaces in filenames and folder names cause **massive silent corruption** across the primehaven ecosystem:

- **Invisible files**: Files/folders with trailing spaces become invisible to some systems
- **Broken references**: Git references fail silently
- **Cross-platform chaos**: What works on Linux might be invisible on macOS/Windows
- **Silent data loss**: Users don't realize files are missing until it's too late

This was identified in the Sparklization Journey as a critical infrastructure issue that needed immediate attention.

### The Solution

The Trailing Space Assassin is a comprehensive toolkit that:

1. **Detects** all files and folders with trailing spaces
2. **Reports** findings with clear visual indicators
3. **Fixes** issues safely with automatic backups
4. **Prevents** future issues via git pre-commit hooks

## Files in This Toolkit

### 1. `trailing_space_assassin.sh`

The main detection and fix script.

**Usage:**

```bash
# Interactive mode (scan and ask before fixing)
./tools/trailing_space_assassin.sh

# Preview mode (scan only, no changes)
./tools/trailing_space_assassin.sh --dry-run

# Automatic fix mode (use with caution)
./tools/trailing_space_assassin.sh --auto-fix

# Check mode (for CI/automation - exits 1 if issues found)
./tools/trailing_space_assassin.sh --check

# Help
./tools/trailing_space_assassin.sh --help
```

**Features:**

- Recursive scanning of entire repository
- Safe handling of special characters in filenames
- Visual indicators showing exactly where trailing spaces are
- Submodule detection and warnings
- Automatic backup and logging of all changes
- Depth-first processing to avoid parent/child conflicts
- Preserves file permissions and timestamps

### 2. `pre-commit-hook-trailing-spaces`

Git pre-commit hook that blocks commits containing files with trailing spaces.

**Installation:**

```bash
# Automatic installation (recommended)
./tools/install-trailing-space-hook.sh

# Manual installation
ln -s ../../tools/pre-commit-hook-trailing-spaces .git/hooks/pre-commit
```

**What it does:**

- Runs automatically before every commit
- Checks all staged files for trailing spaces
- Blocks the commit if issues are found
- Provides clear instructions on how to fix
- Can be bypassed with `git commit --no-verify` (not recommended)

### 3. `install-trailing-space-hook.sh`

Automated installer for the pre-commit hook.

**Features:**

- Detects existing hooks and offers to backup
- Creates symlink for easy updates
- Safe and idempotent (can run multiple times)

## Quick Start

### First-Time Setup

```bash
# 1. Scan your repository for existing issues
./tools/trailing_space_assassin.sh --dry-run

# 2. Fix any issues found
./tools/trailing_space_assassin.sh

# 3. Install the pre-commit hook to prevent future issues
./tools/install-trailing-space-hook.sh

# 4. Verify everything works
git status
```

### Regular Usage

Once the pre-commit hook is installed, it will automatically check for trailing spaces before each commit. If issues are found:

```bash
# The hook will block your commit and show you the problematic files

# Run the assassin to fix them
./tools/trailing_space_assassin.sh

# Stage the corrected files
git add .

# Retry your commit
git commit -m "Your commit message"
```

## Technical Details

### How Detection Works

The script uses `find` with null-terminated output (`-print0`) to safely handle filenames with special characters. It checks each basename against a regex pattern that matches trailing whitespace:

```bash
if [[ "$basename" =~ [[:space:]]$ ]]; then
    # Trailing space detected
fi
```

### How Fixing Works

1. **Depth-first traversal**: Processes deepest files/folders first to avoid issues when renaming parent directories
2. **Safety checks**: Verifies target doesn't already exist before renaming
3. **Atomic operations**: Uses `mv` command which is atomic on most filesystems
4. **Logging**: Records all operations to timestamped log files
5. **Backup directory**: Creates `.trailing_space_backups/` for logs

### Submodule Handling

The script detects git submodules by checking for `.git` files containing `gitdir:` references. When a trailing space is found in a submodule:

- Interactive mode: Asks for confirmation before fixing
- Auto-fix mode: Warns but proceeds
- The fix is local to the submodule

### Edge Cases Handled

- Files with special characters (quotes, spaces, unicode)
- Deeply nested directory structures
- Symlinks (treated as regular files)
- Read-only files (will fail gracefully)
- Concurrent modifications (rare, but handled)
- Empty basenames (skipped)

## Output Examples

### Scan Output

```
╔═══════════════════════════════════════════════════════════════╗
║         TRAILING SPACE ASSASSIN v1.0                         ║
║         Critical Infrastructure for PrimeHaven               ║
╚═══════════════════════════════════════════════════════════════╝

Repository: /home/user/primehaven
Mode: dry-run

Scanning for trailing spaces...

✗ TRAILING SPACE DETECTED: [DIR]
  Path: /home/user/primehaven/journey_of_today 
  Name: 'journey_of_today '
  Dir:  /home/user/primehaven
  Trailing: 1 space(s) → 'journey_of_today[1×SPACE]'

═══════════════════════════════════════════════════════════════
✗ ISSUES FOUND: 1 items with trailing spaces

Dry-run mode: No changes made.
Run without --dry-run to fix these issues.
```

### Fix Output

```
[1/1] Processing: /home/user/primehaven/journey_of_today 
  ✓ Fixed:
    Old: 'journey_of_today '
    New: 'journey_of_today'
    Full path: /home/user/primehaven/journey_of_today

═══════════════════════════════════════════════════════════════
✓ COMPLETE: Fixed 1 items
Log saved to: /home/user/primehaven/.trailing_space_backups/fix_log_20260201_233000.txt

NEXT STEPS:
1. Review the changes with: git status
2. Test your repository to ensure everything works
3. Commit the fixes with a descriptive message
4. Consider installing the pre-commit hook to prevent future issues
```

## Integration with CI/CD

Use `--check` mode in continuous integration:

```yaml
# Example GitHub Actions
- name: Check for trailing spaces
  run: ./tools/trailing_space_assassin.sh --check
```

This will exit with code 1 if any trailing spaces are found, failing the CI build.

## Maintenance

### Log Files

Logs are stored in `.trailing_space_backups/` with timestamps. Clean them periodically:

```bash
# Remove logs older than 30 days
find .trailing_space_backups -name "fix_log_*.txt" -mtime +30 -delete
```

### Updating the Hook

Since the hook is installed as a symlink, any updates to `pre-commit-hook-trailing-spaces` will automatically be used on the next commit.

## Troubleshooting

### "Target already exists" Error

If the script reports that a target already exists, you have a naming conflict:

```
Old: 'filename '
New: 'filename'
```

But `filename` already exists. You'll need to manually resolve this by renaming one of the files.

### Permission Denied

Ensure the scripts are executable:

```bash
chmod +x tools/trailing_space_assassin.sh
chmod +x tools/install-trailing-space-hook.sh
chmod +x tools/pre-commit-hook-trailing-spaces
```

### Hook Not Running

Verify the hook is installed and executable:

```bash
ls -la .git/hooks/pre-commit
# Should show symlink to ../../tools/pre-commit-hook-trailing-spaces

# Ensure it's executable
chmod +x .git/hooks/pre-commit
```

## Contributing

When modifying these scripts:

1. Test thoroughly with edge cases (special characters, deep paths, etc.)
2. Maintain backward compatibility
3. Update this README with any new features or changes
4. Follow the existing code style and safety practices

## Security Considerations

- **Path injection**: All paths are properly quoted and escaped
- **Command injection**: No user input is executed directly
- **Race conditions**: Atomic `mv` operations minimize race windows
- **Permissions**: Preserves original file permissions

## License

Part of the PrimeHaven ecosystem. Use responsibly.

---

**Remember**: Trailing spaces are silent killers. Use this toolkit to keep your repository healthy and cross-platform compatible.
