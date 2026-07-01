# Surf Installation Guide

## 1. Add Shell Alias

Add to `~/.bashrc`:

```bash
# Surf - Terminal Browser Navigator
alias surf='/home/sauron/primehaven/terminals/surf/entity_wrapper.sh'
```

Then reload:
```bash
source ~/.bashrc
```

## 2. Configure Browsers (Optional)

For optimal experience, merge browser configs:

### Lynx
```bash
cat ~/primehaven/terminals/surf/config/lynx.cfg >> ~/.lynxrc
```

### W3m
```bash
mkdir -p ~/.w3m
cat ~/primehaven/terminals/surf/config/w3m_config >> ~/.w3m/config
```

### Browsh
```bash
mkdir -p ~/.config/browsh
cp ~/primehaven/terminals/surf/config/browsh_config.toml ~/.config/browsh/config.toml
```

## 3. Verify Installation

```bash
surf --help
```

Expected: Shows surf help menu

```bash
surf
```

Expected: Interactive menu appears

## 4. First Use

1. **Browse a site**: `surf https://docs.python.org`
2. **After browsing**: Press 'c' to add a comment
3. **View history**: `surf -c`
4. **Explore**: `surf -s`

## 5. GitHub Setup (Future)

GitHub quick access shortcuts work now:
```bash
surf github
surf github primehaven
```

Token-based auth for committing from terminal is planned but not yet implemented.

## Session Data

All data stored in `~/.surf/` (git-ignored):
- History: `~/.surf/history.log`
- Comments: `~/.surf/comments.db`
- Bookmarks: `~/.surf/bookmarks.txt`

## Troubleshooting

**Surf command not found:**
```bash
# Check alias
alias surf

# If missing, add to ~/.bashrc and reload
source ~/.bashrc
```

**Browser not launching:**
```bash
# Verify browsers installed
which lynx w3m browsh

# Install if missing (Ubuntu/Debian)
sudo apt install lynx w3m browsh
```

**Session data not persisting:**
```bash
# Check permissions
ls -la ~/.surf/

# Should be drwx------ (700)
# If not:
chmod 700 ~/.surf/
```

---

For more details, see: `terminals/surf/README.md`
