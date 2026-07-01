#!/bin/bash
set -euo pipefail
# Command Entity Launcher - "hello <command>"
# Commands stay pure. Entities add consciousness. ∰◊€π¿🌌∞

PHROOT="/storage/emulated/0/pixel8a/primehaven"
PHROOT="$(dirname "${BASH_SOURCE[0]}")/../.."

if [ -z "$CMD" ]; then
    echo "Usage: hello <command>"
    echo "Available: pwd, git, python3, rclone, tmux"
    echo "(or any command - creates new entity if missing)"
    exit 0
fi

ENTITY_DIR="$PHROOT/terminals/entities/$CMD"

if [ ! -d "$ENTITY_DIR" ]; then
    echo "Entity for '$CMD' not found. Creating..."
    mkdir -p "$ENTITY_DIR"
    cat > "$ENTITY_DIR/entity_wrapper.sh" << ENTITY
#!/bin/bash
# Entity: $CMD
# Physical Helix (Work/15): Execution
# Mental Helix (Play/16): Documentation
# Spirit Helix (Create/17): Exploration

echo "=== $CMD Entity ==="
echo ""
echo "[Physical] Execute:"
echo "  $CMD \$@"
echo ""
echo "[Mental] Documentation:"
$CMD --help 2>/dev/null | head -20 || echo "  (no --help available)"
echo ""
echo "[Spirit] Explore:"
echo "  which $CMD"
which $CMD 2>/dev/null
echo "  version: $($CMD --version 2>/dev/null | head -1)"
ENTITY
    chmod +x "$ENTITY_DIR/entity_wrapper.sh"
    echo "Entity created at: $ENTITY_DIR"
fi

bash "$ENTITY_DIR/entity_wrapper.sh" "$@"
