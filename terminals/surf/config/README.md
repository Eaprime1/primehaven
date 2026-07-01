# Surf Browser Configuration

Browser-specific configurations for optimal terminal browsing.

## Setup (Manual)

These configs need to be symlinked or copied to browser config locations:

### Lynx
```bash
cat terminals/surf/config/lynx.cfg >> ~/.lynxrc
```

### W3m
```bash
mkdir -p ~/.w3m
cat terminals/surf/config/w3m_config >> ~/.w3m/config
```

### Browsh
```bash
mkdir -p ~/.config/browsh
cp terminals/surf/config/browsh_config.toml ~/.config/browsh/config.toml
```

## Cookie Files

All browsers store cookies in `~/.surf/sessions/` for persistence.

## Notes

- Lynx: VI keys enabled, all cookies accepted
- W3m: Link numbers displayed, UTF-8 charset
- Browsh: Headless Firefox on port 4333
